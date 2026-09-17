-- ==============================================================
-- Seed Data Migrated from Excel into Supabase PostgreSQL
-- ==============================================================


-- 1. المنشأة والخزينة الرئيسية
INSERT INTO public.organizations (id, name, trade_name, currency, currency_symbol)
VALUES ('00000000-0000-0000-0000-000000000001', 'سنترال المركزي', 'المركزي للمبيعات والأقساط', 'EGP', 'ج.م')
ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO public.treasuries (id, organization_id, name, treasury_type, opening_balance, current_balance)
VALUES ('00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000001', 'الدرج الرئيسي', 'drawer', 0, 0)
ON CONFLICT (id) DO NOTHING;

-- 2. ماكينات الدفع الإلكتروني (فوري، أمان، بساطة، أمان تاتش)
INSERT INTO public.pos_machines (organization_id, name) VALUES
('00000000-0000-0000-0000-000000000001', 'فوري'),
('00000000-0000-0000-0000-000000000001', 'أمان'),
('00000000-0000-0000-0000-000000000001', 'بساطة'),
('00000000-0000-0000-0000-000000000001', 'أمان تاتش')
ON CONFLICT DO NOTHING;

-- 3. خطوط ومحافظ الكاش الموثقة من الدفتر
INSERT INTO public.cash_wallets (organization_id, phone_number, provider, account_label) VALUES
('00000000-0000-0000-0000-000000000001', '01091576032', 'vodafone_cash', 'خط كاش 1'),
('00000000-0000-0000-0000-000000000001', '01002919441', 'vodafone_cash', 'خط كاش 2'),
('00000000-0000-0000-0000-000000000001', '01033307821', 'vodafone_cash', 'خط كاش 3'),
('00000000-0000-0000-0000-000000000001', '01098968373', 'vodafone_cash', 'خط كاش 4'),
('00000000-0000-0000-0000-000000000001', '01090067941', 'vodafone_cash', 'خط كاش 5'),
('00000000-0000-0000-0000-000000000001', '01005168098', 'vodafone_cash', 'خط كاش 6')
ON CONFLICT DO NOTHING;


-- الموردين المرحلين من الإكسل
INSERT INTO public.suppliers (organization_id, name, notes) VALUES ('00000000-0000-0000-0000-000000000001', 'حمادة ابو علي', 'مورد مرحّل من الإكسل') ON CONFLICT DO NOTHING;
INSERT INTO public.suppliers (organization_id, name, notes) VALUES ('00000000-0000-0000-0000-000000000001', 'علي مدحتكو', 'مورد مرحّل من الإكسل') ON CONFLICT DO NOTHING;
INSERT INTO public.suppliers (organization_id, name, notes) VALUES ('00000000-0000-0000-0000-000000000001', 'مجدي السلطان', 'مورد مرحّل من الإكسل') ON CONFLICT DO NOTHING;
INSERT INTO public.suppliers (organization_id, name, notes) VALUES ('00000000-0000-0000-0000-000000000001', 'عمر مدحتكو', 'مورد مرحّل من الإكسل') ON CONFLICT DO NOTHING;
INSERT INTO public.suppliers (organization_id, name, notes) VALUES ('00000000-0000-0000-0000-000000000001', 'الشهاوي', 'مورد مرحّل من الإكسل') ON CONFLICT DO NOTHING;
INSERT INTO public.suppliers (organization_id, name, notes) VALUES ('00000000-0000-0000-0000-000000000001', 'ابراهيم ( محل اليمان )', 'مورد مرحّل من الإكسل') ON CONFLICT DO NOTHING;

-- حسابات الأجل السريع (المحلات الزميلة)
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'محل دمرو958041', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'محل سيدي سالم', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'عهده مع احمد سمير', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'غالب 958048', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'ابو شهد', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'م رشدي 149959', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'جمال سلطان', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'حمادة ع الستار', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'محمد شمس', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'صلاح الدين', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'يوسف عزت 108267', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'صلاح السعيد', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'سمير عرفه985934', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'د عماد علي', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'عون الاحول', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'شوقي صالح121616', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'حماده الحنفي ع المجيد', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'السيد جمعه 957981', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'غنيم935836', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'محمود ابوالسعود 330900', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'محمد دبور 121617', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'م ع الله غنيم128004', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', '70032احمد ابوالعنين', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'محمد المصري 92376', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'محمد السواق', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'م احمد مبروك', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'اكرامي 120614', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'احمد ع الرحيم 196949', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'احمد غزال خليل', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'رشا 97972', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'محمد ابو السعود', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'محمد نزيه196944', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'شريف ع منعم 115282 971014', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'ع الوهاب دياب 86944', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', '119441 ماكينه', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'م محمود هاشم 966592', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'عادل ع الله', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'حازم مرعي', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'وائل كمون', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'احمد العزبي 167362', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', '112359 ع الحميد', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'حماده ايوب 306513', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'عادل ع الوهاب 162162', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'احمد حسن مسعود', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'بيومي', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'مني ع الحميد', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', '128260ام منه', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'يونس', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'احمد محمود سعفان 326543', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'محمد شعبان', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'حنفي حسنين813884', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'كريم محمود 1007161', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'حلمي ع العزيز', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'التميمي 87948', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'صبري الحجر 167471', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'احمد السعيد', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'رفيق', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'م سيد ع اللاه 196666', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'حلمي لطفي', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'محمود غباشي', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'علي زايد 162031', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'ام احمد 116702', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'محمود قاسم', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', '971013منه', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'ع الحليم عفيفي 116438', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'السعيد فتحي', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'محمود ناجي 775073', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'موسي علي موسي', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'جمعه 137795', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'هند ام ماك 970672 115452', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'رامي شتات 802057', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'رشاد الخطيب', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'الجميل 116706', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'احمد بهنسي 149941', 'partner_shop') ON CONFLICT DO NOTHING;
INSERT INTO public.fast_credit_accounts (organization_id, name, account_type) VALUES ('00000000-0000-0000-0000-000000000001', 'تقرير مصاري', 'partner_shop') ON CONFLICT DO NOTHING;

-- العملاء وعقود الأقساط وجداول السداد

DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00001', 'احمد سمير فتحي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0001-1', 'جهاز هاتف ذكي',
        0.0, 6500.0, 2500.0, 900.0,
        5, 180.00, CURRENT_DATE,
        CASE WHEN 900.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 2500.0, 2500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 800.0, 800.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 800.0, 800.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 800.0, 500.0, 300.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 800.0, 500.0, 300.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 800.0, 500.0, 300.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00002', 'احمد محمد سعفان', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0002-1', 'جهاز هاتف ذكي',
        0.0, 0.0, 1000.0, 10260.0,
        3, 3420.00, CURRENT_DATE,
        CASE WHEN 10260.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 3420.0, 0.0, 3420.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 3420.0, 0.0, 3420.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 3420.0, 0.0, 3420.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00003', 'احمد المغربي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0003-1', 'جهاز هاتف ذكي',
        0.0, 5200.0, 1000.0, 1370.0,
        10, 137.00, CURRENT_DATE,
        CASE WHEN 1370.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 420.0, 420.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 420.0, 410.0, 10.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 420.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 420.0, 0.0, 420.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 420.0, 0.0, 420.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 420.0, 0.0, 420.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 420.0, 0.0, 420.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 420.0, 0.0, 420.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 420.0, 0.0, 420.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 420.0, 0.0, 420.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00004', 'أ / احمد محمد حامد', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0004-1', 'جهاز هاتف ذكي',
        0.0, 20550.0, 0.0, 7050.0,
        16, 440.62, CURRENT_DATE,
        CASE WHEN 7050.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 0.0, 0.0, 0.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1100.0, 1100.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1100.0, 1100.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1100.0, 2200.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1100.0, 0.0, 1100.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1100.0, 1100.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1835.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 1835.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 1835.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 1835.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 1835.0, 0.0, 1835.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 12,
        CURRENT_DATE, 1835.0, 0.0, 1835.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 13,
        CURRENT_DATE, 1835.0, 0.0, 1835.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 14,
        CURRENT_DATE, 735.0, 0.0, 735.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 15,
        CURRENT_DATE, 735.0, 0.0, 735.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 16,
        CURRENT_DATE, 735.0, 0.0, 735.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 17,
        CURRENT_DATE, 325.0, 0.0, 325.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00005', 'احمد هاشم', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0005-1', 'جهاز هاتف ذكي',
        0.0, 14120.0, 8000.0, 200.0,
        6, 33.33, CURRENT_DATE,
        CASE WHEN 200.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 8000.0, 8000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1020.0, 1000.0, 20.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1020.0, 4000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1020.0, 920.0, 100.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1020.0, 0.0, 1020.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1020.0, 0.0, 1020.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1020.0, 0.0, 1020.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00006', 'احمد ع الله البرجي -عبدالله', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0006-1', 'جهاز هاتف ذكي',
        0.0, 9200.0, 2000.0, 1440.0,
        10, 144.00, CURRENT_DATE,
        CASE WHEN 1440.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 720.0, 720.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 720.0, 720.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 720.0, 720.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 720.0, 720.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 720.0, 720.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 720.0, 720.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 720.0, 720.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 720.0, 720.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 720.0, 0.0, 720.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 720.0, 0.0, 720.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00007', 'احمد ع الله البرجي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0007-1', 'جهاز هاتف ذكي',
        0.0, 0.0, 0.0, 1930.0,
        6, 321.67, CURRENT_DATE,
        CASE WHEN 1930.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 250.0, 5500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 8300.0, 1000.0, 7300.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 480.0, 0.0, 480.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 15000.0, 0.0, 15000.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 350.0, 6000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1850.0, 1800.0, 50.0, 'partially_paid'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0007-2', 'جهاز هاتف ذكي',
        0.0, 1895.0, 500.0, 935.0,
        3, 311.67, CURRENT_DATE,
        CASE WHEN 935.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 500.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 465.0, 460.0, 5.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 465.0, 0.0, 465.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 465.0, 0.0, 465.0, 'pending'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0007-3', 'جهاز هاتف ذكي',
        0.0, 8620.0, 2500.0, 4820.0,
        9, 535.56, CURRENT_DATE,
        CASE WHEN 4820.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 2500.0, 2500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 680.0, 700.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 680.0, 600.0, 80.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 680.0, 0.0, 680.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 680.0, 0.0, 680.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 680.0, 0.0, 680.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 680.0, 0.0, 680.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 680.0, 0.0, 680.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 680.0, 0.0, 680.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 680.0, 0.0, 680.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00008', 'احمد ع الله البرجي -لاب', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0008-1', 'جهاز هاتف ذكي',
        0.0, 10350.0, 2000.0, 865.0,
        10, 86.50, CURRENT_DATE,
        CASE WHEN 865.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 835.0, 835.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 835.0, 835.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 835.0, 835.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 835.0, 835.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 835.0, 835.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 835.0, 835.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 835.0, 835.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 835.0, 1640.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 835.0, 0.0, 835.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 835.0, 0.0, 835.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00009', 'الحاج / اسامة المصري', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0009-1', 'جهاز هاتف ذكي',
        0.0, 1750.0, 0.0, 190.0,
        5, 38.00, CURRENT_DATE,
        CASE WHEN 190.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 0.0, 0.0, 0.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 350.0, 330.0, 20.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 350.0, 330.0, 20.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 350.0, 350.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 350.0, 350.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 350.0, 200.0, 150.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00010', 'الحاج / اسامة مصري', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0010-1', 'جهاز هاتف ذكي',
        0.0, 13700.0, 2000.0, 2335.0,
        10, 233.50, CURRENT_DATE,
        CASE WHEN 2335.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1170.0, 1170.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1170.0, 1170.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1170.0, 1170.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1170.0, 1170.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1170.0, 1170.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1170.0, 1170.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 1170.0, 1170.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 1170.0, 1175.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 1170.0, 0.0, 1170.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 1170.0, 0.0, 1170.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00011', 'أ / احمد عادل لطفي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0011-1', 'جهاز هاتف ذكي',
        0.0, 11220.0, 3000.0, 1540.0,
        3, 513.33, CURRENT_DATE,
        CASE WHEN 1540.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 3000.0, 3000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 2740.0, 2740.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 2740.0, 2740.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 2740.0, 1200.0, 1540.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00012', 'احمد شاهين', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0012-1', 'جهاز هاتف ذكي',
        0.0, 10350.0, 5000.0, 180.0,
        10, 18.00, CURRENT_DATE,
        CASE WHEN 180.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 5000.0, 5000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 535.0, 535.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 535.0, 535.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 535.0, 535.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 535.0, 530.0, 5.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 535.0, 535.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 535.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 535.0, 500.0, 35.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 535.0, 600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 535.0, 400.0, 135.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 535.0, 0.0, 535.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00013', 'أ / اسلام التركي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0013-1', 'جهاز هاتف ذكي',
        0.0, 0.0, 0.0, 12000.0,
        1, 12000.00, CURRENT_DATE,
        CASE WHEN 12000.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 17000.0, 5000.0, 12000.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00014', 'أ / احمد بسيوني', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0014-1', 'جهاز هاتف ذكي',
        0.0, 21520.0, 4000.0, 5840.0,
        6, 973.33, CURRENT_DATE,
        CASE WHEN 5840.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 4000.0, 4000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 2920.0, 2920.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 2920.0, 2920.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 2920.0, 2920.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 2920.0, 2920.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 2920.0, 0.0, 2920.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 2920.0, 0.0, 2920.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00015', 'احمد عبدالعزيز كمال', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0015-1', 'جهاز هاتف ذكي',
        0.0, 14690.0, 4000.0, 1690.0,
        9, 187.78, CURRENT_DATE,
        CASE WHEN 1690.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1025.0, 1000.0, 25.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1025.0, 1000.0, 25.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1025.0, 1000.0, 25.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1025.0, 1000.0, 25.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1025.0, 1000.0, 25.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1025.0, 1000.0, 25.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 4000.0, 4000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 1180.0, 1000.0, 180.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 1180.0, 1000.0, 180.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 1180.0, 0.0, 1180.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00016', 'أ / احمد ابراهيم صالح', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0016-1', 'جهاز هاتف ذكي',
        0.0, 10000.0, 4000.0, 2400.0,
        10, 240.00, CURRENT_DATE,
        CASE WHEN 2400.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 4000.0, 4000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 600.0, 600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 600.0, 600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 600.0, 600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 600.0, 600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 600.0, 600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 600.0, 600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 600.0, 0.0, 600.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 600.0, 0.0, 600.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 600.0, 0.0, 600.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 600.0, 0.0, 600.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00017', 'أ / اسامه المصري', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0017-1', 'جهاز هاتف ذكي',
        0.0, 9750.0, 2000.0, 6200.0,
        10, 620.00, CURRENT_DATE,
        CASE WHEN 6200.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 775.0, 770.0, 5.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 775.0, 780.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 775.0, 0.0, 775.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 775.0, 0.0, 775.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 775.0, 0.0, 775.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 775.0, 0.0, 775.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 775.0, 0.0, 775.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 775.0, 0.0, 775.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 775.0, 0.0, 775.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 775.0, 0.0, 775.0, 'pending'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0017-2', 'جهاز هاتف ذكي',
        0.0, 13750.0, 0.0, 10575.0,
        11, 961.36, CURRENT_DATE,
        CASE WHEN 10575.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1175.0, 1175.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1175.0, 0.0, 1175.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1175.0, 0.0, 1175.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1175.0, 0.0, 1175.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1175.0, 0.0, 1175.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1175.0, 0.0, 1175.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 1175.0, 0.0, 1175.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 1175.0, 0.0, 1175.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 1175.0, 0.0, 1175.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 1175.0, 0.0, 1175.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00018', 'أ / احمد عاطف سلامة', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0018-1', 'جهاز هاتف ذكي',
        0.0, 16600.0, 3000.0, 12100.0,
        10, 1210.00, CURRENT_DATE,
        CASE WHEN 12100.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 3000.0, 3000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1360.0, 1500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1360.0, 0.0, 1360.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1360.0, 0.0, 1360.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1360.0, 0.0, 1360.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1360.0, 0.0, 1360.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1360.0, 0.0, 1360.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 1360.0, 0.0, 1360.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 1360.0, 0.0, 1360.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 1360.0, 0.0, 1360.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 1360.0, 0.0, 1360.0, 'pending'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0018-2', 'جهاز هاتف ذكي',
        0.0, 0.0, 2000.0, 7500.0,
        10, 750.00, CURRENT_DATE,
        CASE WHEN 7500.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 750.0, 0.0, 750.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 750.0, 0.0, 750.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 750.0, 0.0, 750.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 750.0, 0.0, 750.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 750.0, 0.0, 750.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 750.0, 0.0, 750.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 750.0, 0.0, 750.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 750.0, 0.0, 750.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 750.0, 0.0, 750.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 750.0, 0.0, 750.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00019', 'أ / احمد فكري صالح', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0019-1', 'جهاز هاتف ذكي',
        0.0, 14350.0, 0.0, 2870.0,
        10, 287.00, CURRENT_DATE,
        CASE WHEN 2870.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 0.0, 0.0, 0.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1435.0, 1435.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1435.0, 1435.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1435.0, 1435.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1435.0, 1435.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1435.0, 1435.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1435.0, 1435.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 1435.0, 1435.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 1435.0, 1435.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 1435.0, 0.0, 1435.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 1435.0, 0.0, 1435.0, 'pending'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0019-2', 'جهاز هاتف ذكي',
        0.0, 14750.0, 0.0, 7375.0,
        10, 737.50, CURRENT_DATE,
        CASE WHEN 7375.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 0.0, 0.0, 0.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1475.0, 1475.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1475.0, 1475.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1475.0, 1475.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1475.0, 1475.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1475.0, 1475.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1475.0, 0.0, 1475.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 1475.0, 0.0, 1475.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 1475.0, 0.0, 1475.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 1475.0, 0.0, 1475.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 1475.0, 0.0, 1475.0, 'pending'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0019-3', 'جهاز هاتف ذكي',
        0.0, 15000.0, 0.0, 12000.0,
        10, 1200.00, CURRENT_DATE,
        CASE WHEN 12000.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 0.0, 0.0, 0.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1500.0, 1500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1500.0, 1500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1500.0, 0.0, 1500.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1500.0, 0.0, 1500.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1500.0, 0.0, 1500.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1500.0, 0.0, 1500.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 1500.0, 0.0, 1500.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 1500.0, 0.0, 1500.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 1500.0, 0.0, 1500.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 1500.0, 0.0, 1500.0, 'pending'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0019-4', 'جهاز هاتف ذكي',
        0.0, 12500.0, 4500.0, 1300.0,
        10, 130.00, CURRENT_DATE,
        CASE WHEN 1300.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 4500.0, 0.0, 4500.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 800.0, 800.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 800.0, 800.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 800.0, 800.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 800.0, 0.0, 800.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 800.0, 1600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 800.0, 800.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 800.0, 800.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 800.0, 800.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 800.0, 800.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 800.0, 800.0, 0.0, 'paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00020', 'اسلام طارق', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0020-1', 'جهاز هاتف ذكي',
        0.0, 5100.0, 2000.0, 0.0,
        11, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 310.0, 310.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 310.0, 300.0, 10.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 310.0, 310.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 310.0, 310.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 310.0, 320.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 310.0, 310.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 310.0, 310.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 310.0, 310.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 310.0, 620.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 310.0, 0.0, 310.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 12,
        CURRENT_DATE, 0.0, 0.0, 0.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00021', 'احمد ماهر بهجات', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0021-1', 'جهاز هاتف ذكي',
        0.0, 8300.0, 4000.0, 0.0,
        4, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 4000.0, 4000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1075.0, 1100.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1075.0, 1000.0, 75.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1075.0, 1000.0, 75.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1075.0, 1200.0, 0.0, 'paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00022', 'احمد عبدالرحمن اصيل', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0022-1', 'جهاز هاتف ذكي',
        0.0, 4700.0, 600.0, 0.0,
        10, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 600.0, 500.0, 100.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 410.0, 400.0, 10.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 410.0, 800.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 410.0, 400.0, 10.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 410.0, 2500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 410.0, 100.0, 310.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 410.0, 0.0, 410.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 410.0, 0.0, 410.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 410.0, 0.0, 410.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 410.0, 0.0, 410.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 410.0, 0.0, 410.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00023', 'ابراهيم عبدالرحمن اصيل', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0023-1', 'جهاز هاتف ذكي',
        0.0, 8250.0, 500.0, 5450.0,
        10, 545.00, CURRENT_DATE,
        CASE WHEN 5450.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 500.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 725.0, 500.0, 225.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 725.0, 400.0, 325.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 725.0, 0.0, 725.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 725.0, 0.0, 725.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 725.0, 0.0, 725.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 500.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 725.0, 400.0, 325.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 725.0, 0.0, 725.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 725.0, 500.0, 225.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 725.0, 0.0, 725.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 12,
        CURRENT_DATE, 725.0, 0.0, 725.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00024', 'أ / بليغ حمدي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0024-1', 'جهاز هاتف ذكي',
        0.0, 10950.0, 3000.0, 100.0,
        3, 33.33, CURRENT_DATE,
        CASE WHEN 100.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 3000.0, 3000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 2650.0, 2650.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 2650.0, 2600.0, 50.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 2650.0, 2600.0, 50.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00025', 'بسام السعيد', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0025-1', 'جهاز هاتف ذكي',
        0.0, 6800.0, 3000.0, 100.0,
        2, 50.00, CURRENT_DATE,
        CASE WHEN 100.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 3000.0, 3000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1900.0, 1500.0, 400.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1900.0, 2200.0, 0.0, 'paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00026', 'احمد شمس', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0026-1', 'جهاز هاتف ذكي',
        0.0, 5500.0, 500.0, 0.0,
        10, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 500.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 500.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 500.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 500.0, 1500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 500.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 500.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 500.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 500.0, 0.0, 500.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 500.0, 0.0, 500.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 500.0, 0.0, 500.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 500.0, 0.0, 500.0, 'pending'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0026-2', 'جهاز هاتف ذكي',
        0.0, 5500.0, 500.0, 2000.0,
        10, 200.00, CURRENT_DATE,
        CASE WHEN 2000.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 500.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 500.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 500.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 500.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 500.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 500.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 500.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 500.0, 0.0, 500.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 500.0, 0.0, 500.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 500.0, 0.0, 500.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 500.0, 0.0, 500.0, 'pending'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0026-3', 'جهاز هاتف ذكي',
        0.0, 5900.0, 500.0, 560.0,
        10, 56.00, CURRENT_DATE,
        CASE WHEN 560.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 500.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 540.0, 540.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 540.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 540.0, 500.0, 40.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 540.0, 500.0, 40.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 540.0, 800.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 540.0, 500.0, 40.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 540.0, 500.0, 40.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 540.0, 500.0, 40.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 540.0, 0.0, 540.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 540.0, 0.0, 540.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00027', 'اشرف عبدالحميد الحنفي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0027-1', 'جهاز هاتف ذكي',
        0.0, 17850.0, 3000.0, 0.0,
        10, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 3000.0, 12900.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1485.0, 1000.0, 485.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1485.0, 1000.0, 485.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1485.0, 2950.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1485.0, 0.0, 1485.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1485.0, 0.0, 1485.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1485.0, 0.0, 1485.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 1485.0, 0.0, 1485.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 1485.0, 0.0, 1485.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 1485.0, 0.0, 1485.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 1485.0, 0.0, 1485.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00028', 'احمد طارق الاشموني', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0028-1', 'جهاز هاتف ذكي',
        0.0, 4995.0, 1500.0, 665.0,
        3, 221.67, CURRENT_DATE,
        CASE WHEN 665.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1500.0, 1500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1165.0, 1165.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1165.0, 1165.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1165.0, 500.0, 665.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00029', 'بلال كامل شمس', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0029-1', 'جهاز هاتف ذكي',
        0.0, 3800.0, 1000.0, 0.0,
        10, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 280.0, 280.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 280.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 280.0, 520.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 280.0, 0.0, 280.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 280.0, 0.0, 280.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 280.0, 0.0, 280.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 280.0, 0.0, 280.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 280.0, 0.0, 280.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 280.0, 0.0, 280.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 280.0, 0.0, 280.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00030', 'أ / تامرعلي سرور', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0030-1', 'جهاز هاتف ذكي',
        0.0, 6600.0, 3000.0, 50.0,
        4, 12.50, CURRENT_DATE,
        CASE WHEN 50.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 3000.0, 2950.0, 50.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 900.0, 800.0, 100.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 900.0, 800.0, 100.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 900.0, 800.0, 100.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 900.0, 200.0, 700.0, 'partially_paid'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0030-2', 'جهاز هاتف ذكي',
        0.0, 10500.0, 3000.0, 300.0,
        10, 30.00, CURRENT_DATE,
        CASE WHEN 300.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 3000.0, 3000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 750.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 750.0, 600.0, 150.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 750.0, 700.0, 50.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 750.0, 700.0, 50.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 750.0, 500.0, 250.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 750.0, 600.0, 150.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 750.0, 700.0, 50.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 750.0, 700.0, 50.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 750.0, 700.0, 50.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 750.0, 500.0, 250.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00031', 'أ / جمال عبدالحميد', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0031-1', 'جهاز هاتف ذكي',
        0.0, 8660.0, 0.0, 0.0,
        5, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1665.0, 1665.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1665.0, 1670.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1665.0, 1665.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1665.0, 1660.0, 5.0, 'partially_paid'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0031-2', 'جهاز هاتف ذكي',
        0.0, 8100.0, 1000.0, 4260.0,
        5, 852.00, CURRENT_DATE,
        CASE WHEN 4260.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1420.0, 1420.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1420.0, 1420.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1420.0, 0.0, 1420.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1420.0, 0.0, 1420.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1420.0, 0.0, 1420.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00032', 'جمال عبدالحميد', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0032-1', 'جهاز هاتف ذكي',
        0.0, 4200.0, 500.0, 0.0,
        10, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 500.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 370.0, 740.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 370.0, 370.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 370.0, 720.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 370.0, 300.0, 70.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 370.0, 370.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 370.0, 1200.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 370.0, 0.0, 370.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 370.0, 0.0, 370.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 370.0, 0.0, 370.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 370.0, 0.0, 370.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00033', 'جابر', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0033-1', 'جهاز هاتف ذكي',
        0.0, 3900.0, 0.0, 900.0,
        2, 450.00, CURRENT_DATE,
        CASE WHEN 900.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1900.0, 1000.0, 900.0, 'partially_paid'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0033-2', 'جهاز هاتف ذكي',
        0.0, 4400.0, 1500.0, 20.0,
        4, 5.00, CURRENT_DATE,
        CASE WHEN 20.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1500.0, 1500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 725.0, 720.0, 5.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 725.0, 720.0, 5.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 725.0, 720.0, 5.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 725.0, 720.0, 5.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00034', 'أ / حسن شمس', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0034-1', 'جهاز هاتف ذكي',
        0.0, 28300.0, 14000.0, 8580.0,
        10, 858.00, CURRENT_DATE,
        CASE WHEN 8580.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 14000.0, 14000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1430.0, 4400.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1430.0, 0.0, 1430.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1430.0, 0.0, 1430.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1430.0, 1320.0, 110.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1430.0, 0.0, 1430.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1430.0, 0.0, 1430.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 1430.0, 0.0, 1430.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 1430.0, 0.0, 1430.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 1430.0, 0.0, 1430.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 1430.0, 0.0, 1430.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00035', 'حسن شمس', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0035-1', 'جهاز هاتف ذكي',
        0.0, 0.0, 0.0, 670.0,
        10, 67.00, CURRENT_DATE,
        CASE WHEN 670.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 68.0, 0.0, 68.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 33.0, 0.0, 33.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1330.0, 0.0, 1330.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 2325.0, 0.0, 2325.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, -130.0, 0.0, 0.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, -950.0, 0.0, 0.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, -600.0, 0.0, 0.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, -300.0, 0.0, 0.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, -130.0, 0.0, 0.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, -400.0, 0.0, 0.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00036', 'أ / حمدي علاء', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0036-1', 'جهاز هاتف ذكي',
        0.0, 40000.0, 10000.0, 18000.0,
        10, 1800.00, CURRENT_DATE,
        CASE WHEN 18000.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 10000.0, 10000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 3000.0, 3000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 3000.0, 3000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 3000.0, 3000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 3000.0, 3000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 3000.0, 0.0, 3000.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 3000.0, 0.0, 3000.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 3000.0, 0.0, 3000.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 3000.0, 0.0, 3000.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 3000.0, 0.0, 3000.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 3000.0, 0.0, 3000.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00037', 'أ / حماده عبد الستار', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0037-1', 'جهاز هاتف ذكي',
        0.0, 0.0, 0.0, 63000.0,
        1, 63000.00, CURRENT_DATE,
        CASE WHEN 63000.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 78000.0, 10000.0, 68000.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00038', 'أ / حاتم فؤاد محي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0038-1', 'جهاز هاتف ذكي',
        0.0, 34400.0, 20000.0, 4800.0,
        4, 1200.00, CURRENT_DATE,
        CASE WHEN 4800.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 20000.0, 14800.0, 5200.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 4550.0, 5000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 4550.0, 4800.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 4550.0, 5000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 750.0, 0.0, 750.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00039', 'الحاج / حسن غنيم', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0039-1', 'جهاز هاتف ذكي',
        0.0, 11645.0, 3000.0, 6175.0,
        7, 882.14, CURRENT_DATE,
        CASE WHEN 6175.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 3000.0, 3000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1235.0, 1235.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1235.0, 1235.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1235.0, 0.0, 1235.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1235.0, 0.0, 1235.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1235.0, 0.0, 1235.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1235.0, 0.0, 1235.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 1235.0, 0.0, 1235.0, 'pending'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0039-2', 'جهاز هاتف ذكي',
        0.0, 11645.0, 3000.0, 8645.0,
        7, 1235.00, CURRENT_DATE,
        CASE WHEN 8645.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 3000.0, 3000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1235.0, 1235.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1235.0, 1235.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1235.0, 0.0, 1235.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1235.0, 0.0, 1235.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1235.0, 0.0, 1235.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1235.0, 0.0, 1235.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 1235.0, 0.0, 1235.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00040', 'حنفي محمد راشد', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0040-1', 'جهاز هاتف ذكي',
        0.0, 3750.0, 0.0, 2500.0,
        6, 416.67, CURRENT_DATE,
        CASE WHEN 2500.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 500.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 650.0, 150.0, 500.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 650.0, 150.0, 500.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 650.0, 150.0, 500.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 650.0, 150.0, 500.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 650.0, 150.0, 500.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00041', 'حميدو رشاد', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0041-1', 'جهاز هاتف ذكي',
        0.0, 8320.0, 5500.0, 0.0,
        6, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 5500.0, 5500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 470.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 470.0, 1140.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 470.0, 700.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 470.0, -20.0, 490.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 470.0, 0.0, 470.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 470.0, 0.0, 470.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00042', 'حسام المنسي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0042-1', 'جهاز هاتف ذكي',
        0.0, 4280.0, 600.0, 0.0,
        8, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 600.0, 600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 460.0, 200.0, 260.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 460.0, 260.0, 200.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 460.0, 450.0, 10.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 460.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 460.0, 1100.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 460.0, 670.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 460.0, 0.0, 460.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 460.0, 0.0, 460.0, 'pending'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0042-2', 'جهاز هاتف ذكي',
        0.0, 3850.0, 600.0, 0.0,
        10, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 600.0, 600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 325.0, 320.0, 5.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 325.0, 325.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 325.0, 325.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 325.0, 325.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 325.0, 325.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 325.0, 320.0, 5.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 325.0, 325.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 325.0, 325.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 325.0, 630.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 325.0, 30.0, 295.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00043', 'خالد المهاجر', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0043-1', 'جهاز هاتف ذكي',
        0.0, 3760.0, 0.0, 680.0,
        7, 97.14, CURRENT_DATE,
        CASE WHEN 680.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 460.0, 360.0, 100.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 460.0, 360.0, 100.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 460.0, 360.0, 100.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 460.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 460.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 460.0, 0.0, 460.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00044', 'خليل مغربي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0044-1', 'جهاز هاتف ذكي',
        0.0, 7600.0, 1600.0, 3000.0,
        10, 300.00, CURRENT_DATE,
        CASE WHEN 3000.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1600.0, 1600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 600.0, 600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 600.0, 600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 600.0, 600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 600.0, 600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 600.0, 600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 600.0, 0.0, 600.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 600.0, 0.0, 600.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 600.0, 0.0, 600.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 600.0, 0.0, 600.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 600.0, 0.0, 600.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00045', 'أ / خالد عاطف', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0045-1', 'جهاز هاتف ذكي',
        0.0, 6800.0, 1500.0, 4770.0,
        10, 477.00, CURRENT_DATE,
        CASE WHEN 4770.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1500.0, 1500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 530.0, 530.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 530.0, 0.0, 530.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 530.0, 0.0, 530.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 530.0, 0.0, 530.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 530.0, 0.0, 530.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 530.0, 0.0, 530.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 530.0, 0.0, 530.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 530.0, 0.0, 530.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 530.0, 0.0, 530.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 530.0, 0.0, 530.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00046', 'خليفة خليفة', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0046-1', 'جهاز هاتف ذكي',
        0.0, 3800.0, 0.0, 150.0,
        12, 12.50, CURRENT_DATE,
        CASE WHEN 150.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 200.0, 50.0, 150.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 500.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 310.0, 310.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 310.0, 520.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 310.0, 0.0, 310.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 310.0, 0.0, 310.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 310.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 310.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 310.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 310.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 310.0, 270.0, 40.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 12,
        CURRENT_DATE, 310.0, 0.0, 310.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00047', 'دينا عبد الجواد', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0047-1', 'جهاز هاتف ذكي',
        0.0, 6275.0, 2000.0, 1430.0,
        3, 476.67, CURRENT_DATE,
        CASE WHEN 1430.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1425.0, 1420.0, 5.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1425.0, 1425.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1425.0, 0.0, 1425.0, 'pending'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0047-2', 'جهاز هاتف ذكي',
        0.0, 5100.0, 400.0, 50.0,
        10, 5.00, CURRENT_DATE,
        CASE WHEN 50.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 400.0, 400.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 470.0, 400.0, 70.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 470.0, 470.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 470.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 470.0, 240.0, 230.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 470.0, 390.0, 80.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 470.0, 400.0, 70.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 470.0, 400.0, 70.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 470.0, 950.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 470.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 470.0, 400.0, 70.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00048', 'داود سليمان', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0048-1', 'جهاز هاتف ذكي',
        0.0, 5500.0, 700.0, 0.0,
        10, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 700.0, 700.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 480.0, 400.0, 80.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 480.0, 800.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 480.0, 800.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 480.0, 800.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 480.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 480.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 480.0, 0.0, 480.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 480.0, 0.0, 480.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 480.0, 0.0, 480.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 480.0, 0.0, 480.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00049', 'أ / رامي وليد', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0049-1', 'أ / حمدي المهاجر',
        0.0, 13810.0, 4000.0, 1635.0,
        6, 272.50, CURRENT_DATE,
        CASE WHEN 1635.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 4000.0, 4000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1635.0, 1635.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1635.0, 1635.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1635.0, 1635.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1635.0, 1635.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1635.0, 1635.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1635.0, 0.0, 1635.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00050', 'رمضان مسعد', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0050-1', 'جهاز هاتف ذكي',
        0.0, 2425.0, 0.0, 575.0,
        4, 143.75, CURRENT_DATE,
        CASE WHEN 575.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 475.0, 450.0, 25.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 475.0, 200.0, 275.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 475.0, 200.0, 275.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00051', 'رحاب عادل لطفي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0051-1', 'جهاز هاتف ذكي',
        0.0, 5080.0, 1000.0, 0.0,
        8, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 510.0, 800.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 510.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 510.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 510.0, 510.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 510.0, 400.0, 110.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 510.0, 230.0, 280.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 510.0, 100.0, 410.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 510.0, 40.0, 470.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00052', 'رجب', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0052-1', 'جهاز هاتف ذكي',
        0.0, 10640.0, 5000.0, 40.0,
        6, 6.67, CURRENT_DATE,
        CASE WHEN 40.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 5000.0, 5000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 940.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 940.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 940.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 940.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 940.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 940.0, 600.0, 340.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00053', 'رجب -المخبز', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0053-1', 'جهاز هاتف ذكي',
        0.0, 5100.0, 3000.0, 0.0,
        2, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 3000.0, 3000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1050.0, 1900.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1050.0, 200.0, 850.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00054', 'رضا صابر', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0054-1', 'جهاز هاتف ذكي',
        0.0, 0.0, 0.0, 0.0,
        0, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00055', 'رضا فؤاد ابو طاجن', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0055-1', 'جهاز هاتف ذكي',
        0.0, 5160.0, 0.0, 0.0,
        12, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 430.0, 400.0, 30.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 430.0, 400.0, 30.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 430.0, 400.0, 30.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 430.0, 400.0, 30.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 430.0, 3000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 430.0, 560.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 430.0, 0.0, 430.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 430.0, 0.0, 430.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 430.0, 0.0, 430.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 430.0, 0.0, 430.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 430.0, 0.0, 430.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 12,
        CURRENT_DATE, 430.0, 0.0, 430.0, 'pending'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0055-2', 'جهاز هاتف ذكي',
        0.0, 7650.0, 500.0, 450.0,
        10, 45.00, CURRENT_DATE,
        CASE WHEN 450.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 500.0, 6500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 715.0, 500.0, 215.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 715.0, 200.0, 515.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 715.0, 0.0, 715.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 715.0, 0.0, 715.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 715.0, 0.0, 715.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 715.0, 0.0, 715.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 715.0, 0.0, 715.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 715.0, 0.0, 715.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 715.0, 0.0, 715.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 715.0, 0.0, 715.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00056', 'رضا الشوادفي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0056-1', 'جهاز هاتف ذكي',
        0.0, 5040.0, 1500.0, 0.0,
        6, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1500.0, 1500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 590.0, 590.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 590.0, 500.0, 90.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 590.0, 500.0, 90.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 590.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 590.0, 950.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 590.0, 0.0, 590.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00057', 'أ / سندس', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0057-1', 'جهاز هاتف ذكي',
        0.0, 14650.0, 0.0, 7650.0,
        2, 3825.00, CURRENT_DATE,
        CASE WHEN 7650.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 14300.0, 3000.0, 11300.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 350.0, 4000.0, 0.0, 'paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00058', 'سمر عادل لطفي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0058-1', 'جهاز هاتف ذكي',
        0.0, 8325.0, 3000.0, 3325.0,
        3, 1108.33, CURRENT_DATE,
        CASE WHEN 3325.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 3000.0, 2000.0, 1000.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1775.0, 1000.0, 775.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1775.0, 1000.0, 775.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1775.0, 1000.0, 775.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00059', 'الشيخ / سعد حسن موسي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0059-1', 'جهاز هاتف ذكي',
        0.0, 12600.0, 1000.0, 0.0,
        10, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1160.0, 1160.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1160.0, 1160.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1160.0, 1160.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1160.0, 1160.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1160.0, 1160.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1160.0, 1160.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 1160.0, 1160.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 1160.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 1160.0, 1400.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 1160.0, 80.0, 1080.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00060', 'الحاج / شريف سعفان', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0060-1', 'جهاز هاتف ذكي',
        0.0, 12500.0, 4000.0, 0.0,
        10, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 4000.0, 4000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 850.0, 850.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 850.0, 850.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 850.0, 850.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 850.0, 850.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 850.0, 850.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 850.0, 850.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 850.0, 850.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 850.0, 850.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 850.0, 850.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 850.0, 850.0, 0.0, 'paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00061', 'شريف ع المنعم', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0061-1', 'جهاز هاتف ذكي',
        0.0, 0.0, 0.0, -6040.0,
        0, -6040.00, CURRENT_DATE,
        CASE WHEN -6040.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00062', 'الشيخ شريف سعفان', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0062-1', 'جهاز هاتف ذكي',
        0.0, 9300.0, 2000.0, 100.0,
        4, 25.00, CURRENT_DATE,
        CASE WHEN 100.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1825.0, 1800.0, 25.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1825.0, 1800.0, 25.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1825.0, 1800.0, 25.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1825.0, 1800.0, 25.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00063', 'شوقي عسران', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0063-1', 'جهاز هاتف ذكي',
        0.0, 0.0, 0.0, 0.0,
        1, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 6250.0, 2000.0, 4250.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00064', 'شاكر جمال شاكر سرور', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0064-1', 'جهاز هاتف ذكي',
        0.0, 7850.0, 3000.0, 0.0,
        10, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 3000.0, 2500.0, 500.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 485.0, 4200.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 485.0, 1150.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 485.0, 0.0, 485.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 485.0, 0.0, 485.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 485.0, 0.0, 485.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 485.0, 0.0, 485.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 485.0, 0.0, 485.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 485.0, 0.0, 485.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 485.0, 0.0, 485.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 485.0, 0.0, 485.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00065', 'صبري', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0065-1', 'جهاز هاتف ذكي',
        0.0, 7250.0, 0.0, 1950.0,
        2, 975.00, CURRENT_DATE,
        CASE WHEN 1950.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 7050.0, 4300.0, 2750.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 200.0, 1000.0, 0.0, 'paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00066', 'صبري قاسم', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0066-1', 'جهاز هاتف ذكي',
        0.0, 4500.0, 1000.0, 300.0,
        7, 42.86, CURRENT_DATE,
        CASE WHEN 300.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 500.0, 300.0, 200.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 500.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 500.0, 200.0, 300.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 500.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 500.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 500.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 500.0, 200.0, 300.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00067', 'أ / صفاء هاشم', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0067-1', 'جهاز هاتف ذكي',
        0.0, 6375.0, 1000.0, 0.0,
        5, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1075.0, 1000.0, 75.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1075.0, 1150.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1075.0, 1000.0, 75.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1075.0, 1000.0, 75.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1075.0, 1225.0, 0.0, 'paid'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0067-2', 'جهاز هاتف ذكي',
        0.0, 5000.0, 1000.0, 0.0,
        10, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 400.0, 400.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 400.0, 400.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 400.0, 400.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 400.0, 400.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 400.0, 400.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 400.0, 400.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 400.0, 400.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 400.0, 400.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 400.0, 400.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 400.0, 400.0, 0.0, 'paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00068', 'غنيم لولو', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0068-1', 'جهاز هاتف ذكي',
        0.0, 13350.0, 0.0, 4350.0,
        2, 2175.00, CURRENT_DATE,
        CASE WHEN 4350.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 6700.0, 4000.0, 2700.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 6650.0, 5000.0, 1650.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00069', 'م / غنيم لولو', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0069-1', 'جهاز هاتف ذكي',
        0.0, 15800.0, 6000.0, 800.0,
        10, 80.00, CURRENT_DATE,
        CASE WHEN 800.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 6000.0, 6000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 980.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 980.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 980.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 980.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 980.0, 4000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 980.0, 0.0, 980.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 980.0, 0.0, 980.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 980.0, 0.0, 980.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 980.0, 0.0, 980.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 980.0, 0.0, 980.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00070', 'عبدالرحمن فرحات', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0070-1', 'جهاز هاتف ذكي',
        0.0, 2125.0, 500.0, 625.0,
        5, 125.00, CURRENT_DATE,
        CASE WHEN 625.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 500.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 325.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 325.0, 0.0, 325.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 325.0, 0.0, 325.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 325.0, 0.0, 325.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 325.0, 0.0, 325.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00071', 'أ / عمرو عباس هاشم', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0071-1', 'جهاز هاتف ذكي',
        0.0, 30800.0, 7000.0, 12200.0,
        11, 1109.09, CURRENT_DATE,
        CASE WHEN 12200.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 7000.0, 7000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 2380.0, 2300.0, 80.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 2380.0, 2300.0, 80.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 2380.0, 5000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 2380.0, 0.0, 2380.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 2380.0, 0.0, 2380.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 2380.0, 0.0, 2380.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 2380.0, 0.0, 2380.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 2380.0, 0.0, 2380.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 2380.0, 0.0, 2380.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 2380.0, 0.0, 2380.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 12,
        CURRENT_DATE, 9900.0, 2000.0, 7900.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00072', 'عبدالعزيز صالح', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0072-1', 'جهاز هاتف ذكي',
        0.0, 7650.0, 1000.0, 1335.0,
        10, 133.50, CURRENT_DATE,
        CASE WHEN 1335.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 665.0, 665.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 665.0, 650.0, 15.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 665.0, 4000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 665.0, 0.0, 665.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 665.0, 0.0, 665.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 665.0, 0.0, 665.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 665.0, 0.0, 665.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 665.0, 0.0, 665.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 665.0, 0.0, 665.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 665.0, 0.0, 665.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00073', 'أ / علا البلاصي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0073-1', 'جهاز هاتف ذكي',
        21930.0, 0.0, 0.0, 0.0,
        5, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 7100.0, 7030.0, 70.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 7100.0, 0.0, 7100.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 7100.0, 0.0, 7100.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 195.0, 0.0, 195.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 435.0, 0.0, 435.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00074', 'ك / علي كامل', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0074-1', 'جهاز هاتف ذكي',
        0.0, 15850.0, 9000.0, 500.0,
        5, 100.00, CURRENT_DATE,
        CASE WHEN 500.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 9000.0, 9000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1370.0, 1370.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1370.0, 1370.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1370.0, 1000.0, 370.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1370.0, 1000.0, 370.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1370.0, 1610.0, 0.0, 'paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00075', 'أ / عمر سيداحمد', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0075-1', 'جهاز هاتف ذكي',
        0.0, 9720.0, 5000.0, 820.0,
        4, 205.00, CURRENT_DATE,
        CASE WHEN 820.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 5000.0, 5000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1180.0, 1000.0, 180.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1180.0, 500.0, 680.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1180.0, 800.0, 380.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1180.0, 1000.0, 180.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00076', 'أ / عبدالحميد صالح', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0076-1', 'جهاز هاتف ذكي',
        0.0, 24880.0, 10000.0, 4960.0,
        6, 826.67, CURRENT_DATE,
        CASE WHEN 4960.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 10000.0, 10000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 2480.0, 2480.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 2480.0, 2480.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 2480.0, 2480.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 2480.0, 2480.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 2480.0, 0.0, 2480.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 2480.0, 0.0, 2480.0, 'pending'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0076-2', 'جهاز هاتف ذكي',
        0.0, 8000.0, 2000.0, 0.0,
        6, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0076-3', 'جهاز هاتف ذكي',
        0.0, 15290.0, 1000.0, 140.0,
        16, 8.75, CURRENT_DATE,
        CASE WHEN 140.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1500.0, 1500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 940.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 940.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 940.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 940.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 940.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 940.0, 500.0, 440.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 715.0, 715.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 715.0, 715.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 715.0, 715.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 12,
        CURRENT_DATE, 715.0, 715.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 13,
        CURRENT_DATE, 715.0, 715.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 14,
        CURRENT_DATE, 715.0, 715.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 15,
        CURRENT_DATE, 715.0, 0.0, 715.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 16,
        CURRENT_DATE, 715.0, 1430.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 17,
        CURRENT_DATE, 715.0, 1400.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 18,
        CURRENT_DATE, 715.0, 30.0, 685.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00077', 'أ / عبدالرحمن محمد سرحان', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0077-1', 'جهاز هاتف ذكي',
        0.0, 25450.0, 6000.0, 15550.0,
        10, 1555.00, CURRENT_DATE,
        CASE WHEN 15550.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 6000.0, 6000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1945.0, 1950.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1945.0, 1950.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1945.0, 0.0, 1945.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1945.0, 0.0, 1945.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1945.0, 0.0, 1945.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1945.0, 0.0, 1945.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 1945.0, 0.0, 1945.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 1945.0, 0.0, 1945.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 1945.0, 0.0, 1945.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 1945.0, 0.0, 1945.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00078', 'أ / عفت عرابي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0078-1', 'جهاز هاتف ذكي',
        0.0, 16180.0, 2000.0, 2000.0,
        11, 181.82, CURRENT_DATE,
        CASE WHEN 2000.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 2000.0, 1500.0, 500.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1400.0, 1000.0, 400.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1400.0, 1000.0, 400.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1400.0, 1680.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1400.0, 1000.0, 400.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1400.0, 1000.0, 400.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1400.0, 1000.0, 400.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 1400.0, 1000.0, 400.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 1400.0, 1000.0, 400.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 1400.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 1400.0, 1000.0, 400.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 12,
        CURRENT_DATE, 180.0, 1000.0, 0.0, 'paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00079', 'ا/ عبدالعزيز مجدي سرور', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0079-1', 'جهاز هاتف ذكي',
        0.0, 7895.0, 5000.0, 0.0,
        3, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 5000.0, 5000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 965.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 965.0, 895.0, 70.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 965.0, 0.0, 965.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00080', 'علي محمد مرعي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0080-1', 'جهاز هاتف ذكي',
        0.0, 16215.0, 7000.0, 215.0,
        11, 19.55, CURRENT_DATE,
        CASE WHEN 215.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 7000.0, 7000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 875.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 875.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 875.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 875.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 875.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 875.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 875.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 875.0, 0.0, 875.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 875.0, 0.0, 875.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 875.0, 0.0, 875.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 12,
        CURRENT_DATE, 465.0, 0.0, 465.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00081', 'أ / عماد رشاد', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0081-1', 'جهاز هاتف ذكي',
        0.0, 9200.0, 5000.0, 0.0,
        4, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 5000.0, 5000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1050.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1050.0, 1000.0, 50.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1050.0, 500.0, 550.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1050.0, 700.0, 350.0, 'partially_paid'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0081-2', 'جهاز هاتف ذكي',
        0.0, 0.0, 2000.0, 8800.0,
        10, 880.00, CURRENT_DATE,
        CASE WHEN 8800.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 2000.0, 1000.0, 1000.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 880.0, 500.0, 380.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 880.0, 500.0, 380.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 880.0, 0.0, 880.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 880.0, 0.0, 880.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 880.0, 0.0, 880.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 880.0, 0.0, 880.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 880.0, 0.0, 880.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 880.0, 0.0, 880.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 880.0, 0.0, 880.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 880.0, 0.0, 880.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00082', 'أ / عبد المنعم - صيدلية مكة', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0082-1', 'جهاز هاتف ذكي',
        0.0, 0.0, 0.0, 0.0,
        1, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 13950.0, 4000.0, 9950.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00083', 'أ / عمرو عصام', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0083-1', 'جهاز هاتف ذكي',
        0.0, 40280.0, 8000.0, 0.0,
        16, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 8000.0, 8000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 2190.0, 2200.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 2190.0, 2190.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 2190.0, 2190.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 2190.0, 2190.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 2190.0, 2190.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 2190.0, 2190.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 2190.0, 2190.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 2190.0, 2190.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 2190.0, 2190.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 2190.0, 2190.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 12,
        CURRENT_DATE, 2190.0, 2190.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 13,
        CURRENT_DATE, 2190.0, 2190.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 14,
        CURRENT_DATE, 1500.0, 1500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 15,
        CURRENT_DATE, 1500.0, 1500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 16,
        CURRENT_DATE, 1500.0, 2990.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 17,
        CURRENT_DATE, 1500.0, 0.0, 1500.0, 'pending'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0083-2', 'جهاز هاتف ذكي',
        0.0, 42600.0, 15000.0, 18390.0,
        12, 1532.50, CURRENT_DATE,
        CASE WHEN 18390.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 15000.0, 15000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 2300.0, 2300.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 2300.0, 2310.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 2300.0, 2300.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 2300.0, 2300.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 2300.0, 0.0, 2300.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 2300.0, 0.0, 2300.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 2300.0, 0.0, 2300.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 2300.0, 0.0, 2300.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 2300.0, 0.0, 2300.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 2300.0, 0.0, 2300.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 12,
        CURRENT_DATE, 2300.0, 0.0, 2300.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 13,
        CURRENT_DATE, 2300.0, 0.0, 2300.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00084', 'أ / عماد حمدي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0084-1', 'جهاز هاتف ذكي',
        0.0, 65650.0, 25000.0, 30650.0,
        3, 10216.67, CURRENT_DATE,
        CASE WHEN 30650.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 25000.0, 25000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 13550.0, 10000.0, 3550.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 13550.0, 0.0, 13550.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 13550.0, 0.0, 13550.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00085', 'علاء حمدي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0085-1', 'جهاز هاتف ذكي',
        0.0, 6350.0, 0.0, 300.0,
        11, 27.27, CURRENT_DATE,
        CASE WHEN 300.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 3000.0, 2000.0, 1000.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 335.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 335.0, 300.0, 35.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 335.0, 300.0, 35.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 335.0, 300.0, 35.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 335.0, 300.0, 35.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 335.0, 300.0, 35.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 335.0, 300.0, 35.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 335.0, 400.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 335.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 335.0, 350.0, 0.0, 'paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00086', 'الشيخ عبدالعزيز شحاته', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0086-1', 'جهاز هاتف ذكي',
        0.0, 10600.0, 4000.0, 0.0,
        3, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 4000.0, 4000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 2200.0, 4000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 2200.0, 2400.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 2200.0, 200.0, 2000.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00087', 'عبد العزيز الجندي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0087-1', 'جهاز هاتف ذكي',
        0.0, 2925.0, 1500.0, 0.0,
        5, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1500.0, 1500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 285.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 285.0, 925.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 285.0, 0.0, 285.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 285.0, 0.0, 285.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 285.0, 0.0, 285.0, 'pending'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0087-2', 'جهاز هاتف ذكي',
        0.0, 7000.0, 3500.0, 4000.0,
        5, 800.00, CURRENT_DATE,
        CASE WHEN 4000.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 3500.0, 2500.0, 1000.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 700.0, 500.0, 200.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 700.0, 0.0, 700.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 700.0, 0.0, 700.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 700.0, 0.0, 700.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 700.0, 0.0, 700.0, 'pending'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0087-3', 'جهاز هاتف ذكي',
        0.0, 7000.0, 3000.0, 6250.0,
        5, 1250.00, CURRENT_DATE,
        CASE WHEN 6250.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 3000.0, 750.0, 2250.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 800.0, 0.0, 800.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 800.0, 0.0, 800.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 800.0, 0.0, 800.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 800.0, 0.0, 800.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 800.0, 0.0, 800.0, 'pending'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0087-4', 'جهاز هاتف ذكي',
        0.0, 0.0, 0.0, 9250.0,
        1, 9250.00, CURRENT_DATE,
        CASE WHEN 9250.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 10250.0, 1000.0, 9250.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00088', 'فارس -الخوالد', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0088-1', 'جهاز هاتف ذكي',
        0.0, 7800.0, 3000.0, 100.0,
        6, 16.67, CURRENT_DATE,
        CASE WHEN 100.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 3000.0, 3000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 800.0, 800.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 800.0, 1600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 800.0, 800.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 800.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 800.0, 500.0, 300.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 800.0, 0.0, 800.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00089', 'أ / فوزي زكريا', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0089-1', 'جهاز هاتف ذكي',
        0.0, 7600.0, 0.0, 5600.0,
        1, 5600.00, CURRENT_DATE,
        CASE WHEN 5600.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 7600.0, 2000.0, 5600.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00090', 'فهمي السماحي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0090-1', 'جهاز هاتف ذكي',
        0.0, 2800.0, 500.0, 570.0,
        10, 57.00, CURRENT_DATE,
        CASE WHEN 570.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 500.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 230.0, 230.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 230.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 230.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 230.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 230.0, 0.0, 230.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 230.0, 0.0, 230.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 230.0, 0.0, 230.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 230.0, 0.0, 230.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 230.0, 0.0, 230.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 230.0, 0.0, 230.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00091', 'الحاج / فؤاد لولو', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0091-1', 'جهاز هاتف ذكي',
        0.0, 8500.0, 1500.0, 0.0,
        10, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1500.0, 500.0, 1000.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 700.0, 1500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 700.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 700.0, 1500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 700.0, 500.0, 200.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 700.0, 500.0, 200.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 700.0, 500.0, 200.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 700.0, 2500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 700.0, 0.0, 700.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 700.0, 0.0, 700.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 700.0, 0.0, 700.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00092', 'فارس - الخوالد', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0092-1', 'جهاز هاتف ذكي',
        0.0, 18000.0, 5000.0, 0.0,
        10, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 5000.0, 5000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1300.0, 1300.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1300.0, 1300.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1300.0, 1200.0, 100.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1300.0, 1400.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1300.0, 2600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1300.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 1300.0, 3200.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 1300.0, 0.0, 1300.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 1300.0, 0.0, 1300.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 1300.0, 0.0, 1300.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00093', 'أ / كمال سالم كمال', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0093-1', 'جهاز هاتف ذكي',
        0.0, 12000.0, 4000.0, 6400.0,
        5, 1280.00, CURRENT_DATE,
        CASE WHEN 6400.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 4000.0, 4000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1600.0, 1600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1600.0, 0.0, 1600.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1600.0, 0.0, 1600.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1600.0, 0.0, 1600.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1600.0, 0.0, 1600.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00094', 'كمال سالم كمال', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0094-1', 'جهاز هاتف ذكي',
        0.0, 7000.0, 3000.0, 0.0,
        10, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 3000.0, 3000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 400.0, 400.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 400.0, 400.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 400.0, 400.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 400.0, 400.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 400.0, 400.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 400.0, 400.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 400.0, 400.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 400.0, 600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 400.0, 600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 400.0, 0.0, 400.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00095', 'كمال مسعود حميد', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0095-1', 'جهاز هاتف ذكي',
        0.0, 0.0, 3000.0, 17700.0,
        5, 3540.00, CURRENT_DATE,
        CASE WHEN 17700.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 3000.0, 3000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 3540.0, 0.0, 3540.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 3540.0, 0.0, 3540.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 3540.0, 0.0, 3540.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 3540.0, 0.0, 3540.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 3540.0, 0.0, 3540.0, 'pending'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0095-2', 'جهاز هاتف ذكي',
        0.0, 0.0, 3000.0, 17200.0,
        5, 3440.00, CURRENT_DATE,
        CASE WHEN 17200.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 3000.0, 3500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 3540.0, 0.0, 3540.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 3540.0, 0.0, 3540.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 3540.0, 0.0, 3540.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 3540.0, 0.0, 3540.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 3540.0, 0.0, 3540.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00096', 'كريم شتا', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0096-1', 'جهاز هاتف ذكي',
        0.0, 3630.0, 900.0, 2730.0,
        6, 455.00, CURRENT_DATE,
        CASE WHEN 2730.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 900.0, 900.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 455.0, 0.0, 455.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 455.0, 0.0, 455.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 455.0, 0.0, 455.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 455.0, 0.0, 455.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 455.0, 0.0, 455.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 455.0, 0.0, 455.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00097', 'كمال فتحي صالح', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0097-1', 'جهاز هاتف ذكي',
        0.0, 9300.0, 2000.0, 0.0,
        10, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 730.0, 730.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 730.0, 725.0, 5.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 730.0, 730.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 730.0, 725.0, 5.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 730.0, 725.0, 5.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 730.0, 1460.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 730.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 730.0, 205.0, 525.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 730.0, 0.0, 730.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 730.0, 0.0, 730.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00098', 'الحاج / لطفي الغباري', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0098-1', 'جهاز هاتف ذكي',
        0.0, 2850.0, 0.0, 0.0,
        2, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 850.0, 850.0, 0.0, 'paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00099', 'أ / محمد عبدالعال فوده', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0099-1', 'جهاز هاتف ذكي',
        0.0, 17005.0, 4000.0, 0.0,
        3, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 4000.0, 4000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 4335.0, 13005.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 4335.0, 0.0, 4335.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 4335.0, 0.0, 4335.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00100', 'أ / محمد رضا عبدالعال', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0100-1', 'جهاز هاتف ذكي',
        0.0, 21750.0, 13000.0, 7000.0,
        10, 700.00, CURRENT_DATE,
        CASE WHEN 7000.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 13000.0, 13000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 875.0, 875.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 875.0, 875.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 875.0, 0.0, 875.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 875.0, 0.0, 875.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 875.0, 0.0, 875.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 875.0, 0.0, 875.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 875.0, 0.0, 875.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 875.0, 0.0, 875.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 875.0, 0.0, 875.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 875.0, 0.0, 875.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00101', 'الحاج / متولي عبدالجليل', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0101-1', 'جهاز هاتف ذكي',
        0.0, 12150.0, 5000.0, 220.0,
        10, 22.00, CURRENT_DATE,
        CASE WHEN 220.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 5000.0, 5000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 715.0, 710.0, 5.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 715.0, 720.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 715.0, 700.0, 15.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 715.0, 700.0, 15.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 715.0, 700.0, 15.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 715.0, 700.0, 15.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 715.0, 700.0, 15.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 715.0, 700.0, 15.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 715.0, 1300.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 715.0, 0.0, 715.0, 'pending'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0101-2', 'جهاز هاتف ذكي',
        0.0, 12100.0, 3000.0, 3900.0,
        7, 557.14, CURRENT_DATE,
        CASE WHEN 3900.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 3000.0, 3000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1300.0, 1300.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1300.0, 1300.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1300.0, 1300.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1300.0, 1300.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1300.0, 0.0, 1300.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1300.0, 0.0, 1300.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 1300.0, 0.0, 1300.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00102', 'محمود عطيه طلخان', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0102-1', 'جهاز هاتف ذكي',
        0.0, 9000.0, 2000.0, 2000.0,
        7, 285.71, CURRENT_DATE,
        CASE WHEN 2000.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1000.0, 0.0, 1000.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 1000.0, 0.0, 1000.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00103', 'أ / محمد مراد حماده', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0103-1', 'جهاز هاتف ذكي',
        0.0, 8300.0, 2000.0, 6300.0,
        5, 1260.00, CURRENT_DATE,
        CASE WHEN 6300.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1260.0, 0.0, 1260.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1260.0, 0.0, 1260.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1260.0, 0.0, 1260.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1260.0, 0.0, 1260.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1260.0, 0.0, 1260.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00104', 'م / محمد علاء', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0104-1', 'جهاز هاتف ذكي',
        0.0, 19400.0, 14000.0, 2700.0,
        2, 1350.00, CURRENT_DATE,
        CASE WHEN 2700.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 14000.0, 14000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 2700.0, 2000.0, 700.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 2700.0, 200.0, 2500.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00105', 'أ / محمد عبد الله غنيم', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0105-1', 'جهاز هاتف ذكي',
        0.0, 26450.0, 8650.0, 0.0,
        5, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 8650.0, 6000.0, 2650.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 3560.0, 4000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 3560.0, 5000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 3560.0, 8000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 3560.0, 0.0, 3560.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 3560.0, 3450.0, 110.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00106', 'أ / محمود رجب', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0106-1', 'جهاز هاتف ذكي',
        0.0, 22500.0, 10000.0, 7000.0,
        10, 700.00, CURRENT_DATE,
        CASE WHEN 7000.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 10000.0, 10000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1250.0, 300.0, 950.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1250.0, 800.0, 450.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1250.0, 1400.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1250.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1250.0, 1000.0, 250.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1250.0, 0.0, 1250.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 1250.0, 0.0, 1250.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 1250.0, 0.0, 1250.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 1250.0, 0.0, 1250.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 1250.0, 0.0, 1250.0, 'pending'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0106-2', 'جهاز هاتف ذكي',
        0.0, 33900.0, 14000.0, 11380.0,
        10, 1138.00, CURRENT_DATE,
        CASE WHEN 11380.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 14000.0, 14000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 2260.0, 2260.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 2260.0, 2260.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 2260.0, 2000.0, 260.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 2260.0, 2000.0, 260.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 2260.0, 0.0, 2260.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1720.0, 0.0, 1720.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 1720.0, 0.0, 1720.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 1720.0, 0.0, 1720.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 1720.0, 0.0, 1720.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 1720.0, 0.0, 1720.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00107', 'أ / مندور', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0107-1', 'جهاز هاتف ذكي',
        0.0, 7100.0, 2000.0, 5100.0,
        5, 1020.00, CURRENT_DATE,
        CASE WHEN 5100.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1020.0, 0.0, 1020.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1020.0, 0.0, 1020.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1020.0, 0.0, 1020.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1020.0, 0.0, 1020.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1020.0, 0.0, 1020.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00108', 'أ / محمد زغلول', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0108-1', 'جهاز هاتف ذكي',
        0.0, 81000.0, 30000.0, 2500.0,
        6, 416.67, CURRENT_DATE,
        CASE WHEN 2500.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 30000.0, 30000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 10200.0, 25000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 10200.0, 5000.0, 5200.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 10200.0, 2000.0, 8200.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 10200.0, 6000.0, 4200.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 10200.0, 3000.0, 7200.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 0.0, 0.0, 0.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00109', 'أ / محمود محي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0109-1', 'جهاز هاتف ذكي',
        0.0, 10900.0, 3600.0, 4570.0,
        10, 457.00, CURRENT_DATE,
        CASE WHEN 4570.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 3600.0, 3600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 730.0, 730.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 730.0, 0.0, 730.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 730.0, 0.0, 730.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 730.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 730.0, 0.0, 730.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 730.0, 0.0, 730.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 730.0, 0.0, 730.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 730.0, 0.0, 730.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 730.0, 0.0, 730.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 730.0, 0.0, 730.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00110', 'مصطفي صبحي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0110-1', 'جهاز هاتف ذكي',
        0.0, 7920.0, 1500.0, 3920.0,
        6, 653.33, CURRENT_DATE,
        CASE WHEN 3920.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1500.0, 1000.0, 500.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1070.0, 1000.0, 70.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1070.0, 1000.0, 70.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1070.0, 1000.0, 70.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1070.0, 0.0, 1070.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1070.0, 0.0, 1070.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1070.0, 0.0, 1070.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00111', 'اجمالي حساب محمد سمير صالح', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0111-1', 'جهاز هاتف ذكي',
        0.0, 72650.0, 0.0, 34000.0,
        3, 11333.33, CURRENT_DATE,
        CASE WHEN 34000.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 4350.0, 8000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 26900.0, 29650.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 41400.0, 1000.0, 40400.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00112', 'أ / محمد عبدالمحسن', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0112-1', 'جهاز هاتف ذكي',
        0.0, 8750.0, 2000.0, 6075.0,
        10, 607.50, CURRENT_DATE,
        CASE WHEN 6075.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 675.0, 675.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 675.0, 0.0, 675.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 675.0, 0.0, 675.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 675.0, 0.0, 675.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 675.0, 0.0, 675.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 675.0, 0.0, 675.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 675.0, 0.0, 675.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 675.0, 0.0, 675.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 675.0, 0.0, 675.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 675.0, 0.0, 675.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00113', 'أ / مصطفي زغلول', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0113-1', 'جهاز هاتف ذكي',
        0.0, 18795.0, 7000.0, 8795.0,
        5, 1759.00, CURRENT_DATE,
        CASE WHEN 8795.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 7000.0, 7000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 3115.0, 3000.0, 115.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 3115.0, 0.0, 3115.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 3115.0, 0.0, 3115.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1225.0, 0.0, 1225.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1225.0, 0.0, 1225.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00114', 'أ / محمود همام', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0114-1', 'جهاز هاتف ذكي',
        0.0, 24600.0, 15000.0, 7100.0,
        6, 1183.33, CURRENT_DATE,
        CASE WHEN 7100.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 15000.0, 2000.0, 13000.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1600.0, 3000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1600.0, 5000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1600.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1600.0, 500.0, 1100.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1600.0, 5000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1600.0, 0.0, 1600.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00115', 'أ/ محمد جمال شمس', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0115-1', 'جهاز هاتف ذكي',
        0.0, 11000.0, 3000.0, 7200.0,
        10, 720.00, CURRENT_DATE,
        CASE WHEN 7200.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 3000.0, 3000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 800.0, 800.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 800.0, 0.0, 800.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 800.0, 0.0, 800.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 800.0, 0.0, 800.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 800.0, 0.0, 800.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 800.0, 0.0, 800.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 800.0, 0.0, 800.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 800.0, 0.0, 800.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 800.0, 0.0, 800.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 800.0, 0.0, 800.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00116', 'أ / محمد السواق', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0116-1', 'جهاز هاتف ذكي',
        0.0, 30725.0, 5100.0, 8375.0,
        13, 644.23, CURRENT_DATE,
        CASE WHEN 8375.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 12000.0, 12000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 800.0, 800.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 800.0, 800.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 800.0, 0.0, 800.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 800.0, 0.0, 800.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 800.0, 0.0, 800.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 800.0, 0.0, 800.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 800.0, 0.0, 800.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 800.0, 0.0, 800.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 800.0, 0.0, 800.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 800.0, 0.0, 800.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 12,
        CURRENT_DATE, 5100.0, 5000.0, 100.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 13,
        CURRENT_DATE, 1875.0, 1875.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 14,
        CURRENT_DATE, 1875.0, 1875.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 15,
        CURRENT_DATE, 1875.0, 0.0, 1875.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00117', 'أ / محمد حمدي رفاعي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0117-1', 'جهاز هاتف ذكي',
        0.0, 24000.0, 4000.0, 2000.0,
        10, 200.00, CURRENT_DATE,
        CASE WHEN 2000.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 4000.0, 4000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 2000.0, 0.0, 2000.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 2000.0, 4000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 2000.0, 0.0, 2000.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00118', 'م / محمد السعيد عبداللاه', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0118-1', 'جهاز هاتف ذكي',
        0.0, 9400.0, 3000.0, 1600.0,
        4, 400.00, CURRENT_DATE,
        CASE WHEN 1600.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 3000.0, 3000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1600.0, 1600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1600.0, 1600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1600.0, 1600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1600.0, 0.0, 1600.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00119', 'الحاج / مسعد ابو هاشم', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0119-1', 'جهاز هاتف ذكي',
        0.0, 19000.0, 6000.0, 6000.0,
        10, 600.00, CURRENT_DATE,
        CASE WHEN 6000.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 6000.0, 4000.0, 2000.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1300.0, 3000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1300.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1300.0, 4000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1300.0, 0.0, 1300.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1300.0, 0.0, 1300.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1300.0, 0.0, 1300.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 1300.0, 0.0, 1300.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 1300.0, 0.0, 1300.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 1300.0, 0.0, 1300.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 1300.0, 0.0, 1300.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00120', 'أ / محمود الريفي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0120-1', 'جهاز هاتف ذكي',
        0.0, 13500.0, 3000.0, 7350.0,
        10, 735.00, CURRENT_DATE,
        CASE WHEN 7350.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 3000.0, 3000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1050.0, 1050.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1050.0, 1050.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1050.0, 1050.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1050.0, 0.0, 1050.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1050.0, 0.0, 1050.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1050.0, 0.0, 1050.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 1050.0, 0.0, 1050.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 1050.0, 0.0, 1050.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 1050.0, 0.0, 1050.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 1050.0, 0.0, 1050.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00121', 'أ / محمد رشاد موسي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0121-1', 'جهاز هاتف ذكي',
        0.0, 13250.0, 3000.0, 9225.0,
        10, 922.50, CURRENT_DATE,
        CASE WHEN 9225.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 3000.0, 3000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1025.0, 1025.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1025.0, 0.0, 1025.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1025.0, 0.0, 1025.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1025.0, 0.0, 1025.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1025.0, 0.0, 1025.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1025.0, 0.0, 1025.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 1025.0, 0.0, 1025.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 1025.0, 0.0, 1025.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 1025.0, 0.0, 1025.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 1025.0, 0.0, 1025.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00122', 'أ / محمد ماهرهاشم', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0122-1', 'جهاز هاتف ذكي',
        0.0, 15600.0, 4800.0, 10800.0,
        6, 1800.00, CURRENT_DATE,
        CASE WHEN 10800.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 4800.0, 4800.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1800.0, 0.0, 1800.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1800.0, 0.0, 1800.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1800.0, 0.0, 1800.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1800.0, 0.0, 1800.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1800.0, 0.0, 1800.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1800.0, 0.0, 1800.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00123', 'نزيه مسعود', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0123-1', 'جهاز هاتف ذكي',
        0.0, 7925.0, 4000.0, 2355.0,
        5, 471.00, CURRENT_DATE,
        CASE WHEN 2355.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 4000.0, 4000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 785.0, 785.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 785.0, 785.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 785.0, 0.0, 785.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 785.0, 0.0, 785.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 785.0, 0.0, 785.0, 'pending'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0123-2', 'جهاز هاتف ذكي',
        0.0, 22350.0, 1235.0, 11115.0,
        9, 1235.00, CURRENT_DATE,
        CASE WHEN 11115.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 10000.0, 10000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1235.0, 1235.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1235.0, 0.0, 1235.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1235.0, 0.0, 1235.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1235.0, 0.0, 1235.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1235.0, 0.0, 1235.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 1235.0, 0.0, 1235.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 1235.0, 0.0, 1235.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 1235.0, 0.0, 1235.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 1235.0, 0.0, 1235.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 1235.0, 0.0, 1235.0, 'pending'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0123-3', 'جهاز هاتف ذكي',
        0.0, 14250.0, 0.0, 400.0,
        6, 66.67, CURRENT_DATE,
        CASE WHEN 400.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 5000.0, 5000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1850.0, 0.0, 1850.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1850.0, 3700.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1850.0, 5150.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1850.0, 0.0, 1850.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1850.0, 0.0, 1850.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00124', 'محمد عاطف شمس', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0124-1', 'جهاز هاتف ذكي',
        0.0, 9245.0, 4000.0, 1000.0,
        6, 166.67, CURRENT_DATE,
        CASE WHEN 1000.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 4000.0, 4000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1350.0, 500.0, 850.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1350.0, 100.0, 1250.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1350.0, 200.0, 1150.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 165.0, 0.0, 165.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 675.0, 0.0, 675.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 355.0, 0.0, 355.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00125', 'نبيل الخطيب', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0125-1', 'جهاز هاتف ذكي',
        0.0, 12500.0, 3000.0, 3800.0,
        10, 380.00, CURRENT_DATE,
        CASE WHEN 3800.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 3000.0, 3000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 950.0, 950.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 950.0, 950.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 950.0, 950.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 950.0, 950.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 950.0, 950.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 950.0, 950.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 950.0, 0.0, 950.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 950.0, 0.0, 950.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 950.0, 0.0, 950.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 950.0, 0.0, 950.0, 'pending'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0125-2', 'جهاز هاتف ذكي',
        0.0, 11700.0, 2000.0, 7760.0,
        10, 776.00, CURRENT_DATE,
        CASE WHEN 7760.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 970.0, 970.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 970.0, 970.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 970.0, 0.0, 970.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 970.0, 0.0, 970.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 970.0, 0.0, 970.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 970.0, 0.0, 970.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 970.0, 0.0, 970.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 970.0, 0.0, 970.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 970.0, 0.0, 970.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 970.0, 0.0, 970.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00126', 'الحاج متولي عبدالجليل', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0126-1', 'جهاز هاتف ذكي',
        0.0, 10100.0, 3100.0, 0.0,
        10, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 3100.0, 3100.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 700.0, 1300.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 700.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 700.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 700.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 700.0, 0.0, 700.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 700.0, 1700.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 700.0, 0.0, 700.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 700.0, 0.0, 700.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 700.0, 0.0, 700.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 700.0, 0.0, 700.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00127', 'محمود غنيم داود', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0127-1', 'جهاز هاتف ذكي',
        0.0, 7900.0, 2000.0, 220.0,
        10, 22.00, CURRENT_DATE,
        CASE WHEN 220.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 590.0, 600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 590.0, 590.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 590.0, 600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 590.0, 600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 590.0, 590.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 590.0, 600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 590.0, 600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 590.0, 400.0, 190.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 590.0, 500.0, 90.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 590.0, 600.0, 0.0, 'paid'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0127-2', 'جهاز هاتف ذكي',
        0.0, 4200.0, 0.0, 2650.0,
        2, 1325.00, CURRENT_DATE,
        CASE WHEN 2650.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1500.0, 1100.0, 400.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 2700.0, 450.0, 2250.0, 'partially_paid'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0127-3', 'جهاز هاتف ذكي',
        0.0, 7400.0, 2000.0, 4000.0,
        3, 1333.33, CURRENT_DATE,
        CASE WHEN 4000.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1800.0, 1000.0, 800.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1800.0, 200.0, 1600.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1800.0, 200.0, 1600.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00128', 'محمود غنيم', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0128-1', 'جهاز هاتف ذكي',
        0.0, 11350.0, 2500.0, 6050.0,
        10, 605.00, CURRENT_DATE,
        CASE WHEN 6050.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 2500.0, 2500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 885.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 885.0, 800.0, 85.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 885.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 885.0, 0.0, 885.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 885.0, 0.0, 885.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 885.0, 0.0, 885.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 885.0, 0.0, 885.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 885.0, 0.0, 885.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 885.0, 0.0, 885.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 885.0, 0.0, 885.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00129', 'محمد عبد الله غنيم', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0129-1', 'جهاز هاتف ذكي',
        0.0, 8450.0, 0.0, 5450.0,
        2, 2725.00, CURRENT_DATE,
        CASE WHEN 5450.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 4600.0, 500.0, 4100.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 3850.0, 2500.0, 1350.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00130', 'محمد سمسم', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0130-1', 'جهاز هاتف ذكي',
        0.0, 3250.0, 1000.0, 1825.0,
        10, 182.50, CURRENT_DATE,
        CASE WHEN 1825.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 225.0, 225.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 225.0, 100.0, 125.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 225.0, 100.0, 125.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 225.0, 0.0, 225.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 225.0, 0.0, 225.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 225.0, 0.0, 225.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 225.0, 0.0, 225.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 225.0, 0.0, 225.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 225.0, 0.0, 225.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 225.0, 0.0, 225.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00131', 'د / نسمة موسي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0131-1', 'جهاز هاتف ذكي',
        0.0, 5650.0, 1000.0, 0.0,
        10, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 465.0, 465.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 465.0, 470.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 465.0, 460.0, 5.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 465.0, 470.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 465.0, 470.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 465.0, 470.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 465.0, 470.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 465.0, 470.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 465.0, 460.0, 5.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 465.0, 445.0, 20.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00132', 'محمد هاشم السيد', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0132-1', 'جهاز هاتف ذكي',
        0.0, 4300.0, 1000.0, 0.0,
        10, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1000.0, 950.0, 50.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 330.0, 330.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 330.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 330.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 330.0, 1300.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 330.0, 220.0, 110.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 330.0, 0.0, 330.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 330.0, 0.0, 330.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 330.0, 0.0, 330.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 330.0, 0.0, 330.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 330.0, 0.0, 330.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00133', 'مصطفي محمود البرجي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0133-1', 'جهاز هاتف ذكي',
        0.0, 7040.0, 5000.0, 0.0,
        6, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 540.0, 0.0, 540.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 5000.0, 1500.0, 3500.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 300.0, 3900.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 300.0, 1650.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 300.0, -10.0, 310.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 300.0, 0.0, 300.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 300.0, 0.0, 300.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00134', 'محمود محي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0134-1', 'جهاز هاتف ذكي',
        0.0, 5100.0, 1500.0, 0.0,
        6, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1500.0, 1500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 600.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 600.0, 500.0, 100.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 600.0, 1200.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 600.0, 400.0, 200.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 600.0, 200.0, 400.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 600.0, 300.0, 300.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00135', 'محمد ع الرؤف ع العزيز', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0135-1', 'جهاز هاتف ذكي',
        0.0, 7650.0, 1000.0, 0.0,
        10, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 665.0, 500.0, 165.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 665.0, 600.0, 65.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 665.0, 500.0, 165.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 665.0, 500.0, 165.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 665.0, 500.0, 165.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 665.0, 500.0, 165.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 665.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 665.0, 2550.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 665.0, 0.0, 665.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 665.0, 0.0, 665.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00136', 'نوال احمد هارون', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0136-1', 'جهاز هاتف ذكي',
        0.0, 4125.0, 0.0, 2800.0,
        11, 254.55, CURRENT_DATE,
        CASE WHEN 2800.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 425.0, 425.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 370.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 370.0, 400.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 370.0, 0.0, 370.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 370.0, 0.0, 370.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 370.0, 0.0, 370.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 370.0, 0.0, 370.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 370.0, 0.0, 370.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 370.0, 0.0, 370.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 370.0, 0.0, 370.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 370.0, 0.0, 370.0, 'pending'
    );


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0136-2', 'جهاز هاتف ذكي',
        0.0, 4250.0, 500.0, 3075.0,
        10, 307.50, CURRENT_DATE,
        CASE WHEN 3075.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 500.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 375.0, 375.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 375.0, 300.0, 75.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 375.0, 0.0, 375.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 375.0, 0.0, 375.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 375.0, 0.0, 375.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 375.0, 0.0, 375.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 375.0, 0.0, 375.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 375.0, 0.0, 375.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 375.0, 0.0, 375.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 375.0, 0.0, 375.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00137', 'محمد ابراهيم ع السلام ابراهيم', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0137-1', 'جهاز هاتف ذكي',
        0.0, 3750.0, 500.0, 0.0,
        5, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 500.0, 500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 650.0, 650.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 650.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 650.0, 1600.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 650.0, 0.0, 650.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 650.0, 0.0, 650.0, 'pending'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00138', 'محمد عابد صالح', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0138-1', 'جهاز هاتف ذكي',
        0.0, 5000.0, 0.0, 200.0,
        5, 40.00, CURRENT_DATE,
        CASE WHEN 200.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 0.0, 0.0, 0.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1000.0, 1000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 1000.0, 800.0, 200.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00139', 'م / هيثم عطيان', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0139-1', 'جهاز هاتف ذكي',
        0.0, 8080.0, 4000.0, 0.0,
        3, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 4000.0, 4000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1360.0, 1360.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1360.0, 1360.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1360.0, 1360.0, 0.0, 'paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00140', 'وائل الشوادفي', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0140-1', 'جهاز هاتف ذكي',
        0.0, 7400.0, 1500.0, 0.0,
        4, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 1500.0, 1500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 1475.0, 1500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 1475.0, 1500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 1475.0, 1500.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 1475.0, 1400.0, 75.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00141', 'وليد نصر', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0141-1', 'جهاز هاتف ذكي',
        0.0, 0.0, 0.0, 0.0,
        3, 0.00, CURRENT_DATE,
        CASE WHEN 0.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 185600.0, 100000.0, 85600.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 332220.0, 50000.0, 282220.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 52180.0, 50000.0, 2180.0, 'partially_paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00142', 'وائل جلال', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0142-1', 'جهاز هاتف ذكي',
        0.0, 0.0, 0.0, -25.0,
        0, -25.00, CURRENT_DATE,
        CASE WHEN -25.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00143', 'يوسف الدهشان', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0143-1', 'جهاز هاتف ذكي',
        0.0, 9850.0, 2000.0, 550.0,
        10, 55.00, CURRENT_DATE,
        CASE WHEN 550.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 2000.0, 2000.0, 0.0, 'paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 785.0, 700.0, 85.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 785.0, 700.0, 85.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 785.0, 700.0, 85.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 5,
        CURRENT_DATE, 785.0, 700.0, 85.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 6,
        CURRENT_DATE, 785.0, 700.0, 85.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 7,
        CURRENT_DATE, 785.0, 700.0, 85.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 8,
        CURRENT_DATE, 785.0, 700.0, 85.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 9,
        CURRENT_DATE, 785.0, 700.0, 85.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 10,
        CURRENT_DATE, 785.0, 700.0, 85.0, 'partially_paid'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 11,
        CURRENT_DATE, 785.0, 1000.0, 0.0, 'paid'
    );

