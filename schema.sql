-- جداول نظام سنترال المركزي في Supabase

-- 1. جدول العملاء
CREATE TABLE IF NOT EXISTS public.customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    phone TEXT,
    national_id TEXT,
    address TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 2. جدول عقود الأقساط
CREATE TABLE IF NOT EXISTS public.installment_contracts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID REFERENCES public.customers(id) ON DELETE CASCADE,
    device_name TEXT NOT NULL,
    cash_price NUMERIC(10, 2) DEFAULT 0,
    installment_price NUMERIC(10, 2) NOT NULL,
    down_payment NUMERIC(10, 2) DEFAULT 0,
    down_payment_date DATE,
    monthly_amount NUMERIC(10, 2) DEFAULT 0,
    total_months INT DEFAULT 0,
    status TEXT DEFAULT 'active', -- active, completed, defaulted
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 3. جدول دفعات الأقساط
CREATE TABLE IF NOT EXISTS public.installment_payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contract_id UUID REFERENCES public.installment_contracts(id) ON DELETE CASCADE,
    installment_no INT,
    due_date DATE NOT NULL,
    due_amount NUMERIC(10, 2) NOT NULL,
    payment_date DATE,
    paid_amount NUMERIC(10, 2) DEFAULT 0,
    status TEXT DEFAULT 'pending', -- pending, paid, partial, late
    receipt_no TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 4. جدول دفاتر اليومية والدرج
CREATE TABLE IF NOT EXISTS public.daily_journals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    journal_date DATE NOT NULL UNIQUE,
    day_name TEXT,
    opening_cash NUMERIC(10, 2) DEFAULT 0,
    closing_cash NUMERIC(10, 2) DEFAULT 0,
    cash_difference NUMERIC(10, 2) DEFAULT 0,
    status TEXT DEFAULT 'open', -- open, closed
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 5. خطوط ومحافظ الكاش (Vodafone Cash, etc.)
CREATE TABLE IF NOT EXISTS public.cash_wallets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    phone_number TEXT NOT NULL UNIQUE,
    current_balance NUMERIC(10, 2) DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 6. معاملات محافظ الكاش
CREATE TABLE IF NOT EXISTS public.wallet_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wallet_id UUID REFERENCES public.cash_wallets(id) ON DELETE CASCADE,
    journal_id UUID REFERENCES public.daily_journals(id) ON DELETE SET NULL,
    transaction_type TEXT NOT NULL, -- deposit, cash_out
    amount NUMERIC(10, 2) NOT NULL,
    commission NUMERIC(10, 2) DEFAULT 0,
    client_phone TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 7. ماكينات الدفع الإلكتروني (فوري، أمان، بساطة)
CREATE TABLE IF NOT EXISTS public.pos_machines (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL UNIQUE,
    current_balance NUMERIC(10, 2) DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 8. عملاء الأجل السريع
CREATE TABLE IF NOT EXISTS public.quick_credit_accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    phone TEXT,
    current_balance NUMERIC(10, 2) DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 9. الموردين
CREATE TABLE IF NOT EXISTS public.suppliers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    phone TEXT,
    current_balance NUMERIC(10, 2) DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- تمكين الصلاحيات لجميع الجداول (RLS) للوصول المباشر عبر المفتاح
ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.installment_contracts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.installment_payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.daily_journals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cash_wallets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.wallet_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pos_machines ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quick_credit_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.suppliers ENABLE ROW LEVEL SECURITY;

-- السماح بالقراءة والكتابة
CREATE POLICY "Allow all operations on customers" ON public.customers FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations on installment_contracts" ON public.installment_contracts FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations on installment_payments" ON public.installment_payments FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations on daily_journals" ON public.daily_journals FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations on cash_wallets" ON public.cash_wallets FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations on wallet_transactions" ON public.wallet_transactions FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations on pos_machines" ON public.pos_machines FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations on quick_credit_accounts" ON public.quick_credit_accounts FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations on suppliers" ON public.suppliers FOR ALL USING (true) WITH CHECK (true);
