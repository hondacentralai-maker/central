import React from 'react';
import { X, Printer, Share2, CheckCircle2 } from 'lucide-react';

interface ReceiptModalProps {
  isOpen: boolean;
  onClose: () => void;
  receiptData: {
    receiptNumber: string;
    customerName: string;
    customerPhone?: string;
    contractNumber: string;
    deviceName: string;
    amount: number;
    remainingBalance: number;
    paymentMethod: string;
    date: string;
  } | null;
}

export const ReceiptModal: React.FC<ReceiptModalProps> = ({ isOpen, onClose, receiptData }) => {
  if (!isOpen || !receiptData) return null;

  const handlePrint = () => {
    window.print();
  };

  const handleWhatsApp = () => {
    const phone = receiptData.customerPhone ? receiptData.customerPhone.replace(/[^0-9]/g, '') : '';
    const formattedPhone = phone.startsWith('0') ? '2' + phone : (phone.startsWith('2') ? phone : '20' + phone);
    
    const message = `*إشعار سداد قسط - سنترال المركزي* 📱\n` +
      `----------------------------\n` +
      `إيصال رقم: ${receiptData.receiptNumber}\n` +
      `العميل: ${receiptData.customerName}\n` +
      `الجهاز: ${receiptData.deviceName}\n` +
      `المبلغ المسدد: ${receiptData.amount.toLocaleString('ar-EG')} ج.م\n` +
      `المتبقي بعد السداد: ${receiptData.remainingBalance.toLocaleString('ar-EG')} ج.م\n` +
      `التاريخ: ${receiptData.date}\n` +
      `----------------------------\n` +
      `شكراً لتعاملكم معنا ✨`;

    const url = `https://api.whatsapp.com/send?phone=${formattedPhone}&text=${encodeURIComponent(message)}`;
    window.open(url, '_blank');
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/60 backdrop-blur-sm p-4">
      <div className="bg-white rounded-2xl max-w-sm w-full shadow-2xl overflow-hidden animate-in fade-in zoom-in-95 duration-150">
        {/* Header */}
        <div className="p-4 border-b border-slate-100 flex items-center justify-between bg-slate-50">
          <div className="flex items-center gap-2">
            <CheckCircle2 className="w-5 h-5 text-emerald-600" />
            <span className="font-bold text-slate-800 text-sm">تم تسجيل التحصيل بنجاح</span>
          </div>
          <button onClick={onClose} className="p-1 text-slate-400 hover:text-slate-600 rounded-lg">
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* 80mm Printable Receipt Preview */}
        <div id="printable-receipt" className="p-5 font-mono text-center text-slate-800 space-y-3 bg-white">
          <div className="border-b border-dashed border-slate-300 pb-3">
            <h3 className="font-bold text-base font-sans">سنترال المركزي</h3>
            <p className="text-xs text-slate-500 font-sans">للهواتف الذكية والمبيعات والخدمات</p>
            <p className="text-[11px] text-slate-400 mt-1">إيصال سداد قسط رسمي</p>
          </div>

          <div className="text-xs space-y-1.5 text-right font-sans">
            <div className="flex justify-between">
              <span className="text-slate-500">رقم الإيصال:</span>
              <span className="font-bold">{receiptData.receiptNumber}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-slate-500">التاريخ:</span>
              <span>{receiptData.date}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-slate-500">العميل:</span>
              <span className="font-semibold">{receiptData.customerName}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-slate-500">الجهاز:</span>
              <span>{receiptData.deviceName}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-slate-500">طريقة الدفع:</span>
              <span>{receiptData.paymentMethod === 'cash' ? 'نقداً بالدرج' : receiptData.paymentMethod}</span>
            </div>
          </div>

          <div className="border-y border-dashed border-slate-300 py-3 my-2 text-center bg-slate-50 rounded-lg">
            <div className="text-xs text-slate-500 font-sans">المبلغ المدفوع</div>
            <div className="text-2xl font-black text-slate-900 font-sans">
              {receiptData.amount.toLocaleString('ar-EG')} <span className="text-sm font-bold">ج.م</span>
            </div>
          </div>

          <div className="flex justify-between text-xs font-sans px-1">
            <span className="text-slate-500">المتبقي على العقد:</span>
            <span className="font-bold text-primary">{receiptData.remainingBalance.toLocaleString('ar-EG')} ج.م</span>
          </div>

          <div className="border-t border-dashed border-slate-300 pt-3 text-[11px] text-slate-400 font-sans">
            شكراً لالتزامكم بالسداد في الموعد المحدد ✨
          </div>
        </div>

        {/* Actions (Not printed) */}
        <div className="p-4 border-t border-slate-100 bg-slate-50 flex gap-2">
          <button
            onClick={handlePrint}
            className="flex-1 py-2.5 px-3 rounded-xl bg-slate-900 hover:bg-slate-800 text-white font-bold text-xs flex items-center justify-center gap-2 transition"
          >
            <Printer className="w-4 h-4" />
            طباعة إيصال 80mm
          </button>

          <button
            onClick={handleWhatsApp}
            className="flex-1 py-2.5 px-3 rounded-xl bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs flex items-center justify-center gap-2 transition"
          >
            <Share2 className="w-4 h-4" />
            إرسال WhatsApp
          </button>
        </div>
      </div>
    </div>
  );
};
