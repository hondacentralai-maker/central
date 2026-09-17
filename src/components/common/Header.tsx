import React from 'react';
import { Smartphone, Bell, RefreshCw, CheckCircle2 } from 'lucide-react';

interface HeaderProps {
  onRefresh?: () => void;
  isOnline: boolean;
}

export const Header: React.FC<HeaderProps> = ({ onRefresh, isOnline }) => {
  return (
    <header className="sticky top-0 z-40 bg-white border-b border-slate-200 px-4 py-3 flex items-center justify-between shadow-sm">
      <div className="flex items-center gap-3">
        <div className="w-10 h-10 rounded-xl bg-primary flex items-center justify-center text-white shadow-md shadow-primary/20">
          <Smartphone className="w-5 h-5" />
        </div>
        <div>
          <div className="flex items-center gap-2">
            <h1 className="font-bold text-base md:text-lg text-slate-900 leading-tight">
              سنترال المركزي
            </h1>
            <span className="text-[11px] font-semibold px-2 py-0.5 rounded-full bg-emerald-50 text-emerald-700 border border-emerald-200 flex items-center gap-1">
              <span className="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></span>
              سحابي
            </span>
          </div>
          <p className="text-xs text-slate-500 hidden sm:block">نظام إدارة الأقساط والمبيعات والخزينة</p>
        </div>
      </div>

      <div className="flex items-center gap-2 sm:gap-3">
        {/* Sync / Refresh button */}
        {onRefresh && (
          <button
            onClick={onRefresh}
            title="تحديث البيانات"
            className="p-2 text-slate-600 hover:text-primary hover:bg-slate-100 rounded-lg transition"
          >
            <RefreshCw className="w-4 h-4" />
          </button>
        )}

        {/* Status */}
        <div className="hidden md:flex items-center gap-2 px-3 py-1.5 rounded-lg bg-slate-50 border border-slate-200 text-xs">
          <CheckCircle2 className="w-4 h-4 text-emerald-600" />
          <span className="text-slate-600 font-medium">قاعدة البيانات السحابية متصلة</span>
        </div>

        {/* Notification Bell */}
        <button className="relative p-2 text-slate-600 hover:bg-slate-100 rounded-lg transition">
          <Bell className="w-5 h-5" />
          <span className="absolute top-1.5 right-1.5 w-2 h-2 rounded-full bg-danger"></span>
        </button>
      </div>
    </header>
  );
};
