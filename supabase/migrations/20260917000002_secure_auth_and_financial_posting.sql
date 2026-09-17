-- Security and financial-posting hardening.
-- Apply this migration before exposing the application to staff.

-- Fast, organization-scoped customer lookup by the identifiers used at the cash desk.
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX IF NOT EXISTS idx_customers_org_phone_lookup
    ON public.customers (organization_id, phone);
CREATE INDEX IF NOT EXISTS idx_customers_org_secondary_phone_lookup
    ON public.customers (organization_id, secondary_phone);
CREATE INDEX IF NOT EXISTS idx_customers_org_national_id_lookup
    ON public.customers (organization_id, national_id);
CREATE INDEX IF NOT EXISTS idx_customers_org_name_trgm
    ON public.customers USING gin (name gin_trgm_ops);

-- A profile is provisioned when an administrator creates a Supabase Auth user.
-- The administrator must pass organization_id and role in user metadata; users with
-- incomplete metadata are deliberately unable to see financial data.
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_org_id UUID;
    v_role TEXT;
BEGIN
    v_org_id := NULLIF(NEW.raw_user_meta_data ->> 'organization_id', '')::UUID;
    v_role := COALESCE(NULLIF(NEW.raw_user_meta_data ->> 'role', ''), 'cashier');

    IF v_org_id IS NULL THEN
        RAISE EXCEPTION 'A new user must include organization_id metadata';
    END IF;

    IF v_role NOT IN ('admin', 'manager', 'cashier', 'collector', 'sales', 'reports') THEN
        RAISE EXCEPTION 'Unsupported profile role';
    END IF;

    INSERT INTO public.profiles (id, organization_id, branch_id, full_name, phone, role, is_active)
    VALUES (
        NEW.id,
        v_org_id,
        NULLIF(NEW.raw_user_meta_data ->> 'branch_id', '')::UUID,
        COALESCE(NULLIF(NEW.raw_user_meta_data ->> 'full_name', ''), NEW.email),
        NULLIF(NEW.raw_user_meta_data ->> 'phone', ''),
        v_role,
        true
    )
    ON CONFLICT (id) DO UPDATE
    SET organization_id = EXCLUDED.organization_id,
        branch_id = EXCLUDED.branch_id,
        full_name = EXCLUDED.full_name,
        phone = EXCLUDED.phone,
        role = EXCLUDED.role,
        is_active = true;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- SECURITY DEFINER helpers avoid recursive RLS evaluation on profiles.
CREATE OR REPLACE FUNCTION public.current_organization_id()
RETURNS UUID
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT organization_id
    FROM public.profiles
    WHERE id = auth.uid()
      AND is_active = true
    LIMIT 1;
$$;

CREATE OR REPLACE FUNCTION public.current_user_role()
RETURNS TEXT
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT role
    FROM public.profiles
    WHERE id = auth.uid()
      AND is_active = true
    LIMIT 1;
$$;

CREATE OR REPLACE FUNCTION public.has_any_role(p_roles TEXT[])
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT public.current_user_role() = ANY (p_roles);
$$;

REVOKE ALL ON FUNCTION public.current_organization_id() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.current_user_role() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.has_any_role(TEXT[]) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.current_organization_id() TO authenticated;
GRANT EXECUTE ON FUNCTION public.current_user_role() TO authenticated;
GRANT EXECUTE ON FUNCTION public.has_any_role(TEXT[]) TO authenticated;

-- Remove the previous blanket "USING (true)" policies. All direct-table access
-- below is explicitly scoped to the signed-in user's organization.
DO $$
DECLARE
    v_table TEXT;
