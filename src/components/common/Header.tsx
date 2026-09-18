import React, { useEffect, useState } from 'react';
import { Bell, CheckCircle2, ChevronDown, Cloud, CloudOff, KeyRound, LogOut, RefreshCw, ShieldCheck, Smartphone, UserRound } from 'lucide-react';
import type { Profile } from '../../types';
import type { NavTab } from './Sidebar';

interface HeaderProps {
  onRefresh?: () => void;
  onSignOut: () => Promise<void>;
  isOnline: boolean;
  profile: Profile;
  onNavigate?: (tab: NavTab) => void;
}

const roleLabels: Record<string, string> = {
  admin: 'مدير النظام',
  manager: 'مدير الفرع',
  cashier: 'كاشير',
  collector: 'محصّل',
  sales: 'مبيعات',
  reports: 'تقارير',
};

export const Header: React.FC<HeaderProps> = ({ onRefresh, onSignOut, isOnline: initiallyOnline, profile, onNavigate }) => {
  const [isOnline, setIsOnline] = useState(initiallyOnline);
  const [isUserMenuOpen, setIsUserMenuOpen] = useState(false);

  useEffect(() => {
    const markOnline = () => setIsOnline(true);
    const markOffline = () => setIsOnline(false);
    window.addEventListener('online', markOnline);
    window.addEventListener('offline', markOffline);
    return () => {
      window.removeEventListener('online', markOnline);
      window.removeEventListener('offline', markOffline);
    };
  }, []);

  const branchName = profile.branch?.name || 'فرع غير محدد';
  const navigateToAccountSecurity = () => {
    setIsUserMenuOpen(false);
    onNavigate?.('account_security');
  };

  return (
    <header className="sticky top-0 z-40 border-b border-slate-200 bg-white px-4 py-3 shadow-sm" dir="rtl">
      <div className="mx-auto flex max-w-[96rem] items-center justify-between gap-3">
        <div className="flex min-w-0 items-center gap-3">
          <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-primary text-white shadow-md shadow-primary/20">
            <Smartphone className="h-5 w-5" aria-hidden="true" />
          </div>
          <div className="min-w-0">
            <div className="flex items-center gap-2">
              <h1 className="truncate text-base font-black leading-tight text-slate-900 md:text-lg">سنترال المركزي</h1>
              <span className="hidden rounded-md bg-blue-50 px-1.5 py-0.5 text-[10px] font-black text-primary sm:inline">تشغيل</span>
            </div>
            <p className="hidden text-xs text-slate-500 sm:block">{branchName} • عمليات الأقساط والخزينة</p>
          </div>
        </div>

        <div className="flex items-center gap-1.5 sm:gap-2">
          <div
            className={`hidden items-center gap-1.5 rounded-lg border px-2.5 py-1.5 text-[11px] font-bold md:flex ${
              isOnline ? 'border-blue-100 bg-blue-50 text-blue-800' : 'border-amber-200 bg-amber-50 text-amber-800'
            }`}
            aria-label={isOnline ? 'الجلسة موثقة والاتصال متاح' : 'لا يوجد اتصال بالشبكة'}
          >
            {isOnline ? <Cloud className="h-3.5 w-3.5" aria-hidden="true" /> : <CloudOff className="h-3.5 w-3.5" aria-hidden="true" />}
            {isOnline ? 'جلسة موثقة • جاهز للحفظ' : 'دون اتصال • لا يمكن الحفظ'}
          </div>

          {onRefresh && (
            <button onClick={onRefresh} title="تحديث بيانات الشاشة" aria-label="تحديث بيانات الشاشة" className="rounded-lg p-2 text-slate-600 transition hover:bg-slate-100 hover:text-primary focus:outline-none focus:ring-2 focus:ring-blue-300">
              <RefreshCw className="h-4 w-4" aria-hidden="true" />
            </button>
          )}

          <button type="button" aria-label="الإشعارات" className="relative rounded-lg p-2 text-slate-600 transition hover:bg-slate-100 focus:outline-none focus:ring-2 focus:ring-blue-300">
            <Bell className="h-5 w-5" aria-hidden="true" />
          </button>

          <div className="relative">
            <button
              type="button"
              onClick={() => setIsUserMenuOpen((value) => !value)}
              aria-expanded={isUserMenuOpen}
              aria-haspopup="menu"
              className="flex items-center gap-2 rounded-xl border border-slate-200 bg-white py-1 pl-1.5 pr-2 transition hover:bg-slate-50 focus:outline-none focus:ring-2 focus:ring-blue-300"
            >
              <div className="hidden text-right sm:block">
                <p className="max-w-28 truncate text-xs font-black text-slate-800">{profile.full_name}</p>
                <p className="text-[10px] font-bold text-slate-500">{roleLabels[profile.role] || profile.role}</p>
              </div>
              <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-slate-900 text-xs font-black text-white">
                {profile.full_name.trim().slice(0, 1)}
              </div>
              <ChevronDown className="hidden h-3.5 w-3.5 text-slate-400 sm:block" aria-hidden="true" />
            </button>

            {isUserMenuOpen && (
                <div className="absolute left-0 mt-2 w-64 overflow-hidden rounded-xl border border-slate-200 bg-white py-1 shadow-xl shadow-slate-900/10" role="menu">
                <div className="border-b border-slate-100 px-3 py-2.5">
                  <p className="text-xs font-black text-slate-800">{profile.full_name}</p>
                  <p className="mt-0.5 text-[11px] text-slate-500">{branchName} • {roleLabels[profile.role] || profile.role}</p>
                </div>
                <div className="flex items-center gap-1.5 px-3 py-2 text-[11px] font-semibold text-emerald-700">
                  <CheckCircle2 className="h-3.5 w-3.5" aria-hidden="true" />
                  الصلاحية متحققة لهذه الجلسة
                </div>
                <div className="border-t border-slate-100 px-2 py-1.5">
                  <p className="px-2 py-1 text-[10px] font-black uppercase tracking-wide text-slate-400">الحساب</p>
                  <button type="button" role="menuitem" onClick={navigateToAccountSecurity} className="flex w-full items-center gap-2 rounded-lg px-2 py-2 text-right text-xs font-bold text-slate-700 transition hover:bg-slate-50 focus:outline-none focus:bg-slate-50">
                    <UserRound className="h-4 w-4 text-slate-500" aria-hidden="true" />
                    بيانات الحساب والإعدادات
                  </button>
                </div>
                <div className="border-t border-slate-100 px-2 py-1.5">
                  <p className="px-2 py-1 text-[10px] font-black uppercase tracking-wide text-slate-400">الأمان</p>
                  <button type="button" role="menuitem" onClick={navigateToAccountSecurity} className="flex w-full items-center gap-2 rounded-lg px-2 py-2 text-right text-xs font-bold text-slate-700 transition hover:bg-slate-50 focus:outline-none focus:bg-slate-50">
                    <ShieldCheck className="h-4 w-4 text-primary" aria-hidden="true" />
                    الأمان وتسجيل الدخول
                  </button>
                  <button type="button" role="menuitem" onClick={navigateToAccountSecurity} className="flex w-full items-center gap-2 rounded-lg px-2 py-2 text-right text-xs font-bold text-slate-700 transition hover:bg-slate-50 focus:outline-none focus:bg-slate-50">
                    <KeyRound className="h-4 w-4 text-amber-600" aria-hidden="true" />
                    الأجهزة والجلسات
                  </button>
                </div>
                <button
                  type="button"
                  role="menuitem"
                  onClick={() => void onSignOut()}
                  className="flex w-full items-center gap-2 border-t border-slate-100 px-3 py-2.5 text-right text-xs font-bold text-rose-700 transition hover:bg-rose-50 focus:outline-none focus:bg-rose-50"
                >
                  <LogOut className="h-4 w-4" aria-hidden="true" />
                  تسجيل الخروج من هذا الجهاز
                </button>
              </div>
            )}
          </div>
        </div>
      </div>
    </header>
  );
};
import React, { useEffect, useState } from 'react';
import { Bell, CheckCircle2, ChevronDown, Cloud, CloudOff, LogOut, RefreshCw, ShieldCheck, Smartphone } from 'lucide-react';
import type { Profile } from '../../types';

