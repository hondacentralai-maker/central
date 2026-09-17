import React, { useState, useEffect } from 'react';
import { 
  Users, 
  Search, 
  Phone, 
  CreditCard, 
  ArrowRight, 
  UserPlus, 
  CheckCircle2, 
  Clock, 
  DollarSign, 
  Share2, 
  Calendar,
  Smartphone,
  PlusCircle,
  Hash,
  ShieldCheck,
  MapPin,
  FileText
} from 'lucide-react';

import type { Profile, Contract } from '../types';

interface CustomersPageProps {
  profile?: Profile;
  onOpenCollection?: (contract?: Contract) => void;
  onDirectCollect?: (data: any) => void;
}

export const CustomersPage: React.FC<CustomersPageProps> = ({ profile: _profile, onOpenCollection: _onOpenCollection, onDirectCollect }) => {
  const [customersData, setCustomersData] = useState<any[]>([]);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedCustomer, setSelectedCustomer] = useState<any | null>(null);

  // Add Customer Modal State
  const [isAddModalOpen, setIsAddModalOpen] = useState(false);
  const [newCustCode, setNewCustCode] = useState('');
  const [newCustName, setNewCustName] = useState('');
  const [newCustPhone, setNewCustPhone] = useState('');
  const [newCustSecPhone, setNewCustSecPhone] = useState('');
  const [newCustNationalId, setNewCustNationalId] = useState('');
  const [newCustAddress, setNewCustAddress] = useState('');
  
  // Guarantor Info
  const [newGuarantorName, setNewGuarantorName] = useState('');
  const [newGuarantorPhone, setNewGuarantorPhone] = useState('');
  const [newGuarantorRel, setNewGuarantorRel] = useState('');
  
  // Initial Installment Contract (Optional during customer creation)
  const [includeContract, setIncludeContract] = useState(true);
  const [newDeviceName, setNewDeviceName] = useState('');
  const [newImei, setNewImei] = useState('');
  const [newCashPrice, setNewCashPrice] = useState('');
  const [newInstallmentPrice, setNewInstallmentPrice] = useState('');
  const [newDownPayment, setNewDownPayment] = useState('');
  const [newMonthsCount, setNewMonthsCount] = useState('10');
  const [newFirstDueDate, setNewFirstDueDate] = useState('');

  // Add New Contract Modal for existing customer
  const [isNewContractModalOpen, setIsNewContractModalOpen] = useState(false);

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
        // Ensure every customer has a unique code CUS-00001, etc.
        const list = (json.customers || []).map((c: any, idx: number) => ({
          ...c,
          code: c.code || `CUS-${(idx + 1).toString().padStart(5, '0')}`,
          national_id: c.national_id || '',
        }));
        setCustomersData(list);
      }
    } catch {
      //
    } finally {
      setIsLoading(false);
    }
  };

  const openAddCustomerModal = () => {
    const nextCode = `CUS-${(customersData.length + 1).toString().padStart(5, '0')}`;
    setNewCustCode(nextCode);
    setNewCustName('');
    setNewCustPhone('');
    setNewCustSecPhone('');
    setNewCustNationalId('');
    setNewCustAddress('');
    setNewGuarantorName('');
    setNewGuarantorPhone('');
    setNewGuarantorRel('');
    setNewDeviceName('');
    setNewImei('');
    setNewCashPrice('');
    setNewInstallmentPrice('');
    setNewDownPayment('');
    setNewMonthsCount('10');
    setNewFirstDueDate(new Date(Date.now() + 30*24*60*60*1000).toISOString().slice(0, 10));
    setIsAddModalOpen(true);
  };

  const handleCreateCustomer = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newCustName.trim()) return;

    const contracts = [];
    const instPrice = parseFloat(newInstallmentPrice) || 0;
    const downPay = parseFloat(newDownPayment) || 0;
    const months = parseInt(newMonthsCount) || 10;
    const remaining = Math.max(instPrice - downPay, 0);

    if (includeContract && instPrice > 0) {
      // Generate installment schedule
      const installments = [];
      if (downPay > 0) {
        installments.push({
          item_type: 'down_payment',
          due_amount: downPay,
          paid_amount: downPay,
          remaining_amount: 0,
          due_date: new Date().toLocaleDateString('ar-EG'),
          paid_date: new Date().toLocaleDateString('ar-EG'),
          status: 'paid'
        });
      }

      const monthlyAmt = Math.round(remaining / Math.max(months, 1));
      for (let m = 1; m <= months; m++) {
        const dueDate = new Date();
        dueDate.setMonth(dueDate.getMonth() + m);
        installments.push({
          item_type: 'installment',
          due_amount: monthlyAmt,
          paid_amount: 0,
          remaining_amount: monthlyAmt,
          due_date: dueDate.toLocaleDateString('ar-EG'),
          status: 'pending'
        });
      }

      contracts.push({
        device_name: newDeviceName.trim() || 'هاتف ذكي',
        imei: newImei.trim(),
        cash_price: parseFloat(newCashPrice) || 0,
        installment_price: instPrice,
        down_payment: downPay,
        remaining_balance: remaining,
        installment_count: months,
        installments: installments
      });
    }

    const newCustomer = {
      code: newCustCode,
      name: newCustName.trim(),
      phone: newCustPhone.trim(),
      secondary_phone: newCustSecPhone.trim(),
      national_id: newCustNationalId.trim(),
      address: newCustAddress.trim(),
      sheet: 'عملاء جدد',
      guarantor: {
        name: newGuarantorName.trim(),
        phone: newGuarantorPhone.trim(),
        relationship: newGuarantorRel.trim(),
      },
      contracts: contracts
    };

    const updated = [newCustomer, ...customersData];
    setCustomersData(updated);
    setIsAddModalOpen(false);
    setSelectedCustomer(newCustomer);
  };

  const handlePayInstallment = (contractIndex: number, instIndex: number) => {
    if (!selectedCustomer) return;

    const updatedCust = { ...selectedCustomer };
    const contract = updatedCust.contracts[contractIndex];
    const inst = contract.installments[instIndex];

    const amountPaidNow = inst.remaining_amount > 0 ? inst.remaining_amount : inst.due_amount;
    
    inst.paid_amount = inst.due_amount;
    inst.remaining_amount = 0;
    inst.status = 'paid';
    inst.paid_date = new Date().toLocaleDateString('ar-EG');

    contract.remaining_balance = Math.max(contract.remaining_balance - amountPaidNow, 0);

    const updatedList = customersData.map(c => c.name === selectedCustomer.name ? updatedCust : c);
    setCustomersData(updatedList);
    setSelectedCustomer(updatedCust);

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

  // Search by: Name, Phone, Customer Code, or National ID
  const filtered = customersData.filter((c) => {
    const q = searchTerm.toLowerCase().trim();
    if (!q) return true;
    return (
      (c.name || '').toLowerCase().includes(q) ||
      (c.phone || '').includes(q) ||
      (c.code || '').toLowerCase().includes(q) ||
      (c.national_id || '').includes(q)
    );
  });

  // =========================================================================
  // 1. IN-PAGE CUSTOMER FILE VIEW
  // =========================================================================
  if (selectedCustomer) {
    const totRem = selectedCustomer.contracts?.reduce((sum: number, c: any) => sum + (c.remaining_balance || 0), 0) || 0;
    const totPrice = selectedCustomer.contracts?.reduce((sum: number, c: any) => sum + (c.installment_price || 0), 0) || 0;

    return (
      <div className="space-y-6 animate-in fade-in duration-150">
        {/* Navigation & Header */}
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
          <div className="flex items-center gap-3">
            <button
              onClick={() => setSelectedCustomer(null)}
              className="px-3 py-2 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold text-xs flex items-center gap-1.5 transition active:scale-95"
            >
              <ArrowRight className="w-4 h-4" />
              العودة لقائمة العملاء
            </button>
            <div className="h-6 w-px bg-slate-200 hidden sm:block"></div>
            <div>
              <div className="flex items-center gap-2">
                <h2 className="text-lg font-black text-slate-900">{selectedCustomer.name}</h2>
                <span className="text-[11px] font-mono font-bold px-2.5 py-0.5 rounded-full bg-slate-900 text-white shadow-sm">
                  {selectedCustomer.code}
                </span>
                <span className="text-[11px] font-bold px-2 py-0.5 rounded-full bg-blue-50 text-primary border border-blue-100">
                  {selectedCustomer.sheet}
                </span>
              </div>
              <p className="text-xs text-slate-500 mt-0.5">
                الهاتف: <span className="font-bold text-slate-700">{selectedCustomer.phone || 'غير مسجل'}</span>
                {selectedCustomer.national_id && ` • الرقم القومي: ${selectedCustomer.national_id}`}
                {selectedCustomer.address && ` • العنوان: ${selectedCustomer.address}`}
              </p>
            </div>
          </div>

          <div className="flex items-center gap-2 w-full sm:w-auto">
            {selectedCustomer.phone && (
              <a
                href={`https://api.whatsapp.com/send?phone=2${selectedCustomer.phone.replace(/[^0-9]/g, '')}`}
                target="_blank"
                rel="noreferrer"
                className="py-2 px-3.5 rounded-xl bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs flex items-center gap-1.5 transition shadow-sm"
              >
                <Share2 className="w-4 h-4" />
                مراسلة WhatsApp
              </a>
            )}
          </div>
        </div>

        {/* Guarantor Info if available */}
        {selectedCustomer.guarantor && selectedCustomer.guarantor.name && (
          <div className="p-3.5 rounded-2xl bg-amber-50/80 border border-amber-200 text-xs flex items-center justify-between text-amber-900">
            <div className="flex items-center gap-2">
              <ShieldCheck className="w-4 h-4 text-amber-600 flex-shrink-0" />
              <span>
                <strong>بيانات الضامن:</strong> {selectedCustomer.guarantor.name} • هاتف: {selectedCustomer.guarantor.phone || 'بدون هاتف'} 
                {selectedCustomer.guarantor.relationship && ` (${selectedCustomer.guarantor.relationship})`}
              </span>
            </div>
          </div>
        )}

        {/* Customer Top Summary Cards */}
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
          <div className="p-5 rounded-2xl bg-white border border-slate-200 shadow-sm">
            <span className="text-xs text-slate-400 font-bold block mb-1">المتبقي على العميل (الديون)</span>
            <div className="text-2xl font-black text-primary">
              {totRem.toLocaleString('ar-EG')} <span className="text-xs font-bold text-slate-500">ج.م</span>
            </div>
            <div className="text-[11px] text-slate-400 mt-1">الواجب تحصيله خلال الشهور القادمة</div>
          </div>

          <div className="p-5 rounded-2xl bg-white border border-slate-200 shadow-sm">
            <span className="text-xs text-slate-400 font-bold block mb-1">إجمالي قيمة العقود</span>
            <div className="text-2xl font-black text-slate-900">
              {totPrice.toLocaleString('ar-EG')} <span className="text-xs font-bold text-slate-500">ج.م</span>
            </div>
            <div className="text-[11px] text-slate-400 mt-1">سعر بيع الأجهزة بالتقسيط</div>
          </div>

          <div className="p-5 rounded-2xl bg-white border border-slate-200 shadow-sm">
            <span className="text-xs text-slate-400 font-bold block mb-1">المسدد فعلياً</span>
            <div className="text-2xl font-black text-emerald-600">
              {(totPrice - totRem).toLocaleString('ar-EG')} <span className="text-xs font-bold text-slate-500">ج.م</span>
            </div>
            <div className="text-[11px] text-emerald-700 font-semibold mt-1">
              نسبة السداد: {totPrice > 0 ? Math.round(((totPrice - totRem) / totPrice) * 100) : 100}%
            </div>
          </div>
        </div>

        {/* Contracts & Detailed Month-By-Month Tables */}
        {selectedCustomer.contracts?.map((ctr: any, ctrIdx: number) => (
          <div key={ctrIdx} className="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden space-y-4 p-5">
            {/* Contract Header Banner */}
            <div className="p-4 rounded-xl bg-slate-900 text-white flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-cyan-500/20 text-cyan-400 flex items-center justify-center">
                  <Smartphone className="w-5 h-5" />
                </div>
                <div>
                  <h3 className="font-bold text-base text-cyan-300">{ctr.device_name}</h3>
                  <span className="text-xs text-slate-400">
                    عقد تقسيط رقم {ctrIdx + 1} {ctr.imei ? `• IMEI: ${ctr.imei}` : ''}
                  </span>
                </div>
              </div>

              <div className="flex items-center gap-4 text-xs">
                <div>
                  <span className="text-slate-400 block text-[11px]">المقدم المدفوع:</span>
                  <span className="font-bold text-emerald-400">{ctr.down_payment?.toLocaleString('ar-EG')} ج.م</span>
                </div>
                <div className="h-6 w-px bg-slate-700"></div>
                <div>
                  <span className="text-slate-400 block text-[11px]">المتبقي للعقد:</span>
                  <span className="font-black text-cyan-300">{ctr.remaining_balance?.toLocaleString('ar-EG')} ج.م</span>
                </div>
              </div>
            </div>

            {/* Installments Table */}
            <div className="space-y-2">
              <div className="flex items-center justify-between">
                <h4 className="font-bold text-slate-800 text-xs flex items-center gap-1.5">
                  <Calendar className="w-4 h-4 text-primary" />
                  جدول الشهور والأقساط المستحقة (سداد أي شهر بنقرة واحدة):
                </h4>
                <span className="text-[11px] text-slate-400">
                  {ctr.installments?.length} قسط مسجل
                </span>
              </div>

              <div className="border border-slate-200 rounded-xl overflow-x-auto">
                <table className="w-full text-right text-xs">
                  <thead className="bg-slate-50 border-b border-slate-200 text-slate-500 font-bold">
                    <tr>
                      <th className="p-3">الشهر / الدفعة</th>
                      <th className="p-3">تاريخ الاستحقاق</th>
                      <th className="p-3">المطلوب</th>
                      <th className="p-3">المدفوع</th>
                      <th className="p-3">الحالة</th>
                      <th className="p-3 text-center">إجراء السداد</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-100">
                    {ctr.installments?.map((inst: any, instIdx: number) => {
                      const isPaid = inst.status === 'paid' || (inst.paid_amount >= inst.due_amount && inst.due_amount > 0);
                      const isDownPayment = inst.item_type === 'down_payment';

                      return (
                        <tr key={instIdx} className={isPaid ? 'bg-emerald-50/30' : 'hover:bg-slate-50/80 transition'}>
                          <td className="p-3 font-bold text-slate-900">
                            {isDownPayment ? 'الدفعة المقدمة' : `قسط شهر ${instIdx}`}
                          </td>
                          <td className="p-3 text-slate-600 font-mono">
                            {inst.due_date || '-'}
                          </td>
                          <td className="p-3 font-black text-slate-900 text-sm">
                            {inst.due_amount?.toLocaleString('ar-EG')} ج.م
                          </td>
                          <td className="p-3 text-emerald-700 font-semibold">
                            {inst.paid_amount > 0 ? `${inst.paid_amount.toLocaleString('ar-EG')} ج.م` : '0 ج.م'}
                          </td>
                          <td className="p-3">
                            {isPaid ? (
                              <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-emerald-100 text-emerald-800">
                                <CheckCircle2 className="w-3 h-3 text-emerald-600" />
                                مسدد ✅
                              </span>
                            ) : inst.paid_amount > 0 ? (
                              <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-blue-100 text-blue-800">
                                سداد جزئي ({inst.paid_amount} ج.م)
                              </span>
                            ) : (
                              <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-amber-100 text-amber-800">
                                <Clock className="w-3 h-3 text-amber-600" />
                                مستحق السداد ⏳
                              </span>
                            )}
                          </td>
                          <td className="p-3 text-center">
                            {!isPaid ? (
                              <button
                                onClick={() => handlePayInstallment(ctrIdx, instIdx)}
                                className="px-3 py-1.5 rounded-xl bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs shadow-sm transition inline-flex items-center gap-1 active:scale-95"
                              >
                                <DollarSign className="w-3.5 h-3.5" />
                                سداد هذا الشهر
                              </button>
                            ) : (
                              <span className="text-slate-400 text-xs font-semibold">تم السداد</span>
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
    );
  }

  // =========================================================================
  // 2. MAIN CUSTOMERS DIRECTORY LIST VIEW
  // =========================================================================
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
            البحث بكود العميل الفريد أو بالاسم أو برقم الهاتف أو بالرقم القومي لمنع التشابهات
          </p>
        </div>

        <button
          onClick={openAddCustomerModal}
          className="px-4 py-2.5 rounded-xl bg-primary hover:bg-primary-dark text-white font-black text-xs shadow-md shadow-primary/25 flex items-center gap-2 transition active:scale-95"
        >
          <UserPlus className="w-4 h-4" />
          إضافة عميل جديد + عقد تقسيط
        </button>
      </div>

      {/* Advanced Search Bar */}
      <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm flex flex-col md:flex-row items-center justify-between gap-3">
        <div className="relative w-full max-w-lg">
          <Search className="w-4 h-4 absolute right-3.5 top-1/2 -translate-y-1/2 text-slate-400" />
          <input
            type="text"
            placeholder="ابحث بكود العميل (مثال CUS-00001) أو بالاسم أو بالهاتف أو بالرقم القومي..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full pr-10 pl-3 py-2.5 rounded-xl border border-slate-200 text-xs focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary transition"
          />
        </div>

        <div className="flex items-center gap-2 text-xs font-bold text-slate-500">
          <span>نتائج البحث:</span>
          <span className="px-2.5 py-1 rounded-lg bg-slate-100 text-slate-800 font-bold">{filtered.length} عميل</span>
        </div>
      </div>

      {/* Customers Cards Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3.5">
        {isLoading ? (
          <div className="col-span-full p-12 text-center text-slate-400 text-sm">جاري تحميل سجل العملاء...</div>
        ) : filtered.length === 0 ? (
          <div className="col-span-full p-12 text-center space-y-2">
            <Users className="w-10 h-10 text-slate-300 mx-auto" />
            <div className="font-bold text-slate-700 text-sm">لا يوجد عميل مطابق للبحث الحالي</div>
            <p className="text-xs text-slate-400">تأكد من رقم العميل أو الاسم</p>
          </div>
        ) : (
          filtered.map((c, idx) => {
            const remBal = c.contracts?.reduce((sum: number, x: any) => sum + (x.remaining_balance || 0), 0) || 0;
            const mainDevice = c.contracts?.[0]?.device_name || 'هاتف ذكي';

            return (
              <div
                key={idx}
                onClick={() => setSelectedCustomer(c)}
                className="p-4 rounded-2xl bg-white border border-slate-200 shadow-sm hover:border-primary hover:shadow-md transition cursor-pointer flex flex-col justify-between space-y-3 group"
              >
                <div>
                  <div className="flex items-start justify-between">
                    <div>
                      <div className="flex items-center gap-1.5 mb-1">
                        <span className="text-[10px] font-mono font-bold px-2 py-0.5 rounded-md bg-slate-900 text-white">
                          {c.code || `CUS-${(idx + 1).toString().padStart(5, '0')}`}
                        </span>
                        <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-blue-50 text-primary border border-blue-100">
                          {c.sheet}
                        </span>
                      </div>
                      <h4 className="font-bold text-slate-900 text-sm group-hover:text-primary transition">{c.name}</h4>
                    </div>
                  </div>

                  <div className="text-slate-500 text-xs flex items-center gap-2 mt-2">
                    <span className="flex items-center gap-1">
                      <Phone className="w-3 h-3 text-slate-400" />
                      {c.phone || 'بدون هاتف'}
                    </span>
                    {c.national_id && (
                      <span className="text-[11px] text-slate-400 font-mono">
                        (هوية: {c.national_id.slice(-6)}***)
                      </span>
                    )}
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

                  <span className="text-xs font-bold text-primary flex items-center gap-1 group-hover:translate-x-[-3px] transition">
                    عرض الأقساط ←
                  </span>
                </div>
              </div>
            );
          })
        )}
      </div>

      {/* =========================================================================
          COMPREHENSIVE "ADD CUSTOMER + INSTALLMENT CONTRACT" MODAL
         ========================================================================= */}
      {isAddModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/60 backdrop-blur-sm p-3 md:p-6 overflow-y-auto">
          <div className="bg-white rounded-3xl max-w-2xl w-full shadow-2xl overflow-hidden my-auto animate-in fade-in zoom-in-95 duration-150 flex flex-col max-h-[92vh]">
            {/* Modal Header */}
            <div className="p-4 md:p-5 border-b border-slate-100 flex items-center justify-between bg-slate-50">
              <div className="flex items-center gap-2.5">
                <div className="w-9 h-9 rounded-xl bg-primary text-white flex items-center justify-center shadow-md shadow-primary/20">
                  <UserPlus className="w-5 h-5" />
                </div>
                <div>
                  <h3 className="font-bold text-slate-900 text-base">إضافة عميل جديد وتعيين كود فريد</h3>
                  <p className="text-xs text-slate-500">تسجيل بيانات العميل، الرقم القومي، والضامن، مع إنشاء عقد التقسيط</p>
                </div>
              </div>
              <button onClick={() => setIsAddModalOpen(false)} className="p-1.5 text-slate-400 hover:text-slate-600 rounded-lg">
                ✕
              </button>
            </div>

            {/* Modal Form Body */}
            <form onSubmit={handleCreateCustomer} className="p-5 md:p-6 overflow-y-auto space-y-5">
              {/* Section 1: Customer Identifiers */}
              <div className="space-y-3">
                <div className="flex items-center justify-between border-b border-slate-100 pb-1.5">
                  <span className="text-xs font-black text-slate-900 flex items-center gap-1.5">
                    <Hash className="w-4 h-4 text-primary" />
                    بيانات العميل والكود التعريفي
                  </span>
                  <span className="text-[11px] text-slate-400">الكود يمنع تشابه الأسماء في البحث</span>
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                  <div>
                    <label className="block text-xs font-bold text-slate-700 mb-1">كود العميل الفريد *</label>
                    <input
                      type="text"
                      required
                      value={newCustCode}
                      onChange={(e) => setNewCustCode(e.target.value)}
                      className="w-full p-2.5 rounded-xl border border-slate-200 text-xs font-mono font-bold bg-slate-50 text-primary focus:outline-none focus:border-primary"
                    />
                  </div>

                  <div className="sm:col-span-2">
                    <label className="block text-xs font-bold text-slate-700 mb-1">اسم العميل الرباعي *</label>
                    <input
                      type="text"
                      required
                      placeholder="مثال: أحمد محمد سمير علي"
                      value={newCustName}
                      onChange={(e) => setNewCustName(e.target.value)}
                      className="w-full p-2.5 rounded-xl border border-slate-200 text-xs font-semibold focus:outline-none focus:border-primary"
                    />
                  </div>
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                  <div>
                    <label className="block text-xs font-bold text-slate-700 mb-1">رقم الهاتف الأساسي *</label>
                    <input
                      type="tel"
                      required
                      placeholder="010xxxxxxxx"
                      value={newCustPhone}
                      onChange={(e) => setNewCustPhone(e.target.value)}
                      className="w-full p-2.5 rounded-xl border border-slate-200 text-xs focus:outline-none focus:border-primary"
                    />
                  </div>

                  <div>
                    <label className="block text-xs font-bold text-slate-700 mb-1">هاتف إضافي / واتساب</label>
                    <input
                      type="tel"
                      placeholder="011xxxxxxxx"
                      value={newCustSecPhone}
                      onChange={(e) => setNewCustSecPhone(e.target.value)}
                      className="w-full p-2.5 rounded-xl border border-slate-200 text-xs focus:outline-none focus:border-primary"
                    />
                  </div>

                  <div>
                    <label className="block text-xs font-bold text-slate-700 mb-1">الرقم القومي (14 رقم)</label>
                    <input
                      type="text"
                      maxLength={14}
                      placeholder="298xxxxxxxxxxx"
                      value={newCustNationalId}
                      onChange={(e) => setNewCustNationalId(e.target.value)}
                      className="w-full p-2.5 rounded-xl border border-slate-200 text-xs font-mono focus:outline-none focus:border-primary"
                    />
                  </div>
                </div>

                <div>
                  <label className="block text-xs font-bold text-slate-700 mb-1">العنوان بالتفصيل والمنطقة</label>
                  <input
                    type="text"
                    placeholder="الشارع، المنطقة، القرية أو المركز..."
                    value={newCustAddress}
                    onChange={(e) => setNewCustAddress(e.target.value)}
                    className="w-full p-2.5 rounded-xl border border-slate-200 text-xs focus:outline-none focus:border-primary"
                  />
                </div>
              </div>

              {/* Section 2: Guarantor Info */}
              <div className="p-4 rounded-2xl bg-slate-50 border border-slate-200 space-y-3">
                <div className="text-xs font-black text-slate-800 flex items-center gap-1.5">
                  <ShieldCheck className="w-4 h-4 text-emerald-600" />
                  بيانات الضامن (اختياري)
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-3 gap-2.5">
                  <div>
                    <input
                      type="text"
                      placeholder="اسم الضامن..."
                      value={newGuarantorName}
                      onChange={(e) => setNewGuarantorName(e.target.value)}
                      className="w-full p-2 rounded-lg border border-slate-200 text-xs bg-white focus:outline-none focus:border-primary"
                    />
                  </div>
                  <div>
                    <input
                      type="tel"
                      placeholder="هاتف الضامن..."
                      value={newGuarantorPhone}
                      onChange={(e) => setNewGuarantorPhone(e.target.value)}
                      className="w-full p-2 rounded-lg border border-slate-200 text-xs bg-white focus:outline-none focus:border-primary"
                    />
                  </div>
                  <div>
                    <input
                      type="text"
                      placeholder="صلة القرابة (أب، أخ، صديق)..."
                      value={newGuarantorRel}
                      onChange={(e) => setNewGuarantorRel(e.target.value)}
                      className="w-full p-2 rounded-lg border border-slate-200 text-xs bg-white focus:outline-none focus:border-primary"
                    />
                  </div>
                </div>
              </div>

              {/* Section 3: Optional Initial Installment Contract */}
              <div className="p-4 rounded-2xl bg-blue-50/60 border border-blue-200 space-y-3">
                <div className="flex items-center justify-between">
                  <label className="flex items-center gap-2 cursor-pointer">
                    <input
                      type="checkbox"
                      checked={includeContract}
                      onChange={(e) => setIncludeContract(e.target.checked)}
                      className="w-4 h-4 rounded text-primary focus:ring-primary"
                    />
                    <span className="text-xs font-black text-blue-950">إنشاء عقد تقسيط جهاز لهذا العميل فوراً</span>
                  </label>
                </div>

                {includeContract && (
                  <div className="space-y-3 pt-2">
                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                      <div>
                        <label className="block text-[11px] font-bold text-slate-700 mb-1">اسم الجهاز / الموديل *</label>
                        <input
                          type="text"
                          required={includeContract}
                          placeholder="مثال: OPPO A78 8-256 أو Samsung A15"
                          value={newDeviceName}
                          onChange={(e) => setNewDeviceName(e.target.value)}
                          className="w-full p-2 rounded-xl border border-slate-200 text-xs bg-white focus:outline-none focus:border-primary"
                        />
                      </div>

                      <div>
                        <label className="block text-[11px] font-bold text-slate-700 mb-1">رقم المسلسل IMEI (اختياري)</label>
                        <input
                          type="text"
                          placeholder="الرقم التسلسلي للجهاز..."
                          value={newImei}
                          onChange={(e) => setNewImei(e.target.value)}
                          className="w-full p-2 rounded-xl border border-slate-200 text-xs bg-white font-mono focus:outline-none focus:border-primary"
                        />
                      </div>
                    </div>

                    <div className="grid grid-cols-2 sm:grid-cols-4 gap-2.5">
                      <div>
                        <label className="block text-[11px] font-bold text-slate-700 mb-1">السعر كاش</label>
                        <input
                          type="number"
                          placeholder="0.00"
                          value={newCashPrice}
                          onChange={(e) => setNewCashPrice(e.target.value)}
                          className="w-full p-2 rounded-xl border border-slate-200 text-xs bg-white font-bold focus:outline-none focus:border-primary"
                        />
                      </div>

                      <div>
                        <label className="block text-[11px] font-bold text-slate-700 mb-1">إجمالي سعر القسط *</label>
                        <input
                          type="number"
                          required={includeContract}
                          placeholder="مثال: 8500"
                          value={newInstallmentPrice}
                          onChange={(e) => setNewInstallmentPrice(e.target.value)}
                          className="w-full p-2 rounded-xl border border-slate-200 text-xs bg-white font-black text-primary focus:outline-none focus:border-primary"
                        />
                      </div>

                      <div>
                        <label className="block text-[11px] font-bold text-slate-700 mb-1">المقدم المسدد</label>
                        <input
                          type="number"
                          placeholder="مثال: 2000"
                          value={newDownPayment}
                          onChange={(e) => setNewDownPayment(e.target.value)}
                          className="w-full p-2 rounded-xl border border-slate-200 text-xs bg-white font-bold text-emerald-700 focus:outline-none focus:border-primary"
                        />
                      </div>

                      <div>
                        <label className="block text-[11px] font-bold text-slate-700 mb-1">عدد الشهور / الأقساط</label>
                        <select
                          value={newMonthsCount}
                          onChange={(e) => setNewMonthsCount(e.target.value)}
                          className="w-full p-2 rounded-xl border border-slate-200 text-xs bg-white font-bold focus:outline-none focus:border-primary"
                        >
                          <option value="6">6 شهور</option>
                          <option value="10">10 شهور</option>
                          <option value="12">12 شهر (سنة)</option>
                          <option value="18">18 شهر</option>
                          <option value="24">24 شهر (سنتين)</option>
                        </select>
                      </div>
                    </div>
                  </div>
                )}
              </div>

              {/* Submit Button */}
              <div className="flex gap-2 pt-2 border-t border-slate-100">
                <button
                  type="button"
                  onClick={() => setIsAddModalOpen(false)}
                  className="flex-1 py-2.5 rounded-xl border border-slate-200 text-slate-600 font-bold text-xs hover:bg-slate-50 transition"
                >
                  إلغاء
                </button>
                <button
                  type="submit"
                  className="flex-1 py-2.5 rounded-xl bg-primary hover:bg-primary-dark text-white font-black text-xs shadow-md shadow-primary/25 transition active:scale-95 flex items-center justify-center gap-1.5"
                >
                  <CheckCircle2 className="w-4 h-4" />
                  حفظ العميل وفتح ملفه
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
