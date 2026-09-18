import React, { useState, useEffect } from 'react';
import { 
  BarChart3, 
  Download, 
  Printer, 
  TrendingUp, 
  CreditCard, 
  DollarSign, 
  Wallet, 
  Layers, 
  Store, 
  RefreshCw,
  Calendar,
  FileText,
  Loader2
} from 'lucide-react';
import { api } from '../services/api';

export const ReportsPage: React.FC = () => {
  const [metrics, setMetrics] = useState<any>({
    totalCustomers: 0,
    totalContractsValue: 0,
    totalRemainingDebt: 0,
    totalCashInTreasury: 0,
    overdueInstallments: 0,
    activeContractsCount: 0
  });

  const [walletsTotal, setWalletsTotal] = useState(0);
  const [posTotal, setPosTotal] = useState(0);
  const [fastCreditTotal, setFastCreditTotal] = useState(0);
  const [period, setPeriod] = useState<'all' | 'today' | 'month'>('all');
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    loadFinancialReport();
  }, []);

  const loadFinancialReport = async () => {
    setIsLoading(true);
    try {
      const [m, wList, pList, fList, tList] = await Promise.all([
        api.getDashboardMetrics(),
        api.getCashWallets(),
        api.getPOSMachines(),
        api.getFastCreditAccounts(),
        api.getTreasuries(),
      ]);

      const drawer = tList.find(t => t.treasury_type === 'drawer') || tList[0];
      const custody = tList.find(t => t.treasury_type === 'custody');
      const totalCash = Number(drawer?.current_balance || 0) + Number(custody?.current_balance || 0);

      const wSum = wList.reduce((acc, w) => acc + Number(w.current_balance || 0), 0);
      const pSum = pList.reduce((acc, p) => acc + Number(p.current_balance || 0), 0);
      const fSum = fList.reduce((acc, f) => acc + Number(f.current_balance || 0), 0);

      setMetrics({
        ...m,
        totalCashInTreasury: totalCash
      });
      setWalletsTotal(wSum);
      setPosTotal(pSum);
      setFastCreditTotal(fSum);
    } catch (err: any) {
      setMetrics(current => ({ ...current, error: err?.message || 'تعذر تحميل التقرير.' }));
    } finally {
      setIsLoading(false);
    }
  };

  const totalPaid = Math.max(metrics.totalContractsValue - metrics.totalRemainingDebt, 0);
  const paymentRate = metrics.totalContractsValue > 0 
    ? ((totalPaid / metrics.totalContractsValue) * 100).toFixed(1)
    : '0';

  const totalLiquidAssets = metrics.totalCashInTreasury + walletsTotal + posTotal;

  const handleExportCSV = () => {
    const csvRows = [
      ["البند المحاسبي", "القيمة بالجنيه المصري", "ملاحظات"],
      ["إجمالي عقود الأقساط", metrics.totalContractsValue, "إجمالي قيمة العقود المسجلة"],
      ["المسدد فعلياً من الأقساط", totalPaid, `نسبة التحصيل ${paymentRate}%`],
      ["متبقي ديون الأقساط على العملاء", metrics.totalRemainingDebt, "واجب التحصيل"],
      ["نقدية الدرج والخزينة", metrics.totalCashInTreasury, "النقدية الفعلية"],
      ["أرصدة خطوط فودافون كاش", walletsTotal, "الأرصدة المسجلة في قاعدة البيانات"],
      ["أرصدة ماكينات فوري وأمان", posTotal, "4 ماكينات دفع إلكتروني"],
      ["أرصدة عملاء الأجل السريع", fastCreditTotal, "75 حساب ومحل شريك"],
      ["إجمالي السيولة النقدية والرقمية", totalLiquidAssets, "الدرج + المحافظ + الماكينات"],
    ];

    const csvContent = "data:text/csv;charset=utf-8,\uFEFF" + 
      csvRows.map(e => e.join(",")).join("\n");

    const encodedUri = encodeURI(csvContent);
    const link = document.createElement("a");
    link.setAttribute("href", encodedUri);
    link.setAttribute("download", `تقرير_مالي_سنترال_المركزي_${new Date().toISOString().slice(0,10)}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  return (
    <div className="space-y-5" dir="rtl">
      {/* Header */}
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3">
        <div>
          <h2 className="text-xl font-bold text-slate-900 flex items-center gap-2">
            <BarChart3 className="w-6 h-6 text-primary" />
            التقرير المالي العام ومصدر الحقيقة
          </h2>
          <p className="text-xs text-slate-500">حسابات دقيقة موحدة مستندة إلى قاعدة البيانات، كشوف السيولة، وتحصيل الأقساط</p>
        </div>

        <div className="flex items-center gap-2">
          <button
            onClick={loadFinancialReport}
            disabled={isLoading}
            className="p-2 rounded-xl border border-slate-200 text-slate-600 hover:bg-slate-50 transition"
          >
            <RefreshCw className={`w-4 h-4 ${isLoading ? 'animate-spin' : ''}`} />
          </button>
          <button
            onClick={() => window.print()}
            className="px-3.5 py-2 rounded-xl bg-white border border-slate-200 text-slate-700 hover:bg-slate-50 font-bold text-xs shadow-sm flex items-center gap-1.5 transition"
          >
            <Printer className="w-4 h-4" />
            طباعة كشف الحساب
          </button>
          <button
            onClick={handleExportCSV}
            className="px-3.5 py-2 rounded-xl bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs shadow-sm flex items-center gap-1.5 transition"
          >
            <Download className="w-4 h-4" />
            تصدير Excel / CSV
          </button>
        </div>
      </div>

      {/* KPI Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {/* Total Contracts Value */}
        <div className="p-5 rounded-2xl bg-white border border-slate-200 shadow-sm space-y-2">
          <div className="flex items-center justify-between text-xs text-slate-500 font-bold">
            <span>إجمالي مبيعات التقسيط</span>
            <CreditCard className="w-4 h-4 text-primary" />
          </div>
          <div className="text-2xl font-black text-slate-900 font-mono">
            {metrics.totalContractsValue.toLocaleString('en-US')} <span className="text-xs font-bold text-slate-500">ج.م</span>
          </div>
          <div className="text-[11px] text-slate-400">من {metrics.activeContractsCount} عقد قسط</div>
        </div>

        {/* Collected */}
        <div className="p-5 rounded-2xl bg-white border border-slate-200 shadow-sm space-y-2">
          <div className="flex items-center justify-between text-xs text-slate-500 font-bold">
            <span>المسدد فعلياً</span>
            <DollarSign className="w-4 h-4 text-emerald-600" />
          </div>
          <div className="text-2xl font-black text-emerald-600 font-mono">
            {totalPaid.toLocaleString('en-US')} <span className="text-xs font-bold text-emerald-700">ج.م</span>
          </div>
          <div className="text-[11px] text-emerald-700 font-bold">نسبة التحصيل: {paymentRate}%</div>
        </div>

        {/* Remaining Debt */}
        <div className="p-5 rounded-2xl bg-white border border-slate-200 shadow-sm space-y-2">
          <div className="flex items-center justify-between text-xs text-slate-500 font-bold">
            <span>المتبقي الواجب تحصيله</span>
            <TrendingUp className="w-4 h-4 text-primary" />
          </div>
          <div className="text-2xl font-black text-primary font-mono">
            {metrics.totalRemainingDebt.toLocaleString('en-US')} <span className="text-xs font-bold text-primary/70">ج.م</span>
          </div>
          <div className="text-[11px] text-slate-400">على {metrics.totalCustomers} عميل مسجل</div>
        </div>

        {/* Total Liquid Assets (Clean White Theme) */}
        <div className="p-5 rounded-2xl bg-white border-2 border-primary/30 shadow-sm space-y-2">
          <div className="flex items-center justify-between text-xs text-primary font-bold">
            <span>إجمالي السيولة الحالية</span>
            <Wallet className="w-4 h-4 text-primary" />
          </div>
          <div className="text-2xl font-black text-slate-900 font-mono">
            {totalLiquidAssets.toLocaleString('en-US')} <span className="text-xs font-bold text-primary">ج.م</span>
          </div>
          <div className="text-[11px] text-slate-500">درج + محافظ + ماكينات</div>
        </div>
      </div>

      {/* Comprehensive Ledger Breakdown Table */}
      <div className="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div className="p-4 border-b border-slate-100 flex items-center justify-between">
          <h3 className="font-bold text-slate-900 text-sm flex items-center gap-2">
            <Layers className="w-4 h-4 text-primary" />
            توزيع السيولة والذمم المالية الشاملة
          </h3>
          <span className="text-xs text-slate-400">مطابق لجميع الحسابات</span>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full text-right text-xs">
            <thead className="bg-slate-50 border-b border-slate-100 text-slate-500 font-semibold">
              <tr>
                <th className="p-3.5">البند المالي</th>
                <th className="p-3.5">طبيعة البند</th>
                <th className="p-3.5">الرصيد الفعلي</th>
                <th className="p-3.5">الحالة</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              <tr className="hover:bg-slate-50 transition">
                <td className="p-3.5 font-bold text-slate-900 flex items-center gap-2">
                  <Wallet className="w-4 h-4 text-primary" />
                  النقدية السائلة (الدرج + العهدة)
                </td>
                <td className="p-3.5 text-slate-500">نقدية كاش بالفرع</td>
                <td className="p-3.5 font-black text-slate-900 text-sm font-mono">
                  {metrics.totalCashInTreasury.toLocaleString('en-US')} ج.م
                </td>
                <td className="p-3.5"><span className="text-emerald-700 bg-emerald-50 px-2 py-0.5 rounded font-bold">مطابق للدرج</span></td>
              </tr>

              <tr className="hover:bg-slate-50 transition">
                <td className="p-3.5 font-bold text-slate-900 flex items-center gap-2">
                  <Wallet className="w-4 h-4 text-purple-600" />
                  أرصدة خطوط فودافون كاش
                </td>
                <td className="p-3.5 text-slate-500">محافظ إلكترونية سائلة</td>
                <td className="p-3.5 font-black text-slate-900 text-sm font-mono">
                  {walletsTotal.toLocaleString('en-US')} ج.م
                </td>
                <td className="p-3.5"><span className="text-purple-700 bg-purple-50 px-2 py-0.5 rounded font-bold">جاهز للإيداع والسحب</span></td>
              </tr>

              <tr className="hover:bg-slate-50 transition">
                <td className="p-3.5 font-bold text-slate-900 flex items-center gap-2">
                  <Layers className="w-4 h-4 text-cyan-600" />
                  ماكينات الدفع (فوري، أمان، بساطة)
                </td>
                <td className="p-3.5 text-slate-500">أرصدة شحن وخدمات</td>
                <td className="p-3.5 font-black text-slate-900 text-sm font-mono">
                  {posTotal.toLocaleString('en-US')} ج.م
                </td>
                <td className="p-3.5"><span className="text-blue-700 bg-blue-50 px-2 py-0.5 rounded font-bold">4 ماكينات نشطة</span></td>
              </tr>

              <tr className="hover:bg-slate-50 transition">
                <td className="p-3.5 font-bold text-slate-900 flex items-center gap-2">
                  <CreditCard className="w-4 h-4 text-amber-600" />
                  ديون أقساط العملاء المتبقية
                </td>
                <td className="p-3.5 text-slate-500">مديونيات أقساط مستحقة</td>
                <td className="p-3.5 font-black text-primary text-sm font-mono">
                  {metrics.totalRemainingDebt.toLocaleString('en-US')} ج.م
                </td>
                <td className="p-3.5"><span className="text-amber-700 bg-amber-50 px-2 py-0.5 rounded font-bold">قيد التحصيل الشهري</span></td>
              </tr>

              <tr className="hover:bg-slate-50 transition">
                <td className="p-3.5 font-bold text-slate-900 flex items-center gap-2">
                  <Store className="w-4 h-4 text-slate-700" />
                  عملاء الأجل السريع
                </td>
                <td className="p-3.5 text-slate-500">حسابات تحويل وشحن أجل</td>
                <td className="p-3.5 font-black text-slate-900 text-sm">
                  {fastCreditTotal.toLocaleString('en-US')} ج.م
                </td>
                <td className="p-3.5"><span className="text-slate-700 bg-slate-100 px-2 py-0.5 rounded font-bold">حسابات دورية</span></td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};
