-- ==============================================================================
-- نظام إدارة السنترال والمبيعات والأقساط والتحصيل والخزينة (Central Management System)
-- PostgreSQL / Supabase Complete Schema
-- ==============================================================================

-- تفعيل ملحقات PostgreSQL الأساسية
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ==============================================================================
-- 1. جداول المنشأة والمستخدمين والصلاحيات (Organizations, Profiles, Roles)
-- ==============================================================================

CREATE TABLE IF NOT EXISTS public.organizations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    trade_name TEXT,
    logo_url TEXT,
    phone TEXT,
    secondary_phone TEXT,
    email TEXT,
    tax_number TEXT,
    commercial_register TEXT,
    address TEXT,
    city TEXT,
    currency TEXT DEFAULT 'EGP',
    currency_symbol TEXT DEFAULT 'ج.م',
    receipt_header TEXT,
    receipt_footer TEXT,
    terms_and_conditions TEXT,
    default_installment_due_day INT DEFAULT 1,
    default_grace_period_days INT DEFAULT 5,
    customer_prefix TEXT DEFAULT 'CUS',
    contract_prefix TEXT DEFAULT 'CTR',
    receipt_prefix TEXT DEFAULT 'REC',
    invoice_prefix TEXT DEFAULT 'INV',
    closing_prefix TEXT DEFAULT 'CLS',
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.branches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    code TEXT,
    address TEXT,
    phone TEXT,
    is_main BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    organization_id UUID REFERENCES public.organizations(id) ON DELETE SET NULL,
    branch_id UUID REFERENCES public.branches(id) ON DELETE SET NULL,
    full_name TEXT NOT NULL,
    phone TEXT,
    role TEXT NOT NULL DEFAULT 'cashier', -- admin, manager, cashier, collector, sales, reports
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- ==============================================================================
-- 2. جداول العملاء والضامنين (Customers & Guarantors)
-- ==============================================================================

CREATE TABLE IF NOT EXISTS public.customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    code TEXT NOT NULL,
    name TEXT NOT NULL,
    phone TEXT,
    secondary_phone TEXT,
    national_id TEXT,
    address TEXT,
    city TEXT,
    status TEXT DEFAULT 'active', -- active, inactive, blocked
    notes TEXT,
    total_contracts_amount NUMERIC(14,2) DEFAULT 0,
    total_paid_amount NUMERIC(14,2) DEFAULT 0,
    current_balance NUMERIC(14,2) DEFAULT 0, -- إجمالي المتبقي على العميل
    created_by UUID REFERENCES public.profiles(id),
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    CONSTRAINT uq_org_customer_code UNIQUE (organization_id, code)
);

CREATE INDEX IF NOT EXISTS idx_customers_org ON public.customers(organization_id);
CREATE INDEX IF NOT EXISTS idx_customers_phone ON public.customers(phone);
CREATE INDEX IF NOT EXISTS idx_customers_name ON public.customers(name);

CREATE TABLE IF NOT EXISTS public.guarantors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    customer_id UUID NOT NULL REFERENCES public.customers(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    phone TEXT,
    relationship TEXT, -- صلة القرابة: أب، أخ، صديق، زميل عمل
    national_id TEXT,
    address TEXT,
    job_title TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- ==============================================================================
-- 3. جداول المنتجات والمخزون (Products, Categories & Inventory)
-- ==============================================================================

CREATE TABLE IF NOT EXISTS public.categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    category_id UUID REFERENCES public.categories(id) ON DELETE SET NULL,
    name TEXT NOT NULL,
    brand TEXT,
    model TEXT,
    barcode TEXT,
    sku TEXT,
    product_type TEXT DEFAULT 'device', -- device, accessory, service, line
    purchase_price NUMERIC(14,2) DEFAULT 0,
    cash_selling_price NUMERIC(14,2) DEFAULT 0,
    installment_selling_price NUMERIC(14,2) DEFAULT 0,
    current_stock INT DEFAULT 0,
    min_stock_alert INT DEFAULT 2,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.stock_movements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
    movement_type TEXT NOT NULL, -- purchase, sale, return, adjustment
    quantity INT NOT NULL,
    unit_cost NUMERIC(14,2),
    reference_type TEXT, -- sale, purchase, manual
    reference_id UUID,
    notes TEXT,
    created_by UUID REFERENCES public.profiles(id),
    created_at TIMESTAMPTZ DEFAULT now()
);

