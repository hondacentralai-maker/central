import React from 'react';
import { Printer, X, ShieldCheck, FileText, CheckCircle2 } from 'lucide-react';

interface PromissoryNoteModalProps {
  isOpen: boolean;
  onClose: () => void;
  customer: any;
  contract: any;
}

// Helper to convert number to written Arabic currency words
const numberToArabicWords = (num: number): string => {
  if (!num || num <= 0) return 'صفر جنيه مصري';
  // Simplified Arabic currency translation for typical installment amounts
  const thousands = Math.floor(num / 1000);
  const remainder = num % 1000;
  
  let text = '';
  if (thousands > 0) {
    if (thousands === 1) text += 'ألف';
    else if (thousands === 2) text += 'ألفان';
    else if (thousands >= 3 && thousands <= 10) text += `${thousands} آلاف`;
    else text += `${thousands} ألف`;
  }
  if (remainder > 0) {
    if (text) text += ' و ';
    text += `${remainder}`;
  }
  return `فقط وقدره ${num.toLocaleString('ar-EG')} جنيه مصري لا غير (${text ? text + ' جنيه' : ''})`;
};

export const PromissoryNoteModal: React.FC<PromissoryNoteModalProps> = ({
  isOpen,
  onClose,
  customer,
  contract
}) => {
  if (!isOpen || !customer || !contract) return null;

  const totalAmount = contract.installment_price || 0;
  const serialNo = `BND-${new Date().getFullYear()}-${Math.floor(1000 + Math.random() * 9000)}`;
  const issueDate = new Date().toLocaleDateString('ar-EG', { day: 'numeric', month: 'long', year: 'numeric' });

  const handlePrint = () => {
    window.print();
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/80 backdrop-blur-sm p-4 overflow-y-auto">
      <div className="bg-white rounded-3xl shadow-2xl max-w-3xl w-full border border-slate-200 overflow-hidden text-slate-900 my-8">
        {/* Header - Screen only */}
        <div className="p-4 bg-slate-900 text-white flex items-center justify-between print:hidden">
          <div className="flex items-center gap-2">
            <FileText className="w-5 h-5 text-cyan-400" />
            <h3 className="font-bold text-sm">معاينة وطباعة السند لأمر / الكمبيالة القانونية</h3>
          </div>
          <div className="flex items-center gap-2">
            <button
              onClick={handlePrint}
              className="px-4 py-1.5 rounded-xl bg-cyan-500 hover:bg-cyan-400 text-slate-950 font-black text-xs flex items-center gap-1.5 shadow transition active:scale-95"
            >
              <Printer className="w-4 h-4" />
              طباعة السند (A4)
            </button>
            <button
              onClick={onClose}
              className="p-1.5 rounded-lg text-slate-400 hover:text-white hover:bg-slate-800 transition"
            >
              <X className="w-5 h-5" />
            </button>
          </div>
        </div>

        {/* Printable Promissory Note Document */}
        <div className="p-8 md:p-12 space-y-6 text-right font-serif leading-relaxed print:p-0">
          {/* Top Document Header */}
          <div className="border-b-2 border-slate-900 pb-4 flex items-center justify-between">
            <div>
              <span className="text-xs font-mono font-bold text-slate-500 block">رقم السند: {serialNo}</span>
              <span className="text-xs text-slate-500 block">تاريخ التحرير: {issueDate}</span>
            </div>
            <div className="text-center">
              <h2 className="text-2xl font-black text-slate-950 underline decoration-double underline-offset-8">
                ســنـد لأمـــــر
              </h2>
              <span className="text-xs text-slate-600 font-sans font-bold mt-1 block">
                محرر وفقاً لأحكام قانون التجارة المصري
              </span>
            </div>
            <div className="w-24 text-left">
              <span className="px-2.5 py-1 rounded-md bg-slate-100 border border-slate-300 font-mono font-bold text-xs">
                {totalAmount.toLocaleString('ar-EG')} ج.م
              </span>
            </div>
          </div>

          {/* Legal Text Body */}
          <div className="space-y-4 text-sm md:text-base text-slate-800">
            <p className="font-bold">
              المبلغ الإجمالي المستحق: <span className="font-black text-slate-950 text-base underline">{numberToArabicWords(totalAmount)}</span>
            </p>

            <p>
              أتعهد أنا الموقع أدناه:{' '}
              <strong className="text-slate-950 text-base">{customer.name}</strong>،{' '}
              المقيم في:{' '}
              <strong className="text-slate-950">{customer.address || 'العنوان المسجل بالبطاقة'}</strong>،{' '}
              وحامل بطاقة رقم قومي رقم:{' '}
              <strong className="text-slate-950 font-mono tracking-wider">{customer.national_id || '________________'}</strong>،{' '}
              ورقم هاتف:{' '}
              <strong className="text-slate-950 font-mono">{customer.phone || '________________'}</strong>.
            </p>

            <p className="p-4 rounded-xl bg-slate-50 border border-slate-200 text-xs md:text-sm text-slate-700">
              بأن أدفع بموجب هذا السند لأمر إذن / <strong>إدارة السنترال (الطرف الدائن)</strong>، أو لأي حامل شرعي لهذا السند،
              المبلغ المذكور أعلاه كاملاً وقدره <strong>{totalAmount.toLocaleString('ar-EG')} ج.م</strong>،
              وذلك كقيمة ثمن تقسيط جهاز <strong>({contract.device_name || 'سلعة تقسيط'})</strong>،
              وأن هذا الدين دين ثابت في ذمتي خالص من أي نزاع أو شرط، ومستحق السداد وفقاً لجدول الأقساط الشهرية المتفق عليها.
            </p>

            {/* Installment terms note */}
            <div className="text-xs text-slate-600 space-y-1">
              <p>• في حالة التأخر عن سداد أي قسط في موعده المحدد يعتبر السند لأمر بأكمله واجب الأداء فوراً دون حاجة إلى تنبيه أو إعذار رسمي.</p>
              <p>• يسقط حقي في التمسك بأي مدة تأجيل غير معتمدة وموثقة بإيصال رسمي صادر من السنترال.</p>
            </div>

            {/* Guarantor Section */}
            {customer.guarantor?.name && (
              <div className="p-3 rounded-lg border border-dashed border-slate-300 bg-slate-50/50 text-xs text-slate-700">
                <strong>كفالة وتضامن الضامن:</strong> أقر أنا الضامن المتضامن:{' '}
                <strong>{customer.guarantor.name}</strong> (صلة القرابة: {customer.guarantor.relationship || 'ضامن'})، هاتف: {customer.guarantor.phone || '________'}،
                بكفالة المدين كفالة تضامنية مطلقة ومسؤوليتي التامة عن سداد كافة مبالغ هذا السند عند أول مطالبة.
              </div>
            )}
          </div>

          {/* Signatures and Fingerprints */}
          <div className="pt-6 border-t-2 border-slate-900 grid grid-cols-3 gap-6 text-center text-xs">
            <div className="space-y-8">
              <span className="font-bold block text-slate-700">توقيع المدين (المشتري)</span>
              <div className="h-12 border-b border-dashed border-slate-400"></div>
              <span className="text-[11px] text-slate-500 font-sans">{customer.name}</span>
            </div>

            <div className="space-y-4">
              <span className="font-bold block text-slate-700">بصمة إبهام المدين</span>
              <div className="w-20 h-20 border-2 border-dashed border-slate-300 rounded-xl mx-auto flex items-center justify-center text-slate-400 text-[10px]">
                (مكان البصمة)
              </div>
            </div>

            <div className="space-y-8">
              <span className="font-bold block text-slate-700">توقيع وبصمة الضامن</span>
              <div className="h-12 border-b border-dashed border-slate-400"></div>
              <span className="text-[11px] text-slate-500 font-sans">{customer.guarantor?.name || 'الضامن'}</span>
            </div>
          </div>

          {/* Footer Watermark */}
          <div className="pt-4 text-center text-[10px] text-slate-400 font-sans flex items-center justify-center gap-1">
            <ShieldCheck className="w-3.5 h-3.5 text-emerald-600" />
            وثيقة رسمية صادرة من نظام سنترال المركزي لإدارة المبيعات والائتمان
          </div>
        </div>
      </div>
    </div>
  );
};
