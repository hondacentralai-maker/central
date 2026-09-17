import React from 'react';
import { LayoutDashboard, CreditCard, PlusCircle, Receipt, Menu } from 'lucide-react';
import { NavTab } from './Sidebar';

interface BottomNavProps {
  activeTab: NavTab;
  onTabChange: (tab: NavTab) => void;
  onOpenMobileMenu: () => void;
  onQuickCollect: () => void;
  role: string;
}

export const BottomNav: React.FC<BottomNavProps> = ({
  activeTab,
  onTabChange,
  onOpenMobileMenu,
  onQuickCollect,
  role,
}) => {
  const canCollect = ['admin', 'manager', 'cashier', 'collector'].includes(role);
  return (
    <nav className="md:hidden fixed bottom-0 left-0 right-0 z-40 bg-white border-t border-slate-200 px-3 py-1.5 flex items-center justify-around shadow-lg">
      <button
        onClick={() => onTabChange('dashboard')}
        className={`flex flex-col items-center gap-1 py-1 px-2 rounded-lg text-[11px] font-medium transition ${
          activeTab === 'dashboard' ? 'text-primary font-bold' : 'text-slate-500'
        }`}
      >
        <LayoutDashboard className="w-5 h-5" />
        الرئيسية
      </button>

      <button
        onClick={() => onTabChange('installments')}
        className={`flex flex-col items-center gap-1 py-1 px-2 rounded-lg text-[11px] font-medium transition ${
          activeTab === 'installments' ? 'text-primary font-bold' : 'text-slate-500'
        }`}
      >
        <CreditCard className="w-5 h-5" />
        الأقساط
      </button>

      {/* Floating Center Quick Collect Button */}
      {canCollect ? (
        <button
          onClick={onQuickCollect}
          aria-label="تسجيل تحصيل سريع"
          className="flex flex-col items-center -mt-5 rounded-full bg-primary p-3 text-white shadow-lg shadow-primary/30 transition active:scale-95 focus:outline-none focus:ring-4 focus:ring-blue-200"
        >
          <PlusCircle className="w-6 h-6" />
        </button>
      ) : (
        <button
          onClick={() => onTabChange(role === 'reports' ? 'reports' : 'customers')}
          className="flex flex-col items-center gap-1 py-1 px-2 rounded-lg text-[11px] font-medium text-slate-500"
        >
          <PlusCircle className="w-5 h-5" />
          {role === 'reports' ? 'التقارير' : 'العملاء'}
        </button>
      )}

      <button
        onClick={() => onTabChange('treasury')}
        className={`flex flex-col items-center gap-1 py-1 px-2 rounded-lg text-[11px] font-medium transition ${
          activeTab === 'treasury' ? 'text-primary font-bold' : 'text-slate-500'
        }`}
      >
        <Receipt className="w-5 h-5" />
        الخزينة
      </button>

      <button
        onClick={onOpenMobileMenu}
        className="flex flex-col items-center gap-1 py-1 px-2 rounded-lg text-[11px] font-medium text-slate-500"
      >
        <Menu className="w-5 h-5" />
        المزيد
      </button>
    </nav>
  );
};
