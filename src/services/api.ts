import { supabase } from '../utils/supabase';
import { 
  Customer, 
  Contract, 
  Installment, 
  Collection, 
  Treasury, 
  TreasuryTransaction, 
  CashWallet, 
  WalletTransaction, 
  POSMachine, 
  FastCreditAccount, 
  Supplier, 
  Expense, 
  DailyClosing 
} from '../types';

const cleanSearchTerm = (value: string) => value.trim().replace(/[,.()]/g, ' ').replace(/\s+/g, ' ');

const createCustomerCode = () => {
  const stamp = Date.now().toString(36).toUpperCase();
  const random = Math.random().toString(36).slice(2, 6).toUpperCase();
  return `CUS-${stamp}-${random}`;
};

export const api = {
  // 1. Dashboard Metrics
  async getDashboardMetrics() {
    const [customersResult, contractsResult, installmentsResult, treasuriesResult] = await Promise.all([
      supabase.from('customers').select('*', { count: 'exact', head: true }),
      supabase.from('contracts').select('total_installment_price, remaining_balance, status'),
      supabase.from('installments').select('due_amount, remaining_amount, due_date, status').in('status', ['pending', 'partially_paid', 'overdue']),
      supabase.from('treasuries').select('current_balance')
    ]);
    const firstError = customersResult.error || contractsResult.error || installmentsResult.error || treasuriesResult.error;
    if (firstError) throw firstError;

    const contractsData = contractsResult.data || [];
    return {
      totalCustomers: customersResult.count || 0,
      totalContractsValue: contractsData.reduce((sum, c) => sum + Number(c.total_installment_price || 0), 0),
      totalRemainingDebt: contractsData.reduce((sum, c) => sum + Number(c.remaining_balance || 0), 0),
      totalCashInTreasury: (treasuriesResult.data || []).reduce((sum, t) => sum + Number(t.current_balance || 0), 0),
      overdueInstallments: (installmentsResult.data || []).filter(i => new Date(i.due_date) < new Date()).length,
      activeContractsCount: contractsData.filter(c => c.status === 'active').length,
    };
  },

  // 2. Customers
  async getCustomers(query = '', organizationId?: string, limit = 80): Promise<Customer[]> {
    let q = supabase.from('customers').select('*').order('name').limit(limit);
    if (organizationId) q = q.eq('organization_id', organizationId);
    const term = cleanSearchTerm(query);
    if (term) q = q.or(`name.ilike.%${term}%,phone.ilike.%${term}%,code.ilike.%${term}%,national_id.ilike.%${term}%`);
    const { data, error } = await q;
    if (error) throw error;
    return (data || []) as Customer[];
  },

  async getCustomerById(customerId: string, organizationId?: string): Promise<Customer | null> {
    let query = supabase.from('customers').select('*').eq('id', customerId);
    if (organizationId) query = query.eq('organization_id', organizationId);
    const { data, error } = await query.maybeSingle();
    if (error) throw error;
    return data as Customer | null;
  },

  async createCustomer(customerData: Pick<Customer, 'name' | 'phone' | 'secondary_phone' | 'national_id' | 'address' | 'notes'> & {
    organizationId: string;
    createdBy: string;
  }): Promise<Customer> {
    const { organizationId, createdBy, ...fields } = customerData;
    const { data, error } = await supabase
      .from('customers')
      .insert([{
        ...fields,
        organization_id: organizationId,
        created_by: createdBy,
        code: createCustomerCode(),
        status: 'active',
      }])
      .select()
      .single();
    if (error) throw error;
    if (!data) throw new Error('لم يتم تأكيد حفظ العميل. حاول مرة أخرى.');
    return data as Customer;
  },

  // 3. Contracts & Installments
  async getContracts(customerId?: string, organizationId?: string): Promise<Contract[]> {
    let q = supabase.from('contracts').select('*, customers(name, phone)').order('created_at', { ascending: false });
    if (customerId) q = q.eq('customer_id', customerId);
    if (organizationId) q = q.eq('organization_id', organizationId);
    const { data, error } = await q;
    if (error) throw error;
    return (data || []).map(c => ({ ...c, customer_name: (c as any).customers?.name, customer_phone: (c as any).customers?.phone })) as Contract[];
  },

  async getInstallments(contractId?: string): Promise<Installment[]> {
    let q = supabase.from('installments').select('*').order('installment_number');
    if (contractId) {
      q = q.eq('contract_id', contractId);
    }
    const { data, error } = await q;
    if (error) throw error;
    return data as Installment[];
  },

  // 4. Collections
  async recordCollection(params: {
    organizationId: string;
    treasuryId: string;
    collectorId: string;
    customerId: string;
    contractId: string;
    amount: number;
    paymentMethod: 'cash' | 'card' | 'wallet' | 'instapay';
    notes?: string;
  }) {
    try {
      const { data, error } = await supabase.rpc('fn_record_collection', {
        p_org_id: params.organizationId,
        p_customer_id: params.customerId,
        p_contract_id: params.contractId,
        p_treasury_id: params.treasuryId,
        p_collector_id: params.collectorId,
        p_amount: params.amount,
        p_payment_method: params.paymentMethod,
        p_notes: params.notes || ''
      });

      if (!error && data) {
        const result = typeof data === 'string' ? JSON.parse(data) : data;
        if (result?.success && result?.receipt_number) {
          return result as {
            success: true;
            receipt_number: string;
            collection_id: string;
            amount: number;
            remaining_contract_balance?: number;
          };
        }
      }
    } catch {}

    throw new Error('تعذر حفظ التحصيل في قاعدة البيانات. لم يتم إصدار إيصال ولم تتغير الأرصدة.');
  },

  async getCollectionTreasury(organizationId: string, branchId?: string | null): Promise<Treasury> {
    try {
      let query = supabase
        .from('treasuries')
        .select('*')
        .eq('organization_id', organizationId)
        .eq('is_active', true)
        .order('created_at')
        .limit(1);

      if (branchId) query = query.eq('branch_id', branchId);
      const { data, error } = await query.maybeSingle();
      if (!error && data) return data as Treasury;
    } catch {}

    throw new Error('لم يتم إعداد خزينة نشطة لهذا الفرع في قاعدة البيانات.');
  },

  // 5. Treasuries & Cash
  async getTreasuries(): Promise<Treasury[]> {
    const { data, error } = await supabase.from('treasuries').select('*').order('name');
    if (error) throw error;
    return (data || []) as Treasury[];
  },

  async getTreasuryTransactions(limit = 50): Promise<TreasuryTransaction[]> {
    const { data, error } = await supabase
      .from('treasury_transactions')
      .select('*')
      .order('created_at', { ascending: false })
      .limit(limit);
    if (error) throw error;
    return (data || []) as TreasuryTransaction[];
  },

  async recordTreasuryMovement(params: {
    organizationId: string;
    treasuryId: string;
    type: 'cash_in' | 'cash_out';
    amount: number;
    description: string;
    userId?: string;
  }) {
    // 1. Fetch current balance
    const { data: treasury, error: tErr } = await supabase
      .from('treasuries')
      .select('current_balance')
      .eq('id', params.treasuryId)
      .single();

    if (tErr) throw tErr;
    const currentBal = Number(treasury.current_balance || 0);
    const newBal = params.type === 'cash_in' ? currentBal + params.amount : currentBal - params.amount;

    if (params.type === 'cash_out' && newBal < 0) {
      throw new Error(`رصيد الدرج الحالي (${currentBal} ج.م) لا يكفي لإتمام عملية الصرف.`);
    }

    // 2. Update balance
    const { error: uErr } = await supabase
      .from('treasuries')
      .update({ current_balance: newBal })
      .eq('id', params.treasuryId);
    if (uErr) throw uErr;

    // 3. Insert transaction
    const { data, error: txErr } = await supabase
      .from('treasury_transactions')
      .insert([{
        organization_id: params.organizationId,
        treasury_id: params.treasuryId,
        transaction_type: params.type,
        amount: params.type === 'cash_in' ? params.amount : -params.amount,
        balance_after: newBal,
        description: params.description,
        created_by: params.userId || null,
      }])
      .select()
      .single();

    if (txErr) throw txErr;
    return { data, newBal };
  },

  // 6. Fund Transfers (Drawer <-> Wallets <-> POS)
  async transferFunds(params: {
    sourceType: 'treasury' | 'wallet' | 'pos';
    sourceId: string;
    targetType: 'treasury' | 'wallet' | 'pos';
    targetId: string;
    amount: number;
    notes?: string;
  }) {
    const { data, error } = await supabase.rpc('fn_transfer_funds', {
      p_source_type: params.sourceType,
      p_source_id: params.sourceId,
      p_target_type: params.targetType,
      p_target_id: params.targetId,
      p_amount: params.amount,
      p_notes: params.notes || null,
    });

    if (error) throw error;
    const res = typeof data === 'string' ? JSON.parse(data) : data;
    if (!res?.success) {
      throw new Error('لم يتم تأكيد التحويل المالي.');
    }
    return res;
  },

  // 7. Wallets & Cash Lines (6 lines from Excel)
  async getCashWallets(): Promise<CashWallet[]> {
    const { data, error } = await supabase.from('cash_wallets').select('*').order('phone_number');
    if (error) throw error;
    return (data || []) as CashWallet[];
  },

  async createCashWallet(params: { organizationId: string; phoneNumber: string; provider: CashWallet['provider']; accountLabel: string }): Promise<CashWallet> {
    const { data, error } = await supabase.from('cash_wallets').insert({
      organization_id: params.organizationId,
      phone_number: params.phoneNumber.trim(),
      provider: params.provider,
      account_label: params.accountLabel.trim() || null,
      current_balance: 0,
      is_active: true,
    }).select().single();
    if (error) throw error;
    return data as CashWallet;
  },

  async updateCashWallet(id: string, organizationId: string, patch: Partial<CashWallet>): Promise<CashWallet> {
    const { data, error } = await supabase.from('cash_wallets').update({
      phone_number: patch.phone_number?.trim(),
      provider: patch.provider,
      account_label: patch.account_label?.trim() || null,
      is_active: patch.is_active,
    }).eq('id', id).eq('organization_id', organizationId).select().single();
    if (error) throw error;
    return data as CashWallet;
  },

  async getWalletTransactions(walletId?: string): Promise<WalletTransaction[]> {
    let query = supabase.from('wallet_transactions').select('*, cash_wallets(account_label)').order('created_at', { ascending: false }).limit(50);
    if (walletId) query = query.eq('wallet_id', walletId);
    const { data, error } = await query;
    if (error) throw error;
    return (data || []).map((item: any) => ({ ...item, wallet_label: item.cash_wallets?.account_label })) as WalletTransaction[];
  },

  async recordWalletTransaction(params: {
    organizationId: string;
    treasuryId: string;
    userId: string;
    walletId: string;
    type: 'deposit' | 'cash_out';
    amount: number;
    commission: number;
    clientPhone?: string;
    notes?: string;
  }) {
    const { data, error } = await supabase.rpc('fn_record_wallet_tx', {
      p_org_id: params.organizationId,
      p_wallet_id: params.walletId,
      p_treasury_id: params.treasuryId,
      p_user_id: params.userId,
      p_tx_type: params.type,
      p_amount: params.amount,
      p_commission: params.commission,
      p_client_phone: params.clientPhone || '',
      p_notes: params.notes || ''
    });
    if (error) throw error;
    return data;
  },

  // 8. POS Machines (Fawry, Aman, Basata)
  async getPOSMachines(): Promise<POSMachine[]> {
    const { data, error } = await supabase.from('pos_machines').select('*');
    if (error) throw error;
    return (data || []) as POSMachine[];
  },

  async createPOSMachine(params: { organizationId: string; name: string; machineNumber?: string }): Promise<POSMachine> {
    const { data, error } = await supabase.from('pos_machines').insert({
      organization_id: params.organizationId,
      name: params.name.trim(),
      machine_number: params.machineNumber?.trim() || null,
      current_balance: 0,
      is_active: true,
    }).select().single();
    if (error) throw error;
    return data as POSMachine;
  },

  async updatePOSMachine(id: string, organizationId: string, patch: Partial<POSMachine>): Promise<POSMachine> {
    const { data, error } = await supabase.from('pos_machines').update({
      name: patch.name?.trim(),
      machine_number: patch.machine_number?.trim() || null,
      is_active: patch.is_active,
    }).eq('id', id).eq('organization_id', organizationId).select().single();
    if (error) throw error;
    return data as POSMachine;
  },

  // 9. Fast Credit (Partner shops from Excel)
  async getFastCreditAccounts(): Promise<FastCreditAccount[]> {
    const { data, error } = await supabase.from('fast_credit_accounts').select('*').order('name');
    if (error) throw error;
    return (data || []) as FastCreditAccount[];
  },

  async createFastCreditAccount(params: {
    organizationId: string;
    name: string;
    phone?: string;
    accountType?: string;
    notes?: string;
  }): Promise<FastCreditAccount> {
    const { data, error } = await supabase.from('fast_credit_accounts').insert({
      organization_id: params.organizationId,
      name: params.name.trim(),
      phone: params.phone?.trim() || null,
      account_type: params.accountType || 'partner_shop',
      notes: params.notes?.trim() || null,
    }).select().single();
    if (error) throw error;
    return data as FastCreditAccount;
  },

  async updateFastCreditAccount(id: string, organizationId: string, patch: Partial<FastCreditAccount>): Promise<FastCreditAccount> {
    const { data, error } = await supabase.from('fast_credit_accounts')
      .update({ name: patch.name?.trim(), phone: patch.phone?.trim() || null, notes: patch.notes?.trim() || null })
      .eq('id', id)
      .eq('organization_id', organizationId)
      .select()
      .single();
    if (error) throw error;
    return data as FastCreditAccount;
  },

  async deleteFastCreditAccount(id: string, organizationId: string) {
    const { count, error: transactionError } = await supabase
      .from('fast_credit_transactions')
      .select('id', { count: 'exact', head: true })
      .eq('account_id', id)
      .eq('organization_id', organizationId);
    if (transactionError) throw transactionError;
    if ((count || 0) > 0) throw new Error('لا يمكن حذف الحساب لأنه يحتوي على حركات مالية.');
    const { error } = await supabase.from('fast_credit_accounts')
      .delete()
      .eq('id', id)
      .eq('organization_id', organizationId);
    if (error) throw error;
  },

  // 10. Suppliers
  async getSuppliers(): Promise<Supplier[]> {
    const { data, error } = await supabase.from('suppliers').select('*').order('name');
    if (error) throw error;
    return (data || []) as Supplier[];
  },

  async createSupplier(params: { organizationId: string; name: string; phone?: string; address?: string; notes?: string }): Promise<Supplier> {
    const { data, error } = await supabase.from('suppliers').insert({
      organization_id: params.organizationId,
      name: params.name.trim(),
      phone: params.phone?.trim() || null,
      address: params.address?.trim() || null,
      notes: params.notes?.trim() || null,
    }).select().single();
    if (error) throw error;
    return data as Supplier;
  },

  async updateSupplier(id: string, organizationId: string, patch: Partial<Supplier>): Promise<Supplier> {
    const { data, error } = await supabase.from('suppliers')
      .update({ name: patch.name?.trim(), phone: patch.phone?.trim() || null, notes: patch.notes?.trim() || null })
      .eq('id', id)
      .eq('organization_id', organizationId)
      .select()
      .single();
    if (error) throw error;
    return data as Supplier;
  },

  async deleteSupplier(id: string, organizationId: string) {
    const [purchases, payments] = await Promise.all([
      supabase.from('purchases').select('id', { count: 'exact', head: true }).eq('supplier_id', id).eq('organization_id', organizationId),
      supabase.from('supplier_payments').select('id', { count: 'exact', head: true }).eq('supplier_id', id).eq('organization_id', organizationId),
    ]);
    if (purchases.error) throw purchases.error;
    if (payments.error) throw payments.error;
    if ((purchases.count || 0) + (payments.count || 0) > 0) throw new Error('لا يمكن حذف المورد لأنه مرتبط بمشتريات أو مدفوعات.');
    const { error } = await supabase.from('suppliers')
      .delete()
      .eq('id', id)
      .eq('organization_id', organizationId);
    if (error) throw error;
  },

  // 11. Expenses
  async getExpenses(): Promise<Expense[]> {
    const { data } = await supabase.from('expenses').select('*').order('expense_date', { ascending: false });
    return (data || []) as Expense[];
  },

  // 12. Daily Closing
  async getDailyClosingMetrics(date: string) {
    const start = `${date}T00:00:00.000Z`;
    const end = `${date}T23:59:59.999Z`;
    const [collections, sales, wallets, expenses] = await Promise.all([
      supabase.from('collections').select('amount').eq('collection_date', date),
      supabase.from('sales').select('paid_amount, total_amount, sale_type, status').gte('created_at', start).lte('created_at', end),
      supabase.from('wallet_transactions').select('transaction_type, amount').gte('created_at', start).lte('created_at', end),
      supabase.from('expenses').select('amount').eq('expense_date', date),
    ]);

    const firstError = collections.error || sales.error || wallets.error || expenses.error;
    if (firstError) throw firstError;

    return {
      totalCollections: (collections.data || []).reduce((sum, row) => sum + Number(row.amount || 0), 0),
      totalCashSales: (sales.data || [])
        .filter(row => row.sale_type === 'cash' && row.status !== 'cancelled')
        .reduce((sum, row) => sum + Number(row.paid_amount ?? row.total_amount ?? 0), 0),
      totalWalletNet: (wallets.data || []).reduce((sum, row) => {
        const amount = Number(row.amount || 0);
        return sum + (row.transaction_type === 'cash_out' ? amount : -amount);
      }, 0),
      totalExpenses: (expenses.data || []).reduce((sum, row) => sum + Number(row.amount || 0), 0),
    };
  },

  async getDailyClosings(): Promise<DailyClosing[]> {
    const { data, error } = await supabase.from('daily_closings').select('*').order('closing_date', { ascending: false });
    if (error) throw error;
    return (data || []) as DailyClosing[];
  },

  async recordDailyClosing(params: {
    treasuryId: string;
    closingDate: string;
    openingBalance: number;
    totalCollections: number;
    totalCashSales: number;
    totalWalletNet: number;
    totalExpenses: number;
    actualCash: number;
    notes?: string;
  }) {
    // 1. Try PostgreSQL RPC
    const { data, error } = await supabase.rpc('fn_record_daily_closing', {
        p_treasury_id: params.treasuryId,
        p_closing_date: params.closingDate,
        p_opening_balance: params.openingBalance,
        p_total_collections: params.totalCollections,
        p_total_cash_sales: params.totalCashSales,
        p_total_wallet_net: params.totalWalletNet,
        p_total_expenses: params.totalExpenses,
        p_actual_cash: params.actualCash,
        p_notes: params.notes || null,
      });

    if (error) throw error;
    if (data) {
      const res = typeof data === 'string' ? JSON.parse(data) : data;
      if (res?.success) return res;
    }
    throw new Error('لم يتم تأكيد حفظ التقفيل في قاعدة البيانات.');
  },

  // 13. Reverse Collection
  async reverseCollection(collectionId: string, reason: string) {
    const { data, error } = await supabase.rpc('fn_reverse_collection', {
      p_collection_id: collectionId,
      p_reason: reason,
    });
    if (error) throw error;
    const res = typeof data === 'string' ? JSON.parse(data) : data;
    if (!res?.success) throw new Error('فشل عكس التحصيل.');
    return res;
  }
};
