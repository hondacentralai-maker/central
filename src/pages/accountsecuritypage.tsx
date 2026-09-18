import React, { useEffect, useMemo, useState } from 'react';
import {
  AlertCircle,
  CheckCircle2,
  Copy,
  Eye,
  EyeOff,
  History,
  KeyRound,
  Laptop,
  Loader2,
  LogOut,
  Mail,
  Phone,
  RefreshCw,
  ShieldCheck,
  Smartphone,
  UserRound,
} from 'lucide-react';
import type { Profile } from '../types';
import { supabase } from '../utils/supabase';

interface AccountSecurityPageProps {
  profile: Profile;
  onProfileUpdated: (profile: Profile) => void;
  onSignOut: () => Promise<void>;
}

interface SecuritySettings {
  recovery_email: string | null;
  recovery_phone: string | null;
  pin_set_at: string | null;
  recovery_codes_generated_at: string | null;
}

interface SecurityActivity {
  id: string;
  event_type: string;
  created_at: string;
}

interface MfaFactor {
  id: string;
  factor_type: string;
  friendly_name?: string | null;
  status: string;
}

const emptySettings: SecuritySettings = {
  recovery_email: null,
  recovery_phone: null,
  pin_set_at: null,
  recovery_codes_generated_at: null,
};

const eventLabels: Record<string, string> = {
  password_changed: 'تم تغيير كلمة المرور',
  profile_updated: 'تم تحديث بيانات الحساب',
  recovery_updated: 'تم تحديث بيانات الاسترداد',
  pin_updated: 'تم تحديث PIN الإضافي',
  recovery_codes_generated: 'تم إنشاء رموز استرداد جديدة',
  mfa_enabled: 'تم تفعيل التحقق بخطوتين',
  mfa_disabled: 'تم إيقاف التحقق بخطوتين',
  global_sign_out: 'تم تسجيل الخروج من كل الجلسات',
};

const formatDate = (value: string | null | undefined) => value
  ? new Intl.DateTimeFormat('ar-EG', { dateStyle: 'medium', timeStyle: 'short' }).format(new Date(value))
  : 'غير متاح';

const hashValue = async (value: string) => {
  const bytes = new TextEncoder().encode(value);
  const digest = await crypto.subtle.digest('SHA-256', bytes);
  return Array.from(new Uint8Array(digest)).map((byte) => byte.toString(16).padStart(2, '0')).join('');
};

const createRecoveryCodes = () => Array.from({ length: 8 }, () => {
  const bytes = new Uint8Array(10);
  crypto.getRandomValues(bytes);
  const value = Array.from(bytes).map((byte) => (byte % 36).toString(36)).join('').toUpperCase();
  return `${value.slice(0, 5)}-${value.slice(5)}`;
});

const isMobileDevice = () => /Android|iPhone|iPad|iPod|Mobile/i.test(navigator.userAgent);