BEGIN
    FOREACH v_table IN ARRAY ARRAY[
        'organizations', 'branches', 'profiles', 'customers', 'guarantors',
        'categories', 'products', 'stock_movements', 'treasuries',
        'treasury_transactions', 'sales', 'contracts', 'installments',
        'collections', 'collection_installments', 'pos_machines',
        'pos_transactions', 'cash_wallets', 'wallet_transactions',
        'fast_credit_accounts', 'fast_credit_transactions', 'suppliers',
        'purchases', 'supplier_payments', 'expense_categories', 'expenses',
        'daily_closings', 'audit_logs', 'notifications'
    ]
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS "policy_%s_all" ON public.%I', v_table, v_table);
    END LOOP;
END;
$$;

-- Organization identity, branch, and profile policies.
CREATE POLICY organization_members_can_read
    ON public.organizations FOR SELECT TO authenticated
    USING (id = public.current_organization_id());

CREATE POLICY organization_managers_can_update
    ON public.organizations FOR UPDATE TO authenticated
    USING (id = public.current_organization_id()
       AND public.has_any_role(ARRAY['admin', 'manager']))
    WITH CHECK (id = public.current_organization_id()
       AND public.has_any_role(ARRAY['admin', 'manager']));

CREATE POLICY branch_members_can_read
    ON public.branches FOR SELECT TO authenticated
    USING (organization_id = public.current_organization_id());

CREATE POLICY branch_managers_can_manage
    ON public.branches FOR ALL TO authenticated
    USING (organization_id = public.current_organization_id()
       AND public.has_any_role(ARRAY['admin', 'manager']))
    WITH CHECK (organization_id = public.current_organization_id()
       AND public.has_any_role(ARRAY['admin', 'manager']));

CREATE POLICY profiles_can_read_own_or_managed_org
    ON public.profiles FOR SELECT TO authenticated
    USING (
        id = auth.uid()
        OR (
            organization_id = public.current_organization_id()
            AND public.has_any_role(ARRAY['admin', 'manager'])
        )
    );

CREATE POLICY profiles_managers_can_update
    ON public.profiles FOR UPDATE TO authenticated
    USING (organization_id = public.current_organization_id()
       AND public.has_any_role(ARRAY['admin', 'manager']))
    WITH CHECK (organization_id = public.current_organization_id()
       AND public.has_any_role(ARRAY['admin', 'manager']));

-- Every table that owns organization_id gets a read policy. There is no anonymous
-- policy, so published keys alone cannot disclose customer or financial data.
DO $$
DECLARE
    v_table TEXT;
BEGIN
    FOREACH v_table IN ARRAY ARRAY[
        'customers', 'guarantors', 'categories', 'products', 'stock_movements',
        'treasuries', 'treasury_transactions', 'sales', 'contracts',
        'installments', 'collections', 'pos_machines', 'pos_transactions',
        'cash_wallets', 'wallet_transactions', 'fast_credit_accounts',
        'fast_credit_transactions', 'suppliers', 'purchases',
        'supplier_payments', 'expense_categories', 'expenses',
        'daily_closings', 'audit_logs', 'notifications'
    ]
    LOOP
        EXECUTE format(
            'CREATE POLICY %I ON public.%I FOR SELECT TO authenticated USING (organization_id = public.current_organization_id())',
            v_table || '_organization_read',
            v_table
        );
    END LOOP;
END;
$$;

CREATE POLICY collection_installments_organization_read
    ON public.collection_installments FOR SELECT TO authenticated
    USING (
        EXISTS (
            SELECT 1
            FROM public.collections c
            WHERE c.id = collection_id
              AND c.organization_id = public.current_organization_id()
        )
    );

-- Master data can be maintained by business staff. Financial ledgers intentionally
-- have no direct write policy; only the validated SECURITY DEFINER functions post them.
DO $$
DECLARE
    v_table TEXT;
