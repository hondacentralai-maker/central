import React, { useState } from 'react';
import { FileText, Calculator, CheckCircle2, AlertTriangle, Printer, Lock } from 'lucide-react';

export const DailyClosingPage: React.FC = () => {
  const [openingBalance, setOpeningBalance] = useState<number>(10000);
  const [totalCollections, setTotalCollections] = useState<number>(14500);
  const [totalCashSales, setTotalCashSales] = useState<number>(8200);
  const [totalWalletNet, setTotalWalletNet] = useState<number>(3150);
  const [totalExpenses, setTotalExpenses] = useState<number>(430);
  const [actualCash, setActualCash] = useState<string>('35420');
  const [closingNotes, setClosingNotes] = useState<string>('');
  const [isSubmitted, setIsSubmitted] = useState<boolean>(false);

  // Financial calculation: Expected = Opening + Cash In - Cash Out
  const totalCashIn = totalCollections + totalCashSales + totalWalletNet;
  const totalCashOut = totalExpenses;
  const expectedBalance = openingBalance + totalCashIn - totalCashOut;
  const actualNum = parseFloat(actualCash) || 0;
  const difference = actualNum - expectedBalance;

  const handleCloseDay = (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitted(true);
  };

  return (
    <div className="space-y-5">
      {/* Header */}
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3">
        <div>
          <h2 className="text-xl font-bold text-slate-900 flex items-center gap-2">
            <FileText className="w-6 h-6 text-primary" />
            التقفيل اليومي للدرج والخزينة
          </h2>
          <p className="text-xs text-slate-500">مطابقة النقدية الفعلية مع الحسابات الآلية وكشف أي عجز أو زيادة</p>
        </div>

        <div className="text-xs font-semibold px-3 py-1.5 rounded-xl bg-blue-50 text-primary border border-blue-200">
          تاريخ اليومية: {new Date().toLocaleDateString('ar-EG', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' })}
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-5">
        {/* Closing Form */}
        <div className="lg:col-span-2 bg-white p-5 rounded-2xl border border-slate-200 shadow-sm space-y-5">
          <div className="border-b border-slate-100 pb-3">
            <h3 className="font-bold text-slate-900 text-sm">بيانات حركة نقدية اليوم</h3>
            <p className="text-xs text-slate-400">تجميع العمليات المالية المسجلة خلال اليوم</p>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3.5 text-xs">
            {/* Opening Balance */}
            <div className="p-3.5 rounded-xl bg-slate-50 border border-slate-200 space-y-1">
              <span className="text-slate-500">رصيد افتتاحي للدرج (الصباحي):</span>
              <div className="text-lg font-black text-slate-900">
                {openingBalance.toLocaleString('ar-EG')} ج.م
              </div>
            </div>

            {/* Total Collections */}
            <div className="p-3.5 rounded-xl bg-emerald-50 border border-emerald-200 space-y-1">
              <span className="text-emerald-700 font-semibold">+ تحصيلات الأقساط النقدية:</span>
              <div className="text-lg font-black text-emerald-800">
                {totalCollections.toLocaleString('ar-EG')} ج.م
              </div>
            </div>

            {/* Cash Sales */}
            <div className="p-3.5 rounded-xl bg-emerald-50 border border-emerald-200 space-y-1">
              <span className="text-emerald-700 font-semibold">+ المبيعات النقدية المباشرة:</span>
              <div className="text-lg font-black text-emerald-800">
                {totalCashSales.toLocaleString('ar-EG')} ج.م
              </div>
            </div>

            {/* Cash Wallets Net */}
            <div className="p-3.5 rounded-xl bg-purple-50 border border-purple-200 space-y-1">
              <span className="text-purple-700 font-semibold">+ صافي إيداعات وسحب المحافظ:</span>
              <div className="text-lg font-black text-purple-800">
                {totalWalletNet.toLocaleString('ar-EG')} ج.م
              </div>
            </div>

            {/* Expenses */}
            <div className="p-3.5 rounded-xl bg-rose-50 border border-rose-200 space-y-1 sm:col-span-2">
              <span className="text-rose-700 font-semibold">- المصروفات والمنصرفات النقدية:</span>
              <div className="text-lg font-black text-rose-800">
                {totalExpenses.toLocaleString('ar-EG')} ج.م
              </div>
            </div>
          </div>

          {/* Actual Cash Input */}
          <form onSubmit={handleCloseDay} className="pt-2 border-t border-slate-100 space-y-4">
            <div>
              <label className="block text-xs font-bold text-slate-800 mb-1.5">
                الكاش الفعلي في الدرج عند الجرد (ج.م) *
              </label>
              <div className="relative">
                <input
                  type="number"
                  step="0.01"
                  required
                  placeholder="0.00"
                  value={actualCash}
                  onChange={(e) => setActualCash(e.target.value)}
                  className="w-full pl-12 pr-3 py-3 rounded-xl border border-slate-300 text-xl font-black text-slate-900 focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary"
                />
                <span className="absolute left-3 top-1/2 -translate-y-1/2 text-xs font-bold text-slate-400">ج.م</span>
              </div>
            </div>

            <div>
              <label className="block text-xs font-semibold text-slate-700 mb-1">
                ملاحظات التقفيل (اختياري)
              </label>
              <input
                type="text"
                placeholder="أي ملاحظات حول الجرد أو فوارق النقدية..."
                value={closingNotes}
                onChange={(e) => setClosingNotes(e.target.value)}
                className="w-full p-2.5 rounded-xl border border-slate-200 text-xs focus:outline-none focus:border-primary"
              />
            </div>

            <button
              type="submit"
              className="w-full py-3 rounded-xl bg-slate-900 hover:bg-slate-800 text-white font-bold text-sm shadow-md transition flex items-center justify-center gap-2"
            >
              <Lock className="w-4 h-4" />
              اعتماد وإغلاق اليومية
            </button>
          </form>
        </div>

        {/* Reconciliation Summary Card */}
        <div className="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm space-y-4 flex flex-col justify-between">
          <div className="space-y-4">
            <div className="border-b border-slate-100 pb-3">
              <h3 className="font-bold text-slate-900 text-sm">نتيجة المطابقة</h3>
              <p className="text-xs text-slate-400">مقارنة الرصيد الدفتري بالرصيد الفعلي</p>
            </div>

            <div className="space-y-3 text-xs">
              <div className="flex justify-between p-2.5 rounded-xl bg-slate-50">
                <span className="text-slate-500">الرصيد الدفتري المتوقع:</span>
                <span className="font-bold text-slate-900">{expectedBalance.toLocaleString('ar-EG')} ج.م</span>
              </div>

              <div className="flex justify-between p-2.5 rounded-xl bg-slate-50">
                <span className="text-slate-500">النقدية الفعلية بالدرج:</span>
                <span className="font-bold text-slate-900">{actualNum.toLocaleString('ar-EG')} ج.م</span>
              </div>

              {/* Status Box */}
              <div className={`p-4 rounded-xl border text-center space-y-1.5 ${
                Math.abs(difference) < 1
                  ? 'bg-emerald-50 border-emerald-200 text-emerald-900'
                  : difference > 0
                  ? 'bg-blue-50 border-blue-200 text-blue-900'
                  : 'bg-rose-50 border-rose-200 text-rose-900'
              }`}>
                <div className="text-xs font-bold">
                  {Math.abs(difference) < 1
                    ? 'الدرج متطابق تماماً (لا يوجد عجز أو زيادة)'
                    : difference > 0
                    ? 'يوجد زيادة في الدرج'
                    : 'يوجد عجز في نقدية الدرج'}
                </div>
                <div className="text-2xl font-black">
                  {difference > 0 ? '+' : ''}{difference.toLocaleString('ar-EG')} ج.م
                </div>
              </div>
            </div>
          </div>

          {isSubmitted && (
            <div className="p-3 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-800 text-xs text-center space-y-2">
              <CheckCircle2 className="w-5 h-5 text-emerald-600 mx-auto" />
              <div className="font-bold">تم حفظ واعتماد تقفيل اليوم بنجاح</div>
              <button
                onClick={() => window.print()}
                className="w-full py-2 rounded-lg bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs flex items-center justify-center gap-1.5"
              >
                <Printer className="w-3.5 h-3.5" />
                طباعة تقرير التقفيل
              </button>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};