-- ==============================================================================
-- 4. جداول الخزينة والدرج اليومي (Treasuries & Movements)
-- ==============================================================================

CREATE TABLE IF NOT EXISTS public.treasuries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    branch_id UUID REFERENCES public.branches(id) ON DELETE SET NULL,
    name TEXT NOT NULL, -- الدرج، الخزينة الرئيسية، عهدة المحل
    treasury_type TEXT DEFAULT 'drawer', -- drawer, main_safe, custody
    opening_balance NUMERIC(14,2) DEFAULT 0,
    current_balance NUMERIC(14,2) DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.treasury_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    treasury_id UUID NOT NULL REFERENCES public.treasuries(id) ON DELETE CASCADE,
    transaction_type TEXT NOT NULL, -- cash_in, cash_out, collection, sale, expense, transfer, wallet_deposit, wallet_cashout, closing_adjustment
    amount NUMERIC(14,2) NOT NULL,
    balance_after NUMERIC(14,2) NOT NULL,
    reference_type TEXT, -- collection, sale, expense, daily_closing, wallet, pos
    reference_id UUID,
    description TEXT,
    is_reversed BOOLEAN DEFAULT false,
    reversal_reason TEXT,
    reversed_by UUID REFERENCES public.profiles(id),
    reversed_at TIMESTAMPTZ,
    created_by UUID REFERENCES public.profiles(id),
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_treasury_tx_org ON public.treasury_transactions(organization_id);
CREATE INDEX IF NOT EXISTS idx_treasury_tx_date ON public.treasury_transactions(created_at);

-- ==============================================================================
-- 5. جداول المبيعات والعقود والأقساط والتحصيل (Sales, Contracts, Installments & Collections)
-- ==============================================================================

CREATE TABLE IF NOT EXISTS public.sales (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    customer_id UUID NOT NULL REFERENCES public.customers(id) ON DELETE CASCADE,
    sale_number TEXT NOT NULL,
    sale_type TEXT NOT NULL DEFAULT 'installment', -- cash, installment, fast_credit
    total_amount NUMERIC(14,2) NOT NULL,
    paid_amount NUMERIC(14,2) DEFAULT 0,
    remaining_amount NUMERIC(14,2) DEFAULT 0,
    status TEXT DEFAULT 'completed', -- completed, cancelled, refunded
    notes TEXT,
    created_by UUID REFERENCES public.profiles(id),
    created_at TIMESTAMPTZ DEFAULT now(),
    CONSTRAINT uq_org_sale_number UNIQUE (organization_id, sale_number)
);

CREATE TABLE IF NOT EXISTS public.contracts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    customer_id UUID NOT NULL REFERENCES public.customers(id) ON DELETE CASCADE,
    guarantor_id UUID REFERENCES public.guarantors(id) ON DELETE SET NULL,
    sale_id UUID REFERENCES public.sales(id) ON DELETE SET NULL,
    contract_number TEXT NOT NULL,
    device_name TEXT NOT NULL,
    imei_number TEXT, -- الرقم التسلسلي للهاتف
    cash_price NUMERIC(14,2) DEFAULT 0,
    total_installment_price NUMERIC(14,2) NOT NULL,
    down_payment NUMERIC(14,2) DEFAULT 0,
    down_payment_date DATE,
    remaining_balance NUMERIC(14,2) NOT NULL, -- المتبقي بعد المقدم
    installment_count INT NOT NULL, -- عدد الأقساط
    monthly_installment_amount NUMERIC(14,2) NOT NULL,
    start_date DATE NOT NULL,
    due_day INT DEFAULT 1,
    status TEXT DEFAULT 'active', -- active, completed, overdue, defaulted, cancelled
    notes TEXT,
    created_by UUID REFERENCES public.profiles(id),
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    CONSTRAINT uq_org_contract_number UNIQUE (organization_id, contract_number)
);

