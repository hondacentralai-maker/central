import React, { useState, useEffect } from 'react';
import { X, Search, CreditCard, DollarSign, Check, AlertCircle } from 'lucide-react';
import { api } from '../../services/api';
import { Customer, Contract } from '../../types';

interface QuickCollectionModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSuccess: (receiptData: any) => void;
  preselectedCustomer?: Customer | null;
  preselectedContract?: Contract | null;
}

export const QuickCollectionModal: React.FC<QuickCollectionModalProps> = ({
  isOpen,
  onClose,
  onSuccess,
  preselectedCustomer,
  preselectedContract
}) => {
  const [searchTerm, setSearchTerm] = useState('');
  const [searchResults, setSearchResults] = useState<Customer[]>([]);
  const [selectedCustomer, setSelectedCustomer] = useState<Customer | null>(null);
  const [contracts, setContracts] = useState<Contract[]>([]);
  const [selectedContract, setSelectedContract] = useState<Contract | null>(null);
  const [amount, setAmount] = useState<string>('');
  const [paymentMethod, setPaymentMethod] = useState<'cash' | 'card' | 'wallet' | 'instapay'>('cash');
  const [notes, setNotes] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    if (preselectedCustomer) {
      setSelectedCustomer(preselectedCustomer);
      loadContracts(preselectedCustomer.id);
    }
    if (preselectedContract) {
      setSelectedContract(preselectedContract);
      setAmount(preselectedContract.monthly_installment_amount?.toString() || '');
    }
  }, [preselectedCustomer, preselectedContract]);

  const loadContracts = async (customerId: string) => {
    try {
      const data = await api.getContracts(customerId);
      setContracts(data);
      if (data.length > 0) {
        setSelectedContract(data[0]);
        setAmount(data[0].monthly_installment_amount?.toString() || '');
      }
    } catch {
      // Fallback
    }
  };

  const handleSearch = async (val: string) => {
    setSearchTerm(val);
    if (val.trim().length > 1) {
      try {
        const res = await api.getCustomers(val);
        setSearchResults(res);
      } catch {
        setSearchResults([]);
      }
    } else {
      setSearchResults([]);
    }
  };

  const handleSelectCustomer = (cust: Customer) => {
    setSelectedCustomer(cust);
    setSearchTerm('');
    setSearchResults([]);
    loadContracts(cust.id);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const numAmount = parseFloat(amount);
    if (!numAmount || numAmount <= 0) {
      setError('يرجى إدخال مبلغ صحيح للتحصيل');
      return;
    }
    if (!selectedContract) {
      setError('يرجى اختيار العقد أو القسط المراد سداده');
      return;
    }

    setIsLoading(true);
    setError('');

    try {
      const res = await api.recordCollection({
        customerId: selectedCustomer?.id || selectedContract.customer_id,
        contractId: selectedContract.id,
        amount: numAmount,
        paymentMethod,
        notes
      });

      const remBal = Math.max((selectedContract.remaining_balance || 0) - numAmount, 0);

      onSuccess({
        receiptNumber: res.receipt_number || ('REC-' + Math.floor(1000 + Math.random() * 9000)),
        customerName: selectedCustomer?.name || selectedContract.customer_name || 'عميل المحل',
        customerPhone: selectedCustomer?.phone || selectedContract.customer_phone,
        contractNumber: selectedContract.contract_number,
        deviceName: selectedContract.device_name,
        amount: numAmount,
        remainingBalance: remBal,
        paymentMethod,
        date: new Date().toLocaleDateString('ar-EG')
      });

      onClose();
    } catch (err: any) {
      setError(err.message || 'حدث خطأ أثناء تسجيل السداد');
    } finally {
      setIsLoading(false);
    }
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/60 backdrop-blur-sm p-4 overflow-y-auto">
      <div className="bg-white rounded-2xl max-w-lg w-full shadow-2xl overflow-hidden my-8 animate-in fade-in zoom-in-95 duration-150">
        {/* Header */}
        <div className="p-4 border-b border-slate-100 flex items-center justify-between bg-slate-50">
          <div className="flex items-center gap-2">
            <CreditCard className="w-5 h-5 text-primary" />
            <h3 className="font-bold text-slate-800 text-base">تسجيل تحصيل قسط سريع</h3>
          </div>
          <button onClick={onClose} className="p-1 text-slate-400 hover:text-slate-600 rounded-lg">
            <X className="w-5 h-5" />
          </button>
        </div>

        <form onSubmit={handleSubmit} className="p-5 space-y-4">
          {error && (
            <div className="p-3 rounded-xl bg-danger/10 border border-danger/20 text-danger text-xs flex items-center gap-2">
              <AlertCircle className="w-4 h-4 flex-shrink-0" />
              <span>{error}</span>
            </div>
          )}

          {/* Customer Selection / Search */}
          {!selectedCustomer ? (
            <div className="space-y-1.5">
              <label className="block text-xs font-semibold text-slate-700">البحث عن العميل</label>
              <div className="relative">
                <Search className="w-4 h-4 absolute right-3 top-1/2 -translate-y-1/2 text-slate-400" />
                <input
                  type="text"
                  placeholder="اكتب اسم العميل أو رقم هاتفه..."
                  value={searchTerm}
                  onChange={(e) => handleSearch(e.target.value)}
                  className="w-full pl-3 pr-9 py-2.5 rounded-xl border border-slate-200 text-sm focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary"
                />
              </div>

              {/* Search dropdown results */}
              {searchResults.length > 0 && (
                <div className="border border-slate-200 rounded-xl max-h-48 overflow-y-auto divide-y divide-slate-100 bg-white shadow-lg mt-1">
                  {searchResults.map((cust) => (
                    <button
                      type="button"
                      key={cust.id}
                      onClick={() => handleSelectCustomer(cust)}
                      className="w-full p-2.5 text-right hover:bg-slate-50 flex items-center justify-between text-xs transition"
                    >
                      <div>
                        <div className="font-bold text-slate-800">{cust.name}</div>
                        <div className="text-slate-400 text-[11px]">{cust.phone || 'بدون هاتف'}</div>
                      </div>
                      <span className="text-primary font-semibold">اختيار</span>
                    </button>
                  ))}
                </div>
              )}
            </div>
          ) : (
            /* Selected Customer Card */
            <div className="p-3 rounded-xl bg-slate-50 border border-slate-200 flex items-center justify-between">
              <div>
                <div className="text-xs text-slate-400">العميل المختار:</div>
                <div className="font-bold text-slate-800 text-sm">{selectedCustomer.name}</div>
                <div className="text-xs text-slate-500">{selectedCustomer.phone || 'بدون هاتف'}</div>
              </div>
              <button
                type="button"
                onClick={() => {
                  setSelectedCustomer(null);
                  setSelectedContract(null);
                  setContracts([]);
                }}
                className="text-xs text-primary hover:underline font-semibold"
              >
                تغيير العميل
              </button>
            </div>
          )}

          {/* Contract Selector if customer selected */}
          {selectedCustomer && (
            <div className="space-y-1.5">
              <label className="block text-xs font-semibold text-slate-700">العقد أو الجهاز</label>
              {contracts.length > 0 ? (
                <select
                  value={selectedContract?.id || ''}
                  onChange={(e) => {
                    const c = contracts.find(x => x.id === e.target.value);
                    setSelectedContract(c || null);
                    if (c) setAmount(c.monthly_installment_amount?.toString() || '');
                  }}
                  className="w-full p-2.5 rounded-xl border border-slate-200 text-sm focus:outline-none focus:border-primary"
                >
                  {contracts.map((c) => (
                    <option key={c.id} value={c.id}>
                      {c.device_name} • المتبقي: {c.remaining_balance?.toLocaleString('ar-EG')} ج.م
                    </option>
                  ))}
                </select>
              ) : (
                <div className="p-3 rounded-xl bg-amber-50 border border-amber-200 text-amber-800 text-xs">
                  لا توجد عقود نشطة مسجلة لهذا العميل حالياً.
                </div>
              )}
            </div>
          )}

          {/* Amount to collect */}
          <div className="space-y-1.5">
            <label className="block text-xs font-semibold text-slate-700">المبلغ المسدد (ج.م) *</label>
            <div className="relative">
              <input
                type="number"
                step="0.01"
                required
                placeholder="أدخل المبلغ..."
                value={amount}
                onChange={(e) => setAmount(e.target.value)}
                className="w-full pr-3 pl-12 py-2.5 rounded-xl border border-slate-200 text-lg font-bold text-slate-900 focus:outline-none focus:border-primary"
              />
              <span className="absolute left-3 top-1/2 -translate-y-1/2 text-xs font-bold text-slate-400">ج.م</span>
            </div>
          </div>

          {/* Payment Method */}
          <div className="space-y-1.5">
            <label className="block text-xs font-semibold text-slate-700">طريقة الدفع وإيداع النقدية</label>
            <div className="grid grid-cols-2 sm:grid-cols-4 gap-2">
              {[
                { id: 'cash', label: 'كاش الدرج' },
                { id: 'wallet', label: 'فودافون كاش' },
                { id: 'instapay', label: 'إنستاباي' },
                { id: 'card', label: 'فيزا / بطاقة' },
              ].map((m) => (
                <button
                  type="button"
                  key={m.id}
                  onClick={() => setPaymentMethod(m.id as any)}
                  className={`py-2 px-2 rounded-xl text-xs font-bold border transition text-center ${
                    paymentMethod === m.id
                      ? 'bg-primary text-white border-primary shadow-sm'
                      : 'bg-white text-slate-700 border-slate-200 hover:bg-slate-50'
                  }`}
                >
                  {m.label}
                </button>
              ))}
            </div>
          </div>

          {/* Notes */}
          <div className="space-y-1.5">
            <label className="block text-xs font-semibold text-slate-700">ملاحظات (اختياري)</label>
            <input
              type="text"
              placeholder="مثال: دفعة شهر 10..."
              value={notes}
              onChange={(e) => setNotes(e.target.value)}
              className="w-full p-2.5 rounded-xl border border-slate-200 text-xs focus:outline-none focus:border-primary"
            />
          </div>

          {/* Action buttons */}
          <div className="pt-2 flex gap-2">
            <button
              type="button"
              onClick={onClose}
              className="flex-1 py-2.5 rounded-xl border border-slate-200 text-slate-600 text-sm font-semibold hover:bg-slate-50 transition"
            >
              إلغاء
            </button>
            <button
              type="submit"
              disabled={isLoading || !selectedCustomer || !selectedContract}
              className="flex-1 py-2.5 rounded-xl bg-primary hover:bg-primary-dark disabled:opacity-50 text-white text-sm font-bold shadow-md shadow-primary/20 transition flex items-center justify-center gap-2"
            >
              {isLoading ? 'جاري السداد...' : 'تأكيد التحصيل وإصدار الإيصال'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};
