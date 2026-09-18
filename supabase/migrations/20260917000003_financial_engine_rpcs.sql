-- ==============================================================================
-- Migration 003: Core Financial Engine Functions (Atomic Posting & Audit)
-- Includes:
-- 1. fn_transfer_funds: Transfers between Drawer, Safe, Wallets & POS
-- 2. fn_record_daily_closing: Audited cash drawer closing with shortage/surplus
-- 3. fn_reverse_collection: Supervised reversal of collection with ledger integrity
-- ==============================================================================

-- 1. Atomic Fund Transfer
CREATE OR REPLACE FUNCTION public.fn_transfer_funds(
    p_source_type TEXT,        -- 'treasury', 'wallet', 'pos'
    p_source_id UUID,
    p_target_type TEXT,        -- 'treasury', 'wallet', 'pos'
    p_target_id UUID,
    p_amount NUMERIC(14,2),
    p_notes TEXT DEFAULT NULL
) RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_org_id UUID := public.current_organization_id();
    v_user_id UUID := auth.uid();
    v_user_role TEXT := public.current_user_role();
    v_source_bal NUMERIC(14,2);
    v_target_bal NUMERIC(14,2);
    v_transfer_code TEXT;
BEGIN
    -- Validation: User must be signed in and possess staff role
    IF v_org_id IS NULL OR v_user_id IS NULL THEN
        RAISE EXCEPTION 'غير مصرح: يجب تسجيل الدخول بحساب موثق لإجراء التحويل المالي.';
    END IF;

    IF NOT public.has_any_role(ARRAY['admin', 'manager', 'cashier']) THEN
        RAISE EXCEPTION 'غير مصرح: لا تملك صلاحية تحويل الأموال أو تغذية الماكينات.';
    END IF;

    IF p_amount <= 0 THEN
        RAISE EXCEPTION 'المبلغ المراد تحويله يجب أن يكون أكبر من صفر.';
    END IF;

    IF p_source_type = p_target_type AND p_source_id = p_target_id THEN
        RAISE EXCEPTION 'لا يمكن التحويل لنفس الحساب أو الدرج.';
    END IF;

    v_transfer_code := 'TRF-' || to_char(now(), 'YYYYMMDD') || '-' || substr(gen_random_uuid()::text, 1, 6);

    -- 1. Deduct from Source
    IF p_source_type = 'treasury' THEN
        SELECT current_balance INTO v_source_bal
        FROM public.treasuries
        WHERE id = p_source_id AND organization_id = v_org_id
        FOR UPDATE;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'الخزينة أو الدرج المصدر غير موجود أو لا ينتمي لمنظمتك.';
        END IF;

        IF v_source_bal < p_amount THEN
            RAISE EXCEPTION 'رصيد الخزينة المصدر (% ج.م) لا يكفي لإتمام تحويل % ج.م.', v_source_bal, p_amount;
        END IF;

        UPDATE public.treasuries
        SET current_balance = current_balance - p_amount
        WHERE id = p_source_id;

        INSERT INTO public.treasury_transactions (
            organization_id, treasury_id, transaction_type, amount, balance_after,
            reference_type, description, created_by
        ) VALUES (
            v_org_id, p_source_id, 'transfer', -p_amount, v_source_bal - p_amount,
            p_target_type, COALESCE(p_notes, 'تحويل صادر إلى ' || p_target_type || ' [' || v_transfer_code || ']'), v_user_id
        );

    ELSIF p_source_type = 'wallet' THEN
        SELECT current_balance INTO v_source_bal
        FROM public.cash_wallets
        WHERE id = p_source_id AND organization_id = v_org_id
        FOR UPDATE;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'المحفظة المصدر غير موجودة أو لا تنتمي لمنظمتك.';
        END IF;

        IF v_source_bal < p_amount THEN
            RAISE EXCEPTION 'رصيد المحفظة المصدر (% ج.م) غير كافٍ.', v_source_bal;
        END IF;

        UPDATE public.cash_wallets
        SET current_balance = current_balance - p_amount
        WHERE id = p_source_id;

        INSERT INTO public.wallet_transactions (
            organization_id, wallet_id, transaction_type, amount, balance_after,
            notes, created_by
        ) VALUES (
            v_org_id, p_source_id, 'transfer_out', p_amount, v_source_bal - p_amount,
            COALESCE(p_notes, 'تحويل من المحفظة [' || v_transfer_code || ']'), v_user_id
        );

    ELSIF p_source_type = 'pos' THEN
        SELECT current_balance INTO v_source_bal
        FROM public.pos_machines
        WHERE id = p_source_id AND organization_id = v_org_id
        FOR UPDATE;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'ماكينة الدفع المصدر غير موجودة.';
        END IF;

        IF v_source_bal < p_amount THEN
            RAISE EXCEPTION 'رصيد ماكينة الدفع (% ج.م) غير كافٍ.', v_source_bal;
        END IF;

        UPDATE public.pos_machines
        SET current_balance = current_balance - p_amount
        WHERE id = p_source_id;

        INSERT INTO public.pos_transactions (
            organization_id, pos_machine_id, transaction_type, amount, commission, net_amount,
            notes, created_by
        ) VALUES (
            v_org_id, p_source_id, 'settlement', p_amount, 0, p_amount,
            COALESCE(p_notes, 'سحب وتوريد من الماكينة للدرج [' || v_transfer_code || ']'), v_user_id
        );
    ELSE
        RAISE EXCEPTION 'نوع المصدر غير مدعوم: %', p_source_type;
    END IF;

    -- 2. Deposit into Target
    IF p_target_type = 'treasury' THEN
        SELECT current_balance INTO v_target_bal
        FROM public.treasuries
        WHERE id = p_target_id AND organization_id = v_org_id
        FOR UPDATE;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'الخزينة المستلمة غير موجودة أو لا تنتمي لمنظمتك.';
        END IF;

        UPDATE public.treasuries
        SET current_balance = current_balance + p_amount
        WHERE id = p_target_id;

        INSERT INTO public.treasury_transactions (
            organization_id, treasury_id, transaction_type, amount, balance_after,
            reference_type, description, created_by
        ) VALUES (
            v_org_id, p_target_id, 'transfer', p_amount, v_target_bal + p_amount,
            p_source_type, COALESCE(p_notes, 'تحويل وارد من ' || p_source_type || ' [' || v_transfer_code || ']'), v_user_id
        );

    ELSIF p_target_type = 'wallet' THEN
        SELECT current_balance INTO v_target_bal
        FROM public.cash_wallets
        WHERE id = p_target_id AND organization_id = v_org_id
        FOR UPDATE;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'المحفظة المستلمة غير موجودة.';
        END IF;

        UPDATE public.cash_wallets
        SET current_balance = current_balance + p_amount
        WHERE id = p_target_id;

        INSERT INTO public.wallet_transactions (
            organization_id, wallet_id, transaction_type, amount, balance_after,
            notes, created_by
        ) VALUES (
            v_org_id, p_target_id, 'transfer_in', p_amount, v_target_bal + p_amount,
            COALESCE(p_notes, 'تغذية رصيد المحفظة [' || v_transfer_code || ']'), v_user_id
        );

    ELSIF p_target_type = 'pos' THEN
        SELECT current_balance INTO v_target_bal
        FROM public.pos_machines
        WHERE id = p_target_id AND organization_id = v_org_id
        FOR UPDATE;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'ماكينة الدفع المستلمة غير موجودة.';
        END IF;

        UPDATE public.pos_machines
        SET current_balance = current_balance + p_amount
        WHERE id = p_target_id;

        INSERT INTO public.pos_transactions (
            organization_id, pos_machine_id, transaction_type, amount, commission, net_amount,
            notes, created_by
        ) VALUES (
            v_org_id, p_target_id, 'recharge', p_amount, 0, p_amount,
            COALESCE(p_notes, 'تغذية شحن ماكينة [' || v_transfer_code || ']'), v_user_id
        );
    ELSE
        RAISE EXCEPTION 'نوع المستلم غير مدعوم: %', p_target_type;
    END IF;

    -- 3. Audit Log
    INSERT INTO public.audit_logs (
        organization_id, user_id, action, module, record_id, new_values
    ) VALUES (
        v_org_id, v_user_id, 'transfer', 'funds_transfer', v_transfer_code,
        jsonb_build_object(
            'code', v_transfer_code,
            'source_type', p_source_type,
            'source_id', p_source_id,
            'target_type', p_target_type,
            'target_id', p_target_id,
            'amount', p_amount,
            'notes', p_notes
        )
    );

    RETURN jsonb_build_object(
        'success', true,
        'transfer_code', v_transfer_code,
        'amount', p_amount,
        'source_new_balance', v_source_bal - p_amount,
        'target_new_balance', v_target_bal + p_amount
    );