CREATE INDEX IF NOT EXISTS idx_contracts_cust ON public.contracts(customer_id);
CREATE INDEX IF NOT EXISTS idx_contracts_status ON public.contracts(status);

CREATE TABLE IF NOT EXISTS public.installments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    contract_id UUID NOT NULL REFERENCES public.contracts(id) ON DELETE CASCADE,
    customer_id UUID NOT NULL REFERENCES public.customers(id) ON DELETE CASCADE,
    installment_number INT NOT NULL,
    due_date DATE NOT NULL,
    due_amount NUMERIC(14,2) NOT NULL,
    paid_amount NUMERIC(14,2) DEFAULT 0,
    remaining_amount NUMERIC(14,2) NOT NULL,
    status TEXT DEFAULT 'pending', -- pending, partially_paid, paid, overdue, cancelled
    paid_date DATE,
    days_overdue INT DEFAULT 0,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_installments_contract ON public.installments(contract_id);
CREATE INDEX IF NOT EXISTS idx_installments_due_date ON public.installments(due_date);
CREATE INDEX IF NOT EXISTS idx_installments_status ON public.installments(status);

CREATE TABLE IF NOT EXISTS public.collections (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    customer_id UUID NOT NULL REFERENCES public.customers(id) ON DELETE CASCADE,
    contract_id UUID NOT NULL REFERENCES public.contracts(id) ON DELETE CASCADE,
    treasury_id UUID NOT NULL REFERENCES public.treasuries(id) ON DELETE CASCADE,
    receipt_number TEXT NOT NULL,
    collection_date DATE NOT NULL DEFAULT CURRENT_DATE,
    amount NUMERIC(14,2) NOT NULL,
    payment_method TEXT DEFAULT 'cash', -- cash, card, bank, wallet, instapay
    notes TEXT,
    is_reversed BOOLEAN DEFAULT false,
    reversal_reason TEXT,
    reversed_by UUID REFERENCES public.profiles(id),
    reversed_at TIMESTAMPTZ,
    collected_by UUID REFERENCES public.profiles(id),
    created_at TIMESTAMPTZ DEFAULT now(),
    CONSTRAINT uq_org_receipt_number UNIQUE (organization_id, receipt_number)
);

CREATE TABLE IF NOT EXISTS public.collection_installments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    collection_id UUID NOT NULL REFERENCES public.collections(id) ON DELETE CASCADE,
    installment_id UUID NOT NULL REFERENCES public.installments(id) ON DELETE CASCADE,
    amount_applied NUMERIC(14,2) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- ==============================================================================
-- 6. جداول خدمات السنترال: ماكينات الدفع الإلكتروني (فوري، أمان، بساطة...)
-- ==============================================================================

CREATE TABLE IF NOT EXISTS public.pos_machines (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    name TEXT NOT NULL, -- فوري، أمان، بساطة، أمان تاتش
    machine_number TEXT,
    current_balance NUMERIC(14,2) DEFAULT 0,
    notes TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.pos_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    pos_machine_id UUID NOT NULL REFERENCES public.pos_machines(id) ON DELETE CASCADE,
    transaction_type TEXT NOT NULL, -- service_payment, recharge_balance, commission_settlement
    service_name TEXT, -- شحن رصيد، فواتير، مرافق
    amount NUMERIC(14,2) NOT NULL,
    commission NUMERIC(14,2) DEFAULT 0,
    net_amount NUMERIC(14,2) NOT NULL, -- القيمة المخصومة من الماكينة
    reference_number TEXT,
    notes TEXT,
    created_by UUID REFERENCES public.profiles(id),
    created_at TIMESTAMPTZ DEFAULT now()
);

-- ==============================================================================
-- 7. جداول خطوط ومحافظ الكاش (Vodafone Cash, Orange, Etisalat, InstaPay)
-- ==============================================================================

