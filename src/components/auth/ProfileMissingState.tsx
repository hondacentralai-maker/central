import React, { useState } from 'react';
import { KeyRound, Loader2, LogOut, ShieldAlert } from 'lucide-react';
import { supabase } from '../../utils/supabase';

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
      <SubscriptionRenewal />
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

const SubscriptionRenewal: React.FC = () => {
  const [code, setCode] = useState('');
  const [message, setMessage] = useState('');
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const redeem = async (event: React.FormEvent) => {
    event.preventDefault();
    if (!code.trim()) return;
    setIsLoading(true);
    setMessage('');
    setError('');
    const { data, error: redeemError } = await supabase.rpc('redeem_subscription_code', { p_code: code.trim() });
    if (redeemError) setError(redeemError.message || 'الكود غير صالح أو تم استخدامه من قبل.');
    else {
      setMessage(`تم تفعيل الاشتراك حتى ${new Intl.DateTimeFormat('ar-EG', { dateStyle: 'long' }).format(new Date(data.active_until))}. جاري فتح النظام...`);
      setTimeout(() => window.location.reload(), 1200);
    }
    setIsLoading(false);
  };

  return (
    <div className="mt-5 rounded-2xl border border-blue-100 bg-blue-50 p-4 text-right">
      <h2 className="flex items-center gap-2 text-sm font-black text-blue-950"><KeyRound className="h-4 w-4" /> هل لديك كود اشتراك؟</h2>
      <p className="mt-1 text-xs leading-6 text-blue-800">أدخل الكود لتمديد الحساب ثم حاول فتح النظام مرة أخرى.</p>
      <form onSubmit={redeem} className="mt-3 flex gap-2">
        <input value={code} onChange={(event) => setCode(event.target.value.toUpperCase())} placeholder="CENTRAL-XXXX-XXXX-XXXX" dir="ltr" className="min-w-0 flex-1 rounded-xl border border-blue-200 bg-white px-3 py-2 text-left font-mono text-xs outline-none focus:border-blue-500" />
        <button type="submit" disabled={isLoading || !code.trim()} className="inline-flex items-center gap-1 rounded-xl bg-blue-700 px-3 py-2 text-xs font-bold text-white disabled:opacity-50">
          {isLoading ? <Loader2 className="h-3.5 w-3.5 animate-spin" /> : <KeyRound className="h-3.5 w-3.5" />} تفعيل
        </button>
      </form>
      {message && <p className="mt-2 text-xs font-bold text-emerald-700">{message}</p>}
      {error && <p className="mt-2 text-xs font-bold text-rose-700">{error}</p>}
    </div>
  );
};
