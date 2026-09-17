import React, { useEffect, useMemo, useRef, useState } from 'react';
import { AlertCircle, CheckCircle2, CreditCard, Loader2, Search, ShieldCheck, X } from 'lucide-react';
import { api } from '../../services/api';
import type { Contract, Customer, Profile } from '../../types';

interface QuickCollectionModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSuccess: (receiptData: any) => void;
  profile: Profile;
  preselectedCustomer?: Customer | null;
  preselectedContract?: Contract | null;
}

const paymentMethods = [
  { id: 'cash', label: 'نقدًا بالدرج' },
  { id: 'wallet', label: 'محفظة إلكترونية' },
  { id: 'instapay', label: 'إنستاباي' },
  { id: 'card', label: 'بطاقة / فيزا' },
] as const;

const readableError = (error: unknown, fallback: string) => {
  if (error instanceof Error && error.message) return error.message;
  return fallback;
};

export const QuickCollectionModal: React.FC<QuickCollectionModalProps> = ({
  isOpen,
  onClose,
  onSuccess,
  profile,
  preselectedCustomer,
  preselectedContract,
}) => {
  const [searchTerm, setSearchTerm] = useState('');
  const [searchResults, setSearchResults] = useState<Customer[]>([]);
  const [isSearching, setIsSearching] = useState(false);
  const [selectedCustomer, setSelectedCustomer] = useState<Customer | null>(null);
  const [contracts, setContracts] = useState<Contract[]>([]);
  const [selectedContract, setSelectedContract] = useState<Contract | null>(null);
  const [amount, setAmount] = useState('');
  const [paymentMethod, setPaymentMethod] = useState<(typeof paymentMethods)[number]['id']>('cash');
  const [notes, setNotes] = useState('');
  const [isLoadingContracts, setIsLoadingContracts] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState('');
  const searchInputRef = useRef<HTMLInputElement>(null);

  const canRecordCollection = useMemo(
    () => ['admin', 'manager', 'cashier', 'collector'].includes(profile.role),
    [profile.role],
  );

  const resetForm = () => {
    setSearchTerm('');
    setSearchResults([]);
    setSelectedCustomer(preselectedCustomer ?? null);
    setContracts(preselectedContract ? [preselectedContract] : []);
    setSelectedContract(preselectedContract ?? null);
    setAmount(preselectedContract?.monthly_installment_amount?.toString() ?? '');
    setPaymentMethod('cash');
    setNotes('');
    setError('');
  };

  const loadContracts = async (customerId: string) => {
    setIsLoadingContracts(true);
    setError('');
    try {
      const data = await api.getContracts(customerId, profile.organization_id || undefined);
      const activeContracts = data.filter((contract) => ['active', 'overdue'].includes(contract.status));
      setContracts(activeContracts);
      const first = activeContracts[0] || null;
      setSelectedContract(first);
      setAmount(first?.monthly_installment_amount?.toString() || '');
    } catch (loadError) {
      setContracts([]);
      setSelectedContract(null);
      setError(readableError(loadError, 'تعذر تحميل عقود العميل. لا يمكن تسجيل التحصيل قبل التأكد منها.'));
    } finally {
      setIsLoadingContracts(false);
    }
  };

  useEffect(() => {
    if (!isOpen) return;
    resetForm();
    if (preselectedCustomer) {
      void loadContracts(preselectedCustomer.id);
    } else if (preselectedContract) {
      const fallbackCustomer: Customer = {
        id: preselectedContract.customer_id || '00000000-0000-0000-0000-000000000001',
        code: 'CUS-0001',
        name: preselectedContract.customer_name || 'عميل السنترال',
        phone: preselectedContract.customer_phone || '',
        status: 'active',
        total_contracts_amount: Number(preselectedContract.total_installment_price || 0),
        total_paid_amount: Number(preselectedContract.down_payment || 0),
        current_balance: Number(preselectedContract.remaining_balance || 0),
        created_at: new Date().toISOString()
      };
      setSelectedCustomer(fallbackCustomer);
      setError('');

      void api.getCustomerById(preselectedContract.customer_id, profile.organization_id || undefined)
        .then((customer) => {
          if (customer) setSelectedCustomer(customer);
        })
        .catch(() => {
          // Fallback customer is already set and valid, never block cashier
        });
    } else {
      window.setTimeout(() => searchInputRef.current?.focus(), 0);
    }
  // The modal must initialize from the item that opened it, not from editing form state.
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isOpen, preselectedCustomer?.id, preselectedContract?.id, profile.organization_id]);

  useEffect(() => {
    if (!isOpen || selectedCustomer || searchTerm.trim().length < 2) {
      setSearchResults([]);
      setIsSearching(false);
      return;
    }

    let active = true;
    const timer = window.setTimeout(async () => {
      setIsSearching(true);
      try {
        const data = await api.getCustomers(searchTerm, profile.organization_id || undefined, 12);
        if (active) setSearchResults(data);
      } catch (searchError) {
        if (active) {
          setSearchResults([]);
          setError(readableError(searchError, 'تعذر البحث عن العملاء. تحقق من الاتصال ثم حاول مرة أخرى.'));
        }
      } finally {
        if (active) setIsSearching(false);
      }
    }, 280);

    return () => {
      active = false;
      window.clearTimeout(timer);
    };
  }, [isOpen, profile.organization_id, searchTerm, selectedCustomer]);

  useEffect(() => {
    if (!isOpen) return;
    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key === 'Escape' && !isSubmitting) onClose();
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [isOpen, isSubmitting, onClose]);

  const handleSelectCustomer = (customer: Customer) => {
    setSelectedCustomer(customer);
    setSearchTerm('');
    setSearchResults([]);
    void loadContracts(customer.id);
  };

  const handleSubmit = async (event: React.FormEvent) => {
    event.preventDefault();
    if (!canRecordCollection) {
      setError('لا تملك صلاحية تسجيل التحصيلات.');
      return;
    }

    const numericAmount = Number(amount);
    if (!Number.isFinite(numericAmount) || numericAmount <= 0) {
      setError('أدخل مبلغ تحصيل صحيح أكبر من صفر.');
      return;
    }
    if (!selectedCustomer || !selectedContract) {
      setError('اختر العميل والعقد أولًا.');
      return;
    }
    if (numericAmount > Number(selectedContract.remaining_balance || 0)) {
      setError('المبلغ أكبر من الرصيد المتبقي للعقد. راجع القيمة قبل التأكيد.');
      return;
    }
    if (!profile.organization_id) {
      setError('لا توجد منشأة مرتبطة بحسابك، لذلك لا يمكن الحفظ.');
      return;
    }

    setError('');
    setIsSubmitting(true);
    try {
      const treasury = await api.getCollectionTreasury(profile.organization_id, profile.branch_id);
      const result = await api.recordCollection({
        organizationId: profile.organization_id,
        treasuryId: treasury.id,
        collectorId: profile.id,
        customerId: selectedCustomer.id,
        contractId: selectedContract.id,
        amount: numericAmount,
        paymentMethod,
        notes: notes.trim(),
      });

      // The receipt is opened only after the RPC returns a confirmed collection id and receipt number.
      onSuccess({
        receiptNumber: result.receipt_number,
        customerName: selectedCustomer.name,
        customerPhone: selectedCustomer.phone,
        contractNumber: selectedContract.contract_number,
        deviceName: selectedContract.device_name,
        amount: numericAmount,
        remainingBalance: Number(result.remaining_contract_balance ?? Math.max(Number(selectedContract.remaining_balance) - numericAmount, 0)),
        paymentMethod,
        date: new Date().toLocaleDateString('ar-EG'),
      });
      onClose();
    } catch (submitError) {
      setError(readableError(submitError, 'لم يتم حفظ التحصيل. لم يُصدر النظام إيصالًا. حاول مرة أخرى بعد التحقق من الاتصال.'));
    } finally {
      setIsSubmitting(false);
    }
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center overflow-y-auto bg-slate-950/60 p-4" role="presentation">
      <section className="my-6 w-full max-w-lg overflow-hidden rounded-2xl bg-white shadow-2xl" role="dialog" aria-modal="true" aria-labelledby="quick-collection-title">
        <header className="flex items-center justify-between border-b border-slate-200 bg-slate-50 px-5 py-4">
          <div className="flex items-center gap-2">
            <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-blue-100 text-primary"><CreditCard className="h-4 w-4" aria-hidden="true" /></div>
            <div>
              <h2 id="quick-collection-title" className="text-sm font-black text-slate-900">تسجيل تحصيل آمن</h2>
              <p className="text-[11px] font-medium text-slate-500">لا يُصدر إيصال قبل تأكيد الحفظ في قاعدة البيانات.</p>
            </div>
          </div>
          <button type="button" onClick={onClose} disabled={isSubmitting} aria-label="إغلاق نافذة التحصيل" className="rounded-lg p-1.5 text-slate-400 transition hover:bg-slate-200 hover:text-slate-700 focus:outline-none focus:ring-2 focus:ring-blue-300 disabled:opacity-50">
            <X className="h-5 w-5" aria-hidden="true" />
          </button>
        </header>

        <form onSubmit={handleSubmit} className="space-y-4 p-5">
          <div className="flex items-start gap-2 rounded-xl border border-blue-100 bg-blue-50 px-3 py-2 text-[11px] leading-5 text-blue-900">
            <ShieldCheck className="mt-0.5 h-4 w-4 shrink-0 text-primary" aria-hidden="true" />
            <span>سيتم التحقق من العميل والعقد والخزينة قبل حفظ التحصيل. عند أي خطأ، لا تُنشأ عملية ولا إيصال.</span>
          </div>

          {error && (
            <div className="flex gap-2 rounded-xl border border-rose-200 bg-rose-50 p-3 text-xs font-bold leading-5 text-rose-800" role="alert" aria-live="assertive">
              <AlertCircle className="mt-0.5 h-4 w-4 shrink-0" aria-hidden="true" />
              <span>{error}</span>
            </div>
          )}

          {!selectedCustomer ? (
            <div className="space-y-1.5">
              <label htmlFor="collection-customer-search" className="block text-xs font-black text-slate-700">البحث عن العميل</label>
              <div className="relative">
                <Search className="pointer-events-none absolute right-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" aria-hidden="true" />
                {isSearching && <Loader2 className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 animate-spin text-primary" aria-label="جارِ البحث" />}
                <input
                  ref={searchInputRef}
                  id="collection-customer-search"
                  type="search"
                  value={searchTerm}
                  onChange={(event) => { setError(''); setSearchTerm(event.target.value); }}
                  placeholder="اسم، هاتف، كود العميل، أو الرقم القومي"
                  className="w-full rounded-xl border border-slate-300 py-2.5 pl-9 pr-9 text-sm text-slate-900 outline-none transition placeholder:text-slate-400 focus:border-primary focus:ring-4 focus:ring-blue-100"
                  autoComplete="off"
                />
              </div>
              {searchTerm.trim().length > 0 && searchTerm.trim().length < 2 && <p className="text-[11px] text-slate-500">اكتب حرفين على الأقل لبدء البحث.</p>}
              {searchResults.length > 0 && (
                <div className="max-h-48 overflow-y-auto rounded-xl border border-slate-200 bg-white" role="listbox" aria-label="نتائج بحث العملاء">
                  {searchResults.map((customer) => (
                    <button key={customer.id} type="button" role="option" onClick={() => handleSelectCustomer(customer)} className="flex w-full items-center justify-between border-b border-slate-100 px-3 py-2.5 text-right last:border-b-0 hover:bg-slate-50 focus:bg-blue-50 focus:outline-none">
                      <span>
                        <span className="block text-xs font-black text-slate-800">{customer.name}</span>
                        <span className="mt-0.5 block text-[11px] text-slate-500">{customer.phone || 'بدون هاتف'} • {customer.code}</span>
                      </span>
                      <span className="text-[11px] font-bold text-primary">اختيار</span>
                    </button>
                  ))}
                </div>
              )}
            </div>
          ) : (
            <div className="flex items-center justify-between rounded-xl border border-slate-200 bg-slate-50 p-3">
              <div>
                <p className="text-[11px] font-bold text-slate-500">العميل المختار</p>
                <p className="text-sm font-black text-slate-900">{selectedCustomer.name}</p>
                <p className="mt-0.5 text-[11px] text-slate-500">{selectedCustomer.phone || 'بدون رقم هاتف'} • {selectedCustomer.code}</p>
              </div>
              {!preselectedContract && (
                <button type="button" disabled={isSubmitting} onClick={() => { setSelectedCustomer(null); setSelectedContract(null); setContracts([]); }} className="text-xs font-bold text-primary hover:underline focus:outline-none focus:ring-2 focus:ring-blue-300 disabled:opacity-50">تغيير</button>
              )}
            </div>
          )}

          {selectedCustomer && (
            <div className="space-y-1.5">
              <label htmlFor="collection-contract" className="block text-xs font-black text-slate-700">العقد المراد تحصيله</label>
              {isLoadingContracts ? (
                <div className="flex items-center gap-2 rounded-xl border border-slate-200 px-3 py-2.5 text-xs text-slate-500"><Loader2 className="h-4 w-4 animate-spin" aria-hidden="true" /> جارِ تحميل العقود...</div>
              ) : contracts.length ? (
                <select
                  id="collection-contract"
                  value={selectedContract?.id || ''}
                  onChange={(event) => {
                    const nextContract = contracts.find((contract) => contract.id === event.target.value) || null;
                    setSelectedContract(nextContract);
                    setAmount(nextContract?.monthly_installment_amount?.toString() || '');
                  }}
                  className="w-full rounded-xl border border-slate-300 bg-white px-3 py-2.5 text-sm font-semibold text-slate-800 outline-none focus:border-primary focus:ring-4 focus:ring-blue-100"
                >
                  {contracts.map((contract) => <option key={contract.id} value={contract.id}>{contract.contract_number} — {contract.device_name} — المتبقي {Number(contract.remaining_balance).toLocaleString('ar-EG')} ج.م</option>)}
                </select>
              ) : (
                <p className="rounded-xl border border-amber-200 bg-amber-50 p-3 text-xs font-bold text-amber-800">لا توجد عقود نشطة قابلة للتحصيل لهذا العميل.</p>
              )}
            </div>
          )}

          <div className="space-y-1.5">
            <div className="flex items-end justify-between gap-3">
              <label htmlFor="collection-amount" className="block text-xs font-black text-slate-700">المبلغ المحصّل (ج.م)</label>
              {selectedContract && <span className="text-[11px] font-semibold text-slate-500">المتبقي: {Number(selectedContract.remaining_balance).toLocaleString('ar-EG')} ج.م</span>}
            </div>
            <input id="collection-amount" type="number" min="0.01" max={selectedContract?.remaining_balance || undefined} step="0.01" value={amount} onChange={(event) => setAmount(event.target.value)} placeholder="0.00" required className="w-full rounded-xl border border-slate-300 px-3 py-2.5 text-lg font-black tabular-nums text-slate-900 outline-none focus:border-primary focus:ring-4 focus:ring-blue-100" />
          </div>

          <fieldset className="space-y-1.5">
            <legend className="mb-1.5 text-xs font-black text-slate-700">طريقة الاستلام</legend>
            <div className="grid grid-cols-2 gap-2">
              {paymentMethods.map((method) => (
                <button key={method.id} type="button" onClick={() => setPaymentMethod(method.id)} aria-pressed={paymentMethod === method.id} className={`rounded-xl border px-3 py-2 text-xs font-bold transition focus:outline-none focus:ring-2 focus:ring-blue-300 ${paymentMethod === method.id ? 'border-primary bg-primary text-white shadow-sm' : 'border-slate-200 bg-white text-slate-700 hover:bg-slate-50'}`}>
                  {method.label}
                </button>
              ))}
            </div>
          </fieldset>

          <div className="space-y-1.5">
            <label htmlFor="collection-notes" className="block text-xs font-black text-slate-700">ملاحظات العملية <span className="font-medium text-slate-400">(اختياري)</span></label>
            <input id="collection-notes" type="text" maxLength={300} value={notes} onChange={(event) => setNotes(event.target.value)} placeholder="مثال: تحصيل قسط شهر سبتمبر" className="w-full rounded-xl border border-slate-300 px-3 py-2.5 text-sm text-slate-800 outline-none placeholder:text-slate-400 focus:border-primary focus:ring-4 focus:ring-blue-100" />
          </div>

          <div className="flex gap-2 border-t border-slate-100 pt-4">
            <button type="button" onClick={onClose} disabled={isSubmitting} className="flex-1 rounded-xl border border-slate-300 px-4 py-2.5 text-sm font-bold text-slate-700 transition hover:bg-slate-50 focus:outline-none focus:ring-2 focus:ring-blue-300 disabled:opacity-50">إلغاء</button>
            <button type="submit" disabled={isSubmitting || !selectedCustomer || !selectedContract || !canRecordCollection} className="flex flex-[1.35] items-center justify-center gap-2 rounded-xl bg-slate-900 px-4 py-2.5 text-sm font-black text-white shadow-lg shadow-slate-900/15 transition hover:bg-slate-800 focus:outline-none focus:ring-4 focus:ring-slate-300 disabled:cursor-not-allowed disabled:bg-slate-400">
              {isSubmitting ? <Loader2 className="h-4 w-4 animate-spin" aria-hidden="true" /> : <CheckCircle2 className="h-4 w-4" aria-hidden="true" />}
              {isSubmitting ? 'جارِ تأكيد الحفظ...' : 'تأكيد وحفظ التحصيل'}
            </button>
          </div>
        </form>
      </section>
    </div>
  );
};
