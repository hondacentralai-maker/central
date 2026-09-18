import React, { useEffect, useMemo, useState } from 'react';
import { Pencil, Plus, Search, Store, Trash2, X } from 'lucide-react';
import { FastCreditAccount, Profile } from '../types';
import { api } from '../services/api';

interface FastCreditPageProps {
  profile: Profile;
}

interface AccountForm {
  name: string;
  phone: string;
  notes: string;
}

const emptyForm: AccountForm = { name: '', phone: '', notes: '' };
const money = (value: number) => Number(value || 0).toLocaleString('en-US');

export const FastCreditPage: React.FC<FastCreditPageProps> = ({ profile }) => {
  const canDelete = ['admin', 'manager'].includes(profile.role);
  const [accounts, setAccounts] = useState<FastCreditAccount[]>([]);
  const [searchTerm, setSearchTerm] = useState('');
  const [form, setForm] = useState<AccountForm>(emptyForm);
  const [editing, setEditing] = useState<FastCreditAccount | null>(null);
  const [isFormOpen, setIsFormOpen] = useState(false);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');
  const [notice, setNotice] = useState('');

  const load = async () => {
    setLoading(true);
    setError('');
    try {
      setAccounts(await api.getFastCreditAccounts());
    } catch (err: any) {
      setError(err?.message || 'تعذر تحميل حسابات الأجل السريع من قاعدة البيانات.');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { void load(); }, []);

  const filtered = useMemo(() => {
    const term = searchTerm.trim().toLowerCase();
    if (!term) return accounts;
    return accounts.filter(account => `${account.name} ${account.phone || ''}`.toLowerCase().includes(term));
  }, [accounts, searchTerm]);

  const openCreate = () => {
    setEditing(null);
    setForm(emptyForm);
    setNotice('');
    setIsFormOpen(true);
  };

  const openEdit = (account: FastCreditAccount) => {
    setEditing(account);
    setForm({ name: account.name, phone: account.phone || '', notes: account.notes || '' });
    setNotice('');
    setIsFormOpen(true);
  };

  const closeForm = () => {
    if (!saving) setIsFormOpen(false);
  };

  const submit = async (event: React.FormEvent) => {
    event.preventDefault();
    if (!form.name.trim()) {
      setError('اكتب اسم المحل أو الحساب أولًا.');
      return;
    }
    if (!profile.organization_id) {
      setError('لا توجد منشأة مرتبطة بهذا المستخدم.');
      return;
    }
    setSaving(true);
    setError('');
    setNotice('');
    try {
      const saved = editing
        ? await api.updateFastCreditAccount(editing.id, profile.organization_id, form)
        : await api.createFastCreditAccount({ ...form, organizationId: profile.organization_id });
      setAccounts(current => editing ? current.map(account => account.id === saved.id ? saved : account) : [saved, ...current]);
      setIsFormOpen(false);
      setNotice(editing ? 'تم تحديث الحساب.' : 'تمت إضافة الحساب.');
    } catch (err: any) {
      setError(err?.message || 'تعذر حفظ الحساب في قاعدة البيانات.');
    } finally {
      setSaving(false);
    }
  };

  const remove = async (account: FastCreditAccount) => {
    if (!profile.organization_id || !window.confirm(`حذف حساب «${account.name}»؟`)) return;
    setError('');
    try {
      await api.deleteFastCreditAccount(account.id, profile.organization_id);
      setAccounts(current => current.filter(item => item.id !== account.id));
      setNotice('تم حذف الحساب.');
    } catch (err: any) {
      setError(err?.message || 'تعذر حذف الحساب.');
    }
  };

  return (
    <div className="space-y-5">
      <div className="flex flex-col items-start justify-between gap-3 sm:flex-row sm:items-center">
        <div>
          <h2 className="flex items-center gap-2 text-xl font-bold text-slate-900">
            <Store className="h-6 w-6 text-primary" />
            عملاء الأجل السريع
          </h2>
          <p className="text-xs text-slate-500">حسابات المحلات الزميلة والمعاملات قصيرة الأجل المرتبطة بالمنشأة.</p>
        </div>
        <button type="button" onClick={openCreate} className="inline-flex items-center gap-2 rounded-xl bg-primary px-4 py-2 text-xs font-bold text-white shadow-sm hover:bg-primary/90">
          <Plus className="h-4 w-4" />
          إضافة حساب
        </button>
      </div>

      {(error || notice) && (
        <div className={`rounded-xl border px-4 py-3 text-xs font-bold ${error ? 'border-rose-200 bg-rose-50 text-rose-700' : 'border-emerald-200 bg-emerald-50 text-emerald-700'}`}>
          {error || notice}
        </div>
      )}

      <div className="flex flex-col items-center justify-between gap-3 rounded-2xl border border-slate-200 bg-white p-4 sm:flex-row">
        <div className="relative w-full max-w-md">
          <Search className="absolute right-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
          <input type="search" placeholder="ابحث باسم المحل أو الهاتف..." value={searchTerm} onChange={event => setSearchTerm(event.target.value)} className="w-full rounded-xl border border-slate-200 py-2 pl-3 pr-9 text-xs focus:border-primary focus:outline-none" />
        </div>
        <div className="text-xs font-bold text-slate-500">عدد الحسابات: {filtered.length}</div>
      </div>

      {loading ? <div className="rounded-2xl border border-slate-200 bg-white p-8 text-center text-sm text-slate-500">جارٍ تحميل الحسابات...</div> : filtered.length === 0 ? (
        <div className="rounded-2xl border border-dashed border-slate-300 bg-white p-10 text-center text-sm text-slate-500">لا توجد حسابات مطابقة. استخدم «إضافة حساب» لإنشاء أول حساب.</div>
      ) : (
        <div className="grid grid-cols-1 gap-3.5 sm:grid-cols-2 lg:grid-cols-3">
          {filtered.map(account => (
            <div key={account.id} className="space-y-3 rounded-2xl border border-slate-200 bg-white p-4 shadow-sm">
              <div className="flex items-start justify-between gap-2">
                <div>
                  <div className="text-sm font-bold text-slate-900">{account.name}</div>
                  {account.phone && <div className="mt-1 text-xs text-slate-500">{account.phone}</div>}
                </div>
                <span className="rounded-full bg-slate-100 px-2 py-0.5 text-[10px] font-semibold text-slate-600">محل زميل</span>
              </div>
              <div className="flex items-center justify-between border-t border-slate-100 pt-3 text-xs">
                <span className="text-slate-400">الرصيد الجاري:</span>
                <span className={`font-mono font-bold ${Number(account.current_balance) < 0 ? 'text-rose-600' : 'text-slate-800'}`}>{money(account.current_balance)} ج.م</span>
              </div>
              {account.notes && <p className="text-xs text-slate-500">{account.notes}</p>}
              <div className="flex gap-2 border-t border-slate-100 pt-3">
                <button type="button" onClick={() => openEdit(account)} className="inline-flex flex-1 items-center justify-center gap-1 rounded-lg border border-slate-200 px-2 py-1.5 text-xs font-bold text-slate-700 hover:bg-slate-50"><Pencil className="h-3.5 w-3.5" /> تعديل</button>
                {canDelete && <button type="button" onClick={() => void remove(account)} className="inline-flex items-center justify-center rounded-lg border border-rose-200 px-2 py-1.5 text-xs font-bold text-rose-600 hover:bg-rose-50" aria-label={`حذف ${account.name}`}><Trash2 className="h-3.5 w-3.5" /></button>}
              </div>
            </div>
          ))}
        </div>
      )}

      {isFormOpen && (
        <div className="fixed inset-0 z-50 grid place-items-center bg-slate-950/40 p-4" role="dialog" aria-modal="true" aria-label="حساب أجل سريع">
          <form onSubmit={submit} className="w-full max-w-lg space-y-4 rounded-2xl bg-white p-5 shadow-xl">
            <div className="flex items-center justify-between">
              <h3 className="font-bold text-slate-900">{editing ? 'تعديل حساب الأجل' : 'إضافة حساب أجل سريع'}</h3>
              <button type="button" onClick={closeForm} className="rounded-lg p-1 text-slate-500 hover:bg-slate-100" aria-label="إغلاق"><X className="h-5 w-5" /></button>
            </div>
            <label className="block text-xs font-bold text-slate-700">اسم المحل أو الحساب<input required value={form.name} onChange={event => setForm({ ...form, name: event.target.value })} className="mt-1 w-full rounded-xl border border-slate-200 px-3 py-2 text-sm focus:border-primary focus:outline-none" /></label>
            <label className="block text-xs font-bold text-slate-700">الهاتف<input value={form.phone} onChange={event => setForm({ ...form, phone: event.target.value })} className="mt-1 w-full rounded-xl border border-slate-200 px-3 py-2 text-sm focus:border-primary focus:outline-none" inputMode="tel" /></label>
            <label className="block text-xs font-bold text-slate-700">ملاحظات<textarea value={form.notes} onChange={event => setForm({ ...form, notes: event.target.value })} className="mt-1 min-h-20 w-full rounded-xl border border-slate-200 px-3 py-2 text-sm focus:border-primary focus:outline-none" /></label>
            <div className="flex justify-start gap-2 border-t border-slate-100 pt-4">
              <button type="submit" disabled={saving} className="rounded-xl bg-primary px-5 py-2 text-xs font-bold text-white disabled:opacity-50">{saving ? 'جارٍ الحفظ...' : 'حفظ'}</button>
              <button type="button" onClick={closeForm} disabled={saving} className="rounded-xl border border-slate-200 px-5 py-2 text-xs font-bold text-slate-700">إلغاء</button>
            </div>
          </form>
        </div>
      )}
    </div>
  );
};
