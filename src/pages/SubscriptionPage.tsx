import React, { useEffect, useState } from 'react';
import { BadgeCheck, CalendarClock, CheckCircle2, KeyRound, Loader2, RefreshCw, ShieldCheck } from 'lucide-react';
import type { Profile } from '../types';
import { supabase } from '../utils/supabase';

interface SubscriptionPageProps {
  profile: Profile;
}

interface SubscriptionStatus {
  trial_ends_at: string | null;
  subscription_ends_at: string | null;
  effective_until: string | null;
  is_subscribed: boolean;
}

const formatDate = (value: string | null) => value
  ? new Intl.DateTimeFormat('ar-EG', { dateStyle: 'long' }).format(new Date(value))
  : 'غير محدد';

const getDaysRemaining = (value: string | null) => value
  ? Math.max(0, Math.ceil((new Date(value).getTime() - Date.now()) / 86_400_000))
  : 0;

export const SubscriptionPage: React.FC<SubscriptionPageProps> = ({ profile }) => {
  const [status, setStatus] = useState<SubscriptionStatus | null>(null);
  const [code, setCode] = useState('');
  const [isLoading, setIsLoading] = useState(true);
  const [isRedeeming, setIsRedeeming] = useState(false);
  const [message, setMessage] = useState('');
  const [error, setError] = useState('');

  const loadStatus = async () => {
    setIsLoading(true);
    setError('');
    const { data, error: statusError } = await supabase.rpc('get_subscription_status');
    if (statusError) setError(statusError.message || 'تعذر تحميل حالة الاشتراك.');
    else setStatus(data as SubscriptionStatus);
    setIsLoading(false);
  };

  useEffect(() => {
    void loadStatus();
  }, []);

  const redeem = async (event: React.FormEvent) => {
    event.preventDefault();
    if (!code.trim()) return;
    setIsRedeeming(true);
    setMessage('');
    setError('');
    const { data, error: redeemError } = await supabase.rpc('redeem_subscription_code', {
      p_code: code.trim(),
    });
    if (redeemError) {
      setError(redeemError.message || 'الكود غير صالح أو تم استخدامه من قبل.');
    } else {
      setMessage(`تم تفعيل الاشتراك لمدة ${data?.duration_months || ''} شهرًا حتى ${formatDate(data?.active_until || null)}.`);
      setCode('');
      await loadStatus();
    }
    setIsRedeeming(false);
  };

  const activeUntil = status?.effective_until || null;
  const daysRemaining = getDaysRemaining(activeUntil);

  return (
    <section className="space-y-6" dir="rtl">
      <div className="rounded-3xl bg-gradient-to-l from-slate-950 via-blue-950 to-primary p-6 text-white shadow-xl shadow-blue-900/15 md:p-8">
        <div className="flex flex-col gap-5 md:flex-row md:items-center md:justify-between">
          <div>
            <div className="mb-3 inline-flex items-center gap-2 rounded-full bg-white/10 px-3 py-1 text-xs font-bold text-blue-100">
              <ShieldCheck className="h-4 w-4" /> اشتراك آمن مرتبط بالحساب
            </div>
            <h1 className="text-2xl font-black md:text-3xl">الاشتراك وفترة السماح</h1>
            <p className="mt-2 max-w-xl text-sm leading-7 text-blue-100">
              فعّل كودًا جديدًا لتمديد استخدام النظام. كل كود يُستخدم مرة واحدة ويرتبط بهذا الحساب فقط.
            </p>
          </div>
          <BadgeCheck className="hidden h-20 w-20 text-blue-200/70 md:block" />
        </div>
      </div>

      <div className="grid gap-4 md:grid-cols-3">
        <div className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
          <div className="flex items-center gap-2 text-sm font-bold text-slate-500"><CalendarClock className="h-4 w-4 text-primary" /> نهاية الوصول</div>
          {isLoading ? <Loader2 className="mt-4 h-5 w-5 animate-spin text-primary" /> : <p className="mt-3 text-lg font-black text-slate-900">{formatDate(activeUntil)}</p>}
        </div>
        <div className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
          <div className="flex items-center gap-2 text-sm font-bold text-slate-500"><BadgeCheck className="h-4 w-4 text-emerald-600" /> الأيام المتبقية</div>
          <p className="mt-3 text-lg font-black text-slate-900">{daysRemaining} يوم</p>
        </div>
        <div className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
          <div className="flex items-center gap-2 text-sm font-bold text-slate-500"><KeyRound className="h-4 w-4 text-amber-600" /> نوع الوصول</div>
          <p className="mt-3 text-lg font-black text-slate-900">{status?.is_subscribed ? 'اشتراك مدفوع' : 'فترة سماح مجانية'}</p>
        </div>
      </div>

      <div className="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm md:p-8">
        <div className="mb-5">
          <h2 className="text-lg font-black text-slate-900">تفعيل كود الاشتراك</h2>
          <p className="mt-1 text-sm text-slate-500">أدخل الكود الذي تم إصداره لك لتمديد الحساب بالأشهر المحددة.</p>
        </div>
        {message && <div className="mb-4 flex items-center gap-2 rounded-xl border border-emerald-200 bg-emerald-50 p-3 text-sm font-bold text-emerald-800"><CheckCircle2 className="h-5 w-5" />{message}</div>}
        {error && <div className="mb-4 rounded-xl border border-rose-200 bg-rose-50 p-3 text-sm font-bold text-rose-800">{error}</div>}
        <form onSubmit={redeem} className="flex flex-col gap-3 sm:flex-row">
          <input
            value={code}
            onChange={(event) => setCode(event.target.value.toUpperCase())}
            placeholder="CENTRAL-XXXX-XXXX-XXXX"
            className="min-w-0 flex-1 rounded-xl border border-slate-200 px-4 py-3 text-left font-mono text-sm tracking-wider outline-none transition focus:border-primary focus:ring-4 focus:ring-blue-100"
            dir="ltr"
          />
          <button type="submit" disabled={isRedeeming || !code.trim()} className="inline-flex items-center justify-center gap-2 rounded-xl bg-primary px-6 py-3 text-sm font-black text-white shadow-lg shadow-primary/20 transition hover:bg-primary-dark disabled:cursor-not-allowed disabled:opacity-50">
            {isRedeeming ? <Loader2 className="h-4 w-4 animate-spin" /> : <KeyRound className="h-4 w-4" />}
            تفعيل الكود
          </button>
          <button type="button" onClick={() => void loadStatus()} disabled={isLoading} className="inline-flex items-center justify-center rounded-xl border border-slate-200 px-4 py-3 text-slate-600 transition hover:bg-slate-50 disabled:opacity-50" title="تحديث الحالة">
            <RefreshCw className={`h-4 w-4 ${isLoading ? 'animate-spin' : ''}`} />
          </button>
        </form>
        <p className="mt-4 text-xs leading-6 text-slate-400">الحساب: {profile.full_name} • المؤسسة الخاصة: {profile.organization_id ? 'مرتبطة' : 'غير مرتبطة'}</p>
      </div>
    </section>
  );
};
