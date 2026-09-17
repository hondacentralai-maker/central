import React from 'react';
import { Printer, MessageCircle, FileSpreadsheet, X, CheckCircle2, AlertCircle, Clock, ShieldCheck } from 'lucide-react';
import * as XLSX from 'xlsx';

interface StatementModalProps {
  isOpen: boolean;
  onClose: () => void;
  customer: any;
  contract?: any; // optional, if null shows all contracts for this customer
}

export const StatementModal: React.FC<StatementModalProps> = ({
  isOpen,
  onClose,
  customer,
  contract
}) => {
  if (!isOpen || !customer) return null;

  const targetContracts = contract ? [contract] : (customer.contracts || []);

  let totalContractVal = 0;
  let totalPaid = 0;
  let totalRemaining = 0;

  targetContracts.forEach((ctr: any) => {
    totalContractVal += Number(ctr.installment_price || 0);
    totalRemaining += Number(ctr.remaining_balance || 0);
    totalPaid += (Number(ctr.installment_price || 0) - Number(ctr.remaining_balance || 0));
  });

  const statementNo = `STMT-${new Date().getFullYear()}-${Math.floor(1000 + Math.random() * 9000)}`;
  const dateFormatted = new Date().toLocaleDateString('ar-EG', {
    weekday: 'long',
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  });

  // Print / Save as PDF
  const handlePrint = () => {
    window.print();
  };

  // Send statement via WhatsApp
  const handleSendWhatsApp = () => {
    let cleanPhone = customer.phone ? customer.phone.replace(/\D/g, '') : '';
    if (cleanPhone.startsWith('0')) {
      cleanPhone = '2' + cleanPhone;
    } else if (!cleanPhone.startsWith('20') && cleanPhone.length === 10) {
      cleanPhone = '20' + cleanPhone;
    }

    let msg = `*كشف حساب معتمد - سنترال*\n`;
    msg += `----------------------------\n`;
    msg += `العميل: ${customer.name}\n`;
    msg += `التاريخ: ${new Date().toISOString().slice(0, 10)}\n\n`;

    targetContracts.forEach((ctr: any, idx: number) => {
      msg += `*العقد #${idx + 1}: ${ctr.device_name}*\n`;
      msg += `• إجمالي التقسيط: ${Number(ctr.installment_price).toLocaleString('en-US')} ج.م\n`;
      msg += `• المدفوع: ${(Number(ctr.installment_price) - Number(ctr.remaining_balance)).toLocaleString('en-US')} ج.م\n`;
      msg += `• المتبقي: ${Number(ctr.remaining_balance).toLocaleString('en-US')} ج.م\n`;
      
      const pendingInst = (ctr.installments || []).filter((i: any) => i.status !== 'paid');
      if (pendingInst.length > 0) {
        msg += `*الأقساط المتبقية:*\n`;
        pendingInst.slice(0, 3).forEach((pi: any, pIdx: number) => {
          msg += `  - قسط ${pIdx + 1}: ${Number(pi.due_amount).toLocaleString('en-US')} ج.م (تاريخ: ${pi.due_date})\n`;
        });
      }
      msg += `\n`;
    });

    msg += `*إجمالي المديونية المتبقية: ${totalRemaining.toLocaleString('en-US')} ج.م*\n`;
    msg += `نشكركم لحسن تعاملكم، ويسعدنا دائماً خدمتكم.`;

    const encoded = encodeURIComponent(msg);
    const url = cleanPhone ? `https://wa.me/${cleanPhone}?text=${encoded}` : `https://wa.me/?text=${encoded}`;
    window.open(url, '_blank');
  };

  // Export this statement to Excel
  const handleExportExcel = () => {
    const wb = XLSX.utils.book_new();
    const rows: any[] = [];

    targetContracts.forEach((ctr: any) => {
      (ctr.installments || []).forEach((inst: any, instIdx: number) => {
        const isPaid = inst.status === 'paid' || (inst.paid_amount >= inst.due_amount && inst.due_amount > 0);
        rows.push({
          'العميل': customer.name,
          'الهاتف': customer.phone,
          'الجهاز': ctr.device_name,
          'رقم القسط': inst.item_type === 'down_payment' ? 'الدفعة المقدمة' : `قسط شهر ${instIdx}`,
          'تاريخ الاستحقاق': inst.due_date || '-',
          'المبلغ المطلوب': inst.due_amount,
          'المدفوع': inst.paid_amount || 0,
          'المتبقي': inst.remaining_amount !== undefined ? inst.remaining_amount : (inst.due_amount - (inst.paid_amount || 0)),
          'الحالة': isPaid ? 'مسدد' : (inst.status === 'postponed' ? 'مؤجل' : 'مستحق'),
          'تاريخ السداد الفعلي': inst.paid_date || '-'
        });
      });
    });

    const ws = XLSX.utils.json_to_sheet(rows);
    XLSX.utils.book_append_sheet(wb, ws, 'كشف_الحساب');
    XLSX.writeFile(wb, `كشف_حساب_${customer.name.replace(/\s+/g, '_')}.xlsx`);
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/80 backdrop-blur-sm p-4 overflow-y-auto">
      <div className="bg-white rounded-3xl shadow-2xl max-w-4xl w-full border border-slate-200 overflow-hidden text-slate-900 my-8">
        {/* Header - Screen only toolbar */}
        <div className="p-4 bg-slate-900 text-white flex flex-wrap items-center justify-between gap-3 print:hidden">
          <div className="flex items-center gap-2">
            <span className="px-2.5 py-1 rounded-lg bg-cyan-500/20 text-cyan-400 text-xs font-bold font-mono">
              {statementNo}
            </span>
            <h3 className="font-bold text-sm">كشف حساب العميل والطباعة PDF</h3>
          </div>

          <div className="flex items-center gap-2 flex-wrap">
            <button
              onClick={handlePrint}
              className="px-3.5 py-1.5 rounded-xl bg-cyan-500 hover:bg-cyan-400 text-slate-950 font-black text-xs flex items-center gap-1.5 shadow transition active:scale-95"
            >
              <Printer className="w-4 h-4" />
              طباعة / حفظ كـ PDF
            </button>

            <button
              onClick={handleSendWhatsApp}
              className="px-3.5 py-1.5 rounded-xl bg-emerald-600 hover:bg-emerald-500 text-white font-black text-xs flex items-center gap-1.5 shadow transition active:scale-95"
            >
              <MessageCircle className="w-4 h-4" />
              إرسال عبر الواتساب
            </button>

            <button
              onClick={handleExportExcel}
              className="px-3 py-1.5 rounded-xl bg-slate-800 hover:bg-slate-700 text-slate-200 font-bold text-xs flex items-center gap-1.5 border border-slate-700 transition"
            >
              <FileSpreadsheet className="w-4 h-4 text-emerald-400" />
              إكسل Excel
            </button>

            <button
              onClick={onClose}
              className="p-1.5 rounded-lg text-slate-400 hover:text-white hover:bg-slate-800 transition"
            >
              <X className="w-5 h-5" />
            </button>
          </div>
        </div>

        {/* Printable Official Statement */}
        <div className="p-6 md:p-10 space-y-6 text-right print:p-0">
          {/* Header */}
          <div className="border-b-2 border-slate-900 pb-5 flex items-start justify-between">
            <div>
              <h1 className="text-2xl font-black text-slate-950">سنترال للاتصالات والتقسيط</h1>
              <p className="text-xs text-slate-500 mt-0.5">الفرع الرئيسي • إدارة المبيعات والائتمان</p>
              <p className="text-xs text-slate-500">هاتف الإدارة: 01000000000</p>
            </div>
            <div className="text-left">
              <span className="px-3 py-1 rounded-full bg-slate-100 text-slate-800 font-black text-xs block mb-1">
                كشف حساب معتمد
              </span>
              <span className="text-xs text-slate-500 block">رقم الكشف: {statementNo}</span>
              <span className="text-xs text-slate-500 block">تاريخ الإصدار: {dateFormatted}</span>
            </div>
          </div>

          {/* Customer & Guarantor Details Box */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 p-4 rounded-2xl bg-slate-50 border border-slate-200 text-xs">
            <div className="space-y-1.5">
              <span className="font-bold text-slate-900 text-sm block">بيانات العميل:</span>
              <p><span className="text-slate-500">الاسم:</span> <strong>{customer.name}</strong></p>
              <p><span className="text-slate-500">الهاتف الأساسي:</span> <strong className="font-mono">{customer.phone || '-'}</strong></p>
              {customer.national_id && <p><span className="text-slate-500">الرقم القومي:</span> <strong className="font-mono">{customer.national_id}</strong></p>}
              {customer.address && <p><span className="text-slate-500">العنوان:</span> <strong>{customer.address}</strong></p>}
            </div>

            <div className="space-y-1.5 border-t md:border-t-0 md:border-r border-slate-200 md:pr-4">
              <span className="font-bold text-slate-900 text-sm block">الضامن والحالة الائتمانية:</span>
              <p><span className="text-slate-500">الضامن:</span> <strong>{customer.guarantor?.name || 'لا يوجد ضامن مسجل'}</strong></p>
              {customer.guarantor?.phone && <p><span className="text-slate-500">هاتف الضامن:</span> <strong className="font-mono">{customer.guarantor.phone}</strong></p>}
              {customer.guarantor?.relationship && <p><span className="text-slate-500">صلة القرابة:</span> <strong>{customer.guarantor.relationship}</strong></p>}
              <p>
                <span className="text-slate-500">الحالة:</span>{' '}
                <span className={`px-2 py-0.5 rounded-full font-bold text-[10px] ${
                  customer.credit_status === 'defaulted' ? 'bg-red-100 text-red-700' : 'bg-emerald-100 text-emerald-700'
                }`}>
                  {customer.credit_status === 'defaulted' ? 'متعثر ائتمانياً' : 'نشط وملتزم'}
                </span>
              </p>
            </div>
          </div>

          {/* Financial Summary Cards */}
          <div className="grid grid-cols-3 gap-3 text-center">
            <div className="p-3.5 rounded-xl bg-slate-100 border border-slate-200">
              <span className="text-[11px] text-slate-500 block font-bold">إجمالي التقسيط</span>
              <span className="text-lg font-black text-slate-900 font-mono">{totalContractVal.toLocaleString('en-US')} ج.م</span>
            </div>
            <div className="p-3.5 rounded-xl bg-emerald-50 border border-emerald-200">
              <span className="text-[11px] text-emerald-700 block font-bold">المسدد فعلياً</span>
              <span className="text-lg font-black text-emerald-700 font-mono">{totalPaid.toLocaleString('en-US')} ج.م</span>
            </div>
            <div className="p-3.5 rounded-xl bg-amber-50 border border-amber-200">
              <span className="text-[11px] text-amber-700 block font-bold">المتبقي في الذمة</span>
              <span className="text-lg font-black text-amber-700 font-mono">{totalRemaining.toLocaleString('en-US')} ج.م</span>
            </div>
          </div>

          {/* Contracts and Installments Tables */}
          {targetContracts.map((ctr: any, ctrIdx: number) => (
            <div key={ctrIdx} className="space-y-3">
              <div className="flex items-center justify-between bg-slate-100 border border-slate-200 text-slate-900 px-4 py-2.5 rounded-xl text-xs">
                <span className="font-bold">
                  عقد #{ctrIdx + 1}: {ctr.device_name} {ctr.imei ? `(IMEI: ${ctr.imei})` : ''}
                </span>
                <span className="text-primary font-mono font-black">
                  المتبقي: {Number(ctr.remaining_balance).toLocaleString('en-US')} ج.م
                </span>
              </div>

              <div className="border border-slate-200 rounded-xl overflow-hidden">
                <table className="w-full text-right text-xs">
                  <thead className="bg-slate-50 border-b border-slate-200 font-bold text-slate-700">
                    <tr>
                      <th className="p-2.5">الدفعة / القسط</th>
                      <th className="p-2.5">تاريخ الاستحقاق</th>
                      <th className="p-2.5">المطلوب</th>
                      <th className="p-2.5">المسدد</th>
                      <th className="p-2.5">المتبقي</th>
                      <th className="p-2.5">الحالة</th>
                      <th className="p-2.5">تاريخ السداد</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-100 font-mono">
                    {(ctr.installments || []).map((inst: any, iIdx: number) => {
                      const isPaid = inst.status === 'paid' || (inst.paid_amount >= inst.due_amount && inst.due_amount > 0);
                      return (
                        <tr key={iIdx} className={isPaid ? 'bg-emerald-50/30' : ''}>
                          <td className="p-2.5 font-bold font-sans">
                            {inst.item_type === 'down_payment' ? 'المقدم' : `قسط #${iIdx}`}
                          </td>
                          <td className="p-2.5 text-slate-600">{inst.due_date || '-'}</td>
                          <td className="p-2.5 font-bold text-slate-900">{Number(inst.due_amount || 0).toLocaleString('en-US')} ج.م</td>
                          <td className="p-2.5 text-emerald-700 font-semibold">{Number(inst.paid_amount || 0).toLocaleString('en-US')} ج.م</td>
                          <td className="p-2.5 font-bold text-primary">{Number(inst.remaining_amount !== undefined ? inst.remaining_amount : (inst.due_amount - (inst.paid_amount || 0))).toLocaleString('en-US')} ج.م</td>
                          <td className="p-2.5 font-sans">
                            {isPaid ? (
                              <span className="text-emerald-700 font-bold">مسدد ✅</span>
                            ) : inst.status === 'postponed' ? (
                              <span className="text-purple-700 font-bold">مؤجل لـ {inst.due_date}</span>
                            ) : inst.paid_amount > 0 ? (
                              <span className="text-blue-700 font-bold">سداد جزئي</span>
                            ) : (
                              <span className="text-rose-600 font-bold">متأخر ⏳</span>
                            )}
                          </td>
                          <td className="p-2.5 text-slate-500 font-mono">{inst.paid_date || '-'}</td>
                        </tr>
                      );
                    })}
                  </tbody>
                </table>
              </div>
            </div>
          ))}

          {/* Statement Footer */}
          <div className="pt-6 border-t-2 border-slate-900 flex items-center justify-between text-xs text-slate-600">
            <div>
              <p>ختم واعتماد إدارة السنترال:</p>
              <div className="mt-2 w-28 h-12 border-2 border-dashed border-slate-300 rounded-lg flex items-center justify-center text-slate-400 text-[10px]">
                (خاتم الحسابات)
              </div>
            </div>
            <div className="text-left space-y-1">
              <p className="font-bold text-slate-800">توقيع المحاسب / أمين الخزينة:</p>
              <div className="h-8 border-b border-dashed border-slate-400 w-36"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
