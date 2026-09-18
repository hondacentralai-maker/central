-- Private account-security settings and an auditable security activity feed.
CREATE TABLE IF NOT EXISTS public.account_security_settings (
    user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    recovery_email TEXT,
    recovery_phone TEXT,
    pin_hash TEXT,
    pin_set_at TIMESTAMPTZ,
    recovery_code_hashes TEXT[] NOT NULL DEFAULT '{}',
    recovery_codes_generated_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.security_activity (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    event_type TEXT NOT NULL,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.account_security_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.security_activity ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS account_security_select_own ON public.account_security_settings;
DROP POLICY IF EXISTS account_security_insert_own ON public.account_security_settings;
DROP POLICY IF EXISTS account_security_update_own ON public.account_security_settings;
CREATE POLICY account_security_select_own ON public.account_security_settings
    FOR SELECT TO authenticated USING (user_id = auth.uid());
CREATE POLICY account_security_insert_own ON public.account_security_settings
    FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());
CREATE POLICY account_security_update_own ON public.account_security_settings
    FOR UPDATE TO authenticated USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());

DROP POLICY IF EXISTS security_activity_select_own ON public.security_activity;
DROP POLICY IF EXISTS security_activity_insert_own ON public.security_activity;
CREATE POLICY security_activity_select_own ON public.security_activity
    FOR SELECT TO authenticated USING (user_id = auth.uid());
CREATE POLICY security_activity_insert_own ON public.security_activity
    FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());

DROP POLICY IF EXISTS profiles_owner_update ON public.profiles;
CREATE POLICY profiles_owner_update ON public.profiles
    FOR UPDATE TO authenticated
    USING (id = auth.uid())
    WITH CHECK (id = auth.uid());

CREATE OR REPLACE FUNCTION public.save_recovery_code_hashes(p_hashes TEXT[])
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    IF auth.uid() IS NULL THEN
        RAISE EXCEPTION 'Authentication required';
    END IF;
    IF p_hashes IS NULL OR cardinality(p_hashes) < 4 OR cardinality(p_hashes) > 12 THEN
        RAISE EXCEPTION 'Recovery code count must be between 4 and 12';
    END IF;

    INSERT INTO public.account_security_settings (user_id, recovery_code_hashes, recovery_codes_generated_at, updated_at)
    VALUES (auth.uid(), p_hashes, now(), now())
    ON CONFLICT (user_id) DO UPDATE
    SET recovery_code_hashes = EXCLUDED.recovery_code_hashes,
        recovery_codes_generated_at = now(),
        updated_at = now();
END;
$$;

REVOKE ALL ON FUNCTION public.save_recovery_code_hashes(TEXT[]) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.save_recovery_code_hashes(TEXT[]) TO authenticated;
