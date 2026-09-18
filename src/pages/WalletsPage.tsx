import React, { useEffect, useState } from 'react';
import { ArrowDownLeft, ArrowUpRight, CheckCircle2, DollarSign, Pencil, Plus, Smartphone, X } from 'lucide-react';
import { api } from '../services/api';
import { CashWallet, Profile, WalletTransaction } from '../types';

interface WalletsPageProps { profile: Profile; }
interface WalletForm { phone_number: string; provider: CashWallet['provider']; account_label: string; }
const emptyForm: WalletForm = { phone_number: '', provider: 'vodafone_cash', account_label: '' };
const money = (value: number) => Number(value || 0).toLocaleString('en-US');

export const WalletsPage: React.FC<WalletsPageProps> = ({ profile }) => {
  const canManage = ['admin', 'manager'].includes(profile.role);
  const [wallets, setWallets] = useState<CashWallet[]>([]);
  const [recentTx, setRecentTx] = useState<WalletTransaction[]>([]);
  const [selectedWallet, setSelectedWallet] = useState<CashWallet | null>(null);
  const [txType, setTxType] = useState<'deposit' | 'cash_out'>('deposit');
  const [amount, setAmount] = useState('');
  const [commission, setCommission] = useState('5');
  const [clientPhone, setClientPhone] = useState('');
  const [form, setForm] = useState<WalletForm>(emptyForm);
  const [editing, setEditing] = useState<CashWallet | null>(null);
  const [isFormOpen, setIsFormOpen] = useState(false);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');
  const [notice, setNotice] = useState('');

  const load = async () => {
    setLoading(true);
    setError('');
    try {
      const [walletList, transactions] = await Promise.all([api.getCashWallets(), api.getWalletTransactions()]);
      setWallets(walletList);
      setRecentTx(transactions);
      setSelectedWallet(current => walletList.find(wallet => wallet.id === current?.id) || walletList[0] || null);
    } catch (err: any) {
      setError(err?.message || 'تعذر تحميل المحافظ من قاعدة البيانات.');
    } finally { setLoading(false); }
  };

  useEffect(() => { void load(); }, []);
  useEffect(() => {
    const num = Number(amount);
    if (num > 0) setCommission(String(Math.max(5, Math.ceil(num / 1000) * 5)));
  }, [amount]);

  const openCreate = () => { setEditing(null); setForm(emptyForm); setIsFormOpen(true); setError(''); };
  const openEdit = (wallet: CashWallet) => { setEditing(wallet); setForm({ phone_number: wallet.phone_number, provider: wallet.provider, account_label: wallet.account_label || '' }); setIsFormOpen(true); setError(''); };

  const saveWallet = async (event: React.FormEvent) => {
    event.preventDefault();
    if (!profile.organization_id || !form.phone_number.trim()) { setError('أدخل رقم الخط وتأكد من وجود منشأة مرتبطة بالمستخدم.'); return; }
    setSaving(true); setError('');
    try {
      const saved = editing
        ? await api.updateCashWallet(editing.id, profile.organization_id, form)
        : await api.createCashWallet({ organizationId: profile.organization_id, phoneNumber: form.phone_number, provider: form.provider, accountLabel: form.account_label });
      setWallets(current => editing ? current.map(wallet => wallet.id === saved.id ? saved : wallet) : [saved, ...current]);
      setSelectedWallet(saved);
      setIsFormOpen(false);
      setNotice(editing ? 'تم تحديث بيانات الخط.' : 'تمت إضافة الخط.');
    } catch (err: any) { setError(err?.message || 'تعذر حفظ بيانات الخط.'); }
    finally { setSaving(false); }
  };

  const toggleWallet = async (wallet: CashWallet) => {
    if (!profile.organization_id) return;
    setError('');
    try {
      const saved = await api.updateCashWallet(wallet.id, profile.organization_id, { ...wallet, is_active: !wallet.is_active });
      setWallets(current => current.map(item => item.id === saved.id ? saved : item));
      if (selectedWallet?.id === saved.id) setSelectedWallet(saved);
      setNotice(saved.is_active ? 'تم تفعيل الخط.' : 'تم تعطيل الخط مع الاحتفاظ بسجله المالي.');
    } catch (err: any) { setError(err?.message || 'تعذر تغيير حالة الخط.'); }
  };

  const executeTransaction = async (event: React.FormEvent) => {
    event.preventDefault();
    const numericAmount = Number(amount);
    if (!profile.organization_id || !profile.id || !selectedWallet || !numericAmount || numericAmount <= 0) { setError('اختر خطًا وأدخل مبلغًا صحيحًا.'); return; }
    setSaving(true); setError(''); setNotice('');
    try {
      const treasuries = await api.getTreasuries();
      const treasury = treasuries.find(item => item.treasury_type === 'drawer') || treasuries[0];
      if (!treasury) throw new Error('لا توجد خزينة فعالة لتنفيذ عملية المحفظة.');
      await api.recordWalletTransaction({ organizationId: profile.organization_id, treasuryId: treasury.id, userId: profile.id, walletId: selectedWallet.id, type: txType, amount: numericAmount, commission: Number(commission) || 0, clientPhone, notes: txType === 'deposit' ? 'إيداع لمحفظة عميل' : 'سحب كاش أوت' });
      setNotice(txType === 'deposit' ? 'تم تسجيل الإيداع وتحديث رصيد المحفظة.' : 'تم تسجيل السحب وتحديث رصيد المحفظة.');
      setAmount(''); setClientPhone('');
      await load();
    } catch (err: any) { setError(err?.message || 'فشلت العملية ولم يتم اعتمادها.'); }
    finally { setSaving(false); }
  };

  return <div className="space-y-5">
    <div className="flex flex-col items-start justify-between gap-3 sm:flex-row sm:items-center">
      <div><h2 className="flex items-center gap-2 text-xl font-bold text-slate-900"><Smartphone className="h-6 w-6 text-primary" /> خطوط ومحافظ الكاش</h2><p className="text-xs text-slate-500">إدارة الخطوط والحركات المالية الموثقة. لا يتم حذف الخط ذي السجل المالي، بل يتم تعطيله.</p></div>
      <button type="button" onClick={openCreate} disabled={!canManage} className="inline-flex items-center gap-2 rounded-xl bg-primary px-4 py-2 text-xs font-bold text-white disabled:cursor-not-allowed disabled:opacity-50"><Plus className="h-4 w-4" /> إضافة خط</button>
    </div>
    {(error || notice) && <div className={`rounded-xl border px-4 py-3 text-xs font-bold ${error ? 'border-rose-200 bg-rose-50 text-rose-700' : 'border-emerald-200 bg-emerald-50 text-emerald-700'}`}>{error || notice}</div>}

    {loading ? <div className="rounded-2xl border border-slate-200 bg-white p-8 text-center text-sm text-slate-500">جارٍ تحميل المحافظ...</div> : wallets.length === 0 ? <div className="rounded-2xl border border-dashed border-slate-300 bg-white p-10 text-center text-sm text-slate-500">لا توجد خطوط مسجلة. أضف أول خط للبدء.</div> : <div className="grid grid-cols-1 gap-3.5 sm:grid-cols-2 lg:grid-cols-3">
      {wallets.map(wallet => <div key={wallet.id} className={`rounded-2xl border p-4 transition ${selectedWallet?.id === wallet.id ? 'border-primary bg-primary text-white shadow-md' : 'border-slate-200 bg-white text-slate-800'}`}>
        <button type="button" onClick={() => setSelectedWallet(wallet)} className="w-full text-right"><div className="mb-2 flex items-center justify-between gap-2"><span className={`text-xs font-bold ${selectedWallet?.id === wallet.id ? 'text-blue-100' : 'text-slate-500'}`}>{wallet.account_label || 'خط كاش'}</span><span className={`rounded-md px-2 py-0.5 font-mono text-[11px] ${selectedWallet?.id === wallet.id ? 'bg-white/20 text-white' : 'bg-slate-100 text-slate-700'}`}>{wallet.phone_number}</span></div><div className="font-mono text-xl font-black">{money(wallet.current_balance)} <span className="text-xs font-bold">ج.م</span></div></button>
        <div className={`mt-2 flex items-center justify-between text-[11px] ${selectedWallet?.id === wallet.id ? 'text-blue-100' : 'text-slate-400'}`}><span>{wallet.provider}</span><span>{wallet.is_active ? 'نشط' : 'معطل'}</span></div>
        <div className="mt-3 flex gap-2 border-t border-white/20 pt-3"><button type="button" disabled={!canManage} onClick={() => openEdit(wallet)} className={`inline-flex flex-1 items-center justify-center gap-1 rounded-lg px-2 py-1.5 text-xs font-bold disabled:cursor-not-allowed disabled:opacity-50 ${selectedWallet?.id === wallet.id ? 'bg-white/15 text-white' : 'border border-slate-200 text-slate-700'}`}><Pencil className="h-3.5 w-3.5" /> تعديل</button><button type="button" disabled={!canManage} onClick={() => void toggleWallet(wallet)} className={`rounded-lg px-2 py-1.5 text-xs font-bold disabled:cursor-not-allowed disabled:opacity-50 ${selectedWallet?.id === wallet.id ? 'bg-white/15 text-white' : 'border border-slate-200 text-slate-700'}`}>{wallet.is_active ? 'تعطيل' : 'تفعيل'}</button></div>
      </div>)}
    </div>}

    <div className="grid grid-cols-1 gap-5 lg:grid-cols-3">
      <div className="space-y-4 rounded-2xl border border-slate-200 bg-white p-5"><div className="border-b border-slate-100 pb-3"><h3 className="text-sm font-bold text-slate-900">تسجيل حركة محفظة</h3><p className="text-xs text-slate-500">الخط: <span className="font-bold text-primary">{selectedWallet?.phone_number || 'غير محدد'}</span></p></div><form onSubmit={executeTransaction} className="space-y-3.5"><div className="grid grid-cols-2 gap-2"><button type="button" onClick={() => setTxType('deposit')} className={`rounded-xl px-3 py-2 text-xs font-bold ${txType === 'deposit' ? 'bg-emerald-600 text-white' : 'bg-slate-100 text-slate-600'}`}><ArrowUpRight className="mx-auto h-4 w-4" /> إيداع للعميل</button><button type="button" onClick={() => setTxType('cash_out')} className={`rounded-xl px-3 py-2 text-xs font-bold ${txType === 'cash_out' ? 'bg-indigo-600 text-white' : 'bg-slate-100 text-slate-600'}`}><ArrowDownLeft className="mx-auto h-4 w-4" /> سحب كاش أوت</button></div><label className="block text-xs font-semibold text-slate-700">المبلغ<input type="number" min="0.01" step="0.01" required value={amount} onChange={event => setAmount(event.target.value)} className="mt-1 w-full rounded-xl border border-slate-200 p-2.5 text-base font-bold focus:border-primary focus:outline-none" /></label><label className="block text-xs font-semibold text-slate-700">العمولة<input type="number" min="0" step="0.01" value={commission} onChange={event => setCommission(event.target.value)} className="mt-1 w-full rounded-xl border border-slate-200 p-2.5 text-sm font-bold focus:border-primary focus:outline-none" /></label><label className="block text-xs font-semibold text-slate-700">هاتف العميل<input type="tel" value={clientPhone} onChange={event => setClientPhone(event.target.value)} className="mt-1 w-full rounded-xl border border-slate-200 p-2.5 text-xs focus:border-primary focus:outline-none" /></label><button type="submit" disabled={saving || !selectedWallet?.is_active} className="inline-flex w-full items-center justify-center gap-2 rounded-xl bg-primary py-2.5 text-xs font-bold text-white disabled:opacity-50"><DollarSign className="h-4 w-4" />{saving ? 'جارٍ الاعتماد...' : 'اعتماد العملية'}</button></form></div>
      <div className="space-y-4 rounded-2xl border border-slate-200 bg-white p-5 lg:col-span-2"><div className="flex items-center justify-between border-b border-slate-100 pb-3"><h3 className="text-sm font-bold text-slate-900">آخر حركات المحافظ</h3><span className="text-xs text-slate-400">{recentTx.length} حركة</span></div>{recentTx.length === 0 ? <div className="p-8 text-center text-xs text-slate-400">لا توجد حركات مسجلة.</div> : <div className="divide-y divide-slate-100">{recentTx.map(tx => <div key={tx.id} className="flex items-center justify-between gap-3 py-3 text-xs"><div className="flex items-center gap-2.5"><div className={`flex h-8 w-8 items-center justify-center rounded-lg ${tx.transaction_type === 'deposit' ? 'bg-emerald-50 text-emerald-600' : 'bg-indigo-50 text-indigo-600'}`}>{tx.transaction_type === 'deposit' ? <ArrowUpRight className="h-4 w-4" /> : <ArrowDownLeft className="h-4 w-4" />}</div><div><div className="font-bold text-slate-800">{tx.transaction_type === 'deposit' ? 'إيداع محفظة' : 'سحب كاش أوت'} • {tx.wallet_label || 'محفظة'}</div><div className="text-[11px] text-slate-400">{tx.client_phone || 'بدون هاتف'} • {new Date(tx.created_at).toLocaleString('en-GB')}</div></div></div><div className="text-left font-mono"><div className="text-sm font-black text-slate-900">{money(tx.amount)} ج.م</div><div className="text-[10px] font-bold text-emerald-600">عمولة: +{money(tx.commission)} ج.م</div></div></div>)}</div>}</div>
    </div>

    {isFormOpen && <div className="fixed inset-0 z-50 grid place-items-center bg-slate-950/40 p-4" role="dialog" aria-modal="true" aria-label="بيانات الخط"><form onSubmit={saveWallet} className="w-full max-w-lg space-y-4 rounded-2xl bg-white p-5 shadow-xl"><div className="flex items-center justify-between"><h3 className="font-bold text-slate-900">{editing ? 'تعديل بيانات الخط' : 'إضافة خط جديد'}</h3><button type="button" onClick={() => !saving && setIsFormOpen(false)} className="rounded-lg p-1 text-slate-500 hover:bg-slate-100" aria-label="إغلاق"><X className="h-5 w-5" /></button></div><label className="block text-xs font-bold text-slate-700">رقم الخط<input required value={form.phone_number} onChange={event => setForm({ ...form, phone_number: event.target.value })} className="mt-1 w-full rounded-xl border border-slate-200 px-3 py-2 text-sm focus:border-primary focus:outline-none" inputMode="tel" /></label><label className="block text-xs font-bold text-slate-700">اسم ظاهر للخط<input value={form.account_label} onChange={event => setForm({ ...form, account_label: event.target.value })} className="mt-1 w-full rounded-xl border border-slate-200 px-3 py-2 text-sm focus:border-primary focus:outline-none" /></label><label className="block text-xs font-bold text-slate-700">المزود<select value={form.provider} onChange={event => setForm({ ...form, provider: event.target.value as CashWallet['provider'] })} className="mt-1 w-full rounded-xl border border-slate-200 px-3 py-2 text-sm focus:border-primary focus:outline-none"><option value="vodafone_cash">Vodafone Cash</option><option value="orange_cash">Orange Cash</option><option value="etisalat_cash">Etisalat Cash</option><option value="instapay">InstaPay</option></select></label><div className="flex justify-start gap-2 border-t border-slate-100 pt-4"><button type="submit" disabled={saving} className="rounded-xl bg-primary px-5 py-2 text-xs font-bold text-white disabled:opacity-50">{saving ? 'جارٍ الحفظ...' : 'حفظ'}</button><button type="button" onClick={() => !saving && setIsFormOpen(false)} className="rounded-xl border border-slate-200 px-5 py-2 text-xs font-bold text-slate-700">إلغاء</button></div></form></div>}
  </div>;
};
