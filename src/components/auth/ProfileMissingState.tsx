import React from 'react';
import { LogOut, ShieldAlert } from 'lucide-react';

interface ProfileMissingStateProps {
  reason?: string;
  onSignOut: () => Promise<void>;
}

export const ProfileMissingState: React.FC<ProfileMissingStateProps> = ({ reason, onSignOut }) => (
  <main className="grid min-h-screen place-items-center bg-slate-100 p-5" dir="rtl">
    <section className="w-full max-w-md rounded-3xl border border-slate-200 bg-white p-7 text-center shadow-xl shadow-slate-900/5">
      <div className="mx-auto flex h-14 w-14 items-center justify-center rounded-2xl bg-amber-50 text-amber-700">
        <ShieldAlert className="h-7 w-7" aria-hidden="true" />
      </div>
      <h1 className="mt-5 text-xl font-black text-slate-900">الحساب يحتاج تفعيلًا</h1>
      <p className="mt-3 text-sm leading-7 text-slate-600">
        تم التحقق من تسجيل الدخول، لكن لا توجد بطاقة مستخدم فعّالة أو فرع مُعيّن لهذا الحساب. لحماية البيانات، لا يمكن عرض أي سجلات مالية الآن.
      </p>
      {reason && <p className="mt-3 rounded-lg bg-slate-50 p-2 text-xs text-slate-500">{reason}</p>}
      <button
        type="button"
        onClick={() => void onSignOut()}
        className="mt-6 inline-flex items-center gap-2 rounded-xl bg-slate-900 px-4 py-2.5 text-sm font-bold text-white transition hover:bg-slate-800 focus:outline-none focus:ring-4 focus:ring-slate-200"
      >
        <LogOut className="h-4 w-4" aria-hidden="true" />
        العودة لتسجيل الدخول
      </button>
    </section>
  </main>
);