interface HeaderProps {
  onRefresh?: () => void;
  onSignOut: () => Promise<void>;
  isOnline: boolean;
  profile: Profile;
}

const roleLabels: Record<string, string> = {
  admin: 'مدير النظام',
  manager: 'مدير الفرع',
  cashier: 'كاشير',
  collector: 'محصّل',
  sales: 'مبيعات',
  reports: 'تقارير',
};

export const Header: React.FC<HeaderProps> = ({ onRefresh, onSignOut, isOnline: initiallyOnline, profile }) => {
  const [isOnline, setIsOnline] = useState(initiallyOnline);
  const [isUserMenuOpen, setIsUserMenuOpen] = useState(false);

  useEffect(() => {
    const markOnline = () => setIsOnline(true);
    const markOffline = () => setIsOnline(false);
    window.addEventListener('online', markOnline);
    window.addEventListener('offline', markOffline);
    return () => {
      window.removeEventListener('online', markOnline);
      window.removeEventListener('offline', markOffline);
    };
  }, []);

  const branchName = profile.branch?.name || 'فرع غير محدد';

  return (
    <header className="sticky top-0 z-40 border-b border-slate-200 bg-white px-4 py-3 shadow-sm" dir="rtl">
      <div className="mx-auto flex max-w-[96rem] items-center justify-between gap-3">
        <div className="flex min-w-0 items-center gap-3">
          <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-primary text-white shadow-md shadow-primary/20">
            <Smartphone className="h-5 w-5" aria-hidden="true" />
          </div>
          <div className="min-w-0">
            <div className="flex items-center gap-2">
              <h1 className="truncate text-base font-black leading-tight text-slate-900 md:text-lg">سنترال المركزي</h1>
              <span className="hidden rounded-md bg-blue-50 px-1.5 py-0.5 text-[10px] font-black text-primary sm:inline">تشغيل</span>
            </div>
            <p className="hidden text-xs text-slate-500 sm:block">{branchName} • عمليات الأقساط والخزينة</p>
          </div>
        </div>

        <div className="flex items-center gap-1.5 sm:gap-2">
          <div
            className={`hidden items-center gap-1.5 rounded-lg border px-2.5 py-1.5 text-[11px] font-bold md:flex ${
              isOnline ? 'border-blue-100 bg-blue-50 text-blue-800' : 'border-amber-200 bg-amber-50 text-amber-800'
            }`}
            aria-label={isOnline ? 'الجلسة موثقة والاتصال متاح' : 'لا يوجد اتصال بالشبكة'}
          >
            {isOnline ? <Cloud className="h-3.5 w-3.5" aria-hidden="true" /> : <CloudOff className="h-3.5 w-3.5" aria-hidden="true" />}
            {isOnline ? 'جلسة موثقة • جاهز للحفظ' : 'دون اتصال • لا يمكن الحفظ'}
          </div>

          {onRefresh && (
            <button onClick={onRefresh} title="تحديث بيانات الشاشة" aria-label="تحديث بيانات الشاشة" className="rounded-lg p-2 text-slate-600 transition hover:bg-slate-100 hover:text-primary focus:outline-none focus:ring-2 focus:ring-blue-300">
              <RefreshCw className="h-4 w-4" aria-hidden="true" />
            </button>
          )}

          <button type="button" aria-label="الإشعارات" className="relative rounded-lg p-2 text-slate-600 transition hover:bg-slate-100 focus:outline-none focus:ring-2 focus:ring-blue-300">
            <Bell className="h-5 w-5" aria-hidden="true" />
          </button>

          <div className="relative">
            <button
              type="button"
              onClick={() => setIsUserMenuOpen((value) => !value)}
              aria-expanded={isUserMenuOpen}
              aria-haspopup="menu"
              className="flex items-center gap-2 rounded-xl border border-slate-200 bg-white py-1 pl-1.5 pr-2 transition hover:bg-slate-50 focus:outline-none focus:ring-2 focus:ring-blue-300"
            >
              <div className="hidden text-right sm:block">
                <p className="max-w-28 truncate text-xs font-black text-slate-800">{profile.full_name}</p>
                <p className="text-[10px] font-bold text-slate-500">{roleLabels[profile.role] || profile.role}</p>
              </div>
              <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-slate-900 text-xs font-black text-white">
                {profile.full_name.trim().slice(0, 1)}
              </div>
              <ChevronDown className="hidden h-3.5 w-3.5 text-slate-400 sm:block" aria-hidden="true" />
            </button>

            {isUserMenuOpen && (
              <div className="absolute left-0 mt-2 w-56 overflow-hidden rounded-xl border border-slate-200 bg-white py-1 shadow-xl shadow-slate-900/10" role="menu">
                <div className="border-b border-slate-100 px-3 py-2.5">
                  <p className="text-xs font-black text-slate-800">{profile.full_name}</p>
                  <p className="mt-0.5 text-[11px] text-slate-500">{branchName} • {roleLabels[profile.role] || profile.role}</p>
                </div>
                <div className="flex items-center gap-1.5 px-3 py-2 text-[11px] font-semibold text-emerald-700">
                  <CheckCircle2 className="h-3.5 w-3.5" aria-hidden="true" />
                  الصلاحية متحققة لهذه الجلسة
                </div>
                <button
                  type="button"
                  role="menuitem"
                  onClick={() => void onSignOut()}
                  className="flex w-full items-center gap-2 border-t border-slate-100 px-3 py-2.5 text-right text-xs font-bold text-rose-700 transition hover:bg-rose-50 focus:outline-none focus:bg-rose-50"
                >
                  <LogOut className="h-4 w-4" aria-hidden="true" />
                  تسجيل الخروج من هذا الجهاز
                </button>
              </div>
            )}
          </div>
        </div>
      </div>
    </header>
  );
};