BEGIN
    FOREACH v_table IN ARRAY ARRAY[
        'customers', 'guarantors', 'categories', 'products', 'suppliers',
        'expense_categories', 'fast_credit_accounts'
    ]
    LOOP
        EXECUTE format(
            'CREATE POLICY %I ON public.%I FOR INSERT TO authenticated WITH CHECK (organization_id = public.current_organization_id() AND public.has_any_role(ARRAY[''admin'', ''manager'', ''cashier'', ''sales'']))',
            v_table || '_staff_insert',
            v_table
        );
        EXECUTE format(
            'CREATE POLICY %I ON public.%I FOR UPDATE TO authenticated USING (organization_id = public.current_organization_id() AND public.has_any_role(ARRAY[''admin'', ''manager'', ''cashier'', ''sales''])) WITH CHECK (organization_id = public.current_organization_id() AND public.has_any_role(ARRAY[''admin'', ''manager'', ''cashier'', ''sales'']))',
            v_table || '_staff_update',
            v_table
        );
    END LOOP;
END;
$$;

-- Only administrators and managers may delete master records, and only inside
-- their own organization.
CREATE POLICY customers_managers_can_delete
    ON public.customers FOR DELETE TO authenticated
    USING (organization_id = public.current_organization_id()
       AND public.has_any_role(ARRAY['admin', 'manager']));

-- Recreate the collection function with organization, identity, amount, contract,
-- and treasury checks. A database failure now propagates to the client; it cannot
-- be turned into a fabricated receipt.
CREATE OR REPLACE FUNCTION public.fn_record_collection(
    p_org_id UUID,
    p_customer_id UUID,
    p_contract_id UUID,
    p_treasury_id UUID,
    p_collector_id UUID,
    p_amount NUMERIC(14,2),
    p_payment_method TEXT,
    p_notes TEXT
) RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_org_id UUID := public.current_organization_id();
    v_actor_id UUID := auth.uid();
    v_receipt_no TEXT;
    v_collection_id UUID;
    v_rem_to_distribute NUMERIC(14,2) := p_amount;
    v_inst RECORD;
    v_applied NUMERIC(14,2);
    v_treasury_bal NUMERIC(14,2);
    v_contract_rem NUMERIC(14,2);
