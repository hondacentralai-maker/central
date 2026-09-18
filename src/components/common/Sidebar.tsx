import React from 'react';
import { 
  LayoutDashboard, 
  Users, 
  CreditCard, 
  Receipt, 
  Wallet, 
  Layers, 
  Store, 
  Truck, 
  FileText,
  BarChart3, 
  X
} from 'lucide-react';
import type { LucideIcon } from 'lucide-react';

export type NavTab = 
  | 'dashboard' 
  | 'customers' 
  | 'installments' 
  | 'treasury' 
  | 'closing' 
  | 'wallets' 
  | 'pos' 
  | 'fast_credit' 
  | 'suppliers' 
  | 'reports';

interface SidebarProps {
  activeTab: NavTab;
  onTabChange: (tab: NavTab) => void;
  isOpenMobile: boolean;
  onCloseMobile: () => void;
  role: string;
}

export const Sidebar: React.FC<SidebarProps> = ({
  activeTab,
  onTabChange,
  isOpenMobile,
  onCloseMobile,
  role,
}) => {
  const navItems: Array<{ id: NavTab; label: string; icon: LucideIcon; badge?: string; count?: string }> = [
    { id: 'dashboard' as NavTab, label: 'لوحة التحكم', icon: LayoutDashboard },
    { id: 'installments' as NavTab, label: 'الأقساط والتحصيل', icon: CreditCard, badge: 'رئيسي' },
    { id: 'customers' as NavTab, label: 'العملاء والعقود', icon: Users },
    { id: 'treasury' as NavTab, label: 'الخزينة والدرج', icon: Receipt },
    { id: 'closing' as NavTab, label: 'التقفيل اليومي', icon: FileText },
    { id: 'wallets' as NavTab, label: 'خطوط ومحافظ الكاش', icon: Wallet },
    { id: 'pos' as NavTab, label: 'ماكينات فوري وأمان', icon: Layers },
    { id: 'fast_credit' as NavTab, label: 'عملاء الأجل السريع', icon: Store },
    { id: 'suppliers' as NavTab, label: 'الموردين والمشتريات', icon: Truck },
    { id: 'reports' as NavTab, label: 'التقارير المالية', icon: BarChart3 },
  ];

  const allowedTabsByRole: Record<string, NavTab[]> = {
    admin: navItems.map((item) => item.id),
    manager: navItems.map((item) => item.id),
    cashier: ['dashboard', 'installments', 'customers', 'treasury', 'closing', 'wallets', 'pos'],
    collector: ['dashboard', 'installments', 'customers'],
    sales: ['dashboard', 'customers', 'installments'],
    reports: ['dashboard', 'reports'],
  };
  const visibleItems = navItems.filter((item) => (allowedTabsByRole[role] || []).includes(item.id));

  const handleSelect = (tab: NavTab) => {
    onTabChange(tab);
    onCloseMobile();
  };

  return (
    <>
      {/* Mobile backdrop */}
      {isOpenMobile && (
        <div 
          onClick={onCloseMobile}
          className="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-40 md:hidden transition-opacity"
        />
      )}

      {/* Sidebar container */}
      <aside className={`
        fixed md:static top-0 right-0 z-50 h-full w-64 bg-white border-l border-slate-200 flex flex-col transition-transform duration-200 ease-in-out
        ${isOpenMobile ? 'translate-x-0' : 'translate-x-full md:translate-x-0'}
      `}>
        {/* Mobile drawer header */}
        <div className="flex md:hidden items-center justify-between p-4 border-b border-slate-200">
          <span className="font-bold text-slate-800">قائمة النظام</span>
          <button 
            onClick={onCloseMobile}
            className="p-1.5 text-slate-500 hover:bg-slate-100 rounded-lg"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Navigation list */}
        <div className="flex-1 overflow-y-auto p-3 space-y-1">
          <div className="px-3 py-2 text-[11px] font-bold text-slate-400 uppercase tracking-wider">
            الوحدات والعمليات
          </div>

          {visibleItems.map((item) => {
            const Icon = item.icon;
            const isActive = activeTab === item.id;
            return (
              <button
                key={item.id}
                onClick={() => handleSelect(item.id)}
                className={`
                  w-full flex items-center justify-between px-3 py-2.5 rounded-xl text-sm font-medium transition
                  ${isActive 
                    ? 'bg-primary text-white shadow-sm shadow-primary/25 font-semibold' 
                    : 'text-slate-700 hover:bg-slate-50 hover:text-slate-900'}
                `}
              >
                <div className="flex items-center gap-3">
                  <Icon className={`w-5 h-5 ${isActive ? 'text-white' : 'text-slate-500'}`} />
                  <span>{item.label}</span>
                </div>
                {item.badge && (
                  <span className={`text-[10px] px-1.5 py-0.5 rounded font-bold ${
                    isActive ? 'bg-white/20 text-white' : 'bg-primary/10 text-primary'
                  }`}>
                    {item.badge}
                  </span>
                )}
                {item.count && (
                  <span className={`text-[11px] ${isActive ? 'text-blue-100' : 'text-slate-400'}`}>
                    {item.count}
                  </span>
                )}
              </button>
            );
          })}
        </div>

        {/* Footer info */}
        <div className="p-3 border-t border-slate-200 bg-slate-50 text-[11px] text-slate-500 text-center">
          سنترال المركزي • صلاحيات حسب الدور
        </div>
      </aside>
    </>
  );
};
