-- Self-signup accounts are active immediately and receive one month of access.
ALTER TABLE public.profiles
    ADD COLUMN IF NOT EXISTS trial_ends_at TIMESTAMPTZ;

-- Restore recently-created pending self-signups from the previous workflow.
UPDATE public.profiles
SET is_active = true,
    trial_ends_at = COALESCE(trial_ends_at, created_at + INTERVAL '1 month')
WHERE is_active = false
  AND role = 'cashier'
  AND trial_ends_at IS NULL
  AND created_at >= now() - INTERVAL '7 days';

-- Legacy accounts without a trial date remain active indefinitely until an
-- administrator explicitly deactivates them.
CREATE OR REPLACE FUNCTION public.account_has_access()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT EXISTS (
        SELECT 1
        FROM public.profiles
        WHERE id = auth.uid()
          AND is_active = true
          AND (trial_ends_at IS NULL OR trial_ends_at > now())
    );
$$;

REVOKE ALL ON FUNCTION public.account_has_access() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.account_has_access() TO authenticated;

-- Keep expired or deactivated users from reading or changing business data
-- through the API, not only from entering the React application.
DO $$
DECLARE
    v_table TEXT;
BEGIN
    FOREACH v_table IN ARRAY ARRAY[
        'organizations', 'branches', 'customers', 'guarantors', 'categories',
        'products', 'stock_movements', 'treasuries', 'treasury_transactions',
        'sales', 'contracts', 'installments', 'collections',
        'collection_installments', 'pos_machines', 'pos_transactions',
        'cash_wallets', 'wallet_transactions', 'fast_credit_accounts',
        'fast_credit_transactions', 'suppliers', 'purchases',
        'supplier_payments', 'expense_categories', 'expenses',
        'daily_closings', 'audit_logs', 'notifications'
    ]
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS owner_select ON public.%I', v_table);
        EXECUTE format('DROP POLICY IF EXISTS owner_insert ON public.%I', v_table);
        EXECUTE format('DROP POLICY IF EXISTS owner_update ON public.%I', v_table);
        EXECUTE format('DROP POLICY IF EXISTS owner_delete ON public.%I', v_table);

        EXECUTE format('CREATE POLICY owner_select ON public.%I FOR SELECT TO authenticated USING (owner_id = auth.uid() AND public.account_has_access())', v_table);
        EXECUTE format('CREATE POLICY owner_insert ON public.%I FOR INSERT TO authenticated WITH CHECK (owner_id = auth.uid() AND public.account_has_access())', v_table);
        EXECUTE format('CREATE POLICY owner_update ON public.%I FOR UPDATE TO authenticated USING (owner_id = auth.uid() AND public.account_has_access()) WITH CHECK (owner_id = auth.uid() AND public.account_has_access())', v_table);
        EXECUTE format('CREATE POLICY owner_delete ON public.%I FOR DELETE TO authenticated USING (owner_id = auth.uid() AND public.account_has_access())', v_table);
    END LOOP;
END;
$$;

-- Public self-signup must never choose an existing organization, role, or
-- activation state through client-controlled metadata.
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_org_id UUID;
    v_full_name TEXT;
BEGIN
    v_full_name := COALESCE(NULLIF(NEW.raw_user_meta_data ->> 'full_name', ''), NEW.email);

    INSERT INTO public.organizations (owner_id, name, trade_name, currency, currency_symbol)
    VALUES (NEW.id, v_full_name, v_full_name, 'EGP', 'ج.م')
    RETURNING id INTO v_org_id;

    INSERT INTO public.profiles (
        id, organization_id, branch_id, full_name, phone, role, is_active, trial_ends_at
    )
    VALUES (
        NEW.id,
        v_org_id,
        NULL,
        v_full_name,
        NULLIF(NEW.raw_user_meta_data ->> 'phone', ''),
        'cashier',
        true,
        now() + INTERVAL '1 month'
    )
    ON CONFLICT (id) DO UPDATE
    SET organization_id = EXCLUDED.organization_id,
        full_name = EXCLUDED.full_name,
        phone = EXCLUDED.phone,
        role = EXCLUDED.role,
        is_active = EXCLUDED.is_active,
        trial_ends_at = EXCLUDED.trial_ends_at;

    RETURN NEW;
END;
$$;

