import React, { useState, useEffect } from 'react';
import { 
  CreditCard, 
  Search, 
  Filter, 
  PlusCircle, 
  AlertCircle, 
  CheckCircle2, 
  Clock, 
  DollarSign, 
  Share2 
} from 'lucide-react';
import { api } from '../services/api';
import { Contract } from '../types';

interface InstallmentsPageProps {
  onCollect: (contract: Contract) => void;
}

export const InstallmentsPage: React.FC<InstallmentsPageProps> = ({ onCollect }) => {
  const [contracts, setContracts] = useState<Contract[]>([]);
  const [filter, setFilter] = useState<'all' | 'active' | 'overdue' | 'completed'>('all');
  const [searchTerm, setSearchTerm] = useState('');
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    loadData();
  }, []);

  const loadData = async () => {
    setIsLoading(true);
    try {
      // Try Supabase first
      const data = await api.getContracts();
      if (data && data.length > 0) {
        setContracts(data);
      } else {
        // Load initial migrated contracts from JSON fallback
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
                customer_phone: c.phone,
                contract_number: `CTR-${cIdx + 1}-${ctrIdx + 1}`,
                device_name: ctr.device_name,
                cash_price: ctr.cash_price,
                total_installment_price: ctr.installment_price,
                down_payment: ctr.down_payment,
                down_payment_date: ctr.down_payment_date,
                remaining_balance: ctr.remaining_balance,
                installment_count: ctr.installment_count || 10,
                monthly_installment_amount: (ctr.remaining_balance / Math.max(ctr.installment_count || 10, 1)),
                start_date: '2025-01-01',
                due_day: 1,
                status: ctr.remaining_balance <= 0 ? 'completed' : 'active',
                created_at: new Date().toISOString()
              });
            });
          });
          setContracts(flatContracts);
        }
      }
    } catch {
      //
    } finally {
      setIsLoading(false);
    }
  };

  const filtered = contracts.filter((c) => {
    const matchesSearch = 
      (c.customer_name || '').toLowerCase().includes(searchTerm.toLowerCase()) ||
      (c.device_name || '').toLowerCase().includes(searchTerm.toLowerCase()) ||
      (c.customer_phone || '').includes(searchTerm);

    if (!matchesSearch) return false;
    if (filter === 'active') return c.status === 'active';
    if (filter === 'completed') return c.status === 'completed';
    if (filter === 'overdue') return c.status === 'active' && (c.remaining_balance > 0);
    return true;
  });

  return (
    <div className="space-y-5">
      {/* Top Header */}
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3">
        <div>
          <h2 className="text-xl font-bold text-slate-900 flex items-center gap-2">
            <CreditCard className="w-6 h-6 text-primary" />
            عقود وأقساط العملاء
          </h2>
          <p className="text-xs text-slate-500">متابعة الأقساط الشهرية، السداد، وإصدار إيصالات التحصيل</p>
        </div>

        <div className="flex items-center gap-2 w-full sm:w-auto">
          <span className="text-xs font-bold text-slate-500 px-3 py-1.5 bg-white border border-slate-200 rounded-xl">
            إجمالي العقود: {contracts.length}
          </span>
        </div>
      </div>

      {/* Filter and Search Bar */}
      <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm flex flex-col md:flex-row items-center justify-between gap-3">
        {/* Search */}
        <div className="relative w-full md:w-80">
          <Search className="w-4 h-4 absolute right-3 top-1/2 -translate-y-1/2 text-slate-400" />
          <input
            type="text"
            placeholder="ابحث باسم العميل أو نوع الجهاز أو الهاتف..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full pr-9 pl-3 py-2 rounded-xl border border-slate-200 text-xs focus:outline-none focus:border-primary"
          />
        </div>

        {/* Status Filter Buttons */}
        <div className="flex items-center gap-1.5 overflow-x-auto w-full md:w-auto pb-1 md:pb-0">
          {[
            { id: 'all', label: 'الكل' },
            { id: 'active', label: 'عقود نشطة' },
            { id: 'overdue', label: 'متأخرات' },
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

      {/* Contracts Table / Cards */}
      <div className="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        {isLoading ? (
          <div className="p-12 text-center text-slate-400 text-sm">جاري تحميل سجل الأقساط...</div>
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
                  <th className="p-3.5">العميل</th>
                  <th className="p-3.5">الجهاز المباع</th>
                  <th className="p-3.5">إجمالي القسط</th>
                  <th className="p-3.5">المقدم</th>
                  <th className="p-3.5">المتبقي</th>
                  <th className="p-3.5">الحالة</th>
                  <th className="p-3.5 text-center">إجراء السداد</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {filtered.map((ctr) => (
                  <tr key={ctr.id} className="hover:bg-slate-50/80 transition">
                    <td className="p-3.5">
                      <div className="font-bold text-slate-900 text-sm">{ctr.customer_name}</div>
                      <div className="text-slate-400 text-[11px]">{ctr.customer_phone || 'بدون هاتف'}</div>
                    </td>
                    <td className="p-3.5">
                      <span className="font-semibold text-slate-800">{ctr.device_name}</span>
                      {ctr.cash_price > 0 && (
                        <div className="text-[11px] text-slate-400">كاش: {ctr.cash_price.toLocaleString('ar-EG')} ج.م</div>
                      )}
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
                    <td className="p-3.5">
                      {ctr.remaining_balance <= 0 ? (
                        <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[10px] font-bold bg-emerald-50 text-emerald-700 border border-emerald-200">
                          <CheckCircle2 className="w-3 h-3" />
                          مسدد بالكامل
                        </span>
                      ) : (
                        <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[10px] font-bold bg-blue-50 text-blue-700 border border-blue-200">
                          <Clock className="w-3 h-3" />
                          نشط (عليه متبقي)
                        </span>
                      )}
                    </td>
                    <td className="p-3.5 text-center">
                      {ctr.remaining_balance > 0 ? (
                        <button
                          onClick={() => onCollect(ctr)}
                          className="px-3 py-1.5 rounded-xl bg-primary hover:bg-primary-dark text-white font-bold text-xs shadow-sm shadow-primary/20 transition inline-flex items-center gap-1"
                        >
                          <DollarSign className="w-3.5 h-3.5" />
                          تحصيل قسط
                        </button>
                      ) : (
                        <span className="text-slate-400 text-xs">-</span>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
};