CREATE TABLE IF NOT EXISTS public.cash_wallets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    phone_number TEXT NOT NULL, -- 01091576032, 01002919441...
    provider TEXT NOT NULL DEFAULT 'vodafone_cash', -- vodafone_cash, orange_cash, etisalat_cash, we_pay, instapay
    account_label TEXT, -- خط رقم 1، خط رئيسي، خط درج 2
    current_balance NUMERIC(14,2) DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now(),
    CONSTRAINT uq_org_wallet_phone UNIQUE (organization_id, phone_number)
);

CREATE TABLE IF NOT EXISTS public.wallet_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    wallet_id UUID NOT NULL REFERENCES public.cash_wallets(id) ON DELETE CASCADE,
    treasury_id UUID REFERENCES public.treasuries(id) ON DELETE SET NULL,
    transaction_type TEXT NOT NULL, -- deposit (إيداع كاش للعميل), cash_out (سحب من محفظة العميل وتسليم كاش)
    amount NUMERIC(14,2) NOT NULL,
    commission NUMERIC(14,2) DEFAULT 0,
    client_phone TEXT,
    balance_after NUMERIC(14,2) NOT NULL,
    notes TEXT,
    created_by UUID REFERENCES public.profiles(id),
    created_at TIMESTAMPTZ DEFAULT now()
);

-- ==============================================================================
-- 8. جداول حسابات الأجل السريع (المحلات الزميلة والمعاملات اليومية السريعة)
-- ==============================================================================

CREATE TABLE IF NOT EXISTS public.fast_credit_accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    name TEXT NOT NULL, -- محل دمرو، محل سيدي سالم، عهدة مع احمد سمير...
    phone TEXT,
    account_type TEXT DEFAULT 'partner_shop', -- partner_shop, personal, casual
    current_balance NUMERIC(14,2) DEFAULT 0, -- موجب: له، سالب: عليه
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.fast_credit_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    account_id UUID NOT NULL REFERENCES public.fast_credit_accounts(id) ON DELETE CASCADE,
    treasury_id UUID REFERENCES public.treasuries(id) ON DELETE SET NULL,
    transaction_type TEXT NOT NULL, -- debit (سحب كاش/بضاعة), credit (سداد كاش/بضاعة)
    amount NUMERIC(14,2) NOT NULL,
    balance_after NUMERIC(14,2) NOT NULL,
    description TEXT,
    created_by UUID REFERENCES public.profiles(id),
    created_at TIMESTAMPTZ DEFAULT now()
);

-- ==============================================================================
-- 9. جداول الموردين والمشتريات (Suppliers & Purchases)
-- ==============================================================================

CREATE TABLE IF NOT EXISTS public.suppliers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    name TEXT NOT NULL, -- حمادة ابو علي، علي مدحتكو، الشهاوي، اليمان...
    phone TEXT,
    address TEXT,
    current_balance NUMERIC(14,2) DEFAULT 0, -- رصيد المورد المستحق
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.purchases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    supplier_id UUID NOT NULL REFERENCES public.suppliers(id) ON DELETE CASCADE,
    purchase_number TEXT NOT NULL,
    purchase_date DATE NOT NULL DEFAULT CURRENT_DATE,
    total_amount NUMERIC(14,2) NOT NULL,
    paid_amount NUMERIC(14,2) DEFAULT 0,
    remaining_amount NUMERIC(14,2) NOT NULL,
    notes TEXT,
    created_by UUID REFERENCES public.profiles(id),
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.supplier_payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    supplier_id UUID NOT NULL REFERENCES public.suppliers(id) ON DELETE CASCADE,
    treasury_id UUID NOT NULL REFERENCES public.treasuries(id) ON DELETE CASCADE,
    amount NUMERIC(14,2) NOT NULL,
    payment_date DATE NOT NULL DEFAULT CURRENT_DATE,
    notes TEXT,
    created_by UUID REFERENCES public.profiles(id),
    created_at TIMESTAMPTZ DEFAULT now()
);

-- ==============================================================================
-- 10. جداول المصروفات (Expenses)
-- ==============================================================================