BEGIN
    IF v_org_id IS NULL OR v_actor_id IS NULL THEN
        RAISE EXCEPTION 'Authentication and an active profile are required';
    END IF;
    IF p_org_id IS DISTINCT FROM v_org_id THEN
        RAISE EXCEPTION 'Cross-organization collection is not allowed';
    END IF;
    IF NOT public.has_any_role(ARRAY['admin', 'manager', 'cashier', 'collector']) THEN
        RAISE EXCEPTION 'Your role cannot record collections';
    END IF;
    IF p_amount IS NULL OR p_amount <= 0 THEN
        RAISE EXCEPTION 'Collection amount must be positive';
    END IF;
    IF p_payment_method NOT IN ('cash', 'card', 'wallet', 'instapay') THEN
        RAISE EXCEPTION 'Unsupported payment method';
    END IF;

    SELECT current_balance
    INTO v_treasury_bal
    FROM public.treasuries
    WHERE id = p_treasury_id
      AND organization_id = v_org_id
      AND is_active = true
    FOR UPDATE;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Active treasury not found for this organization';
    END IF;

    SELECT remaining_balance
    INTO v_contract_rem
    FROM public.contracts
    WHERE id = p_contract_id
      AND customer_id = p_customer_id
      AND organization_id = v_org_id
      AND status IN ('active', 'overdue')
    FOR UPDATE;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Active contract was not found for this customer';
    END IF;
    IF p_amount > v_contract_rem THEN
        RAISE EXCEPTION 'Collection amount exceeds the contract remaining balance';
    END IF;

    LOOP
        v_receipt_no := 'REC-' || to_char(now(), 'YYYYMMDD') || '-' || lpad(floor(random() * 1000000)::text, 6, '0');
        EXIT WHEN NOT EXISTS (
            SELECT 1 FROM public.collections
            WHERE organization_id = v_org_id AND receipt_number = v_receipt_no
        );
    END LOOP;

    v_treasury_bal := v_treasury_bal + p_amount;
    UPDATE public.treasuries
    SET current_balance = v_treasury_bal
    WHERE id = p_treasury_id;

    INSERT INTO public.treasury_transactions (
        organization_id, treasury_id, transaction_type, amount, balance_after,
        reference_type, description, created_by
    ) VALUES (
        v_org_id, p_treasury_id, 'collection', p_amount, v_treasury_bal,
        'collection', 'تحصيل قسط إيصال: ' || v_receipt_no, v_actor_id
    );

    INSERT INTO public.collections (
        organization_id, customer_id, contract_id, treasury_id,
        receipt_number, amount, payment_method, notes, collected_by
    ) VALUES (
        v_org_id, p_customer_id, p_contract_id, p_treasury_id,
        v_receipt_no, p_amount, p_payment_method, COALESCE(p_notes, ''), v_actor_id
    ) RETURNING id INTO v_collection_id;

    FOR v_inst IN
        SELECT id, remaining_amount, due_amount, paid_amount
        FROM public.installments
        WHERE contract_id = p_contract_id
          AND organization_id = v_org_id
          AND status IN ('pending', 'partially_paid', 'overdue')
        ORDER BY due_date ASC, installment_number ASC
        FOR UPDATE
    LOOP
        EXIT WHEN v_rem_to_distribute <= 0;

        v_applied := LEAST(v_rem_to_distribute, v_inst.remaining_amount);
        UPDATE public.installments
        SET paid_amount = paid_amount + v_applied,
            remaining_amount = remaining_amount - v_applied,
            status = CASE WHEN remaining_amount - v_applied <= 0 THEN 'paid' ELSE 'partially_paid' END,
            paid_date = CURRENT_DATE,
            updated_at = now()
        WHERE id = v_inst.id;

        INSERT INTO public.collection_installments (collection_id, installment_id, amount_applied)
        VALUES (v_collection_id, v_inst.id, v_applied);

        v_rem_to_distribute := v_rem_to_distribute - v_applied;
    END LOOP;

    IF v_rem_to_distribute > 0 THEN
        RAISE EXCEPTION 'Collection allocation did not complete';
    END IF;

    SELECT COALESCE(SUM(remaining_amount), 0)
    INTO v_contract_rem
    FROM public.installments
    WHERE contract_id = p_contract_id
      AND organization_id = v_org_id;

    UPDATE public.contracts
    SET remaining_balance = v_contract_rem,
        status = CASE WHEN v_contract_rem <= 0 THEN 'completed' ELSE status END,
        updated_at = now()
    WHERE id = p_contract_id;

    UPDATE public.customers
    SET total_paid_amount = total_paid_amount + p_amount,
        current_balance = GREATEST(current_balance - p_amount, 0),
        updated_at = now()
    WHERE id = p_customer_id
      AND organization_id = v_org_id;

    RETURN jsonb_build_object(
        'success', true,
        'receipt_number', v_receipt_no,
        'collection_id', v_collection_id,
        'amount', p_amount,
        'remaining_contract_balance', v_contract_rem
    );
END;
$$;

-- Wallet operations are subject to the same identity and organization checks.
CREATE OR REPLACE FUNCTION public.fn_record_wallet_tx(
    p_org_id UUID,
    p_wallet_id UUID,
    p_treasury_id UUID,
    p_user_id UUID,
    p_tx_type TEXT,
    p_amount NUMERIC(14,2),
    p_commission NUMERIC(14,2),
    p_client_phone TEXT,
    p_notes TEXT
) RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_org_id UUID := public.current_organization_id();
    v_actor_id UUID := auth.uid();
    v_wallet_bal NUMERIC(14,2);
    v_treasury_bal NUMERIC(14,2);
