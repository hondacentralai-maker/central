import React, { useEffect, useState } from 'react';
import {
  AlertCircle,
  CheckCircle2,
  Eye,
  EyeOff,
  History,
  KeyRound,
  Loader2,
  Mail,
  RefreshCw,
  ShieldCheck,
  UserRound,
} from 'lucide-react';
import type { Profile } from '../types';
import { supabase } from '../utils/supabase';

interface AccountSecurityPageProps {
  profile: Profile;
  onProfileUpdated: (profile: Profile) => void;
}

interface SecuritySettings {
  pin_set_at: string | null;
}

interface SecurityActivity {
  id: string;
  event_type: string;
  created_at: string;
}

const emptySettings: SecuritySettings = {
  pin_set_at: null,
};

const eventLabels: Record<string, string> = {
  password_changed: 'تم تغيير كلمة المرور',
  profile_updated: 'تم تحديث بيانات الحساب',
  pin_updated: 'تم تحديث PIN الإضافي',
};

const formatDate = (value: string | null | undefined) => value
  ? new Intl.DateTimeFormat('ar-EG', { dateStyle: 'medium', timeStyle: 'short' }).format(new Date(value))
  : 'غير متاح';

const hashValue = async (value: string) => {
  const bytes = new TextEncoder().encode(value);
  const digest = await crypto.subtle.digest('SHA-256', bytes);
  return Array.from(new Uint8Array(digest)).map((byte) => byte.toString(16).padStart(2, '0')).join('');
};

