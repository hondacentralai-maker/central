-- Enforce private data ownership at the database boundary.
-- Every business row belongs to the authenticated user who owns it.

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
        EXECUTE format('ALTER TABLE public.%I ADD COLUMN IF NOT EXISTS owner_id UUID REFERENCES auth.users(id)', v_table);
        EXECUTE format('ALTER TABLE public.%I ALTER COLUMN owner_id SET DEFAULT auth.uid()', v_table);
        EXECUTE format('CREATE INDEX IF NOT EXISTS %I ON public.%I(owner_id)', 'idx_' || v_table || '_owner', v_table);
    END LOOP;
END;
$$;

-- Backfill ownership from the existing creator or the owning parent row.
UPDATE public.organizations o
SET owner_id = p.id
FROM (
    SELECT DISTINCT ON (organization_id) organization_id, id
    FROM public.profiles
    WHERE is_active = true
    ORDER BY organization_id, created_at, id
) p
WHERE o.id = p.organization_id AND o.owner_id IS NULL;

UPDATE public.branches b SET owner_id = o.owner_id
FROM public.organizations o WHERE o.id = b.organization_id AND b.owner_id IS NULL;
UPDATE public.customers c SET owner_id = COALESCE(c.created_by, o.owner_id)
FROM public.organizations o WHERE o.id = c.organization_id AND c.owner_id IS NULL;
UPDATE public.guarantors g SET owner_id = c.owner_id
FROM public.customers c WHERE c.id = g.customer_id AND g.owner_id IS NULL;
UPDATE public.categories c SET owner_id = o.owner_id
FROM public.organizations o WHERE o.id = c.organization_id AND c.owner_id IS NULL;
UPDATE public.products p SET owner_id = o.owner_id
FROM public.organizations o WHERE o.id = p.organization_id AND p.owner_id IS NULL;
UPDATE public.stock_movements s SET owner_id = COALESCE(s.created_by, p.owner_id)
FROM public.products p WHERE p.id = s.product_id AND s.owner_id IS NULL;
UPDATE public.treasuries t SET owner_id = o.owner_id
FROM public.organizations o WHERE o.id = t.organization_id AND t.owner_id IS NULL;
UPDATE public.treasury_transactions t SET owner_id = COALESCE(t.created_by, tr.owner_id)
FROM public.treasuries tr WHERE tr.id = t.treasury_id AND t.owner_id IS NULL;
UPDATE public.sales s SET owner_id = COALESCE(s.created_by, c.owner_id)
FROM public.customers c WHERE c.id = s.customer_id AND s.owner_id IS NULL;
UPDATE public.contracts c SET owner_id = COALESCE(c.created_by, cu.owner_id)
FROM public.customers cu WHERE cu.id = c.customer_id AND c.owner_id IS NULL;
UPDATE public.installments i SET owner_id = c.owner_id
FROM public.contracts c WHERE c.id = i.contract_id AND i.owner_id IS NULL;
UPDATE public.collections c SET owner_id = COALESCE(c.collected_by, ctr.owner_id)
FROM public.contracts ctr WHERE ctr.id = c.contract_id AND c.owner_id IS NULL;
UPDATE public.collection_installments ci SET owner_id = c.owner_id
FROM public.collections c WHERE c.id = ci.collection_id AND ci.owner_id IS NULL;
UPDATE public.pos_machines p SET owner_id = o.owner_id
FROM public.organizations o WHERE o.id = p.organization_id AND p.owner_id IS NULL;
UPDATE public.pos_transactions p SET owner_id = COALESCE(p.created_by, m.owner_id)
FROM public.pos_machines m WHERE m.id = p.pos_machine_id AND p.owner_id IS NULL;
UPDATE public.cash_wallets w SET owner_id = o.owner_id
FROM public.organizations o WHERE o.id = w.organization_id AND w.owner_id IS NULL;
UPDATE public.wallet_transactions w SET owner_id = COALESCE(w.created_by, c.owner_id)
FROM public.cash_wallets c WHERE c.id = w.wallet_id AND w.owner_id IS NULL;
UPDATE public.fast_credit_accounts a SET owner_id = o.owner_id
FROM public.organizations o WHERE o.id = a.organization_id AND a.owner_id IS NULL;
UPDATE public.fast_credit_transactions t SET owner_id = COALESCE(t.created_by, a.owner_id)
FROM public.fast_credit_accounts a WHERE a.id = t.account_id AND t.owner_id IS NULL;
UPDATE public.suppliers s SET owner_id = o.owner_id
FROM public.organizations o WHERE o.id = s.organization_id AND s.owner_id IS NULL;
UPDATE public.purchases p SET owner_id = COALESCE(p.created_by, s.owner_id)
FROM public.suppliers s WHERE s.id = p.supplier_id AND p.owner_id IS NULL;
UPDATE public.supplier_payments p SET owner_id = COALESCE(p.created_by, s.owner_id)
FROM public.suppliers s WHERE s.id = p.supplier_id AND p.owner_id IS NULL;
UPDATE public.expense_categories e SET owner_id = o.owner_id
FROM public.organizations o WHERE o.id = e.organization_id AND e.owner_id IS NULL;
UPDATE public.expenses e SET owner_id = COALESCE(e.created_by, t.owner_id)
FROM public.treasuries t WHERE t.id = e.treasury_id AND e.owner_id IS NULL;
UPDATE public.daily_closings d SET owner_id = COALESCE(d.closed_by, t.owner_id)
FROM public.treasuries t WHERE t.id = d.treasury_id AND d.owner_id IS NULL;
UPDATE public.audit_logs a SET owner_id = COALESCE(a.user_id, o.owner_id)
FROM public.organizations o WHERE o.id = a.organization_id AND a.owner_id IS NULL;
UPDATE public.notifications n SET owner_id = COALESCE(n.user_id, o.owner_id)
FROM public.organizations o WHERE o.id = n.organization_id AND n.owner_id IS NULL;

