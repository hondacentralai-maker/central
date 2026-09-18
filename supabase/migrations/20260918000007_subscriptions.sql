-- Subscription codes are issued by an authenticated administrator and redeemed
-- once by the account that owns the private organization.
CREATE TABLE IF NOT EXISTS public.subscription_codes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code_hash TEXT NOT NULL UNIQUE,
    duration_months INT NOT NULL CHECK (duration_months BETWEEN 1 AND 120),
    issued_by UUID REFERENCES auth.users(id),
    issued_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    redeemed_by UUID REFERENCES auth.users(id),
    redeemed_organization_id UUID REFERENCES public.organizations(id) ON DELETE SET NULL,
    redeemed_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS public.organization_subscriptions (
    organization_id UUID PRIMARY KEY REFERENCES public.organizations(id) ON DELETE CASCADE,
    active_until TIMESTAMPTZ NOT NULL,
    last_code_id UUID REFERENCES public.subscription_codes(id),
    updated_by UUID REFERENCES auth.users(id),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.subscription_codes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.organization_subscriptions ENABLE ROW LEVEL SECURITY;

-- The tables are intentionally not directly readable or writable from the
-- browser. The SECURITY DEFINER RPCs below are the only public interface.
REVOKE ALL ON TABLE public.subscription_codes FROM anon, authenticated;
REVOKE ALL ON TABLE public.organization_subscriptions FROM anon, authenticated;

CREATE OR REPLACE FUNCTION public.account_has_access()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT EXISTS (
        SELECT 1
        FROM public.profiles p
        LEFT JOIN public.organization_subscriptions s ON s.organization_id = p.organization_id
        WHERE p.id = auth.uid()
          AND p.is_active = true
          AND (
              p.trial_ends_at IS NULL
              OR p.trial_ends_at > now()
              OR s.active_until > now()
          )
    );
$$;

REVOKE ALL ON FUNCTION public.account_has_access() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.account_has_access() TO authenticated;

CREATE OR REPLACE FUNCTION public.issue_subscription_code(
    p_code TEXT,
    p_duration_months INT
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_code_id UUID;
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM public.profiles
        WHERE id = auth.uid() AND role IN ('admin', 'manager')
    ) THEN
        RAISE EXCEPTION 'Only administrators can issue subscription codes';
    END IF;

    IF p_code IS NULL OR length(trim(p_code)) < 12 THEN
        RAISE EXCEPTION 'Subscription code is too short';
    END IF;

    IF p_duration_months IS NULL OR p_duration_months NOT BETWEEN 1 AND 120 THEN
        RAISE EXCEPTION 'Subscription duration must be between 1 and 120 months';
    END IF;

    INSERT INTO public.subscription_codes (code_hash, duration_months, issued_by)
    VALUES (
        encode(digest(lower(trim(p_code)), 'sha256'), 'hex'),
        p_duration_months,
        auth.uid()
    )
    RETURNING id INTO v_code_id;

    RETURN v_code_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.redeem_subscription_code(p_code TEXT)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_user_id UUID := auth.uid();
    v_org_id UUID;
    v_code public.subscription_codes%ROWTYPE;
    v_active_until TIMESTAMPTZ;
BEGIN
    SELECT organization_id INTO v_org_id
    FROM public.profiles
    WHERE id = v_user_id;

    IF v_org_id IS NULL THEN
        RAISE EXCEPTION 'No organization is linked to this account';
    END IF;

    SELECT * INTO v_code
    FROM public.subscription_codes
    WHERE code_hash = encode(digest(lower(trim(p_code)), 'sha256'), 'hex')
      AND redeemed_at IS NULL
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Invalid or already-used subscription code';
    END IF;

    SELECT GREATEST(COALESCE(active_until, now()), now())
        + make_interval(months => v_code.duration_months)
    INTO v_active_until
    FROM public.organization_subscriptions
    WHERE organization_id = v_org_id;

    IF v_active_until IS NULL THEN
        v_active_until := now() + make_interval(months => v_code.duration_months);
    END IF;

    INSERT INTO public.organization_subscriptions (
        organization_id, active_until, last_code_id, updated_by, updated_at
    )
    VALUES (v_org_id, v_active_until, v_code.id, v_user_id, now())
    ON CONFLICT (organization_id) DO UPDATE
    SET active_until = EXCLUDED.active_until,
        last_code_id = EXCLUDED.last_code_id,
        updated_by = EXCLUDED.updated_by,
        updated_at = now();

    UPDATE public.subscription_codes
    SET redeemed_by = v_user_id,
        redeemed_organization_id = v_org_id,
        redeemed_at = now()
    WHERE id = v_code.id;

    RETURN jsonb_build_object(
        'active_until', v_active_until,
        'duration_months', v_code.duration_months
    );
END;
$$;

CREATE OR REPLACE FUNCTION public.get_subscription_status()
RETURNS JSONB
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT jsonb_build_object(
        'trial_ends_at', p.trial_ends_at,
        'subscription_ends_at', s.active_until,
        'effective_until', CASE
            WHEN s.active_until IS NULL THEN p.trial_ends_at
            WHEN p.trial_ends_at IS NULL THEN s.active_until
            ELSE GREATEST(p.trial_ends_at, s.active_until)
        END,
        'is_subscribed', s.active_until IS NOT NULL AND s.active_until > now()
    )
    FROM public.profiles p
    LEFT JOIN public.organization_subscriptions s ON s.organization_id = p.organization_id
    WHERE p.id = auth.uid();
$$;

REVOKE ALL ON FUNCTION public.issue_subscription_code(TEXT, INT) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.redeem_subscription_code(TEXT) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.get_subscription_status() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.issue_subscription_code(TEXT, INT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.redeem_subscription_code(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_subscription_status() TO authenticated;