END;
$$;

-- 2. Atomic Daily Closing Recording
CREATE OR REPLACE FUNCTION public.fn_record_daily_closing(
    p_treasury_id UUID,
    p_closing_date DATE,
    p_opening_balance NUMERIC(14,2),
    p_total_collections NUMERIC(14,2),
    p_total_cash_sales NUMERIC(14,2),
    p_total_wallet_net NUMERIC(14,2),
    p_total_expenses NUMERIC(14,2),
    p_actual_cash NUMERIC(14,2),
    p_notes TEXT DEFAULT NULL
) RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_org_id UUID := public.current_organization_id();
    v_user_id UUID := auth.uid();
    v_branch_id UUID;
    v_expected_balance NUMERIC(14,2);
    v_difference NUMERIC(14,2);
    v_status TEXT;
    v_closing_id UUID;
    v_closing_number TEXT;
BEGIN
    IF v_org_id IS NULL OR v_user_id IS NULL THEN
        RAISE EXCEPTION 'غير مصرح: يجب تسجيل الدخول بحساب موثق لإجراء التقفيل اليومي.';
    END IF;

    IF NOT public.has_any_role(ARRAY['admin', 'manager', 'cashier']) THEN
        RAISE EXCEPTION 'غير مصرح: لا تملك صلاحية إجراء التقفيل اليومي للدرج والخزينة.';
    END IF;

    -- Verify treasury exists in org
    SELECT branch_id INTO v_branch_id
    FROM public.treasuries
    WHERE id = p_treasury_id AND organization_id = v_org_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'الخزينة المحددة غير موجودة أو لا تنتمي لمنظمتك.';
    END IF;

    -- Mathematical Ledger Formulas
    v_expected_balance := p_opening_balance + p_total_collections + p_total_cash_sales + p_total_wallet_net - p_total_expenses;
    v_difference := p_actual_cash - v_expected_balance;

    IF v_difference = 0 THEN
        v_status := 'balanced';
    ELSIF v_difference < 0 THEN
        v_status := 'shortage';  -- عجز
    ELSE
        v_status := 'surplus';   -- زيادة
    END IF;

    v_closing_number := 'CLS-' || to_char(p_closing_date, 'YYYYMMDD') || '-' || substr(gen_random_uuid()::text, 1, 4);

    -- Insert or Update Closing Record
    INSERT INTO public.daily_closings (
        organization_id, branch_id, treasury_id, closing_number, closing_date,
        opening_balance, total_cash_in, total_cash_out, total_collections,
        total_cash_sales, total_expenses, total_wallet_in, total_wallet_out,
        expected_balance, actual_cash, difference, status, notes,
        is_closed, closed_by
    ) VALUES (
        v_org_id, v_branch_id, p_treasury_id, v_closing_number, p_closing_date,
        p_opening_balance, (p_total_collections + p_total_cash_sales + GREATEST(p_total_wallet_net, 0)),
        (p_total_expenses + ABS(LEAST(p_total_wallet_net, 0))),
        p_total_collections, p_total_cash_sales, p_total_expenses,
        GREATEST(p_total_wallet_net, 0), ABS(LEAST(p_total_wallet_net, 0)),
        v_expected_balance, p_actual_cash, v_difference, v_status, p_notes,
        true, v_user_id
    )
    ON CONFLICT (organization_id, closing_date, treasury_id) DO UPDATE
    SET opening_balance = EXCLUDED.opening_balance,
        total_collections = EXCLUDED.total_collections,
        total_cash_sales = EXCLUDED.total_cash_sales,
        total_cash_in = EXCLUDED.total_cash_in,
        total_cash_out = EXCLUDED.total_cash_out,
        total_expenses = EXCLUDED.total_expenses,
        total_wallet_in = EXCLUDED.total_wallet_in,
        total_wallet_out = EXCLUDED.total_wallet_out,
        expected_balance = EXCLUDED.expected_balance,
        actual_cash = EXCLUDED.actual_cash,
        difference = EXCLUDED.difference,
        status = EXCLUDED.status,
        notes = EXCLUDED.notes,
        is_closed = true,
        closed_by = v_user_id,
        created_at = now()
    RETURNING id, closing_number INTO v_closing_id, v_closing_number;

    -- Audit Log
    INSERT INTO public.audit_logs (
        organization_id, user_id, action, module, record_id, new_values
    ) VALUES (
        v_org_id, v_user_id, 'daily_closing', 'daily_closings', v_closing_id::text,
        jsonb_build_object(
            'closing_number', v_closing_number,
            'closing_date', p_closing_date,
            'expected_balance', v_expected_balance,
            'actual_cash', p_actual_cash,
            'difference', v_difference,
            'status', v_status
        )
    );

    RETURN jsonb_build_object(
        'success', true,
        'closing_id', v_closing_id,
        'closing_number', v_closing_number,
        'expected_balance', v_expected_balance,
        'actual_cash', p_actual_cash,
        'difference', v_difference,
        'status', v_status
    );