export const AccountSecurityPage: React.FC<AccountSecurityPageProps> = ({ profile, onProfileUpdated, onSignOut }) => {
  const [settings, setSettings] = useState<SecuritySettings>(emptySettings);
  const [activities, setActivities] = useState<SecurityActivity[]>([]);
  const [authEmail, setAuthEmail] = useState('');
  const [originalAuthEmail, setOriginalAuthEmail] = useState('');
  const [lastSignInAt, setLastSignInAt] = useState<string | null>(null);
  const [mfaFactors, setMfaFactors] = useState<MfaFactor[]>([]);
  const [fullName, setFullName] = useState(profile.full_name);
  const [phone, setPhone] = useState(profile.phone || '');
  const [recoveryEmail, setRecoveryEmail] = useState('');
  const [recoveryPhone, setRecoveryPhone] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [pin, setPin] = useState('');
  const [confirmPin, setConfirmPin] = useState('');
  const [showPin, setShowPin] = useState(false);
  const [enrollment, setEnrollment] = useState<{ factorId: string; qrCode: string; secret: string } | null>(null);
  const [mfaCode, setMfaCode] = useState('');
  const [recoveryCodes, setRecoveryCodes] = useState<string[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [busyAction, setBusyAction] = useState('');
  const [message, setMessage] = useState('');
  const [error, setError] = useState('');

  const verifiedMfaFactors = useMemo(() => mfaFactors.filter((factor) => factor.status === 'verified'), [mfaFactors]);
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
    const [{ data: userData }, { data: settingsData, error: settingsError }, { data: activityData }, { data: factorData }] = await Promise.all([
      supabase.auth.getUser(),
      supabase.from('account_security_settings').select('recovery_email, recovery_phone, pin_set_at, recovery_codes_generated_at').maybeSingle(),
      supabase.from('security_activity').select('id, event_type, created_at').order('created_at', { ascending: false }).limit(8),
      supabase.auth.mfa.listFactors(),
    ]);

    if (settingsError) setError('تعذر تحميل إعدادات الأمان. نفّذ ترحيل إعدادات الأمان قبل استخدام هذه الصفحة.');
    if (userData.user) {
      setAuthEmail(userData.user.email || '');
      setOriginalAuthEmail(userData.user.email || '');
      setLastSignInAt(userData.user.last_sign_in_at || null);
    }
    const nextSettings = { ...emptySettings, ...(settingsData || {}) } as SecuritySettings;
    setSettings(nextSettings);
    setRecoveryEmail(nextSettings.recovery_email || '');
    setRecoveryPhone(nextSettings.recovery_phone || '');
    setActivities((activityData || []) as SecurityActivity[]);
    setMfaFactors(((factorData as any)?.all || []) as MfaFactor[]);
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
    const { error: updateError } = await supabase.from('profiles').update({ full_name: fullName.trim(), phone: phone.trim() || null }).eq('id', profile.id);
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

  const saveRecovery = async (event: React.FormEvent) => {
    event.preventDefault();
    setBusyAction('recovery');
    setMessage('');
    setError('');
    const { error: saveError } = await supabase.from('account_security_settings').upsert({
      user_id: profile.id,
      recovery_email: recoveryEmail.trim() || null,
      recovery_phone: recoveryPhone.trim() || null,
    });
    if (saveError) setError(saveError.message || 'تعذر حفظ بيانات الاسترداد.');
    else {
      setSettings((current) => ({ ...current, recovery_email: recoveryEmail.trim() || null, recovery_phone: recoveryPhone.trim() || null }));
      await logActivity('recovery_updated');
      showResult('تم حفظ بيانات الاسترداد.');
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

  const generateCodes = async () => {
    setBusyAction('codes');
    setMessage('');
    setError('');
    const codes = createRecoveryCodes();
    const hashes = await Promise.all(codes.map(hashValue));
    const { error: saveError } = await supabase.rpc('save_recovery_code_hashes', { p_hashes: hashes });
    if (saveError) setError(saveError.message || 'تعذر إنشاء رموز الاسترداد.');
    else {
      setRecoveryCodes(codes);
      setSettings((current) => ({ ...current, recovery_codes_generated_at: new Date().toISOString() }));
      await logActivity('recovery_codes_generated');
      showResult('احفظ هذه الرموز في مكان آمن. لن نعرضها مرة أخرى بعد مغادرة الصفحة.');
    }
    setBusyAction('');
  };

  const startMfa = async () => {
    setBusyAction('mfa');
    setMessage('');
    setError('');
    const { data, error: enrollError } = await supabase.auth.mfa.enroll({ factorType: 'totp', friendlyName: 'Central' });
    if (enrollError || !data?.totp) setError(enrollError?.message || 'تعذر بدء إعداد التحقق بخطوتين.');
    else setEnrollment({ factorId: data.id, qrCode: data.totp.qr_code, secret: data.totp.secret });
    setBusyAction('');
  };

  const verifyMfa = async (event: React.FormEvent) => {
    event.preventDefault();
    if (!enrollment || !/^\d{6}$/.test(mfaCode)) return setError('أدخل الرمز المكون من 6 أرقام.');
    setBusyAction('mfa-verify');
    setMessage('');
    setError('');
    const { data: challenge, error: challengeError } = await supabase.auth.mfa.challenge({ factorId: enrollment.factorId });
    if (challengeError || !challenge) setError(challengeError?.message || 'تعذر إنشاء تحدي التحقق.');
    else {
      const { error: verifyError } = await supabase.auth.mfa.verify({ factorId: enrollment.factorId, challengeId: challenge.id, code: mfaCode });
      if (verifyError) setError(verifyError.message || 'رمز التحقق غير صحيح.');
      else {
        setEnrollment(null);
        setMfaCode('');
        await supabase.auth.refreshSession();
        await logActivity('mfa_enabled');
        showResult('تم تفعيل التحقق بخطوتين.');
        await loadSecurityData();
      }
    }
    setBusyAction('');
  };

  const disableMfa = async (factorId: string) => {
    if (!window.confirm('هل تريد إيقاف التحقق بخطوتين لهذا الحساب؟')) return;
    setBusyAction('mfa-disable');
    const { error: unenrollError } = await supabase.auth.mfa.unenroll({ factorId });
    if (unenrollError) setError(unenrollError.message || 'تعذر إيقاف التحقق بخطوتين.');
    else {
      await logActivity('mfa_disabled');
      showResult('تم إيقاف التحقق بخطوتين.');
      await loadSecurityData();
    }
    setBusyAction('');
  };

  const signOutEverywhere = async () => {
    if (!window.confirm('سيتم تسجيل الخروج من كل الأجهزة. هل تريد المتابعة؟')) return;
    setBusyAction('global-signout');
    await logActivity('global_sign_out');
    const { error: signOutError } = await supabase.auth.signOut({ scope: 'global' });
    if (signOutError) setError(signOutError.message || 'تعذر تسجيل الخروج من كل الجلسات.');
    else await onSignOut();
    setBusyAction('');
  };

  return (
    <section className="space-y-5" dir="rtl">
      <div className="flex flex-col gap-2 sm:flex-row sm:items-end sm:justify-between">
        <div>
          <div className="mb-2 inline-flex items-center gap-2 rounded-full bg-blue-50 px-3 py-1 text-xs font-bold text-primary"><ShieldCheck className="h-4 w-4" /> الحساب والأمان</div>
          <h2 className="text-2xl font-black text-slate-900">إدارة الحساب وتسجيل الدخول</h2>
          <p className="mt-1 text-sm leading-6 text-slate-500">تحكم في بيانات الحساب، وسائل الاسترداد، الأجهزة والجلسات من مكان واحد.</p>
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

        <div className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
          <div className="mb-4 flex items-center gap-3"><span className="rounded-xl bg-emerald-50 p-2 text-emerald-700"><ShieldCheck className="h-5 w-5" /></span><div><h3 className="font-black text-slate-900">التحقق بخطوتين</h3><p className="text-xs text-slate-500">حماية إضافية عبر تطبيق المصادقة</p></div></div>
          {verifiedMfaFactors.length > 0 ? <div className="space-y-3">{verifiedMfaFactors.map((factor) => <div key={factor.id} className="flex items-center justify-between rounded-xl border border-emerald-200 bg-emerald-50 p-3"><div className="flex items-center gap-2 text-xs font-bold text-emerald-800"><CheckCircle2 className="h-4 w-4" /> مفعل: {factor.friendly_name || 'تطبيق المصادقة'}</div><button type="button" onClick={() => void disableMfa(factor.id)} disabled={busyAction === 'mfa-disable'} className="text-xs font-bold text-rose-700 hover:underline">إيقاف</button></div>)}</div> : enrollment ? <form onSubmit={verifyMfa} className="space-y-3"><p className="text-xs leading-6 text-slate-600">امسح رمز QR من تطبيق المصادقة ثم أدخل الرمز الحالي.</p><img src={enrollment.qrCode} alt="رمز إعداد التحقق بخطوتين" className="mx-auto h-44 w-44 rounded-xl border border-slate-200 p-2" /><p className="break-all rounded-xl bg-slate-50 p-3 text-center font-mono text-[11px] text-slate-600">{enrollment.secret}</p><input value={mfaCode} onChange={(event) => setMfaCode(event.target.value.replace(/\D/g, '').slice(0, 6))} inputMode="numeric" placeholder="رمز من 6 أرقام" className="w-full rounded-xl border border-slate-200 px-3 py-2.5 text-center font-mono text-sm tracking-[0.4em] outline-none focus:border-primary focus:ring-4 focus:ring-blue-100" /><button type="submit" disabled={busyAction === 'mfa-verify'} className="inline-flex items-center gap-2 rounded-xl bg-primary px-4 py-2.5 text-xs font-black text-white disabled:opacity-50">{busyAction === 'mfa-verify' && <Loader2 className="h-4 w-4 animate-spin" />} تأكيد التفعيل</button></form> : <button type="button" onClick={() => void startMfa()} disabled={busyAction === 'mfa'} className="inline-flex items-center gap-2 rounded-xl bg-primary px-4 py-2.5 text-xs font-black text-white disabled:opacity-50">{busyAction === 'mfa' && <Loader2 className="h-4 w-4 animate-spin" />} تفعيل التحقق بخطوتين</button>}
        </div>
      </div>

      <div className="grid gap-5 xl:grid-cols-2">
        <div className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
          <div className="mb-4 flex items-center gap-3"><span className="rounded-xl bg-blue-50 p-2 text-primary"><Phone className="h-5 w-5" /></span><div><h3 className="font-black text-slate-900">بيانات الاسترداد</h3><p className="text-xs text-slate-500">وسيلتان لاستعادة الحساب عند فقدان الوصول</p></div></div>
          <form onSubmit={saveRecovery} className="space-y-3">
            <input type="email" value={recoveryEmail} onChange={(event) => setRecoveryEmail(event.target.value)} placeholder="بريد استرداد مختلف (اختياري)" dir="ltr" className="w-full rounded-xl border border-slate-200 px-3 py-2.5 text-left text-sm outline-none focus:border-primary focus:ring-4 focus:ring-blue-100" />
            <input value={recoveryPhone} onChange={(event) => setRecoveryPhone(event.target.value)} placeholder="هاتف الاسترداد" dir="ltr" className="w-full rounded-xl border border-slate-200 px-3 py-2.5 text-left text-sm outline-none focus:border-primary focus:ring-4 focus:ring-blue-100" />
            <button type="submit" disabled={busyAction === 'recovery'} className="inline-flex items-center gap-2 rounded-xl border border-slate-200 px-4 py-2.5 text-xs font-black text-slate-700 transition hover:bg-slate-50 disabled:opacity-50">{busyAction === 'recovery' && <Loader2 className="h-4 w-4 animate-spin" />} حفظ بيانات الاسترداد</button>
          </form>
        </div>

        <div className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
          <div className="mb-4 flex items-center gap-3"><span className="rounded-xl bg-slate-100 p-2 text-slate-700"><KeyRound className="h-5 w-5" /></span><div><h3 className="font-black text-slate-900">PIN إضافي</h3><p className="text-xs text-slate-500">عامل إضافي للحماية، وليس وسيلة الاسترداد الوحيدة</p></div></div>
          <form onSubmit={savePin} className="space-y-3">
            <div className="relative"><input type={showPin ? 'text' : 'password'} value={pin} onChange={(event) => setPin(event.target.value.replace(/\D/g, '').slice(0, 8))} inputMode="numeric" placeholder="PIN من 4 إلى 8 أرقام" className="w-full rounded-xl border border-slate-200 px-3 py-2.5 text-left font-mono text-sm tracking-[0.3em] outline-none focus:border-primary focus:ring-4 focus:ring-blue-100" />{pin && <button type="button" onClick={() => setShowPin((value) => !value)} className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400">{showPin ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}</button>}</div>
            <input type={showPin ? 'text' : 'password'} value={confirmPin} onChange={(event) => setConfirmPin(event.target.value.replace(/\D/g, '').slice(0, 8))} inputMode="numeric" placeholder="تأكيد PIN" className="w-full rounded-xl border border-slate-200 px-3 py-2.5 text-left font-mono text-sm tracking-[0.3em] outline-none focus:border-primary focus:ring-4 focus:ring-blue-100" />
            <div className="flex items-center justify-between gap-3"><span className="text-[11px] text-slate-400">{settings.pin_set_at ? `آخر تحديث: ${formatDate(settings.pin_set_at)}` : 'لم يتم إعداد PIN بعد'}</span><button type="submit" disabled={busyAction === 'pin'} className="inline-flex items-center gap-2 rounded-xl bg-slate-900 px-4 py-2.5 text-xs font-black text-white disabled:opacity-50">{busyAction === 'pin' && <Loader2 className="h-4 w-4 animate-spin" />} حفظ PIN</button></div>
          </form>
        </div>
      </div>

      <div className="grid gap-5 xl:grid-cols-2">
        <div className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
          <div className="mb-4 flex items-center gap-3"><span className="rounded-xl bg-amber-50 p-2 text-amber-700"><KeyRound className="h-5 w-5" /></span><div><h3 className="font-black text-slate-900">رموز الاسترداد</h3><p className="text-xs text-slate-500">رموز تستخدم مرة واحدة عند فقدان عامل التحقق</p></div></div>
          {recoveryCodes.length > 0 && <div className="mb-3 grid grid-cols-2 gap-2 rounded-xl bg-slate-50 p-3">{recoveryCodes.map((code) => <code key={code} className="rounded-lg bg-white px-2 py-1.5 text-center font-mono text-xs font-bold text-slate-800">{code}</code>)}</div>}
          <div className="flex items-center justify-between gap-3"><span className="text-[11px] text-slate-400">{settings.recovery_codes_generated_at ? `آخر إنشاء: ${formatDate(settings.recovery_codes_generated_at)}` : 'لم تُنشأ رموز بعد'}</span><button type="button" onClick={() => void generateCodes()} disabled={busyAction === 'codes'} className="inline-flex items-center gap-2 rounded-xl border border-slate-200 px-4 py-2.5 text-xs font-black text-slate-700 transition hover:bg-slate-50 disabled:opacity-50">{busyAction === 'codes' && <Loader2 className="h-4 w-4 animate-spin" />} إنشاء رموز جديدة</button></div>
          {recoveryCodes.length > 0 && <button type="button" onClick={() => void navigator.clipboard?.writeText(recoveryCodes.join('\n'))} className="mt-3 inline-flex items-center gap-2 text-xs font-bold text-primary hover:underline"><Copy className="h-3.5 w-3.5" /> نسخ الرموز</button>}
        </div>

        <div className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
          <div className="mb-4 flex items-center gap-3"><span className="rounded-xl bg-cyan-50 p-2 text-cyan-700">{isMobileDevice() ? <Smartphone className="h-5 w-5" /> : <Laptop className="h-5 w-5" />}</span><div><h3 className="font-black text-slate-900">الأجهزة والجلسات</h3><p className="text-xs text-slate-500">الجلسة الحالية وتسجيل الخروج العام</p></div></div>
          <div className="flex items-center justify-between gap-3 rounded-xl border border-blue-100 bg-blue-50 p-3"><div><p className="text-xs font-black text-slate-800">{currentDeviceLabel} • الجلسة الحالية</p><p className="mt-1 text-[11px] text-slate-500">آخر دخول: {formatDate(lastSignInAt)}</p></div><span className="rounded-full bg-emerald-100 px-2 py-1 text-[10px] font-black text-emerald-700">نشطة</span></div>
          <button type="button" onClick={() => void signOutEverywhere()} disabled={busyAction === 'global-signout'} className="mt-3 inline-flex items-center gap-2 rounded-xl border border-rose-200 px-4 py-2.5 text-xs font-black text-rose-700 transition hover:bg-rose-50 disabled:opacity-50">{busyAction === 'global-signout' && <Loader2 className="h-4 w-4 animate-spin" />}<LogOut className="h-4 w-4" /> تسجيل الخروج من كل الأجهزة</button>
        </div>
      </div>

      <div className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
        <div className="mb-4 flex items-center gap-3"><span className="rounded-xl bg-slate-100 p-2 text-slate-700"><History className="h-5 w-5" /></span><div><h3 className="font-black text-slate-900">نشاط الأمان</h3><p className="text-xs text-slate-500">آخر التغييرات الأمنية على هذا الحساب</p></div></div>
        {activities.length === 0 ? <p className="text-sm text-slate-400">لا توجد أنشطة مسجلة بعد.</p> : <div className="divide-y divide-slate-100">{activities.map((activity) => <div key={activity.id} className="flex items-center justify-between gap-3 py-3 text-xs"><span className="font-bold text-slate-700">{eventLabels[activity.event_type] || activity.event_type}</span><time className="text-slate-400">{formatDate(activity.created_at)}</time></div>)}</div>}
      </div>
    </section>
  );
};
