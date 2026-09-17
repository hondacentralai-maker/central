import React, { useState, useEffect } from 'react';
import { 
  Users, 
  Search, 
  Phone, 
  CreditCard, 
  X, 
  UserPlus, 
  CheckCircle2, 
  Clock, 
  AlertCircle, 
  DollarSign, 
  Share2, 
  Calendar,
  Smartphone
} from 'lucide-react';
import { Customer } from '../types';

interface CustomersPageProps {
  onDirectCollect?: (data: any) => void;
}

export const CustomersPage: React.FC<CustomersPageProps> = ({ onDirectCollect }) => {
  const [customersData, setCustomersData] = useState<any[]>([]);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedCustomer, setSelectedCustomer] = useState<any | null>(null);
  const [isAddModalOpen, setIsAddModalOpen] = useState(false);
  const [newCustName, setNewCustName] = useState('');
  const [newCustPhone, setNewCustPhone] = useState('');
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    loadCustomers();
  }, []);

  const loadCustomers = async () => {
    setIsLoading(true);
    try {
      const res = await fetch('/migrated_data.json');
      if (res.ok) {
        const json = await res.json();
        setCustomersData(json.customers || []);
      }
    } catch {
      //
    } finally {
      setIsLoading(false);
    }
  };

  const handlePayInstallment = (contractIndex: number, instIndex: number) => {
    if (!selectedCustomer) return;

    // Clone and update state
    const updatedCust = { ...selectedCustomer };
    const contract = updatedCust.contracts[contractIndex];
    const inst = contract.installments[instIndex];

    const amountPaidNow = inst.remaining_amount > 0 ? inst.remaining_amount : inst.due_amount;
    
    inst.paid_amount = inst.due_amount;
    inst.remaining_amount = 0;
    inst.status = 'paid';
    inst.paid_date = new Date().toLocaleDateString('ar-EG');

    // Recalculate contract remaining balance
    contract.remaining_balance = Math.max(contract.remaining_balance - amountPaidNow, 0);

    // Update in customersData list
    const updatedList = customersData.map(c => c.name === selectedCustomer.name ? updatedCust : c);
    setCustomersData(updatedList);
    setSelectedCustomer(updatedCust);

    // Trigger receipt modal
    if (onDirectCollect) {
      onDirectCollect({
        receiptNumber: 'REC-' + Math.floor(1000 + Math.random() * 9000),
        customerName: selectedCustomer.name,
        customerPhone: selectedCustomer.phone,
        contractNumber: `CTR-${contractIndex + 1}`,
        deviceName: contract.device_name,
        amount: amountPaidNow,
        remainingBalance: contract.remaining_balance,
        paymentMethod: 'كاش الدرج',
        date: new Date().toLocaleDateString('ar-EG')
      });
    }
  };

  const filtered = customersData.filter((c) =>
    (c.name || '').toLowerCase().includes(searchTerm.toLowerCase()) ||
    (c.phone || '').includes(searchTerm)
  );

  return (
    <div className="space-y-5">
      {/* Header */}
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3">
        <div>
          <h2 className="text-xl font-bold text-slate-900 flex items-center gap-2">
            <Users className="w-6 h-6 text-primary" />
            سجل العملاء وملفات التقسيط
          </h2>
          <p className="text-xs text-slate-500">
            اضغط على أي عميل لمشاهدة عقده وجدول أقساطه الشهرية وسداد أي شهر بضغطة زر
          </p>
        </div>

        <div className="text-xs font-bold text-slate-500 bg-white px-3 py-1.5 rounded-xl border border-slate-200">
          إجمالي العملاء: {customersData.length} عميل
        </div>
      </div>

      {/* Search Bar */}
      <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm flex items-center justify-between gap-3">
        <div className="relative w-full max-w-md">
          <Search className="w-4 h-4 absolute right-3 top-1/2 -translate-y-1/2 text-slate-400" />
          <input
            type="text"
            placeholder="ابحث باسم العميل (مثال: أحمد سمير فتحي)..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full pr-9 pl-3 py-2 rounded-xl border border-slate-200 text-xs focus:outline-none focus:border-primary"
          />
        </div>
      </div>

      {/* Customers Cards Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3.5">
        {isLoading ? (
          <div className="col-span-full p-12 text-center text-slate-400 text-sm">جاري تحميل سجل العملاء...</div>
        ) : filtered.length === 0 ? (
          <div className="col-span-full p-12 text-center text-slate-400 text-sm">لا يوجد عميل مطابق للبحث</div>
        ) : (
          filtered.map((c, idx) => {
            const totPrice = c.contracts?.reduce((sum: number, x: any) => sum + (x.installment_price || 0), 0) || 0;
            const remBal = c.contracts?.reduce((sum: number, x: any) => sum + (x.remaining_balance || 0), 0) || 0;
            const mainDevice = c.contracts?.[0]?.device_name || 'هاتف ذكي';

            return (
              <div
                key={idx}
                onClick={() => setSelectedCustomer(c)}
                className="p-4 rounded-2xl bg-white border border-slate-200 shadow-sm hover:border-primary hover:shadow-md transition cursor-pointer flex flex-col justify-between space-y-3"
              >
                <div>
                  <div className="flex items-start justify-between">
                    <h4 className="font-bold text-slate-900 text-sm">{c.name}</h4>
                    <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-blue-50 text-primary border border-blue-100">
                      شيت: {c.sheet}
                    </span>
                  </div>
                  <div className="text-slate-500 text-xs flex items-center gap-1 mt-1">
                    <Smartphone className="w-3.5 h-3.5 text-slate-400" />
                    <span>{mainDevice}</span>
                  </div>
                </div>

                <div className="pt-2 border-t border-slate-100 flex items-center justify-between text-xs">
                  <div>
                    <span className="text-[11px] text-slate-400 block">المتبقي:</span>
                    <span className={`font-black text-sm ${remBal > 0 ? 'text-primary' : 'text-emerald-600'}`}>
                      {remBal.toLocaleString('ar-EG')} ج.م
                    </span>
                  </div>

                  <button className="text-xs font-bold text-primary hover:underline flex items-center gap-1">
                    عرض جدول الأقساط ←
                  </button>
                </div>
              </div>
            );
          })
        )}
      </div>

      {/* FULL CUSTOMER DOSSIER MODAL WITH MONTH-BY-MONTH SCHEDULE */}
      {selectedCustomer && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/60 backdrop-blur-sm p-3 md:p-6 overflow-y-auto">
          <div className="bg-white rounded-2xl max-w-2xl w-full shadow-2xl overflow-hidden my-auto animate-in fade-in zoom-in-95 duration-150 flex flex-col max-h-[90vh]">
            {/* Modal Header */}
            <div className="p-4 border-b border-slate-100 flex items-center justify-between bg-slate-50">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-primary/10 text-primary flex items-center justify-center font-black">
                  <Users className="w-5 h-5" />
                </div>
                <div>
                  <h3 className="font-bold text-slate-900 text-base">{selectedCustomer.name}</h3>
                  <div className="text-xs text-slate-500 flex items-center gap-2">
                    <span>الهاتف: {selectedCustomer.phone || 'غير مسجل'}</span>
                    <span>•</span>
                    <span>شيت: {selectedCustomer.sheet}</span>
                  </div>
                </div>
              </div>
              <button 
                onClick={() => setSelectedCustomer(null)}
                className="p-1.5 text-slate-400 hover:text-slate-600 rounded-lg"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            {/* Modal Scrollable Body */}
            <div className="p-4 md:p-6 overflow-y-auto space-y-6">
              {selectedCustomer.contracts?.map((ctr: any, ctrIdx: number) => (
                <div key={ctrIdx} className="space-y-4">
                  {/* Contract Overview Cards */}
                  <div className="p-4 rounded-2xl bg-gradient-to-r from-slate-900 to-slate-800 text-white space-y-3">
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-2">
                        <Smartphone className="w-5 h-5 text-cyan-400" />
                        <span className="font-bold text-sm text-cyan-300">{ctr.device_name}</span>
                      </div>
                      <span className="text-xs px-2 py-0.5 rounded-full bg-white/10 text-slate-200">
                        عقد رقم {ctrIdx + 1}
                      </span>
                    </div>

                    <div className="grid grid-cols-2 sm:grid-cols-4 gap-2 pt-2 border-t border-slate-700 text-xs">
                      <div>
                        <span className="text-slate-400 block text-[11px]">سعر القسط:</span>
                        <span className="font-bold">{ctr.installment_price?.toLocaleString('ar-EG')} ج.م</span>
                      </div>
                      <div>
                        <span className="text-slate-400 block text-[11px]">المقدم المدفوع:</span>
                        <span className="font-bold text-emerald-400">{ctr.down_payment?.toLocaleString('ar-EG')} ج.م</span>
                      </div>
                      <div>
                        <span className="text-slate-400 block text-[11px]">المتبقي الكلي:</span>
                        <span className="font-black text-cyan-300">{ctr.remaining_balance?.toLocaleString('ar-EG')} ج.م</span>
                      </div>
                      <div>
                        <span className="text-slate-400 block text-[11px]">عدد الأقساط:</span>
                        <span className="font-bold">{ctr.installment_count || ctr.installments?.length} شهر</span>
                      </div>
                    </div>
                  </div>

                  {/* Month-By-Month Installments Table */}
                  <div className="space-y-2">
                    <div className="flex items-center justify-between">
                      <h4 className="font-bold text-slate-800 text-xs flex items-center gap-1.5">
                        <Calendar className="w-4 h-4 text-primary" />
                        جدول الأقساط الشهرية وسجل السداد
                      </h4>
                      <span className="text-[11px] text-slate-400">
                        اضغط "سداد هذا الشهر" لتسجيل الدفعة فوراً
                      </span>
                    </div>

                    <div className="border border-slate-200 rounded-xl overflow-hidden">
                      <table className="w-full text-right text-xs">
                        <thead className="bg-slate-50 border-b border-slate-200 text-slate-500 font-bold">
                          <tr>
                            <th className="p-2.5">الشهر</th>
                            <th className="p-2.5">تاريخ الاستحقاق</th>
                            <th className="p-2.5">المطلوب</th>
                            <th className="p-2.5">المدفوع</th>
                            <th className="p-2.5">الحالة</th>
                            <th className="p-2.5 text-center">إجراء</th>
                          </tr>
                        </thead>
                        <tbody className="divide-y divide-slate-100">
                          {ctr.installments?.map((inst: any, instIdx: number) => {
                            const isPaid = inst.status === 'paid' || (inst.paid_amount >= inst.due_amount && inst.due_amount > 0);
                            const isDownPayment = inst.item_type === 'down_payment';

                            return (
                              <tr key={instIdx} className={isPaid ? 'bg-emerald-50/30' : 'hover:bg-slate-50'}>
                                <td className="p-2.5 font-bold text-slate-800">
                                  {isDownPayment ? 'الدفعة المقدمة' : `قسط شهر ${instIdx}`}
                                </td>
                                <td className="p-2.5 text-slate-600 font-mono">
                                  {inst.due_date || '-'}
                                </td>
                                <td className="p-2.5 font-bold text-slate-900">
                                  {inst.due_amount?.toLocaleString('ar-EG')} ج.م
                                </td>
                                <td className="p-2.5 text-emerald-700 font-semibold">
                                  {inst.paid_amount > 0 ? `${inst.paid_amount.toLocaleString('ar-EG')} ج.م` : '0'}
                                </td>
                                <td className="p-2.5">
                                  {isPaid ? (
                                    <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[10px] font-bold bg-emerald-100 text-emerald-800">
                                      <CheckCircle2 className="w-3 h-3 text-emerald-600" />
                                      مسدد ✅
                                    </span>
                                  ) : inst.paid_amount > 0 ? (
                                    <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[10px] font-bold bg-blue-100 text-blue-800">
                                      سداد جزئي
                                    </span>
                                  ) : (
                                    <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[10px] font-bold bg-amber-100 text-amber-800">
                                      <Clock className="w-3 h-3 text-amber-600" />
                                      مستحق السداد
                                    </span>
                                  )}
                                </td>
                                <td className="p-2.5 text-center">
                                  {!isPaid ? (
                                    <button
                                      onClick={() => handlePayInstallment(ctrIdx, instIdx)}
                                      className="px-2.5 py-1 rounded-lg bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-[11px] shadow-sm transition inline-flex items-center gap-1 active:scale-95"
                                    >
                                      <DollarSign className="w-3 h-3" />
                                      سداد هذا الشهر
                                    </button>
                                  ) : (
                                    <span className="text-slate-400 text-[11px]">تم السداد</span>
                                  )}
                                </td>
                              </tr>
                            );
                          })}
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>
              ))}
            </div>

            {/* Modal Footer with WhatsApp */}
            <div className="p-4 border-t border-slate-100 bg-slate-50 flex items-center justify-between">
              {selectedCustomer.phone && (
                <a
                  href={`https://api.whatsapp.com/send?phone=2${selectedCustomer.phone.replace(/[^0-9]/g, '')}`}
                  target="_blank"
                  rel="noreferrer"
                  className="py-2 px-4 rounded-xl bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs flex items-center gap-1.5 transition"
                >
                  <Share2 className="w-4 h-4" />
                  مراسلة العميل على WhatsApp
                </a>
              )}
              <button
                onClick={() => setSelectedCustomer(null)}
                className="py-2 px-5 rounded-xl border border-slate-200 text-slate-700 font-bold text-xs hover:bg-slate-100 transition mr-auto"
              >
                إغلاق
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