-- If an old row has no creator, keep it with the first active administrator rather
-- than leaving it visible to nobody or exposing it to every organization member.
DO $$
DECLARE
    v_fallback UUID;
    v_table TEXT;
BEGIN
    SELECT id INTO v_fallback
    FROM public.profiles
    WHERE is_active = true AND role = 'admin'
    ORDER BY created_at, id
    LIMIT 1;

    IF v_fallback IS NOT NULL THEN
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
            EXECUTE format('UPDATE public.%I SET owner_id = $1 WHERE owner_id IS NULL', v_table)
            USING v_fallback;
        END LOOP;
    END IF;
END;
$$;

-- Replace all organization-wide policies with owner-only policies.
DO $$
DECLARE
    v_table TEXT;
    v_policy RECORD;
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
        FOR v_policy IN
            SELECT policyname FROM pg_policies
            WHERE schemaname = 'public' AND tablename = v_table
        LOOP
            EXECUTE format('DROP POLICY IF EXISTS %I ON public.%I', v_policy.policyname, v_table);
        END LOOP;

        EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', v_table);
        EXECUTE format('ALTER TABLE public.%I FORCE ROW LEVEL SECURITY', v_table);
        EXECUTE format('CREATE POLICY owner_select ON public.%I FOR SELECT TO authenticated USING (owner_id = auth.uid())', v_table);
    END LOOP;
END;
$$;

-- Direct writes are still restricted to the authenticated owner. Atomic financial
-- operations continue to use their validated SECURITY DEFINER functions.
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
        EXECUTE format('CREATE POLICY owner_insert ON public.%I FOR INSERT TO authenticated WITH CHECK (owner_id = auth.uid())', v_table);
        EXECUTE format('CREATE POLICY owner_update ON public.%I FOR UPDATE TO authenticated USING (owner_id = auth.uid()) WITH CHECK (owner_id = auth.uid())', v_table);
        EXECUTE format('CREATE POLICY owner_delete ON public.%I FOR DELETE TO authenticated USING (owner_id = auth.uid())', v_table);
    END LOOP;
END;
$$;

-- The auth trigger provisions a private organization before a JWT exists. The
-- function is SECURITY DEFINER, so the organization table must not force RLS on
-- its owner; its public API still has the owner-only SELECT policy above.
ALTER TABLE public.organizations NO FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS profiles_can_read_own_or_managed_org ON public.profiles;
DROP POLICY IF EXISTS profiles_managers_can_update ON public.profiles;
CREATE POLICY profiles_owner_read ON public.profiles
    FOR SELECT TO authenticated USING (id = auth.uid());

-- A signup without an explicit organization receives a private organization.
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_org_id UUID;
    v_role TEXT;
    v_is_active BOOLEAN;
    v_full_name TEXT;
BEGIN
    v_full_name := COALESCE(NULLIF(NEW.raw_user_meta_data ->> 'full_name', ''), NEW.email);
    v_role := COALESCE(NULLIF(NEW.raw_user_meta_data ->> 'role', ''), 'cashier');
    v_is_active := COALESCE(NULLIF(NEW.raw_user_meta_data ->> 'is_active', '')::BOOLEAN, false);
    v_org_id := NULLIF(NEW.raw_user_meta_data ->> 'organization_id', '')::UUID;

    IF v_org_id IS NULL THEN
        INSERT INTO public.organizations (owner_id, name, trade_name, currency, currency_symbol)
        VALUES (NEW.id, v_full_name, v_full_name, 'EGP', 'ج.م')
        RETURNING id INTO v_org_id;
    END IF;

    IF v_role NOT IN ('admin', 'manager', 'cashier', 'collector', 'sales', 'reports') THEN
        RAISE EXCEPTION 'Unsupported profile role';
    END IF;

    INSERT INTO public.profiles (id, organization_id, branch_id, full_name, phone, role, is_active)
    VALUES (
        NEW.id,
        v_org_id,
        NULLIF(NEW.raw_user_meta_data ->> 'branch_id', '')::UUID,
        v_full_name,
        NULLIF(NEW.raw_user_meta_data ->> 'phone', ''),
        v_role,
        v_is_active
    )
    ON CONFLICT (id) DO UPDATE
    SET organization_id = EXCLUDED.organization_id,
        branch_id = EXCLUDED.branch_id,
        full_name = EXCLUDED.full_name,
        phone = EXCLUDED.phone,
        role = EXCLUDED.role,
        is_active = EXCLUDED.is_active;

    RETURN NEW;
END;
$$;