END;
$$;

-- 3. Supervised Collection Reversal
CREATE OR REPLACE FUNCTION public.fn_reverse_collection(
    p_collection_id UUID,
    p_reason TEXT
) RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_org_id UUID := public.current_organization_id();
    v_user_id UUID := auth.uid();
    v_col RECORD;
    v_ci RECORD;
    v_treasury_bal NUMERIC(14,2);
BEGIN
    IF v_org_id IS NULL OR v_user_id IS NULL THEN
        RAISE EXCEPTION 'غير مصرح: يجب تسجيل الدخول بحساب موثق لإلغاء/عكس التحصيل.';
    END IF;

    -- Only Admin and Manager can reverse financial collections
    IF NOT public.has_any_role(ARRAY['admin', 'manager']) THEN
        RAISE EXCEPTION 'غير مصرح: عملية عكس التحصيل تتطلب صلاحية مدير أو مسؤول النظام.';
    END IF;

    IF NULLIF(trim(p_reason), '') IS NULL THEN
        RAISE EXCEPTION 'يجب كتابة سبب الإلغاء أو العكس للأغراض المحاسبية والرقابية.';
    END IF;

    -- Fetch collection
    SELECT * INTO v_col
    FROM public.collections
    WHERE id = p_collection_id AND organization_id = v_org_id
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'حركة التحصيل غير موجودة أو تم إلغاؤها مسبقاً.';
    END IF;

    -- Check if treasury has enough balance to reverse
    SELECT current_balance INTO v_treasury_bal
    FROM public.treasuries
    WHERE id = v_col.treasury_id AND organization_id = v_org_id
    FOR UPDATE;

    IF v_treasury_bal < v_col.amount THEN
        RAISE EXCEPTION 'رصيد الخزينة الحالي (% ج.م) لا يكفي لعكس الإيصال بقيمة % ج.م.', v_treasury_bal, v_col.amount;
    END IF;

    -- 1. Reverse Installments
    FOR v_ci IN
        SELECT * FROM public.collection_installments
        WHERE collection_id = p_collection_id
    LOOP
        UPDATE public.installments
        SET paid_amount = GREATEST(paid_amount - v_ci.amount_applied, 0),
            remaining_amount = remaining_amount + v_ci.amount_applied,
            status = CASE
                WHEN paid_amount - v_ci.amount_applied <= 0 THEN 'pending'
                ELSE 'partially_paid'
            END,
            paid_date = CASE
                WHEN paid_amount - v_ci.amount_applied <= 0 THEN NULL
                ELSE paid_date
            END
        WHERE id = v_ci.installment_id;
    END LOOP;

    -- 2. Reverse Contract Balance
    UPDATE public.contracts
    SET remaining_balance = remaining_balance + v_col.amount,
        status = 'active'
    WHERE id = v_col.contract_id;

    -- 3. Reverse Customer Balance
    UPDATE public.customers
    SET total_paid_amount = GREATEST(total_paid_amount - v_col.amount, 0),
        current_balance = current_balance + v_col.amount
    WHERE id = v_col.customer_id;

    -- 4. Deduct from Treasury and create offsetting entry
    UPDATE public.treasuries
    SET current_balance = current_balance - v_col.amount
    WHERE id = v_col.treasury_id;

    INSERT INTO public.treasury_transactions (
        organization_id, treasury_id, transaction_type, amount, balance_after,
        reference_type, reference_id, description, is_reversed, reversal_reason,
        reversed_by, reversed_at, created_by
    ) VALUES (
        v_org_id, v_col.treasury_id, 'collection_reversal', -v_col.amount,
        v_treasury_bal - v_col.amount, 'collection', v_col.id,
        'عكس إيصال تحصيل رقم [' || v_col.receipt_number || '] - السبب: ' || p_reason,
        true, p_reason, v_user_id, now(), v_user_id
    );

    -- 5. Delete Collection Installment Allocations & Collection Record
    DELETE FROM public.collection_installments WHERE collection_id = p_collection_id;
    DELETE FROM public.collections WHERE id = p_collection_id;

    -- 6. Log in Audit Trail
    INSERT INTO public.audit_logs (
        organization_id, user_id, action, module, record_id, old_values, new_values
    ) VALUES (
        v_org_id, v_user_id, 'reverse_collection', 'collections', p_collection_id::text,
        to_jsonb(v_col),
        jsonb_build_object(
            'receipt_number', v_col.receipt_number,
            'amount', v_col.amount,
            'reason', p_reason,
            'reversed_by', v_user_id
        )
    );

    RETURN jsonb_build_object(
        'success', true,
        'message', 'تم عكس قسط التحصيل بنجاح وتعديل رصيد الخزينة والعقد.',
        'reversed_receipt_number', v_col.receipt_number,
        'amount', v_col.amount
    );
END;
$$;

-- Grant permissions on functions
GRANT EXECUTE ON FUNCTION public.fn_transfer_funds(TEXT, UUID, TEXT, UUID, NUMERIC, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.fn_record_daily_closing(UUID, DATE, NUMERIC, NUMERIC, NUMERIC, NUMERIC, NUMERIC, NUMERIC, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.fn_reverse_collection(UUID, TEXT) TO authenticated;
