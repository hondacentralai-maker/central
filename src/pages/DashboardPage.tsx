import React, { useEffect, useState } from 'react';
import { 
  Users, 
  CreditCard, 
  Wallet, 
  AlertTriangle, 
  TrendingUp, 
  ArrowUpRight, 
  Smartphone, 
  Sparkles,
  PlusCircle,
  Clock
} from 'lucide-react';
import { api } from '../services/api';

interface DashboardPageProps {
  onQuickCollect: () => void;
  onNavigate: (tab: any) => void;
}

export const DashboardPage: React.FC<DashboardPageProps> = ({ onQuickCollect, onNavigate }) => {
  const [stats, setStats] = useState<any>({
    totalCustomers: 144,
    totalContractsValue: 1994800,
    totalRemainingDebt: 694775,
    totalCashInTreasury: 35000,
    overdueInstallments: 18,
    activeContractsCount: 165
  });

  useEffect(() => {
    api.getDashboardMetrics().then(setStats);
  }, []);

  return (
    <div className="space-y-6">
      {/* Top Banner / Store Header */}
      <div className="p-6 rounded-2xl bg-gradient-to-r from-blue-700 via-primary to-indigo-800 text-white shadow-xl shadow-primary/10 flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
        <div className="space-y-1.5">
          <div className="flex items-center gap-2">
            <span className="px-2 py-0.5 rounded-full bg-white/20 text-xs font-bold backdrop-blur-sm">
              الفرع الرئيسي
            </span>
            <span className="text-xs text-blue-100 flex items-center gap-1">
              <Clock className="w-3.5 h-3.5" />
              اليوم: {new Date().toLocaleDateString('ar-EG', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' })}
            </span>
          </div>
          <h2 className="text-xl md:text-2xl font-black">أهلاً بك في نظام سنترال المركزي</h2>
          <p className="text-xs md:text-sm text-blue-100 max-w-xl">
            متابعة شاملة لحظية لجميع عقود الأقساط، حركة الدرج، محافظ الكاش الإلكترونية، وماكينات فوري وأمان.
          </p>
        </div>

        <button
          onClick={onQuickCollect}
          className="w-full md:w-auto px-5 py-3 rounded-xl bg-white text-primary hover:bg-blue-50 font-black text-sm shadow-lg shadow-black/10 active:scale-95 transition flex items-center justify-center gap-2"
        >
          <PlusCircle className="w-5 h-5 text-primary" />
          تسجيل تحصيل قسط فوري
        </button>
      </div>

      {/* KPI Cards Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {/* Total Debt */}
        <div className="p-5 rounded-2xl bg-white border border-slate-200/80 shadow-sm hover:shadow-md transition">
          <div className="flex items-center justify-between text-slate-500 mb-3">
            <span className="text-xs font-bold">إجمالي متبقي الأقساط (الديون)</span>
            <div className="w-9 h-9 rounded-xl bg-primary/10 text-primary flex items-center justify-center">
              <CreditCard className="w-5 h-5" />
            </div>
          </div>
          <div className="text-2xl md:text-3xl font-black text-slate-900">
            {stats.totalRemainingDebt.toLocaleString('ar-EG')} <span className="text-xs font-bold text-slate-500">ج.م</span>
          </div>
          <div className="mt-2 text-xs text-slate-500 flex items-center justify-between">
            <span>من إجمالي عقود:</span>
            <span className="font-bold text-slate-700">{stats.totalContractsValue.toLocaleString('ar-EG')} ج.م</span>
          </div>
        </div>

        {/* Overdue Installments Alert */}
        <div className="p-5 rounded-2xl bg-white border border-red-100 shadow-sm hover:shadow-md transition">
          <div className="flex items-center justify-between text-slate-500 mb-3">
            <span className="text-xs font-bold text-danger">أقساط متأخرة واجبة التحصيل</span>
            <div className="w-9 h-9 rounded-xl bg-danger/10 text-danger flex items-center justify-center">
              <AlertTriangle className="w-5 h-5" />
            </div>
          </div>
          <div className="text-2xl md:text-3xl font-black text-danger">
            {stats.overdueInstallments} <span className="text-xs font-bold text-danger/80">قسط متأخر</span>
          </div>
          <button 
            onClick={() => onNavigate('installments')}
            className="mt-2 text-xs text-primary font-bold hover:underline flex items-center gap-1"
          >
            عرض قائمة المتأخرات للمحصل
            <ArrowUpRight className="w-3.5 h-3.5" />
          </button>
        </div>

        {/* Total Customers */}
        <div className="p-5 rounded-2xl bg-white border border-slate-200/80 shadow-sm hover:shadow-md transition">
          <div className="flex items-center justify-between text-slate-500 mb-3">
            <span className="text-xs font-bold">إجمالي عملاء السنترال</span>
            <div className="w-9 h-9 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center">
              <Users className="w-5 h-5" />
            </div>
          </div>
          <div className="text-2xl md:text-3xl font-black text-slate-900">
            {stats.totalCustomers} <span className="text-xs font-bold text-slate-500">عميل نشط</span>
          </div>
          <div className="mt-2 text-xs text-slate-500 flex items-center justify-between">
            <span>عقود التقسيط النشطة:</span>
            <span className="font-bold text-emerald-700">{stats.activeContractsCount} عقد</span>
          </div>
        </div>

        {/* Treasury / Drawer Cash */}
        <div className="p-5 rounded-2xl bg-white border border-slate-200/80 shadow-sm hover:shadow-md transition">
          <div className="flex items-center justify-between text-slate-500 mb-3">
            <span className="text-xs font-bold">رصيد الدرج والعهدة الحالي</span>
            <div className="w-9 h-9 rounded-xl bg-amber-50 text-amber-600 flex items-center justify-center">
              <Wallet className="w-5 h-5" />
            </div>
          </div>
          <div className="text-2xl md:text-3xl font-black text-slate-900">
            {stats.totalCashInTreasury.toLocaleString('ar-EG')} <span className="text-xs font-bold text-slate-500">ج.م</span>
          </div>
          <div className="mt-2 text-xs text-slate-500 flex items-center justify-between">
            <span>الدرج جاهز للتقفيل اليومي</span>
            <button onClick={() => onNavigate('closing')} className="font-bold text-primary hover:underline">
              التقفيل
            </button>
          </div>
        </div>
      </div>

      {/* Quick Action Tiles */}
      <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-3">
        {[
          { label: 'الأقساط والمتابعة', icon: CreditCard, tab: 'installments', color: 'text-blue-600 bg-blue-50' },
          { label: 'سجل العملاء', icon: Users, tab: 'customers', color: 'text-indigo-600 bg-indigo-50' },
          { label: 'خطوط الكاش (6)', icon: Smartphone, tab: 'wallets', color: 'text-purple-600 bg-purple-50' },
          { label: 'ماكينات فوري وأمان', icon: TrendingUp, tab: 'pos', color: 'text-amber-600 bg-amber-50' },
          { label: 'أجل سريع (75 محل)', icon: Users, tab: 'fast_credit', color: 'text-emerald-600 bg-emerald-50' },
          { label: 'التقفيل اليومي', icon: Wallet, tab: 'closing', color: 'text-rose-600 bg-rose-50' },
        ].map((item, idx) => {
          const Icon = item.icon;
          return (
            <button
              key={idx}
              onClick={() => onNavigate(item.tab)}
              className="p-4 rounded-2xl bg-white border border-slate-200/80 shadow-sm hover:border-primary/40 hover:shadow-md transition text-center flex flex-col items-center gap-2 group"
            >
              <div className={`w-10 h-10 rounded-xl ${item.color} flex items-center justify-center group-hover:scale-110 transition`}>
                <Icon className="w-5 h-5" />
              </div>
              <span className="text-xs font-bold text-slate-700">{item.label}</span>
            </button>
          );
        })}
      </div>

      {/* Migration Notice Banner */}
      <div className="p-5 rounded-2xl bg-slate-900 text-white flex flex-col sm:flex-row items-center justify-between gap-4">
        <div className="flex items-center gap-3 text-center sm:text-right">
          <div className="w-10 h-10 rounded-xl bg-cyan-500/20 text-cyan-400 flex items-center justify-center flex-shrink-0">
            <Sparkles className="w-6 h-6" />
          </div>
          <div>
            <h4 className="font-bold text-sm">تم استخراج وتجهيز بيانات دفاتر الإكسل السابقة بالكامل</h4>
            <p className="text-xs text-slate-400">
              144 عميل • 177 عقد قسط حقيقي بقيمة 1,994,800 ج.م • 75 حساب أجل سريع • 6 موردين
            </p>
          </div>
        </div>
        <button
          onClick={() => onNavigate('migration')}
          className="px-4 py-2 rounded-xl bg-cyan-500 hover:bg-cyan-400 text-slate-950 font-bold text-xs transition"
        >
          معاينة البيانات المستخرجة
        </button>
      </div>
    </div>
  );
};
