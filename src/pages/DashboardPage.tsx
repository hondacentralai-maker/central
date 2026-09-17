import React, { useEffect, useState, useMemo } from 'react';
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
  Clock,
  Calendar,
  MessageCircle,
  CheckCircle2,
  DollarSign,
  Search,
  ChevronLeft,
  Phone,
  RefreshCw,
  ExternalLink,
  Zap
} from 'lucide-react';
import { api } from '../services/api';
import { openWhatsAppReminder } from '../utils/whatsapp';

interface DashboardPageProps {
  onQuickCollect: () => void;
  onNavigate: (tab: any, customerTarget?: string) => void;
  onDirectCollect?: (data: any) => void;
}

interface InstallmentAlertItem {
  id: string;
  customerName: string;
  customerPhone: string;
  customerCode: string;
  deviceName: string;
  installmentNo: string;
  dueAmount: number;
  dueDate: string;
  status: 'overdue' | 'today' | 'upcoming' | 'paid';
  delayDays: number;
  contractIndex: number;
  installmentIndex: number;
}

export const DashboardPage: React.FC<DashboardPageProps> = ({ 
  onQuickCollect, 
  onNavigate,
  onDirectCollect 
}) => {
  const [stats, setStats] = useState<any>({
    totalCustomers: 144,
    totalContractsValue: 1994800,
    totalRemainingDebt: 694775,
    totalCashInTreasury: 35420,
    overdueInstallments: 18,
    activeContractsCount: 165
  });

  const [activeAlertTab, setActiveAlertTab] = useState<'overdue' | 'today' | 'upcoming' | 'paid'>('overdue');
  const [searchQuery, setSearchQuery] = useState('');
  const [allAlerts, setAllAlerts] = useState<InstallmentAlertItem[]>([]);
  const [isLoadingAlerts, setIsLoadingAlerts] = useState(true);

  // Load KPI stats and installments list
  useEffect(() => {
    let mounted = true;

    // 1. Fetch metrics
    api.getDashboardMetrics().then((data) => {
      if (mounted && data) {
        setStats((prev: any) => ({
          ...prev,
          ...data,
          totalCustomers: data.totalCustomers || prev.totalCustomers,
          totalContractsValue: data.totalContractsValue || prev.totalContractsValue,
          totalRemainingDebt: data.totalRemainingDebt || prev.totalRemainingDebt,
          totalCashInTreasury: data.totalCashInTreasury || prev.totalCashInTreasury,
        }));
      }
    });

    // 2. Fetch customers to populate interactive Due / Overdue center
    fetch('/migrated_data.json')
      .then(res => res.json())
      .then(json => {
        if (!mounted) return;

        let customers = json.customers || [];
        const savedCustom = localStorage.getItem('central_custom_customers');
        if (savedCustom) {
          try {
            const customList = JSON.parse(savedCustom);
            customers = [...customList, ...customers];
          } catch {}
        }

        const alerts: InstallmentAlertItem[] = [];
        const today = new Date();
        today.setHours(0, 0, 0, 0);

        customers.forEach((c: any, cIdx: number) => {
          const custCode = c.code || `CUS-${(cIdx + 1).toString().padStart(5, '0')}`;
          (c.contracts || []).forEach((ctr: any, ctrIdx: number) => {
            (ctr.installments || []).forEach((inst: any, instIdx: number) => {
              if (inst.item_type === 'down_payment') return;

              const isPaid = inst.status === 'paid' || (inst.paid_amount >= inst.due_amount && inst.due_amount > 0);
              const remaining = inst.remaining_amount !== undefined ? inst.remaining_amount : (inst.due_amount - (inst.paid_amount || 0));

              // Parse installment date
              let dDate: Date;
              if (inst.due_date && inst.due_date.includes('/')) {
                const parts = inst.due_date.split('/');
                if (parts.length === 2) {
                  dDate = new Date(2026, parseInt(parts[1]) - 1, parseInt(parts[0]));
                } else {
                  dDate = new Date(parseInt(parts[2]), parseInt(parts[1]) - 1, parseInt(parts[0]));
                }
              } else if (inst.due_date && inst.due_date.includes('-')) {
                dDate = new Date(inst.due_date);
              } else {
                // Synthesize realistic dates for demo/sample rows
                dDate = new Date(2026, 8, 10 + (instIdx % 15));
              }

              if (isNaN(dDate.getTime())) {
                dDate = new Date(2026, 8, 15);
              }

              const diffTime = dDate.getTime() - today.getTime();
              const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

              let status: 'overdue' | 'today' | 'upcoming' | 'paid' = 'upcoming';
              let delayDays = 0;

              if (isPaid) {
                status = 'paid';
              } else if (diffDays < 0) {
                status = 'overdue';
                delayDays = Math.abs(diffDays);
              } else if (diffDays === 0) {
                status = 'today';
              } else if (diffDays <= 7) {
                status = 'upcoming';
              } else {
                status = 'upcoming';
              }

              alerts.push({
                id: `alert-${cIdx}-${ctrIdx}-${instIdx}`,
                customerName: c.name,
                customerPhone: c.phone || '01000000000',
                customerCode: custCode,
                deviceName: ctr.device_name || 'جهاز تقسيط',
                installmentNo: `قسط شهر ${instIdx + 1}`,
                dueAmount: remaining > 0 ? remaining : inst.due_amount,
                dueDate: inst.due_date || dDate.toLocaleDateString('ar-EG'),
                status,
                delayDays,
                contractIndex: ctrIdx,
                installmentIndex: instIdx
              });
            });
          });
        });

        setAllAlerts(alerts);
        setIsLoadingAlerts(false);
      })
      .catch(() => {
        setIsLoadingAlerts(false);
      });

    return () => {
      mounted = false;
    };
  }, []);

  // Filtered alert items
  const filteredAlerts = useMemo(() => {
    return allAlerts.filter(item => {
      const matchesTab = item.status === activeAlertTab;
      if (!matchesTab) return false;

      if (!searchQuery.trim()) return true;
      const query = searchQuery.toLowerCase();
      return (
        item.customerName.toLowerCase().includes(query) ||
        item.customerPhone.includes(query) ||
        item.customerCode.toLowerCase().includes(query) ||
        item.deviceName.toLowerCase().includes(query)
      );
    });
  }, [allAlerts, activeAlertTab, searchQuery]);

  // Counts for tabs
  const overdueCount = useMemo(() => allAlerts.filter(a => a.status === 'overdue').length, [allAlerts]);
  const overdueTotal = useMemo(() => allAlerts.filter(a => a.status === 'overdue').reduce((s, a) => s + a.dueAmount, 0), [allAlerts]);
  const todayCount = useMemo(() => allAlerts.filter(a => a.status === 'today').length, [allAlerts]);
  const todayTotal = useMemo(() => allAlerts.filter(a => a.status === 'today').reduce((s, a) => s + a.dueAmount, 0), [allAlerts]);
  const upcomingCount = useMemo(() => allAlerts.filter(a => a.status === 'upcoming').length, [allAlerts]);
  const upcomingTotal = useMemo(() => allAlerts.filter(a => a.status === 'upcoming').reduce((s, a) => s + a.dueAmount, 0), [allAlerts]);
  const paidCount = useMemo(() => allAlerts.filter(a => a.status === 'paid').length, [allAlerts]);

  // Handle direct payment from Dashboard
  const handleDirectDashboardPay = (item: InstallmentAlertItem) => {
    // Mark as paid in local alerts state
    setAllAlerts(prev => prev.map(a => a.id === item.id ? { ...a, status: 'paid' } : a));

    // Update treasury stats
    setStats((prev: any) => ({
      ...prev,
      totalCashInTreasury: (prev.totalCashInTreasury || 0) + item.dueAmount,
      totalRemainingDebt: Math.max((prev.totalRemainingDebt || 0) - item.dueAmount, 0)
    }));

    if (onDirectCollect) {
      onDirectCollect({
        receiptNumber: 'REC-' + Math.floor(1000 + Math.random() * 9000),
        customerName: item.customerName,
        customerPhone: item.customerPhone,
        contractNumber: item.installmentNo,
        deviceName: item.deviceName,
        amount: item.dueAmount,
        remainingBalance: 0,
        paymentMethod: 'كاش الدرج',
        date: new Date().toLocaleDateString('ar-EG')
      });
    } else {
      alert(`✅ تم تحصيل ${item.dueAmount.toLocaleString('en-US')} ج.م بنجاح من الأستاذ ${item.customerName} وتوريدها للدرج.`);
    }
  };

  return (
    <div className="space-y-6">
      {/* Top Banner */}
      <div className="p-6 rounded-2xl bg-gradient-to-r from-blue-700 via-primary to-indigo-800 text-white shadow-xl shadow-primary/10 flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
        <div className="space-y-1.5">
          <div className="flex items-center gap-2">
            <span className="px-2.5 py-0.5 rounded-full bg-white/20 text-xs font-bold backdrop-blur-sm">
              الفرع الرئيسي
            </span>
            <span className="text-xs text-blue-100 flex items-center gap-1 font-mono">
              <Clock className="w-3.5 h-3.5" />
              {new Date().toISOString().slice(0, 10)}
            </span>
          </div>
          <h2 className="text-xl md:text-2xl font-black">أهلاً بك في نظام سنترال المركزي</h2>
          <p className="text-xs md:text-sm text-blue-100 max-w-xl">
            إدارة متكاملة للأقساط والمبيعات، التقفيل اليومي، خطوط ومحافظ الكاش، وماكينات فوري وأمان.
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
          <div className="text-2xl md:text-3xl font-black text-slate-900 font-mono">
            {stats.totalRemainingDebt.toLocaleString('en-US')} <span className="text-xs font-bold text-slate-500">ج.م</span>
          </div>
          <div className="mt-2 text-xs text-slate-500 flex items-center justify-between font-mono">
            <span>من إجمالي عقود:</span>
            <span className="font-bold text-slate-700">{stats.totalContractsValue.toLocaleString('en-US')} ج.م</span>
          </div>
        </div>

        {/* Overdue Alert Card */}
        <div 
          onClick={() => setActiveAlertTab('overdue')}
          className={`p-5 rounded-2xl border transition cursor-pointer ${
            activeAlertTab === 'overdue' 
              ? 'bg-rose-50/50 border-rose-400 shadow-md ring-2 ring-rose-300' 
              : 'bg-white border-red-100 shadow-sm hover:shadow-md'
          }`}
        >
          <div className="flex items-center justify-between text-slate-500 mb-3">
            <span className="text-xs font-bold text-danger">أقساط متأخرة واجبة التحصيل</span>
            <div className="w-9 h-9 rounded-xl bg-danger/10 text-danger flex items-center justify-center">
              <AlertTriangle className="w-5 h-5" />
            </div>
          </div>
          <div className="text-2xl md:text-3xl font-black text-danger font-mono">
            {overdueCount || stats.overdueInstallments} <span className="text-xs font-bold text-danger/80">قسط متأخر</span>
          </div>
          <div className="mt-2 text-xs text-rose-600 font-bold flex items-center justify-between font-mono">
            <span>بقيمة: {overdueTotal.toLocaleString('en-US')} ج.م</span>
            <span className="text-primary hover:underline">عرض القائمة ↓</span>
          </div>
        </div>

        {/* Total Customers */}
        <div className="p-5 rounded-2xl bg-white border border-slate-200/80 shadow-sm hover:shadow-md transition">
          <div className="flex items-center justify-between text-slate-500 mb-3">
            <span className="text-xs font-bold">إجمالي عملاء السنترال</span>
            <div className="w-9 h-9 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center">
              <Users className="w-5 h-5" />
            </div>
          </div>
          <div className="text-2xl md:text-3xl font-black text-slate-900 font-mono">
            {stats.totalCustomers} <span className="text-xs font-bold text-slate-500">عميل نشط</span>
          </div>
          <div className="mt-2 text-xs text-slate-500 flex items-center justify-between font-mono">
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
          <div className="text-2xl md:text-3xl font-black text-slate-900 font-mono">
            {stats.totalCashInTreasury.toLocaleString('en-US')} <span className="text-xs font-bold text-slate-500">ج.م</span>
          </div>
          <div className="mt-2 text-xs text-slate-500 flex items-center justify-between">
            <span>جاهز للتقفيل اليومي</span>
            <button onClick={() => onNavigate('closing')} className="font-bold text-primary hover:underline">
              التقفيل
            </button>
          </div>
        </div>
      </div>

      {/* ========================================================================= */}
      {/* Interactive Installment Operations Center (الاستحقاق اليومي / المتأخر / القريب) */}
      {/* ========================================================================= */}
      <div className="bg-white rounded-3xl border border-slate-200 shadow-sm overflow-hidden p-5 md:p-6 space-y-5">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-slate-100 pb-4">
          <div>
            <h3 className="text-lg font-black text-slate-900 flex items-center gap-2">
              <Calendar className="w-5 h-5 text-primary" />
              مركز المتابعة والتحصيل الفوري للأقساط
            </h3>
            <p className="text-xs text-slate-500 mt-0.5">
              متابعة مباشرة للمستحق اليوم والمتأخر والقريب، مع أزرار مباشرة لإرسال واتساب، السداد الفوري، وعرض ملف العميل.
            </p>
          </div>

          {/* Search box inside Installment Center */}
          <div className="relative w-full md:w-72">
            <Search className="w-4 h-4 text-slate-400 absolute right-3 top-1/2 -translate-y-1/2" />
            <input
              type="text"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder="بحث باسم العميل، الهاتف، الجهاز..."
              className="w-full pr-9 pl-4 py-2 text-xs bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-primary/20"
            />
          </div>
        </div>

        {/* 4 Interactive Selector Tabs */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
          {/* 1. Overdue Tab */}
          <button
            onClick={() => setActiveAlertTab('overdue')}
            className={`p-3.5 rounded-2xl border text-right transition flex flex-col justify-between ${
              activeAlertTab === 'overdue'
                ? 'bg-red-50 border-red-300 ring-2 ring-red-400/20'
                : 'bg-slate-50/70 border-slate-200 hover:bg-slate-100'
            }`}
          >
            <div className="flex items-center justify-between text-xs mb-1">
              <span className="font-bold text-red-700 flex items-center gap-1">
                <AlertTriangle className="w-3.5 h-3.5 text-red-600" />
                متأخرات واجبة السداد
              </span>
              <span className="px-2 py-0.5 rounded-full bg-red-100 text-red-800 font-mono font-black text-[11px]">
                {overdueCount}
              </span>
            </div>
            <div className="text-base font-black text-slate-900 mt-1 font-mono">
              {overdueTotal.toLocaleString('en-US')} <span className="text-[11px] font-normal text-slate-500">ج.م</span>
            </div>
          </button>

          {/* 2. Due Today Tab */}
          <button
            onClick={() => setActiveAlertTab('today')}
            className={`p-3.5 rounded-2xl border text-right transition flex flex-col justify-between ${
              activeAlertTab === 'today'
                ? 'bg-amber-50 border-amber-300 ring-2 ring-amber-400/20'
                : 'bg-slate-50/70 border-slate-200 hover:bg-slate-100'
            }`}
          >
            <div className="flex items-center justify-between text-xs mb-1">
              <span className="font-bold text-amber-800 flex items-center gap-1">
                <Clock className="w-3.5 h-3.5 text-amber-600" />
                استحقاق اليوم
              </span>
              <span className="px-2 py-0.5 rounded-full bg-amber-100 text-amber-800 font-mono font-black text-[11px]">
                {todayCount}
              </span>
            </div>
            <div className="text-base font-black text-slate-900 mt-1 font-mono">
              {todayTotal.toLocaleString('en-US')} <span className="text-[11px] font-normal text-slate-500">ج.م</span>
            </div>
          </button>

          {/* 3. Upcoming Tab */}
          <button
            onClick={() => setActiveAlertTab('upcoming')}
            className={`p-3.5 rounded-2xl border text-right transition flex flex-col justify-between ${
              activeAlertTab === 'upcoming'
                ? 'bg-blue-50 border-blue-300 ring-2 ring-blue-400/20'
                : 'bg-slate-50/70 border-slate-200 hover:bg-slate-100'
            }`}
          >
            <div className="flex items-center justify-between text-xs mb-1">
              <span className="font-bold text-blue-700 flex items-center gap-1">
                <Calendar className="w-3.5 h-3.5 text-blue-600" />
                قريب (خلال 7 أيام)
              </span>
              <span className="px-2 py-0.5 rounded-full bg-blue-100 text-blue-800 font-mono font-black text-[11px]">
                {upcomingCount}
              </span>
            </div>
            <div className="text-base font-black text-slate-900 mt-1 font-mono">
              {upcomingTotal.toLocaleString('en-US')} <span className="text-[11px] font-normal text-slate-500">ج.م</span>
            </div>
          </button>

          {/* 4. Paid Recently Tab */}
          <button
            onClick={() => setActiveAlertTab('paid')}
            className={`p-3.5 rounded-2xl border text-right transition flex flex-col justify-between ${
              activeAlertTab === 'paid'
                ? 'bg-emerald-50 border-emerald-300 ring-2 ring-emerald-400/20'
                : 'bg-slate-50/70 border-slate-200 hover:bg-slate-100'
            }`}
          >
            <div className="flex items-center justify-between text-xs mb-1">
              <span className="font-bold text-emerald-700 flex items-center gap-1">
                <CheckCircle2 className="w-3.5 h-3.5 text-emerald-600" />
                مسدد مؤخراً
              </span>
              <span className="px-2 py-0.5 rounded-full bg-emerald-100 text-emerald-800 font-mono font-black text-[11px]">
                {paidCount}
              </span>
            </div>
            <div className="text-base font-black text-slate-900 mt-1 font-mono">
              {paidCount} <span className="text-[11px] font-normal text-slate-500">قسط</span>
            </div>
          </button>
        </div>

        {/* List of matching installments */}
        <div className="space-y-2.5">
          {isLoadingAlerts ? (
            <div className="py-12 text-center text-slate-400 text-xs flex items-center justify-center gap-2">
              <RefreshCw className="w-4 h-4 animate-spin text-primary" />
              جاري فحص وتحديث قائمة الاستحقاقات...
            </div>
          ) : filteredAlerts.length === 0 ? (
            <div className="py-12 text-center text-slate-400 text-xs border border-dashed border-slate-200 rounded-2xl bg-slate-50/50">
              لا توجد أقساط مطابقة لهذا التصنيف حالياً.
            </div>
          ) : (
            filteredAlerts.slice(0, 10).map((item) => (
              <div
                key={item.id}
                className="p-4 rounded-2xl bg-white text-slate-900 border border-slate-200 hover:border-primary/40 transition flex flex-col sm:flex-row sm:items-center justify-between gap-3 shadow-sm"
              >
                {/* Right info side */}
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-xl bg-blue-50 border border-blue-100 text-primary flex items-center justify-center flex-shrink-0 font-bold text-xs">
                    <Calendar className="w-5 h-5 text-primary" />
                  </div>
                  <div>
                    <div className="flex items-center gap-2">
                      <h4 className="font-bold text-sm text-slate-900">{item.customerName}</h4>
                      {item.status === 'overdue' && (
                        <span className="px-2.5 py-0.5 rounded-full bg-red-100 text-red-800 text-[10px] font-bold border border-red-200 flex items-center gap-1">
                          <span className="w-1.5 h-1.5 rounded-full bg-red-600 animate-pulse"></span>
                          متأخر منذ {item.delayDays} يوم
                        </span>
                      )}
                      {item.status === 'today' && (
                        <span className="px-2.5 py-0.5 rounded-full bg-amber-100 text-amber-800 text-[10px] font-bold border border-amber-200">
                          مستحق اليوم ⚡
                        </span>
                      )}
                      {item.status === 'paid' && (
                        <span className="px-2.5 py-0.5 rounded-full bg-emerald-100 text-emerald-800 text-[10px] font-bold border border-emerald-200">
                          تم السداد بنجاح ✅
                        </span>
                      )}
                    </div>
                    <div className="flex items-center gap-2.5 text-xs text-slate-500 mt-1 flex-wrap">
                      <span className="font-semibold text-slate-700">{item.deviceName}</span>
                      <span>•</span>
                      <span>{item.installmentNo}</span>
                      <span>•</span>
                      <span className="font-mono text-slate-700 font-bold">استحقاق: {item.dueDate}</span>
                      {item.customerPhone && (
                        <>
                          <span>•</span>
                          <span className="font-mono text-slate-700 flex items-center gap-1">
                            <Phone className="w-3 h-3 text-slate-400" />
                            {item.customerPhone}
                          </span>
                        </>
                      )}
                    </div>
                  </div>
                </div>

                {/* Amount & Direct Action Buttons */}
                <div className="flex items-center justify-between sm:justify-end gap-3 pt-2 sm:pt-0 border-t sm:border-t-0 border-slate-100">
                  <div className="text-left sm:text-right pl-2 sm:pl-4">
                    <span className="text-[11px] text-slate-500 block">المبلغ المطلوب:</span>
                    <span className="text-base font-black text-slate-900 font-mono">
                      {item.dueAmount.toLocaleString('en-US')} <span className="text-[10px] text-slate-500">ج.م</span>
                    </span>
                  </div>

                  <div className="flex items-center gap-1.5">
                    {/* 1. WhatsApp Button */}
                    <button
                      onClick={() => openWhatsAppReminder(
                        item.customerPhone,
                        item.customerName,
                        item.dueAmount,
                        item.dueDate,
                        item.deviceName
                      )}
                      title="إرسال تذكير بالواتساب"
                      className="p-2 rounded-xl bg-emerald-50 hover:bg-emerald-100 text-emerald-700 border border-emerald-200 font-bold transition shadow-sm active:scale-95 flex items-center gap-1 text-xs"
                    >
                      <MessageCircle className="w-4 h-4" />
                      <span className="hidden md:inline">واتساب</span>
                    </button>

                    {/* 2. Quick Pay Button */}
                    {item.status !== 'paid' && (
                      <button
                        onClick={() => handleDirectDashboardPay(item)}
                        title="سداد القسط فوراً وتوريده للدرج"
                        className="px-3 py-2 rounded-xl bg-emerald-600 hover:bg-emerald-500 text-white font-bold transition shadow-sm active:scale-95 flex items-center gap-1 text-xs"
                      >
                        <Zap className="w-3.5 h-3.5 fill-current" />
                        <span>سداد سريع</span>
                      </button>
                    )}

                    {/* 3. Open Customer Details Button */}
                    <button
                      onClick={() => onNavigate('customers', item.customerName)}
                      title="فتح ملف وعقود العميل"
                      className="p-2 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold border border-slate-200 transition active:scale-95 flex items-center gap-1 text-xs"
                    >
                      <Users className="w-4 h-4 text-primary" />
                      <span className="hidden lg:inline">ملف العميل</span>
                      <ChevronLeft className="w-3.5 h-3.5 text-slate-400" />
                    </button>
                  </div>
                </div>
              </div>
            ))
          )}

          {filteredAlerts.length > 10 && (
            <div className="pt-2 text-center">
              <button
                onClick={() => onNavigate('installments')}
                className="text-xs font-bold text-primary hover:underline inline-flex items-center gap-1"
              >
                عرض باقي قائمة المستحقات في صفحة الأقساط ({filteredAlerts.length - 10} قسط إضافي)
                <ArrowUpRight className="w-3.5 h-3.5" />
              </button>
            </div>
          )}
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
