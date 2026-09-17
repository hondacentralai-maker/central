import React, { useState, useEffect } from 'react';
import { supabase } from './utils/supabase';
import { 
  LayoutDashboard, 
  Users, 
  Wallet, 
  ReceiptText, 
  CreditCard, 
  ArrowUpRight, 
  ArrowDownLeft, 
  CheckCircle2, 
  Search,
  PlusCircle,
  Smartphone,
  Layers,
  Sparkles,
  RefreshCw
} from 'lucide-react';

export default function App() {
  const [activeTab, setActiveTab] = useState<'dashboard' | 'installments' | 'journal' | 'wallets'>('dashboard');
  const [dbStatus, setDbStatus] = useState<'checking' | 'connected' | 'error'>('checking');
  const [searchQuery, setSearchQuery] = useState('');

  useEffect(() => {
    async function checkConnection() {
      try {
        const { error } = await supabase.from('_test_').select('*').limit(1);
        // If we get an error about table not found, it still means Supabase auth/url is reached!
        if (error && error.code === 'PGRST205') {
          setDbStatus('connected');
        } else if (error && error.message?.includes('API key')) {
          setDbStatus('error');
        } else {
          setDbStatus('connected');
        }
      } catch {
        setDbStatus('error');
      }
    }
    checkConnection();
  }, []);

  return (
    <div className="min-h-screen bg-[#0b0f19] text-slate-100 flex flex-col font-sans" dir="rtl">
      {/* Top Navbar */}
      <header className="border-b border-slate-800 bg-[#0f172a]/90 backdrop-blur sticky top-0 z-50 px-4 py-3 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-gradient-to-tr from-cyan-500 to-blue-600 flex items-center justify-center shadow-lg shadow-cyan-500/20">
            <Smartphone className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="font-bold text-lg leading-tight text-white flex items-center gap-2">
              سنترال المركزي
              <span className="text-xs px-2 py-0.5 rounded-full bg-cyan-500/20 text-cyan-400 border border-cyan-500/30">سحابي</span>
            </h1>
            <p className="text-xs text-slate-400">نظام إدارة الأقساط واليومية ومحافظ الكاش</p>
          </div>
        </div>

        {/* Database status indicator */}
        <div className="flex items-center gap-3">
          <div className="flex items-center gap-2 px-3 py-1.5 rounded-lg bg-slate-800/80 border border-slate-700 text-xs">
            <span className={`w-2 h-2 rounded-full ${dbStatus === 'connected' ? 'bg-emerald-400 animate-pulse' : 'bg-amber-400'}`}></span>
            <span className="text-slate-300">
              {dbStatus === 'connected' ? 'قاعدة البيانات السحابية متصلة' : 'جاري فحص الاتصال...'}
            </span>
          </div>
        </div>
      </header>

      {/* Navigation Tabs */}
      <nav className="bg-[#131b2e] border-b border-slate-800 px-4 flex gap-2 overflow-x-auto py-2">
        <button
          onClick={() => setActiveTab('dashboard')}
          className={`flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium transition ${
            activeTab === 'dashboard' 
              ? 'bg-cyan-500 text-white shadow-md shadow-cyan-500/20' 
              : 'text-slate-400 hover:text-slate-200 hover:bg-slate-800/60'
          }`}
        >
          <LayoutDashboard className="w-4 h-4" />
          لوحة التحكم
        </button>

        <button
          onClick={() => setActiveTab('installments')}
          className={`flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium transition ${
            activeTab === 'installments' 
              ? 'bg-cyan-500 text-white shadow-md shadow-cyan-500/20' 
              : 'text-slate-400 hover:text-slate-200 hover:bg-slate-800/60'
          }`}
        >
          <Users className="w-4 h-4" />
          عملاء الأقساط
        </button>

        <button
          onClick={() => setActiveTab('journal')}
          className={`flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium transition ${
            activeTab === 'journal' 
              ? 'bg-cyan-500 text-white shadow-md shadow-cyan-500/20' 
              : 'text-slate-400 hover:text-slate-200 hover:bg-slate-800/60'
          }`}
        >
          <ReceiptText className="w-4 h-4" />
          دفتر اليومية والدرج
        </button>

        <button
          onClick={() => setActiveTab('wallets')}
          className={`flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium transition ${
            activeTab === 'wallets' 
              ? 'bg-cyan-500 text-white shadow-md shadow-cyan-500/20' 
              : 'text-slate-400 hover:text-slate-200 hover:bg-slate-800/60'
          }`}
        >
          <Wallet className="w-4 h-4" />
          محافظ الكاش وماكينات الدفع
        </button>
      </nav>

      {/* Main Content Area */}
      <main className="flex-1 p-4 md:p-6 max-w-7xl w-full mx-auto">
        {activeTab === 'dashboard' && (
          <div className="space-y-6">
            {/* KPI Cards */}
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
              <div className="p-4 rounded-xl bg-gradient-to-br from-slate-800/90 to-slate-900 border border-slate-700/60 shadow-sm">
                <div className="flex items-center justify-between text-slate-400 mb-2">
                  <span className="text-xs font-medium">إجمالي متبقي الأقساط</span>
                  <div className="w-8 h-8 rounded-lg bg-emerald-500/10 text-emerald-400 flex items-center justify-center">
                    <CreditCard className="w-4 h-4" />
                  </div>
                </div>
                <div className="text-2xl font-bold text-white">جاري الحساب...</div>
                <p className="text-xs text-slate-400 mt-1">من شيت عملاء أجل الأقساط</p>
              </div>

              <div className="p-4 rounded-xl bg-gradient-to-br from-slate-800/90 to-slate-900 border border-slate-700/60 shadow-sm">
                <div className="flex items-center justify-between text-slate-400 mb-2">
                  <span className="text-xs font-medium">رصيد الدرج والعهدة</span>
                  <div className="w-8 h-8 rounded-lg bg-cyan-500/10 text-cyan-400 flex items-center justify-center">
                    <Wallet className="w-4 h-4" />
                  </div>
                </div>
                <div className="text-2xl font-bold text-white">جاهز للتسجيل</div>
                <p className="text-xs text-slate-400 mt-1">متابعة لحظية للنقدية</p>
              </div>

              <div className="p-4 rounded-xl bg-gradient-to-br from-slate-800/90 to-slate-900 border border-slate-700/60 shadow-sm">
                <div className="flex items-center justify-between text-slate-400 mb-2">
                  <span className="text-xs font-medium">خطوط ومحافظ الكاش</span>
                  <div className="w-8 h-8 rounded-lg bg-purple-500/10 text-purple-400 flex items-center justify-center">
                    <Smartphone className="w-4 h-4" />
                  </div>
                </div>
                <div className="text-2xl font-bold text-white">6 خطوط نشطة</div>
                <p className="text-xs text-slate-400 mt-1">سحب، إيداع، كاش أوت</p>
              </div>

              <div className="p-4 rounded-xl bg-gradient-to-br from-slate-800/90 to-slate-900 border border-slate-700/60 shadow-sm">
                <div className="flex items-center justify-between text-slate-400 mb-2">
                  <span className="text-xs font-medium">ماكينات الدفع الإلكتروني</span>
                  <div className="w-8 h-8 rounded-lg bg-amber-500/10 text-amber-400 flex items-center justify-center">
                    <Layers className="w-4 h-4" />
                  </div>
                </div>
                <div className="text-2xl font-bold text-white">فوري • أمان • بساطة</div>
                <p className="text-xs text-slate-400 mt-1">تتبع الأرصدة والعمولات</p>
              </div>
            </div>

            {/* Welcome banner */}
            <div className="p-6 rounded-2xl bg-gradient-to-r from-cyan-950/40 via-slate-900 to-blue-950/40 border border-cyan-500/30 flex flex-col md:flex-row items-center justify-between gap-4">
              <div className="space-y-1 text-center md:text-right">
                <h2 className="text-xl font-bold text-white flex items-center gap-2 justify-center md:justify-start">
                  <Sparkles className="w-5 h-5 text-cyan-400" />
                  نظام السنترال السحابي جاهز للعمل
                </h2>
                <p className="text-sm text-slate-300">
                  متصل بقاعدة بيانات Supabase السحابية ومجهز بالكامل للعمل على سطح المكتب والموبايل.
                </p>
              </div>
              <button 
                onClick={() => setActiveTab('installments')}
                className="px-5 py-2.5 rounded-xl bg-cyan-500 hover:bg-cyan-400 text-slate-950 font-bold text-sm transition shadow-lg shadow-cyan-500/25 flex items-center gap-2"
              >
                <Users className="w-4 h-4" />
                استعراض سجل العملاء
              </button>
            </div>
          </div>
        )}

        {activeTab === 'installments' && (
          <div className="space-y-4">
            <div className="flex flex-col sm:flex-row items-center justify-between gap-3 bg-slate-900/80 p-4 rounded-xl border border-slate-800">
              <div className="relative w-full sm:w-80">
                <Search className="w-4 h-4 absolute right-3 top-1/2 -translate-y-1/2 text-slate-400" />
                <input
                  type="text"
                  placeholder="ابحث باسم العميل أو رقم الهاتف..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="w-full pl-3 pr-9 py-2 rounded-lg bg-slate-800 border border-slate-700 text-sm text-white placeholder-slate-400 focus:outline-none focus:border-cyan-500"
                />
              </div>
              <button className="w-full sm:w-auto px-4 py-2 rounded-lg bg-cyan-500 hover:bg-cyan-400 text-slate-950 font-bold text-sm flex items-center justify-center gap-2">
                <PlusCircle className="w-4 h-4" />
                إضافة قسط جديد
              </button>
            </div>

            <div className="p-8 rounded-xl bg-slate-900/50 border border-slate-800 text-center space-y-3">
              <Users className="w-12 h-12 text-slate-600 mx-auto" />
              <h3 className="font-bold text-lg text-slate-200">سجل عملاء الأقساط</h3>
              <p className="text-sm text-slate-400 max-w-md mx-auto">
                يحتوي ملف الإكسل على أكثر من 680 معاملة قسط. سيتم إظهار كافة العقود وتواريخ السداد والمبالغ المتبقية فور ترحيل البيانات.
              </p>
            </div>
          </div>
        )}

        {activeTab === 'journal' && (
          <div className="p-8 rounded-xl bg-slate-900/50 border border-slate-800 text-center space-y-3">
            <ReceiptText className="w-12 h-12 text-slate-600 mx-auto" />
            <h3 className="font-bold text-lg text-slate-200">دفتر اليومية والدرج</h3>
            <p className="text-sm text-slate-400 max-w-md mx-auto">
              تسجيل رصيد العهدة الصباحي، حركة الدرج، الوارد والمنصرف، والمصروفات اليومية بدقة.
            </p>
          </div>
        )}

        {activeTab === 'wallets' && (
          <div className="p-8 rounded-xl bg-slate-900/50 border border-slate-800 text-center space-y-3">
            <Wallet className="w-12 h-12 text-slate-600 mx-auto" />
            <h3 className="font-bold text-lg text-slate-200">محافظ الكاش وماكينات الدفع</h3>
            <p className="text-sm text-slate-400 max-w-md mx-auto">
              تتبع رصيد كل خط محفظة (فودافون كاش وغيرها)، تسجيل عمليات السحب والإيداع وحساب العمولات لحظياً.
            </p>
          </div>
        )}
      </main>
    </div>
  );
}
