import React, { useState } from 'react';
import { Smartphone, Lock, Mail, Eye, EyeOff, AlertCircle, ShieldCheck, UserPlus, ArrowRight } from 'lucide-react';
import { supabase } from '../../utils/supabase';

interface LoginPageProps {
  onLoginSuccess: (user: { email: string; name: string; role: string }) => void;
}

export const LoginPage: React.FC<LoginPageProps> = ({ onLoginSuccess }) => {
  const [mode, setMode] = useState<'login' | 'signup'>('login');
  const [identifier, setIdentifier] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [fullName, setFullName] = useState('');
  const [phone, setPhone] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [rememberMe, setRememberMe] = useState(true);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');
  const [notice, setNotice] = useState('');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    setError('');
    setNotice('');

    try {
      if (mode === 'signup') {
        if (!fullName.trim()) {
          setError('اكتب الاسم الكامل أولًا.');
          return;
        }
        if (password.length < 8) {
          setError('كلمة المرور يجب أن تكون 8 أحرف على الأقل.');
          return;
        }
        if (password !== confirmPassword) {
          setError('تأكيد كلمة المرور غير مطابق.');
          return;
        }

        const { data, error: signupError } = await supabase.auth.signUp({
          email: identifier.trim(),
          password,
          options: {
            data: {
              full_name: fullName.trim(),
              phone: phone.trim(),
            },
          },
        });

        if (signupError) {
          setError(signupError.message || 'تعذر إنشاء الحساب.');
          return;
        }

        if (data.session) await supabase.auth.signOut();
        setPassword('');
        setConfirmPassword('');
        setMode('login');
        setNotice(
          data.session
            ? 'تم إنشاء الحساب وتفعيله تلقائيًا. لديك فترة سماح مجانية لمدة شهر.'
            : 'تم إنشاء الحساب. افتح رسالة تأكيد البريد الإلكتروني، ثم سجّل الدخول. لديك فترة سماح مجانية لمدة شهر.'
        );
        return;
      }

      const { data, error: authError } = await supabase.auth.signInWithPassword({
        email: identifier,
        password: password,
      });

      if (!authError && data?.user) {
        const userInfo = {
          email: data.user.email || identifier,
          name: data.user.user_metadata?.full_name || 'مدير النظام',
          role: data.user.user_metadata?.role || 'admin',
        };
        onLoginSuccess(userInfo);
        return;
      }

      const normalizedAuthError = (authError?.message || '').toLowerCase();
      setError(
        normalizedAuthError.includes('email not confirmed')
          ? 'البريد الإلكتروني غير مؤكد. افتح رسالة التأكيد المرسلة إلى بريدك ثم حاول تسجيل الدخول.'
          : authError?.message || 'بيانات الدخول غير صحيحة أو انتهت فترة السماح.'
      );
    } catch (err: any) {
      setError(err.message || 'حدث خطأ أثناء تسجيل الدخول');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-slate-100 flex items-center justify-center p-4 selection:bg-primary selection:text-white font-sans" dir="rtl">
      <div className="max-w-md w-full bg-white rounded-3xl p-6 sm:p-8 shadow-2xl border border-slate-100 space-y-6 animate-in fade-in zoom-in-95 duration-200">
        {/* Brand Header */}
        <div className="text-center space-y-2">
          <div className="w-14 h-14 rounded-2xl bg-gradient-to-tr from-blue-700 to-primary flex items-center justify-center text-white mx-auto shadow-xl shadow-primary/25">
            <Smartphone className="w-8 h-8" />
          </div>
          <h1 className="text-2xl font-black text-slate-900 tracking-tight">سنترال المركزي</h1>
          <p className="text-xs text-slate-500 font-medium">نظام سحابي متكامل للمبيعات والأقساط والخزينة</p>
          <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-blue-50 text-primary border border-blue-100 text-xs font-bold mt-1">
            <ShieldCheck className="w-3.5 h-3.5" />
            يدعم تعدد تسجيل الدخول من أجهزة مختلفة
          </div>
        </div>

        {error && (
          <div className="p-3.5 rounded-xl bg-danger/10 border border-danger/20 text-danger text-xs flex items-center gap-2">
            <AlertCircle className="w-4 h-4 flex-shrink-0" />
            <span>{error}</span>
          </div>
        )}

        {notice && (
          <div className="rounded-xl border border-emerald-200 bg-emerald-50 p-3.5 text-xs font-semibold text-emerald-800">
            {notice}
          </div>
        )}

        <form onSubmit={handleSubmit} className="space-y-4">
          {mode === 'signup' && (
            <>
              <div className="space-y-1.5">
                <label className="block text-xs font-bold text-slate-700">الاسم الكامل</label>
                <input
                  type="text"
                  required
                  value={fullName}
                  onChange={(e) => setFullName(e.target.value)}
                  placeholder="الاسم الثلاثي أو الرباعي"
                  className="w-full rounded-xl border border-slate-200 px-3 py-2.5 text-sm transition focus:border-primary focus:outline-none focus:ring-2 focus:ring-primary/10"
                />
              </div>

              <div className="space-y-1.5">
                <label className="block text-xs font-bold text-slate-700">رقم الهاتف (اختياري)</label>
                <input
                  type="tel"
                  value={phone}
                  onChange={(e) => setPhone(e.target.value)}
                  placeholder="01xxxxxxxxx"
                  className="w-full rounded-xl border border-slate-200 px-3 py-2.5 text-sm transition focus:border-primary focus:outline-none focus:ring-2 focus:ring-primary/10"
                />
              </div>
            </>
          )}

          {/* Email / Username */}
          <div className="space-y-1.5">
            <label className="block text-xs font-bold text-slate-700">البريد الإلكتروني</label>
            <div className="relative">
              <Mail className="w-4 h-4 absolute right-3.5 top-1/2 -translate-y-1/2 text-slate-400" />
              <input
                type="email"
                required
                value={identifier}
                onChange={(e) => setIdentifier(e.target.value)}
                placeholder="name@example.com"
                className="w-full pr-10 pl-3 py-2.5 rounded-xl border border-slate-200 text-sm focus:outline-none focus:border-primary focus:ring-2 focus:ring-primary/10 transition"
              />
            </div>
          </div>

          {/* Password */}
          <div className="space-y-1.5">
            <label className="block text-xs font-bold text-slate-700">كلمة المرور</label>
            <div className="relative">
              <Lock className="w-4 h-4 absolute right-3.5 top-1/2 -translate-y-1/2 text-slate-400" />
              <input
                type={showPassword ? 'text' : 'password'}
                required
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder={mode === 'signup' ? '8 أحرف على الأقل' : '••••••••'}
                className="w-full pr-10 pl-10 py-2.5 rounded-xl border border-slate-200 text-sm focus:outline-none focus:border-primary focus:ring-2 focus:ring-primary/10 transition"
              />
              <button
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 p-1"
              >
                {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
              </button>
            </div>
          </div>

          {mode === 'signup' && (
            <div className="space-y-1.5">
              <label className="block text-xs font-bold text-slate-700">تأكيد كلمة المرور</label>
              <input
                type={showPassword ? 'text' : 'password'}
                required
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
                placeholder="أعد كتابة كلمة المرور"
                className="w-full rounded-xl border border-slate-200 px-3 py-2.5 text-sm transition focus:border-primary focus:outline-none focus:ring-2 focus:ring-primary/10"
              />
            </div>
          )}

          {/* Remember Session */}
          {mode === 'login' && (
            <div className="flex items-center justify-between text-xs">
              <label className="flex cursor-pointer select-none items-center gap-2 font-semibold text-slate-600">
                <input
                  type="checkbox"
                  checked={rememberMe}
                  onChange={(e) => setRememberMe(e.target.checked)}
                  className="h-4 w-4 rounded border-slate-300 text-primary focus:ring-primary"
                />
                <span>تذكر تسجيل الدخول على هذا الجهاز</span>
              </label>
              <span className="text-[11px] text-slate-400">تسجيل آمن عبر Supabase</span>
            </div>
          )}

          <button
            type="submit"
            disabled={isLoading}
            className="w-full py-3 rounded-xl bg-primary hover:bg-primary-dark active:scale-95 text-white font-black text-sm shadow-lg shadow-primary/25 transition flex items-center justify-center gap-2 disabled:opacity-50"
          >
            {isLoading ? 'جاري التنفيذ...' : mode === 'login' ? 'تسجيل الدخول للنظام' : 'إنشاء حساب جديد'}
          </button>
        </form>

        <div className="border-t border-slate-100 pt-2 text-center">
          <button
            type="button"
            onClick={() => {
              setMode(mode === 'login' ? 'signup' : 'login');
              setError('');
              setNotice('');
            }}
            className="inline-flex items-center gap-1.5 text-xs font-bold text-primary hover:text-primary-dark"
          >
            {mode === 'login' ? <><UserPlus className="h-4 w-4" /> إنشاء حساب جديد</> : <><ArrowRight className="h-4 w-4" /> العودة لتسجيل الدخول</>}
          </button>
        </div>

        <div className="pt-2 border-t border-slate-100 text-center">
          <p className="text-[11px] text-slate-400">
            يمكنك تسجيل الدخول من الموبايل والكمبيوتر والتابلت في نفس الوقت دون انقطاع الجلسة
          </p>
        </div>
      </div>
    </div>
  );
};
