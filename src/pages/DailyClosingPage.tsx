import React, { useState, useEffect } from 'react';
import { 
  FileText, 
  Calculator, 
  CheckCircle2, 
  AlertTriangle, 
  Printer, 
  Lock,
  RefreshCw,
  AlertCircle,
  Loader2
} from 'lucide-react';
import { api } from '../services/api';
import { Treasury, DailyClosing } from '../types';

const closingStatusLabel: Record<DailyClosing['status'], string> = {
  balanced: 'متطابق',
  shortage: 'عجز',
  surplus: 'زيادة',
};

export const DailyClosingPage: React.FC = () => {
  const [treasury, setTreasury] = useState<Treasury | null>(null);
  const [openingBalance, setOpeningBalance] = useState<number>(0);
  const [totalCollections, setTotalCollections] = useState<number>(0);
  const [totalCashSales, setTotalCashSales] = useState<number>(0);
  const [totalWalletNet, setTotalWalletNet] = useState<number>(0);
  const [totalExpenses, setTotalExpenses] = useState<number>(0);
  const [actualCash, setActualCash] = useState<string>('');
  const [closingNotes, setClosingNotes] = useState<string>('');
  const [isSubmitting, setIsSubmitting] = useState<boolean>(false);
  const [isSubmitted, setIsSubmitted] = useState<boolean>(false);
  const [submittedClosing, setSubmittedClosing] = useState<any | null>(null);
  const [pastClosings, setPastClosings] = useState<DailyClosing[]>([]);
  const [isLoading, setIsLoading] = useState<boolean>(true);
  const [errorMsg, setErrorMsg] = useState<string>('');

  useEffect(() => {
    loadClosingMetrics();
  }, []);

  const loadClosingMetrics = async () => {
    setIsLoading(true);
    setErrorMsg('');
    try {
      const todayStr = new Date().toISOString().slice(0, 10);
      const [tList, metrics, closingsList] = await Promise.all([
        api.getTreasuries(),
        api.getDailyClosingMetrics(todayStr),
        api.getDailyClosings(),
      ]);

      const drawer = tList.find(t => t.treasury_type === 'drawer') || tList[0];
      if (drawer) {
        setTreasury(drawer);
        setOpeningBalance(Number(drawer.opening_balance || 0));
        // Default actual cash to current drawer balance for convenience
        setActualCash(String(drawer.current_balance || 0));
      } else {
        setTreasury(null);
        setOpeningBalance(0);
        setActualCash('0');
      }

      setTotalCollections(metrics.totalCollections);
      setTotalCashSales(metrics.totalCashSales);
      setTotalWalletNet(metrics.totalWalletNet);
      setTotalExpenses(metrics.totalExpenses);

      setPastClosings(closingsList);
    } catch (err: any) {
      setErrorMsg(err.message || 'تعذر تحميل مؤشرات التقفيل من الخادم.');
    } finally {
      setIsLoading(false);
    }
  };

  // Financial calculation: Expected = Opening + Cash In - Cash Out
  const totalCashIn = totalCollections + totalCashSales + Math.max(totalWalletNet, 0);
  const totalCashOut = totalExpenses + Math.abs(Math.min(totalWalletNet, 0));
  const expectedBalance = openingBalance + totalCashIn - totalCashOut;
  const actualNum = parseFloat(actualCash) || 0;
  const difference = actualNum - expectedBalance;

  const handleCloseDay = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!treasury) {
      setErrorMsg('لا توجد خزينة أو درج محدد.');
      return;
    }

    setIsSubmitting(true);
    setErrorMsg('');

    try {
      const todayStr = new Date().toISOString().slice(0, 10);
      const res = await api.recordDailyClosing({
        treasuryId: treasury.id,
        closingDate: todayStr,
        openingBalance: openingBalance,
        totalCollections: totalCollections,
        totalCashSales: totalCashSales,
        totalWalletNet: totalWalletNet,
        totalExpenses: totalExpenses,
        actualCash: actualNum,
        notes: closingNotes.trim() || undefined,
      });

      setSubmittedClosing({
        ...res,
        closingDate: todayStr,
        openingBalance,
        totalCollections,
        totalCashSales,
        totalExpenses,
        expectedBalance,
        actualCash: actualNum,
        difference,
        notes: closingNotes,
      });
      setIsSubmitted(true);
      await loadClosingMetrics();
    } catch (err: any) {
      setErrorMsg(err.message || 'فشل حفظ التقفيل اليومي في قاعدة البيانات.');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="space-y-5" dir="rtl">
      {/* Header */}
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3">
        <div>
          <h2 className="text-xl font-bold text-slate-900 flex items-center gap-2">
            <FileText className="w-6 h-6 text-primary" />
            التقفيل اليومي المحاسبي للدرج والخزينة
          </h2>
          <p className="text-xs text-slate-500">مطابقة النقدية الفعلية مع الحسابات الآلية، كشف أي عجز أو زيادة، واعتماد اليومية</p>
        </div>

        <div className="flex items-center gap-2">
          <button
            onClick={loadClosingMetrics}
            disabled={isLoading}
            className="p-2 rounded-xl border border-slate-200 text-slate-600 hover:bg-slate-50 transition"
          >
            <RefreshCw className={`w-4 h-4 ${isLoading ? 'animate-spin' : ''}`} />
          </button>
          <div className="text-xs font-semibold px-3 py-1.5 rounded-xl bg-blue-50 text-primary border border-blue-200">
            تاريخ اليومية: {new Date().toLocaleDateString('en-GB', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' })}
          </div>
        </div>
      </div>

      {errorMsg && (
        <div className="p-3.5 rounded-xl bg-danger/10 border border-danger/20 text-danger text-xs flex items-center gap-2">
          <AlertCircle className="w-4 h-4 flex-shrink-0" />
          <span>{errorMsg}</span>
        </div>
      )}

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-5">
        {/* Closing Form */}
        <div className="lg:col-span-2 bg-white p-5 rounded-2xl border border-slate-200 shadow-sm space-y-5">
          <div className="border-b border-slate-100 pb-3 flex items-center justify-between">
            <div>
              <h3 className="font-bold text-slate-900 text-sm">بيانات حركة نقدية اليوم</h3>
              <p className="text-xs text-slate-400">تجميع العمليات المالية المسجلة خلال اليوم</p>
            </div>
            <span className="text-[11px] font-bold px-2.5 py-1 rounded-lg bg-slate-100 text-slate-700">
              {treasury?.name || 'درج الكاشير الرئيسي'}
            </span>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3.5 text-xs">
            {/* Opening Balance */}
            <div className="p-3.5 rounded-xl bg-slate-50 border border-slate-200 space-y-1">
              <span className="text-slate-500 font-semibold">رصيد افتتاحي للدرج (الصباحي):</span>
              <div className="text-lg font-black text-slate-900">
                {openingBalance.toLocaleString('en-US')} ج.م
              </div>
            </div>

            {/* Total Collections */}
            <div className="p-3.5 rounded-xl bg-emerald-50 border border-emerald-200 space-y-1">
              <span className="text-emerald-700 font-semibold">+ تحصيلات الأقساط النقدية:</span>
              <div className="text-lg font-black text-emerald-800">
                {totalCollections.toLocaleString('en-US')} ج.م
              </div>
            </div>

            {/* Cash Sales */}
            <div className="p-3.5 rounded-xl bg-emerald-50 border border-emerald-200 space-y-1">
              <span className="text-emerald-700 font-semibold">+ المبيعات النقدية المباشرة:</span>
              <div className="text-lg font-black text-emerald-800">
                {totalCashSales.toLocaleString('en-US')} ج.م
              </div>
            </div>

            {/* Cash Wallets Net */}
            <div className="p-3.5 rounded-xl bg-purple-50 border border-purple-200 space-y-1">
              <span className="text-purple-700 font-semibold">+ صافي إيداعات وسحب المحافظ:</span>
              <div className="text-lg font-black text-purple-800">
                {totalWalletNet.toLocaleString('en-US')} ج.م
              </div>
            </div>

            {/* Expenses */}
            <div className="p-3.5 rounded-xl bg-rose-50 border border-rose-200 space-y-1 sm:col-span-2">
              <span className="text-rose-700 font-semibold">- المصروفات والمنصرفات النقدية:</span>
              <div className="text-lg font-black text-rose-800">
                {totalExpenses.toLocaleString('en-US')} ج.م
              </div>
            </div>
          </div>

          {/* Actual Cash Input */}
          <form onSubmit={handleCloseDay} className="pt-2 border-t border-slate-100 space-y-4">
            <div>
              <label className="block text-xs font-bold text-slate-800 mb-1.5">
                الكاش الفعلي في الدرج عند الجرد (العد الفعلي) *
              </label>
              <div className="relative">
                <input
                  type="number"
                  step="0.01"
                  required
                  placeholder="0.00"
                  value={actualCash}
                  onChange={(e) => setActualCash(e.target.value)}
                  className="w-full pl-12 pr-3 py-3 rounded-xl border border-slate-300 text-xl font-black text-slate-900 focus:outline-none focus:border-primary focus:ring-2 focus:ring-primary/10 transition"
                />
                <span className="absolute left-3 top-1/2 -translate-y-1/2 text-xs font-bold text-slate-400">ج.م</span>
              </div>
            </div>

            <div>
              <label className="block text-xs font-semibold text-slate-700 mb-1">
                ملاحظات التقفيل المحاسبي (اختياري)
              </label>
              <input
                type="text"
                placeholder="مثال: فكة ناقصة، مصروف تم بعد التقفيل، توقيع الكاشير..."
                value={closingNotes}
                onChange={(e) => setClosingNotes(e.target.value)}
                className="w-full p-2.5 rounded-xl border border-slate-200 text-xs focus:outline-none focus:border-primary"
              />
            </div>

            <button
              type="submit"
              disabled={isSubmitting || !actualCash}
              className="w-full py-3 rounded-xl bg-slate-900 hover:bg-slate-800 active:scale-98 text-white font-bold text-sm shadow-md transition flex items-center justify-center gap-2 disabled:opacity-50"
            >
              {isSubmitting ? (
                <>
                  <Loader2 className="w-4 h-4 animate-spin text-white" />
                  جاري قيد واعتماد التقفيل في قاعدة البيانات...
                </>
              ) : (
                <>
                  <Lock className="w-4 h-4" />
                  اعتماد وإغلاق اليومية محاسبياً
                </>
              )}
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
              <div className="flex justify-between p-2.5 rounded-xl bg-slate-50 font-mono">
                <span className="text-slate-500 font-semibold font-sans">الرصيد الدفتري المتوقع:</span>
                <span className="font-bold text-slate-900">{expectedBalance.toLocaleString('en-US')} ج.م</span>
              </div>

              <div className="flex justify-between p-2.5 rounded-xl bg-slate-50 font-mono">
                <span className="text-slate-500 font-semibold font-sans">النقدية الفعلية بالدرج:</span>
                <span className="font-bold text-slate-900">{actualNum.toLocaleString('en-US')} ج.م</span>
              </div>

              {/* Status Box */}
              <div className={`p-4 rounded-xl border text-center space-y-1.5 ${
                Math.abs(difference) < 0.01
                  ? 'bg-emerald-50 border-emerald-200 text-emerald-900'
                  : difference > 0
                  ? 'bg-blue-50 border-blue-200 text-blue-900'
                  : 'bg-rose-50 border-rose-200 text-rose-900'
              }`}>
                <div className="text-xs font-bold">
                  {Math.abs(difference) < 0.01
                    ? 'الدرج متطابق تماماً (لا يوجد عجز أو زيادة) ✅'
                    : difference > 0
                    ? 'يوجد زيادة في نقدية الدرج 🔼'
                    : 'يوجد عجز في نقدية الدرج 🔻'}
                </div>
                <div className="text-2xl font-black font-mono">
                  {difference > 0 ? '+' : ''}{difference.toLocaleString('en-US')} ج.م
                </div>
              </div>
            </div>
          </div>

          {isSubmitted && (
            <div className="p-4 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-800 text-xs text-center space-y-2.5 animate-in fade-in">
              <CheckCircle2 className="w-6 h-6 text-emerald-600 mx-auto" />
              <div className="font-bold">تم قيد واعتماد تقفيل اليوم في قاعدة البيانات بنجاح</div>
              <div className="text-[11px] font-mono text-emerald-700 font-semibold">
                رقم التقفيل: {submittedClosing?.closing_number || 'CLS-PROD-001'}
              </div>
              <button
                onClick={() => window.print()}
                className="w-full py-2.5 rounded-xl bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs flex items-center justify-center gap-1.5 shadow-sm transition"
              >
                <Printer className="w-4 h-4" />
                طباعة كشف التقفيل الرسمي
              </button>
            </div>
          )}
        </div>
      </div>

      <section className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm" aria-labelledby="closing-history-title">
        <div className="mb-4 flex flex-col gap-2 border-b border-slate-100 pb-3 sm:flex-row sm:items-center sm:justify-between">
          <div>
            <h3 id="closing-history-title" className="font-bold text-slate-900 text-sm">سجل التقفيلات السابقة</h3>
            <p className="text-xs text-slate-400">سجل محفوظ في قاعدة البيانات لهذه المؤسسة والدرج فقط</p>
          </div>
          <span className="rounded-lg bg-blue-50 px-2.5 py-1 text-[11px] font-bold text-primary">{pastClosings.length} تقفيل</span>
        </div>

        {pastClosings.length === 0 ? (
          <div className="rounded-xl border border-dashed border-slate-200 bg-slate-50 p-8 text-center text-sm text-slate-500">
            لا يوجد تقفيل محفوظ حتى الآن. سيظهر هنا بعد اعتماد أول تقفيل يومي.
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full min-w-[760px] text-right text-xs">
              <thead>
                <tr className="border-b border-slate-100 text-slate-500">
                  <th className="px-3 py-3 font-bold">التاريخ</th>
                  <th className="px-3 py-3 font-bold">رقم التقفيل</th>
                  <th className="px-3 py-3 font-bold">الافتتاحي</th>
                  <th className="px-3 py-3 font-bold">المتوقع</th>
                  <th className="px-3 py-3 font-bold">الفعلي</th>
                  <th className="px-3 py-3 font-bold">الفرق</th>
                  <th className="px-3 py-3 font-bold">الحالة</th>
                  <th className="px-3 py-3 font-bold">ملاحظات</th>
                </tr>
              </thead>
              <tbody>
                {pastClosings.map((closing) => (
                  <tr key={closing.id} className="border-b border-slate-50 last:border-0 hover:bg-slate-50/70">
                    <td className="whitespace-nowrap px-3 py-3 font-semibold text-slate-700">{new Date(closing.closing_date).toLocaleDateString('ar-EG')}</td>
                    <td className="whitespace-nowrap px-3 py-3 font-mono font-bold text-slate-700">{closing.closing_number}</td>
                    <td className="whitespace-nowrap px-3 py-3">{Number(closing.opening_balance || 0).toLocaleString('en-US')} ج.م</td>
                    <td className="whitespace-nowrap px-3 py-3">{Number(closing.expected_balance || 0).toLocaleString('en-US')} ج.م</td>
                    <td className="whitespace-nowrap px-3 py-3">{Number(closing.actual_cash || 0).toLocaleString('en-US')} ج.م</td>
                    <td className={`whitespace-nowrap px-3 py-3 font-black ${closing.difference < 0 ? 'text-rose-700' : closing.difference > 0 ? 'text-blue-700' : 'text-emerald-700'}`}>
                      {closing.difference > 0 ? '+' : ''}{Number(closing.difference || 0).toLocaleString('en-US')} ج.م
                    </td>
                    <td className="px-3 py-3"><span className={`rounded-full px-2 py-1 font-bold ${closing.status === 'balanced' ? 'bg-emerald-50 text-emerald-700' : closing.status === 'shortage' ? 'bg-rose-50 text-rose-700' : 'bg-blue-50 text-blue-700'}`}>{closingStatusLabel[closing.status] || closing.status}</span></td>
                    <td className="max-w-[180px] truncate px-3 py-3 text-slate-500" title={closing.notes || ''}>{closing.notes || '-'}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </section>

      {/* Official Printable Closing Statement (Hidden on screen, visible on print) */}
      <div className="hidden print:block p-8 bg-white text-slate-900 font-sans" dir="rtl">
        <div className="text-center border-b-2 border-slate-900 pb-4 mb-6">
          <h1 className="text-2xl font-black">سنترال المركزي</h1>
          <p className="text-sm">كشف جرد وتقفيل يومي رسمي معتمد</p>
          <p className="text-xs text-slate-500 mt-1">تاريخ التقفيل: {new Date().toISOString().slice(0, 10)} • الفرع الرئيسي</p>
        </div>

        <table className="w-full text-right text-sm border border-slate-300 mb-6 font-mono">
          <tbody>
            <tr className="border-b"><td className="p-2 font-bold bg-slate-100 font-sans">رقم التقفيل:</td><td className="p-2 font-mono">{submittedClosing?.closing_number || 'CLS-001'}</td></tr>
            <tr className="border-b"><td className="p-2 font-bold bg-slate-100 font-sans">الرصيد الافتتاحي:</td><td className="p-2">{openingBalance.toLocaleString('en-US')} ج.م</td></tr>
            <tr className="border-b"><td className="p-2 font-bold bg-slate-100 font-sans">إجمالي تحصيلات الأقساط:</td><td className="p-2">{totalCollections.toLocaleString('en-US')} ج.م</td></tr>
            <tr className="border-b"><td className="p-2 font-bold bg-slate-100 font-sans">المبيعات النقدية المباشرة:</td><td className="p-2">{totalCashSales.toLocaleString('en-US')} ج.م</td></tr>
            <tr className="border-b"><td className="p-2 font-bold bg-slate-100 font-sans">صافي حركة المحافظ:</td><td className="p-2">{totalWalletNet.toLocaleString('en-US')} ج.م</td></tr>
            <tr className="border-b"><td className="p-2 font-bold bg-slate-100 font-sans">إجمالي المصروفات:</td><td className="p-2">{totalExpenses.toLocaleString('en-US')} ج.م</td></tr>
            <tr className="border-b font-bold"><td className="p-2 bg-slate-100 font-sans">الرصيد الدفتري المتوقع:</td><td className="p-2">{expectedBalance.toLocaleString('en-US')} ج.م</td></tr>
            <tr className="border-b font-black"><td className="p-2 bg-slate-100 font-sans">العد الفعلي للكاش بالدرج:</td><td className="p-2">{actualNum.toLocaleString('en-US')} ج.م</td></tr>
            <tr className="font-bold"><td className="p-2 bg-slate-100 font-sans">فارق المطابقة (عجز/زيادة):</td><td className="p-2">{difference.toLocaleString('en-US')} ج.م</td></tr>
          </tbody>
        </table>

        <div className="grid grid-cols-2 gap-8 pt-8 text-center text-sm font-bold border-t border-slate-300">
          <div>
            <p>توقيع الكاشير المسؤول</p>
            <div className="h-16"></div>
            <p className="text-xs text-slate-400">....................................</p>
          </div>
          <div>
            <p>اعتماد مدير الفرع</p>
            <div className="h-16"></div>
            <p className="text-xs text-slate-400">....................................</p>
          </div>
        </div>
      </div>
    </div>
  );
};