export const AccountSecurityPage: React.FC<AccountSecurityPageProps> = ({ profile, onProfileUpdated }) => {
  const [settings, setSettings] = useState<SecuritySettings>(emptySettings);
  const [activities, setActivities] = useState<SecurityActivity[]>([]);
  const [authEmail, setAuthEmail] = useState('');
  const [originalAuthEmail, setOriginalAuthEmail] = useState('');
  const [fullName, setFullName] = useState(profile.full_name);
  const [phone, setPhone] = useState(profile.phone || '');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [pin, setPin] = useState('');
  const [confirmPin, setConfirmPin] = useState('');
  const [showPin, setShowPin] = useState(false);
  const [isLoading, setIsLoading] = useState(true);
  const [busyAction, setBusyAction] = useState('');
  const [message, setMessage] = useState('');
  const [error, setError] = useState('');

  const currentDeviceLabel = isMobileDevice() ? 'هاتف أو جهاز لوحي' : 'متصفح سطح مكتب';

  const showResult = (nextMessage: string) => {
    setError('');
    setMessage(nextMessage);
  };

  const logActivity = async (eventType: string) => {
    await supabase.from('security_activity').insert({ user_id: profile.id, event_type: eventType, metadata: { source: 'account_security' } });
  };

  const loadSecurityData = async () => {
    setIsLoading(true);
    setError('');
    const [{ data: userData }, { data: settingsData, error: settingsError }, { data: activityData }] = await Promise.all([
      supabase.auth.getUser(),
      supabase.from('account_security_settings').select('pin_set_at').maybeSingle(),
      supabase.from('security_activity').select('id, event_type, created_at').order('created_at', { ascending: false }).limit(8),
    ]);

    if (settingsError) setError('تعذر تحميل إعدادات الأمان. نفّذ ترحيل إعدادات الأمان قبل استخدام هذه الصفحة.');
    if (userData.user) {
      setAuthEmail(userData.user.email || '');
      setOriginalAuthEmail(userData.user.email || '');
      }
    const nextSettings = { ...emptySettings, ...(settingsData || {}) } as SecuritySettings;
    setSettings(nextSettings);
    setActivities((activityData || []) as SecurityActivity[]);
    setIsLoading(false);
  };

  useEffect(() => {
    void loadSecurityData();
  }, []);

  const saveProfile = async (event: React.FormEvent) => {
    event.preventDefault();
    if (!fullName.trim()) return setError('اكتب اسم الحساب أولاً.');
    setBusyAction('profile');
    setMessage('');
    setError('');
    const { error: updateError } = await supabase.rpc('update_own_profile', {
      p_full_name: fullName.trim(),
      p_phone: phone.trim() || null,
    });
    if (updateError) setError(updateError.message || 'تعذر حفظ بيانات الحساب.');
    else {
      onProfileUpdated({ ...profile, full_name: fullName.trim(), phone: phone.trim() || null });
      await logActivity('profile_updated');
      showResult('تم حفظ بيانات الحساب.');
    }
    setBusyAction('');
  };

  const updateEmail = async (event: React.FormEvent) => {
    event.preventDefault();
    if (!authEmail.trim() || authEmail.trim() === originalAuthEmail) return;
    setBusyAction('email');
    setMessage('');
    setError('');
    const { error: updateError } = await supabase.auth.updateUser({ email: authEmail.trim() });
    if (updateError) setError(updateError.message || 'تعذر تحديث البريد الإلكتروني.');
    else showResult('أرسلنا رسالة تأكيد إلى البريد الجديد قبل اعتماد التغيير.');
    setBusyAction('');
  };

  const changePassword = async (event: React.FormEvent) => {
    event.preventDefault();
    if (newPassword.length < 8) return setError('يجب أن تتكون كلمة المرور من 8 أحرف على الأقل.');
    if (newPassword !== confirmPassword) return setError('تأكيد كلمة المرور غير مطابق.');
    setBusyAction('password');
    setMessage('');
    setError('');
    const { error: updateError } = await supabase.auth.updateUser({ password: newPassword });
    if (updateError) setError(updateError.message || 'تعذر تغيير كلمة المرور.');
    else {
      setNewPassword('');
      setConfirmPassword('');
      await logActivity('password_changed');
      showResult('تم تغيير كلمة المرور بنجاح.');
    }
    setBusyAction('');
  };

  const savePin = async (event: React.FormEvent) => {
    event.preventDefault();
    if (!/^\d{4,8}$/.test(pin)) return setError('يجب أن يتكون PIN من 4 إلى 8 أرقام.');
    if (pin !== confirmPin) return setError('تأكيد PIN غير مطابق.');
    setBusyAction('pin');
    setMessage('');
    setError('');
    const pinHash = await hashValue(pin);
    const { error: saveError } = await supabase.from('account_security_settings').upsert({ user_id: profile.id, pin_hash: pinHash, pin_set_at: new Date().toISOString() });
    if (saveError) setError(saveError.message || 'تعذر حفظ PIN.');
    else {
      setPin('');
      setConfirmPin('');
      setSettings((current) => ({ ...current, pin_set_at: new Date().toISOString() }));
      await logActivity('pin_updated');
      showResult('تم تحديث PIN كعامل أمان إضافي.');
    }
    setBusyAction('');
  };

  return (
    <section className="space-y-5" dir="rtl">
      <div className="flex flex-col gap-2 sm:flex-row sm:items-end sm:justify-between">
        <div>
          <div className="mb-2 inline-flex items-center gap-2 rounded-full bg-blue-50 px-3 py-1 text-xs font-bold text-primary"><ShieldCheck className="h-4 w-4" /> الحساب والأمان</div>
          <h2 className="text-2xl font-black text-slate-900">إدارة الحساب وتسجيل الدخول</h2>
          <p className="mt-1 text-sm leading-6 text-slate-500">تحكم في بيانات الحساب، كلمة المرور وPIN من مكان واحد.</p>
        </div>
        <button type="button" onClick={() => void loadSecurityData()} disabled={isLoading} className="inline-flex items-center justify-center gap-2 self-start rounded-xl border border-slate-200 bg-white px-3 py-2 text-xs font-bold text-slate-600 transition hover:bg-slate-50 disabled:opacity-50">
          <RefreshCw className={`h-4 w-4 ${isLoading ? 'animate-spin' : ''}`} /> تحديث الحالة
        </button>
      </div>

      {message && <div className="flex items-center gap-2 rounded-xl border border-emerald-200 bg-emerald-50 p-3 text-sm font-bold text-emerald-800"><CheckCircle2 className="h-5 w-5" />{message}</div>}
      {error && <div className="flex items-center gap-2 rounded-xl border border-rose-200 bg-rose-50 p-3 text-sm font-bold text-rose-800"><AlertCircle className="h-5 w-5" />{error}</div>}

      <div className="grid gap-5 xl:grid-cols-2">
        <div className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
          <div className="mb-4 flex items-center gap-3"><span className="rounded-xl bg-blue-50 p-2 text-primary"><UserRound className="h-5 w-5" /></span><div><h3 className="font-black text-slate-900">بيانات الحساب</h3><p className="text-xs text-slate-500">الاسم ورقم الهاتف الظاهرين داخل النظام</p></div></div>
          <form onSubmit={saveProfile} className="space-y-3">
            <label className="block text-xs font-bold text-slate-600">الاسم الكامل<input value={fullName} onChange={(event) => setFullName(event.target.value)} className="mt-1.5 w-full rounded-xl border border-slate-200 px-3 py-2.5 text-sm font-bold outline-none focus:border-primary focus:ring-4 focus:ring-blue-100" /></label>
            <label className="block text-xs font-bold text-slate-600">رقم الهاتف<input value={phone} onChange={(event) => setPhone(event.target.value)} dir="ltr" className="mt-1.5 w-full rounded-xl border border-slate-200 px-3 py-2.5 text-left text-sm font-bold outline-none focus:border-primary focus:ring-4 focus:ring-blue-100" /></label>
            <button type="submit" disabled={busyAction === 'profile'} className="inline-flex items-center gap-2 rounded-xl bg-primary px-4 py-2.5 text-xs font-black text-white transition hover:bg-primary-dark disabled:opacity-50">{busyAction === 'profile' && <Loader2 className="h-4 w-4 animate-spin" />} حفظ بيانات الحساب</button>
          </form>
        </div>

        <div className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
          <div className="mb-4 flex items-center gap-3"><span className="rounded-xl bg-violet-50 p-2 text-violet-700"><Mail className="h-5 w-5" /></span><div><h3 className="font-black text-slate-900">البريد الإلكتروني</h3><p className="text-xs text-slate-500">تغيير البريد يتطلب تأكيدًا من البريد الجديد</p></div></div>
          <form onSubmit={updateEmail} className="space-y-3">
            <label className="block text-xs font-bold text-slate-600">بريد تسجيل الدخول<input type="email" value={authEmail} onChange={(event) => setAuthEmail(event.target.value)} dir="ltr" className="mt-1.5 w-full rounded-xl border border-slate-200 px-3 py-2.5 text-left text-sm font-bold outline-none focus:border-primary focus:ring-4 focus:ring-blue-100" /></label>
            <button type="submit" disabled={busyAction === 'email'} className="inline-flex items-center gap-2 rounded-xl border border-slate-200 px-4 py-2.5 text-xs font-black text-slate-700 transition hover:bg-slate-50 disabled:opacity-50">{busyAction === 'email' && <Loader2 className="h-4 w-4 animate-spin" />} طلب تغيير البريد</button>
          </form>
        </div>
      </div>

      <div className="grid gap-5 xl:grid-cols-2">
        <div className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
          <div className="mb-4 flex items-center gap-3"><span className="rounded-xl bg-amber-50 p-2 text-amber-700"><KeyRound className="h-5 w-5" /></span><div><h3 className="font-black text-slate-900">كلمة المرور</h3><p className="text-xs text-slate-500">استخدم كلمة مرور قوية من 8 أحرف على الأقل</p></div></div>
          <form onSubmit={changePassword} className="space-y-3">
            <input type="password" value={newPassword} onChange={(event) => setNewPassword(event.target.value)} placeholder="كلمة المرور الجديدة" autoComplete="new-password" className="w-full rounded-xl border border-slate-200 px-3 py-2.5 text-sm outline-none focus:border-primary focus:ring-4 focus:ring-blue-100" />
            <input type="password" value={confirmPassword} onChange={(event) => setConfirmPassword(event.target.value)} placeholder="تأكيد كلمة المرور" autoComplete="new-password" className="w-full rounded-xl border border-slate-200 px-3 py-2.5 text-sm outline-none focus:border-primary focus:ring-4 focus:ring-blue-100" />
            <button type="submit" disabled={busyAction === 'password'} className="inline-flex items-center gap-2 rounded-xl bg-slate-900 px-4 py-2.5 text-xs font-black text-white transition hover:bg-slate-800 disabled:opacity-50">{busyAction === 'password' && <Loader2 className="h-4 w-4 animate-spin" />} تغيير كلمة المرور</button>
          </form>
        </div>


      </div>

      <div className="grid gap-5 xl:grid-cols-2">

      </div>



      <div className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
        <div className="mb-4 flex items-center gap-3"><span className="rounded-xl bg-slate-100 p-2 text-slate-700"><History className="h-5 w-5" /></span><div><h3 className="font-black text-slate-900">نشاط الأمان</h3><p className="text-xs text-slate-500">آخر التغييرات الأمنية على هذا الحساب</p></div></div>
        {activities.length === 0 ? <p className="text-sm text-slate-400">لا توجد أنشطة مسجلة بعد.</p> : <div className="divide-y divide-slate-100">{activities.map((activity) => <div key={activity.id} className="flex items-center justify-between gap-3 py-3 text-xs"><span className="font-bold text-slate-700">{eventLabels[activity.event_type] || activity.event_type}</span><time className="text-slate-400">{formatDate(activity.created_at)}</time></div>)}</div>}
      </div>
    </section>
  );
};
