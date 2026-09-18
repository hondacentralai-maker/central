-- Expired subscriptions retain read access but cannot mutate business data.
CREATE OR REPLACE FUNCTION public.account_can_read()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT EXISTS (
        SELECT 1 FROM public.profiles
        WHERE id = auth.uid() AND is_active = true
    );
$$;

REVOKE ALL ON FUNCTION public.account_can_read() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.account_can_read() TO authenticated;

-- All direct SELECT policies are relaxed to active-owner reads. INSERT, UPDATE,
-- DELETE policies remain subscription-gated by account_has_access().
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
        EXECUTE format('CREATE POLICY owner_select ON public.%I FOR SELECT TO authenticated USING (owner_id = auth.uid() AND public.account_can_read())', v_table);
    END LOOP;
END;
$$;

-- All financial SECURITY DEFINER RPCs use has_any_role, so include the active
-- subscription check there as a second protection against direct RPC calls.
CREATE OR REPLACE FUNCTION public.has_any_role(p_roles TEXT[])
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT public.current_user_role() = ANY (p_roles)
       AND public.account_has_access();
$$;
