import React, { useState, useEffect } from 'react';
import { 
  CreditCard, 
  Search, 
  Filter, 
  AlertCircle, 
  CheckCircle2, 
  Clock, 
  DollarSign, 
  Share2,
  Calendar,
  MessageCircle,
  BookmarkPlus,
  RefreshCw
} from 'lucide-react';
import { api } from '../services/api';
import { Contract } from '../types';

interface InstallmentsPageProps {
  onCollect: (contract: Contract) => void;
}

export const InstallmentsPage: React.FC<InstallmentsPageProps> = ({ onCollect }) => {
  const [contracts, setContracts] = useState<Contract[]>([]);
  const [filter, setFilter] = useState<'all' | 'active' | 'overdue' | 'completed' | 'promises'>('all');
  const [searchTerm, setSearchTerm] = useState('');
  const [isLoading, setIsLoading] = useState(true);

  // Promise to pay modal
  const [promiseModalContract, setPromiseModalContract] = useState<Contract | null>(null);
  const [promiseDate, setPromiseDate] = useState('');
  const [promiseNotes, setPromiseNotes] = useState('');
  const [promises, setPromises] = useState<Record<string, { date: string; notes: string }>>({});

  useEffect(() => {
    loadData();
    // Load stored promises
    const saved = localStorage.getItem('central_payment_promises');
    if (saved) {
      try {
        setPromises(JSON.parse(saved));
      } catch {}
    }
  }, []);

  const loadData = async () => {
    setIsLoading(true);
    try {
      // 1. Check local state first (includes all customers & custom additions)
      const saved = localStorage.getItem('central_customers_state');
      if (saved) {
        try {
          const customers = JSON.parse(saved);
          if (customers && customers.length > 0) {
            const flatContracts: Contract[] = [];
            customers.forEach((c: any, cIdx: number) => {
              (c.contracts || []).forEach((ctr: any, ctrIdx: number) => {
                flatContracts.push({
                  id: `ctr-${cIdx}-${ctrIdx}`,
                  customer_id: c.id || `cus-${cIdx}`,
                  customer_name: c.name,
                  customer_phone: c.phone || '',
                  contract_number: `CTR-${(cIdx + 1).toString().padStart(4, '0')}-${ctrIdx + 1}`,
                  device_name: ctr.device_name || 'جهاز هاتف ذكي',
                  cash_price: Number(ctr.cash_price || 0),
                  total_installment_price: Number(ctr.installment_price || 0),
                  down_payment: Number(ctr.down_payment || 0),
                  down_payment_date: ctr.down_payment_date || '',
                  remaining_balance: Number(ctr.remaining_balance || 0),
                  installment_count: ctr.installment_count || ctr.installments?.length || 10,
                  monthly_installment_amount: Math.round(Number(ctr.remaining_balance || 0) / Math.max(ctr.installment_count || ctr.installments?.length || 10, 1)),
                  start_date: '2025-01-01',
                  due_day: 1,
                  status: Number(ctr.remaining_balance || 0) <= 0 ? 'completed' : 'active',
                  created_at: new Date().toISOString()
                });
              });
            });
            if (flatContracts.length > 0) {
              setContracts(flatContracts);
              setIsLoading(false);
              return;
            }
          }
        } catch {}
      }

      // 2. Try api.getContracts()
      const data = await api.getContracts();
      if (data && data.length > 0) {
        setContracts(data);
        setIsLoading(false);
        return;
      }

      // 3. Fallback to migrated_data.json
      const res = await fetch('/migrated_data.json');
      if (res.ok) {
        const json = await res.json();
        const flatContracts: Contract[] = [];
        json.customers.forEach((c: any, cIdx: number) => {
          c.contracts.forEach((ctr: any, ctrIdx: number) => {
            flatContracts.push({
              id: `ctr-${cIdx}-${ctrIdx}`,
              customer_id: `cus-${cIdx}`,
              customer_name: c.name,
              customer_phone: c.phone || '',
              contract_number: `CTR-${(cIdx + 1).toString().padStart(4, '0')}-${ctrIdx + 1}`,
              device_name: ctr.device_name || 'جهاز هاتف ذكي',
              cash_price: Number(ctr.cash_price || 0),
              total_installment_price: Number(ctr.installment_price || 0),
              down_payment: Number(ctr.down_payment || 0),
              down_payment_date: ctr.down_payment_date || '',
              remaining_balance: Number(ctr.remaining_balance || 0),
              installment_count: ctr.installment_count || 10,
              monthly_installment_amount: Math.round(Number(ctr.remaining_balance || 0) / Math.max(ctr.installment_count || 10, 1)),
              start_date: '2025-01-01',
              due_day: 1,
              status: Number(ctr.remaining_balance || 0) <= 0 ? 'completed' : 'active',
              created_at: new Date().toISOString()
            });
          });
        });
        setContracts(flatContracts);
      }
    } catch {
      //
    } finally {
      setIsLoading(false);
    }
  };

  const handleSavePromise = (e: React.FormEvent) => {
    e.preventDefault();
    if (!promiseModalContract || !promiseDate) return;

    const updated = {
      ...promises,
      [promiseModalContract.id]: { date: promiseDate, notes: promiseNotes.trim() }
    };
    setPromises(updated);
    localStorage.setItem('central_payment_promises', JSON.stringify(updated));
    setPromiseModalContract(null);
    setPromiseDate('');
    setPromiseNotes('');
  };

  const openWhatsApp = (ctr: Contract) => {
    const rawPhone = (ctr.customer_phone || '').replace(/[^0-9]/g, '');
    let cleanPhone = rawPhone;
    if (cleanPhone.startsWith('01')) {
      cleanPhone = '20' + cleanPhone.slice(1);
    }
    const msg = encodeURIComponent(
      `السلام عليكم أ/ ${ctr.customer_name || 'العميل المحترم'}،\nتحية طيبة من سنترال المركزي.\nنود تذكير سيادتكم بميعاد سداد قسط جهاز (${ctr.device_name})، والمتبقي للعقد هو (${ctr.remaining_balance?.toLocaleString('ar-EG')} ج.م).\nنسعد دائماً بتشريفكم لمقر السنترال أو التحويل على أرقام الكاش المعتمدة.\nشكراً لتعاملكم الراقي.`
    );
    window.open(`https://wa.me/${cleanPhone}?text=${msg}`, '_blank');
  };

  const filtered = contracts.filter((c) => {
    const q = searchTerm.toLowerCase().trim();
    const matchesSearch = 
      !q ||
      (c.customer_name || '').toLowerCase().includes(q) ||
      (c.device_name || '').toLowerCase().includes(q) ||
      (c.contract_number || '').toLowerCase().includes(q) ||
      (c.customer_phone || '').includes(q);

    if (!matchesSearch) return false;
    if (filter === 'active') return c.status === 'active' && c.remaining_balance > 0;
    if (filter === 'completed') return c.status === 'completed' || c.remaining_balance <= 0;
    if (filter === 'overdue') return c.status === 'active' && c.remaining_balance > 0;
    if (filter === 'promises') return Boolean(promises[c.id]);
    return true;
  });

  return (
    <div className="space-y-5" dir="rtl">
      {/* Top Header */}
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3">
        <div>
          <h2 className="text-xl font-bold text-slate-900 flex items-center gap-2">
            <CreditCard className="w-6 h-6 text-primary" />
            عقود وأقساط العملاء ومتابعة التحصيل
          </h2>
          <p className="text-xs text-slate-500">إدارة الأقساط، وعود السداد، تنبيهات الواتساب، وإصدار إيصالات التحصيل المؤكدة</p>
        </div>

        <div className="flex items-center gap-2 w-full sm:w-auto">
          <button
            onClick={loadData}
            disabled={isLoading}
            className="p-2 rounded-xl border border-slate-200 text-slate-600 hover:bg-slate-50 transition"
          >
            <RefreshCw className={`w-4 h-4 ${isLoading ? 'animate-spin' : ''}`} />
          </button>
          <span className="text-xs font-bold text-slate-700 px-3 py-2 bg-white border border-slate-200 rounded-xl shadow-sm">
            إجمالي العقود: {contracts.length} عقد
          </span>
        </div>
      </div>

      {/* Filter and Search Bar */}
      <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm flex flex-col md:flex-row items-center justify-between gap-3">
        {/* Search */}
        <div className="relative w-full md:w-96">
          <Search className="w-4 h-4 absolute right-3 top-1/2 -translate-y-1/2 text-slate-400" />
          <input
            type="text"
            placeholder="ابحث بالاسم، رقم الهاتف، رقم العقد، أو نوع الجهاز..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full pr-9 pl-3 py-2.5 rounded-xl border border-slate-200 text-xs focus:outline-none focus:border-primary transition"
          />
        </div>

        {/* Status Filter Buttons */}
        <div className="flex items-center gap-1.5 overflow-x-auto w-full md:w-auto pb-1 md:pb-0">
          {[
            { id: 'all', label: 'الكل' },
            { id: 'active', label: 'عقود نشطة' },
            { id: 'overdue', label: 'أقساط مستحقة ومتأخرة' },
            { id: 'promises', label: 'وعود سداد مسجلة' },
            { id: 'completed', label: 'مسدد بالكامل' },
          ].map((f) => (
            <button
              key={f.id}
              onClick={() => setFilter(f.id as any)}
              className={`px-3 py-1.5 rounded-xl text-xs font-bold transition whitespace-nowrap ${
                filter === f.id
                  ? 'bg-primary text-white shadow-sm'
                  : 'bg-slate-50 text-slate-600 hover:bg-slate-100 border border-slate-200'
              }`}
            >
              {f.label}
            </button>
          ))}
        </div>
      </div>

      {/* Contracts Table */}
      <div className="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        {isLoading ? (
          <div className="p-12 text-center text-slate-400 text-xs">جاري تحميل سجل الأقساط والعقود...</div>
        ) : filtered.length === 0 ? (
          <div className="p-12 text-center space-y-2">
            <CreditCard className="w-10 h-10 text-slate-300 mx-auto" />
            <div className="font-bold text-slate-700 text-sm">لا توجد عقود مطابقة للبحث</div>
            <p className="text-xs text-slate-400">جرب البحث بكلمات أخرى أو اختر تصفية مختلفة</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-right text-xs">
              <thead className="bg-slate-50 border-b border-slate-200 text-slate-500 font-bold">
                <tr>
                  <th className="p-3.5">العميل والهاتف</th>
                  <th className="p-3.5">الجهاز والعقد</th>
                  <th className="p-3.5">إجمالي التقسيط</th>
                  <th className="p-3.5">المقدم</th>
                  <th className="p-3.5">المتبقي</th>
                  <th className="p-3.5">الحالة والمتابعة</th>
                  <th className="p-3.5 text-center">إجراءات المحصل</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {filtered.map((ctr) => {
                  const promise = promises[ctr.id];
                  const isPaid = ctr.remaining_balance <= 0;

                  return (
                    <tr key={ctr.id} className="hover:bg-slate-50/80 transition">
                      <td className="p-3.5">
                        <div className="font-bold text-slate-900 text-sm">{ctr.customer_name}</div>
                        <div className="text-slate-400 text-[11px] font-mono">{ctr.customer_phone || 'بدون هاتف'}</div>
                      </td>
                      <td className="p-3.5">
                        <span className="font-semibold text-slate-800">{ctr.device_name}</span>
                        <div className="text-[11px] text-slate-400 font-mono">
                          {ctr.contract_number} {ctr.imei_number ? `• IMEI: ${ctr.imei_number}` : ''}
                        </div>
                      </td>
                      <td className="p-3.5 font-bold text-slate-900">
                        {ctr.total_installment_price?.toLocaleString('ar-EG')} ج.م
                      </td>
                      <td className="p-3.5 text-emerald-700 font-semibold">
                        {ctr.down_payment > 0 ? `${ctr.down_payment.toLocaleString('ar-EG')} ج.م` : '-'}
                      </td>
                      <td className="p-3.5 font-black text-primary text-sm">
                        {ctr.remaining_balance?.toLocaleString('ar-EG')} ج.م
                      </td>
                      <td className="p-3.5 space-y-1">
                        {isPaid ? (
                          <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-emerald-50 text-emerald-700 border border-emerald-200">
                            <CheckCircle2 className="w-3 h-3" />
                            مسدد بالكامل ✅
                          </span>
                        ) : (
                          <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-amber-50 text-amber-700 border border-amber-200">
                            <Clock className="w-3 h-3" />
                            قسط نشط ⏳
                          </span>
                        )}

                        {promise && (
                          <div className="text-[10px] text-purple-700 font-bold bg-purple-50 px-2 py-0.5 rounded-md border border-purple-200 inline-block">
                            وعد سداد: {promise.date}
                          </div>
                        )}
                      </td>
                      <td className="p-3.5 text-center">
                        <div className="flex items-center justify-center gap-1.5">
                          {!isPaid && (
                            <>
                              <button
                                onClick={() => onCollect(ctr)}
                                className="px-3 py-1.5 rounded-xl bg-primary hover:bg-primary-dark text-white font-bold text-xs shadow-sm transition inline-flex items-center gap-1 active:scale-95"
                              >
                                <DollarSign className="w-3.5 h-3.5" />
                                تحصيل
                              </button>

                              <button
                                onClick={() => setPromiseModalContract(ctr)}
                                title="تسجيل وعد سداد"
                                className="p-1.5 rounded-xl border border-slate-200 text-slate-600 hover:bg-slate-100 transition"
                              >
                                <BookmarkPlus className="w-4 h-4 text-purple-600" />
                              </button>

                              {ctr.customer_phone && (
                                <button
                                  onClick={() => openWhatsApp(ctr)}
                                  title="إرسال تذكير واتساب"
                                  className="p-1.5 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-700 hover:bg-emerald-100 transition"
                                >
                                  <MessageCircle className="w-4 h-4" />
                                </button>
                              )}
                            </>
                          )}
                        </div>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* Promise Modal */}
      {promiseModalContract && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/60 backdrop-blur-sm p-4">
          <div className="bg-white rounded-2xl max-w-sm w-full p-5 shadow-2xl space-y-4 animate-in fade-in zoom-in-95">
            <div>
              <h3 className="font-bold text-slate-900 text-sm">تسجيل وعد سداد للعميل</h3>
              <p className="text-xs text-slate-500">{promiseModalContract.customer_name} ({promiseModalContract.device_name})</p>
            </div>

            <form onSubmit={handleSavePromise} className="space-y-3">
              <div>
                <label className="text-xs font-semibold text-slate-700 block mb-1">تاريخ الوعد المحدد *</label>
                <input
                  type="date"
                  required
                  value={promiseDate}
                  onChange={(e) => setPromiseDate(e.target.value)}
                  className="w-full p-2.5 rounded-xl border border-slate-200 text-xs font-bold focus:outline-none focus:border-primary"
                />
              </div>

              <div>
                <label className="text-xs font-semibold text-slate-700 block mb-1">ملاحظات المحصل</label>
                <input
                  type="text"
                  placeholder="مثال: وعد بسداد 1000 ج.م بعد نزول المرتب..."
                  value={promiseNotes}
                  onChange={(e) => setPromiseNotes(e.target.value)}
                  className="w-full p-2.5 rounded-xl border border-slate-200 text-xs focus:outline-none focus:border-primary"
                />
              </div>

              <div className="flex gap-2 pt-2">
                <button
                  type="button"
                  onClick={() => setPromiseModalContract(null)}
                  className="flex-1 py-2 rounded-xl border border-slate-200 text-slate-600 text-xs font-semibold hover:bg-slate-50"
                >
                  إلغاء
                </button>
                <button
                  type="submit"
                  className="flex-1 py-2 rounded-xl bg-purple-700 hover:bg-purple-800 text-white text-xs font-bold shadow-sm"
                >
                  حفظ وعد السداد
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