BEGIN
    IF v_org_id IS NULL OR v_actor_id IS NULL THEN
        RAISE EXCEPTION 'Authentication and an active profile are required';
    END IF;
    IF p_org_id IS DISTINCT FROM v_org_id THEN
        RAISE EXCEPTION 'Cross-organization wallet operation is not allowed';
    END IF;
    IF NOT public.has_any_role(ARRAY['admin', 'manager', 'cashier']) THEN
        RAISE EXCEPTION 'Your role cannot record wallet operations';
    END IF;
    IF p_tx_type NOT IN ('deposit', 'cash_out') THEN
        RAISE EXCEPTION 'Unsupported wallet transaction type';
    END IF;
    IF p_amount IS NULL OR p_amount <= 0 OR COALESCE(p_commission, 0) < 0 THEN
        RAISE EXCEPTION 'Amount must be positive and commission cannot be negative';
    END IF;

    SELECT current_balance
    INTO v_wallet_bal
    FROM public.cash_wallets
    WHERE id = p_wallet_id
      AND organization_id = v_org_id
      AND is_active = true
    FOR UPDATE;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Active wallet not found for this organization';
    END IF;

    SELECT current_balance
    INTO v_treasury_bal
    FROM public.treasuries
    WHERE id = p_treasury_id
      AND organization_id = v_org_id
      AND is_active = true
    FOR UPDATE;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Active treasury not found for this organization';
    END IF;

    IF p_tx_type = 'deposit' THEN
        IF p_amount > v_wallet_bal THEN
            RAISE EXCEPTION 'Wallet balance is insufficient for this deposit';
        END IF;
        v_wallet_bal := v_wallet_bal - p_amount;
        v_treasury_bal := v_treasury_bal + p_amount + COALESCE(p_commission, 0);
    ELSE
        IF p_amount - COALESCE(p_commission, 0) > v_treasury_bal THEN
            RAISE EXCEPTION 'Treasury balance is insufficient for this cash-out';
        END IF;
        v_wallet_bal := v_wallet_bal + p_amount;
        v_treasury_bal := v_treasury_bal - (p_amount - COALESCE(p_commission, 0));
    END IF;

    UPDATE public.cash_wallets SET current_balance = v_wallet_bal WHERE id = p_wallet_id;
    UPDATE public.treasuries SET current_balance = v_treasury_bal WHERE id = p_treasury_id;

    INSERT INTO public.wallet_transactions (
        organization_id, wallet_id, treasury_id, transaction_type,
        amount, commission, client_phone, balance_after, notes, created_by
    ) VALUES (
        v_org_id, p_wallet_id, p_treasury_id, p_tx_type,
        p_amount, COALESCE(p_commission, 0), COALESCE(p_client_phone, ''),
        v_wallet_bal, COALESCE(p_notes, ''), v_actor_id
    );

    INSERT INTO public.treasury_transactions (
        organization_id, treasury_id, transaction_type, amount, balance_after,
        reference_type, description, created_by
    ) VALUES (
        v_org_id, p_treasury_id,
        CASE WHEN p_tx_type = 'deposit' THEN 'wallet_deposit' ELSE 'wallet_cashout' END,
        p_amount, v_treasury_bal, 'wallet',
        CASE WHEN p_tx_type = 'deposit' THEN 'إيداع محفظة كاش للعميل: ' ELSE 'سحب كاش أوت للعميل: ' END || COALESCE(p_client_phone, ''),
        v_actor_id
    );

    RETURN jsonb_build_object(
        'success', true,
        'wallet_balance', v_wallet_bal,
        'treasury_balance', v_treasury_bal
    );
END;
$$;

REVOKE ALL ON FUNCTION public.fn_record_collection(UUID, UUID, UUID, UUID, UUID, NUMERIC, TEXT, TEXT) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.fn_record_wallet_tx(UUID, UUID, UUID, UUID, TEXT, NUMERIC, NUMERIC, TEXT, TEXT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.fn_record_collection(UUID, UUID, UUID, UUID, UUID, NUMERIC, TEXT, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.fn_record_wallet_tx(UUID, UUID, UUID, UUID, TEXT, NUMERIC, NUMERIC, TEXT, TEXT) TO authenticated;
