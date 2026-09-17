import React from 'react';
import { BarChart3, Download, Printer, TrendingUp, CreditCard, DollarSign } from 'lucide-react';

export const ReportsPage: React.FC = () => {
  const handleExportCSV = () => {
    const csvContent = "data:text/csv;charset=utf-8,\uFEFF" +
      "التقرير,القيمة بالجنيه المصري\n" +
      "إجمالي عقود الأقساط التاريخية,1994800\n" +
      "إجمالي متبقي الأقساط (ديون العملاء),694775\n" +
      "المسدد من الأقساط,1300025\n" +
      "رصيد الدرج والعهدة الحالي,35420\n" +
      "عدد عملاء الأقساط النشطين,144\n";
    const encodedUri = encodeURI(csvContent);
    const link = document.createElement("a");
    link.setAttribute("href", encodedUri);
    link.setAttribute("download", `تقرير_السنترال_${new Date().toISOString().slice(0,10)}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  return (
    <div className="space-y-5">
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3">
        <div>
          <h2 className="text-xl font-bold text-slate-900 flex items-center gap-2">
            <BarChart3 className="w-6 h-6 text-primary" />
            التقارير المالية والإحصائيات
          </h2>
          <p className="text-xs text-slate-500">مؤشرات الأداء، التحصيل الشهري، وتصدير البيانات</p>
        </div>

        <div className="flex items-center gap-2">
          <button
            onClick={() => window.print()}
            className="px-3.5 py-2 rounded-xl bg-white border border-slate-200 text-slate-700 hover:bg-slate-50 font-bold text-xs shadow-sm flex items-center gap-1.5 transition"
          >
            <Printer className="w-4 h-4" />
            طباعة التقرير
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

      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div className="p-5 rounded-2xl bg-white border border-slate-200 shadow-sm space-y-2">
          <div className="text-xs text-slate-400 font-bold">إجمالي مبيعات وعقود الأقساط</div>
          <div className="text-2xl font-black text-slate-900">1,994,800 ج.م</div>
          <div className="text-xs text-slate-500">177 عقد قسط مسجل</div>
        </div>

        <div className="p-5 rounded-2xl bg-white border border-slate-200 shadow-sm space-y-2">
          <div className="text-xs text-slate-400 font-bold">المبالغ المسددة فعلياً</div>
          <div className="text-2xl font-black text-emerald-600">1,300,025 ج.م</div>
          <div className="text-xs text-emerald-700 font-semibold">نسبة سداد: 65.2%</div>
        </div>

        <div className="p-5 rounded-2xl bg-white border border-slate-200 shadow-sm space-y-2">
          <div className="text-xs text-slate-400 font-bold">المتبقي الواجب تحصيله</div>
          <div className="text-2xl font-black text-primary">694,775 ج.م</div>
          <div className="text-xs text-slate-500">موزع على الأقساط المستحقة</div>
        </div>
      </div>
    </div>
  );
};
