// Core Types for Central Management System

export interface Organization {
  id: string;
  name: string;
  trade_name?: string;
  phone?: string;
  address?: string;
  currency: string;
  currency_symbol: string;
  receipt_header?: string;
  receipt_footer?: string;
}

/**
 * The application-facing profile tied to the authenticated Supabase user.
 * Keep this deliberately small: financial screens only need identity,
 * organization scope and the permission role.
 */
export interface Profile {
  id: string;
  organization_id: string | null;
  branch_id: string | null;
  full_name: string;
  phone?: string | null;
  role: 'admin' | 'manager' | 'cashier' | 'collector' | 'sales' | 'reports' | string;
  is_active: boolean;
  trial_ends_at?: string | null;
  branch?: { name: string; code?: string | null } | null;
}

export interface Customer {
  id: string;
  code: string;
  name: string;
  phone?: string;
  secondary_phone?: string;
  national_id?: string;
  address?: string;
  status: 'active' | 'inactive' | 'blocked';
  notes?: string;
  total_contracts_amount: number;
  total_paid_amount: number;
  current_balance: number;
  created_at: string;
}

export interface Guarantor {
  id: string;
  customer_id: string;
  name: string;
  phone?: string;
  relationship?: string;
  national_id?: string;
  address?: string;
  notes?: string;
}

export interface Contract {
  id: string;
  customer_id: string;
  customer_name?: string;
  customer_phone?: string;
  contract_number: string;
  device_name: string;
  imei_number?: string;
  cash_price: number;
  total_installment_price: number;
  down_payment: number;
  down_payment_date?: string;
  remaining_balance: number;
  installment_count: number;
  monthly_installment_amount: number;
  start_date: string;
  due_day: number;
  status: 'active' | 'completed' | 'overdue' | 'cancelled';
  notes?: string;
  created_at: string;
}

export interface Installment {
  id: string;
  contract_id: string;
  customer_id: string;
  installment_number: number;
  due_date: string;
  due_amount: number;
  paid_amount: number;
  remaining_amount: number;
  status: 'pending' | 'partially_paid' | 'paid' | 'overdue' | 'cancelled';
  paid_date?: string;
  notes?: string;
}

export interface Collection {
  id: string;
  customer_id: string;
  customer_name?: string;
  contract_id: string;
  contract_number?: string;
  treasury_id: string;
  receipt_number: string;
  collection_date: string;
  amount: number;
  payment_method: 'cash' | 'card' | 'wallet' | 'instapay';
  notes?: string;
  created_at: string;
}

export interface Treasury {
  id: string;
  name: string;
  treasury_type: 'drawer' | 'main_safe' | 'custody';
  opening_balance: number;
  current_balance: number;
  is_active: boolean;
}

export interface TreasuryTransaction {
  id: string;
  treasury_id: string;
  transaction_type: string;
  amount: number;
  balance_after: number;
  description: string;
  created_at: string;
}

export interface CashWallet {
  id: string;
  phone_number: string;
  provider: 'vodafone_cash' | 'orange_cash' | 'etisalat_cash' | 'instapay';
  account_label: string;
  current_balance: number;
  is_active: boolean;
}

export interface WalletTransaction {
  id: string;
  wallet_id: string;
  wallet_label?: string;
  transaction_type: 'deposit' | 'cash_out';
  amount: number;
  commission: number;
  client_phone?: string;
  balance_after: number;
  notes?: string;
  created_at: string;
}

export interface POSMachine {
  id: string;
  name: string;
  machine_number?: string;
  current_balance: number;
  is_active: boolean;
}

export interface FastCreditAccount {
  id: string;
  name: string;
  phone?: string;
  account_type: string;
  current_balance: number;
  notes?: string;
}

export interface Supplier {
  id: string;
  name: string;
  phone?: string;
  current_balance: number;
  notes?: string;
}

export interface Expense {
  id: string;
  category_name?: string;
  amount: number;
  expense_date: string;
  description: string;
}

export interface DailyClosing {
  id: string;
  closing_number: string;
  closing_date: string;
  opening_balance: number;
  total_cash_in: number;
  total_cash_out: number;
  total_collections: number;
  expected_balance: number;
  actual_cash: number;
  difference: number;
  status: 'balanced' | 'shortage' | 'surplus';
  notes?: string;
  created_at: string;
}