CREATE TABLE IF NOT EXISTS public.expense_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    name TEXT NOT NULL, -- إيجار، كهرباء، عمالة، بوفيه، صيانة، مواصلات
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.expenses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    category_id UUID REFERENCES public.expense_categories(id) ON DELETE SET NULL,
    treasury_id UUID NOT NULL REFERENCES public.treasuries(id) ON DELETE CASCADE,
    amount NUMERIC(14,2) NOT NULL,
    expense_date DATE NOT NULL DEFAULT CURRENT_DATE,
    description TEXT NOT NULL,
    receipt_image_url TEXT,
    created_by UUID REFERENCES public.profiles(id),
    created_at TIMESTAMPTZ DEFAULT now()
);

-- ==============================================================================
-- 11. جداول التقفيل اليومي للخزينة والدرج (Daily Closings)
-- ==============================================================================

CREATE TABLE IF NOT EXISTS public.daily_closings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    branch_id UUID REFERENCES public.branches(id) ON DELETE SET NULL,
    treasury_id UUID NOT NULL REFERENCES public.treasuries(id) ON DELETE CASCADE,
    closing_number TEXT NOT NULL,
    closing_date DATE NOT NULL,
    opening_balance NUMERIC(14,2) NOT NULL,
    total_cash_in NUMERIC(14,2) DEFAULT 0,
    total_cash_out NUMERIC(14,2) DEFAULT 0,
    total_collections NUMERIC(14,2) DEFAULT 0,
    total_cash_sales NUMERIC(14,2) DEFAULT 0,
    total_expenses NUMERIC(14,2) DEFAULT 0,
    total_wallet_in NUMERIC(14,2) DEFAULT 0,
    total_wallet_out NUMERIC(14,2) DEFAULT 0,
    expected_balance NUMERIC(14,2) NOT NULL,
    actual_cash NUMERIC(14,2) NOT NULL,
    difference NUMERIC(14,2) NOT NULL, -- الفرق: actual - expected (عجز بالسالب / زيادة بالموجب)
    status TEXT DEFAULT 'balanced', -- balanced, shortage, surplus
    notes TEXT,
    is_closed BOOLEAN DEFAULT true,
    closed_by UUID REFERENCES public.profiles(id),
    reopened_by UUID REFERENCES public.profiles(id),
    reopened_at TIMESTAMPTZ,
    reopen_reason TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    CONSTRAINT uq_org_closing_date_treasury UNIQUE (organization_id, closing_date, treasury_id)
);

-- ==============================================================================
-- 12. جداول سجل التدقيق والعمليات والإشعارات (Audit Logs & Notifications)
-- ==============================================================================

CREATE TABLE IF NOT EXISTS public.audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    action TEXT NOT NULL, -- create, update, delete, reverse, closing, import
    module TEXT NOT NULL, -- collection, contract, installment, treasury, closing
    record_id TEXT,
    old_values JSONB,
    new_values JSONB,
    ip_address TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    notification_type TEXT DEFAULT 'info', -- info, warning, overdue, closing
    is_read BOOLEAN DEFAULT false,
    link_url TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- ==============================================================================
-- 13. دوال العمليات المالية الذرية (PostgreSQL Atomic Financial Stored Functions)
-- ==============================================================================

-- دالة تسجيل التحصيل المالي الذري
CREATE OR REPLACE FUNCTION public.fn_record_collection(
    p_org_id UUID,
    p_customer_id UUID,
    p_contract_id UUID,
    p_treasury_id UUID,
    p_collector_id UUID,
    p_amount NUMERIC(14,2),
    p_payment_method TEXT,
    p_notes TEXT
) RETURNS JSONB AS $$
DECLARE
    v_receipt_no TEXT;
    v_collection_id UUID;
    v_rem_to_distribute NUMERIC(14,2) := p_amount;
    v_inst RECORD;
    v_applied NUMERIC(14,2);
    v_treasury_bal NUMERIC(14,2);
    v_contract_rem NUMERIC(14,2);