END $$;


DO $$
DECLARE
    v_cust_id UUID;
    v_contract_id UUID;
BEGIN
    INSERT INTO public.customers (organization_id, code, name, phone)
    VALUES ('00000000-0000-0000-0000-000000000001', 'CUS-00144', 'نقدي اقارب وتشغيل', NULLIF('', ''))
    RETURNING id INTO v_cust_id;


    INSERT INTO public.contracts (
        organization_id, customer_id, contract_number, device_name,
        cash_price, total_installment_price, down_payment, remaining_balance,
        installment_count, monthly_installment_amount, start_date, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_cust_id, 'CTR-0144-1', 'جهاز هاتف ذكي',
        0.0, 42300.0, 0.0, 42300.0,
        4, 10575.00, CURRENT_DATE,
        CASE WHEN 42300.0 <= 0 THEN 'completed' ELSE 'active' END
    ) RETURNING id INTO v_contract_id;


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 1,
        CURRENT_DATE, 0.0, 0.0, 0.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 2,
        CURRENT_DATE, 11000.0, 0.0, 11000.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 3,
        CURRENT_DATE, 31300.0, 0.0, 31300.0, 'pending'
    );


    INSERT INTO public.installments (
        organization_id, contract_id, customer_id, installment_number,
        due_date, due_amount, paid_amount, remaining_amount, status
    ) VALUES (
        '00000000-0000-0000-0000-000000000001', v_contract_id, v_cust_id, 4,
        CURRENT_DATE, 0.0, 0.0, 0.0, 'pending'
    );

END $$;