BEGIN
    -- 1. توليد رقم الإيصال
    v_receipt_no := 'REC-' || to_char(now(), 'YYYYMMDD') || '-' || lpad(floor(random() * 10000)::text, 4, '0');

    -- 2. التحقق من رصيد الخزينة الحالي وتحديثه
    SELECT current_balance INTO v_treasury_bal FROM public.treasuries WHERE id = p_treasury_id FOR UPDATE;
    v_treasury_bal := v_treasury_bal + p_amount;
    UPDATE public.treasuries SET current_balance = v_treasury_bal WHERE id = p_treasury_id;

    -- 3. إنشاء حركة الخزينة
    INSERT INTO public.treasury_transactions (
        organization_id, treasury_id, transaction_type, amount, balance_after,
        reference_type, description, created_by
    ) VALUES (
        p_org_id, p_treasury_id, 'collection', p_amount, v_treasury_bal,
        'collection', 'تحصيل قسط إيصال: ' || v_receipt_no, p_collector_id
    );

    -- 4. إنشاء سجل التحصيل
    INSERT INTO public.collections (
        organization_id, customer_id, contract_id, treasury_id,
        receipt_number, amount, payment_method, notes, collected_by
    ) VALUES (
        p_org_id, p_customer_id, p_contract_id, p_treasury_id,
        v_receipt_no, p_amount, p_payment_method, p_notes, p_collector_id
    ) RETURNING id INTO v_collection_id;

    -- 5. توزيع المبلغ تلقائياً على الأقساط المستحقة والمتأخرة بالترتيب الزمني
    FOR v_inst IN 
        SELECT id, remaining_amount, due_amount, paid_amount 
        FROM public.installments 
        WHERE contract_id = p_contract_id AND status IN ('pending', 'partially_paid', 'overdue')
        ORDER BY due_date ASC, installment_number ASC
        FOR UPDATE
    LOOP
        EXIT WHEN v_rem_to_distribute <= 0;

        IF v_rem_to_distribute >= v_inst.remaining_amount THEN
            v_applied := v_inst.remaining_amount;
            UPDATE public.installments 
            SET paid_amount = due_amount,
                remaining_amount = 0,
                status = 'paid',
                paid_date = CURRENT_DATE,
                updated_at = now()
            WHERE id = v_inst.id;
        ELSE
            v_applied := v_rem_to_distribute;
            UPDATE public.installments 
            SET paid_amount = paid_amount + v_applied,
                remaining_amount = remaining_amount - v_applied,
                status = 'partially_paid',
                paid_date = CURRENT_DATE,
                updated_at = now()
            WHERE id = v_inst.id;
        END IF;

        INSERT INTO public.collection_installments (collection_id, installment_id, amount_applied)
        VALUES (v_collection_id, v_inst.id, v_applied);

        v_rem_to_distribute := v_rem_to_distribute - v_applied;
    END LOOP;

    -- 6. تحديث رصيد العقد ورصيد العميل الإجمالي
    SELECT COALESCE(SUM(remaining_amount), 0) INTO v_contract_rem FROM public.installments WHERE contract_id = p_contract_id;
    UPDATE public.contracts 
    SET remaining_balance = v_contract_rem,
        status = CASE WHEN v_contract_rem <= 0 THEN 'completed' ELSE status END,
        updated_at = now()
    WHERE id = p_contract_id;

    UPDATE public.customers
    SET total_paid_amount = total_paid_amount + p_amount,
        current_balance = GREATEST(current_balance - p_amount, 0),
        updated_at = now()
    WHERE id = p_customer_id;

    RETURN jsonb_build_object(
        'success', true,
        'receipt_number', v_receipt_no,
        'collection_id', v_collection_id,
        'amount', p_amount,
        'remaining_contract_balance', v_contract_rem
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- دالة تسجيل حركة محفظة الكاش وتحديث الدرج
CREATE OR REPLACE FUNCTION public.fn_record_wallet_tx(
    p_org_id UUID,
    p_wallet_id UUID,
    p_treasury_id UUID,
    p_user_id UUID,
    p_tx_type TEXT, -- deposit, cash_out
    p_amount NUMERIC(14,2),
    p_commission NUMERIC(14,2),
    p_client_phone TEXT,
    p_notes TEXT
) RETURNS JSONB AS $$
DECLARE
    v_wallet_bal NUMERIC(14,2);
    v_treasury_bal NUMERIC(14,2);
BEGIN
    SELECT current_balance INTO v_wallet_bal FROM public.cash_wallets WHERE id = p_wallet_id FOR UPDATE;
    SELECT current_balance INTO v_treasury_bal FROM public.treasuries WHERE id = p_treasury_id FOR UPDATE;

    IF p_tx_type = 'deposit' THEN
        -- إيداع: العميل يعطينا كاش + عمولة، ونحن نحول له من رصيد المحفظة
        v_wallet_bal := v_wallet_bal - p_amount;
        v_treasury_bal := v_treasury_bal + (p_amount + p_commission);
    ELSIF p_tx_type = 'cash_out' THEN
        -- سحب: العميل يحول لمحفظتنا، ونحن نسلمه كاش مخصوم منه العمولة
        v_wallet_bal := v_wallet_bal + p_amount;
        v_treasury_bal := v_treasury_bal - (p_amount - p_commission);
    END IF;

    UPDATE public.cash_wallets SET current_balance = v_wallet_bal WHERE id = p_wallet_id;
    UPDATE public.treasuries SET current_balance = v_treasury_bal WHERE id = p_treasury_id;

    INSERT INTO public.wallet_transactions (
        organization_id, wallet_id, treasury_id, transaction_type,
        amount, commission, client_phone, balance_after, notes, created_by
    ) VALUES (
        p_org_id, p_wallet_id, p_treasury_id, p_tx_type,
        p_amount, p_commission, p_client_phone, v_wallet_bal, p_notes, p_user_id
    );

    INSERT INTO public.treasury_transactions (
        organization_id, treasury_id, transaction_type, amount, balance_after,
        reference_type, description, created_by
    ) VALUES (
        p_org_id, p_treasury_id, 
        CASE WHEN p_tx_type = 'deposit' THEN 'wallet_deposit' ELSE 'wallet_cashout' END,
        p_amount, v_treasury_bal, 'wallet', 
        CASE WHEN p_tx_type = 'deposit' THEN 'إيداع محفظة كاش للعميل: ' ELSE 'سحب كاش أوت للعميل: ' END || COALESCE(p_client_phone, ''),
        p_user_id
    );

    RETURN jsonb_build_object(
        'success', true,
        'wallet_balance', v_wallet_bal,
        'treasury_balance', v_treasury_bal
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ==============================================================================
-- 14. سياسات الحماية والأمان (Row Level Security - RLS)
-- ==============================================================================

ALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.branches ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.guarantors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stock_movements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.treasuries ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.treasury_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sales ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.contracts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.installments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.collections ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.collection_installments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pos_machines ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pos_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cash_wallets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.wallet_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fast_credit_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fast_credit_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.suppliers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.purchases ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.supplier_payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expense_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.daily_closings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- سياسات عامة للوصول الشامل للمنظمة
DO $$
DECLARE
    tbl text;
    tables text[] := ARRAY[
        'organizations', 'branches', 'profiles', 'customers', 'guarantors',
        'categories', 'products', 'stock_movements', 'treasuries',
        'treasury_transactions', 'sales', 'contracts', 'installments',
        'collections', 'collection_installments', 'pos_machines',
        'pos_transactions', 'cash_wallets', 'wallet_transactions',
        'fast_credit_accounts', 'fast_credit_transactions', 'suppliers',
        'purchases', 'supplier_payments', 'expense_categories', 'expenses',
        'daily_closings', 'audit_logs', 'notifications'
    ];
BEGIN
    FOREACH tbl IN ARRAY tables LOOP
        EXECUTE format('DROP POLICY IF EXISTS "policy_%s_all" ON public.%s;', tbl, tbl);
        EXECUTE format('CREATE POLICY "policy_%s_all" ON public.%s FOR ALL USING (true) WITH CHECK (true);', tbl, tbl);
    END LOOP;
END $$;
