import React, { useEffect, useState } from 'react';
import { Pencil, Plus, Search, Trash2, Truck, X } from 'lucide-react';
import { Supplier, Profile } from '../types';
import { api } from '../services/api';

interface SuppliersPageProps { profile: Profile; }
interface SupplierForm { name: string; phone: string; notes: string; }
const emptyForm: SupplierForm = { name: '', phone: '', notes: '' };
const money = (value: number) => Number(value || 0).toLocaleString('en-US');

export const SuppliersPage: React.FC<SuppliersPageProps> = ({ profile }) => {
  const canDelete = ['admin', 'manager'].includes(profile.role);
  const [suppliers, setSuppliers] = useState<Supplier[]>([]);
  const [searchTerm, setSearchTerm] = useState('');
  const [form, setForm] = useState<SupplierForm>(emptyForm);
  const [editing, setEditing] = useState<Supplier | null>(null);
  const [isFormOpen, setIsFormOpen] = useState(false);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');
  const [notice, setNotice] = useState('');

  const load = async () => {
    setLoading(true);
    setError('');
    try { setSuppliers(await api.getSuppliers()); }
    catch (err: any) { setError(err?.message || 'تعذر تحميل الموردين من قاعدة البيانات.'); }
    finally { setLoading(false); }
  };

  useEffect(() => { void load(); }, []);
  const filtered = suppliers.filter(supplier => `${supplier.name} ${supplier.phone || ''}`.toLowerCase().includes(searchTerm.trim().toLowerCase()));

  const openCreate = () => { setEditing(null); setForm(emptyForm); setNotice(''); setIsFormOpen(true); };
  const openEdit = (supplier: Supplier) => { setEditing(supplier); setForm({ name: supplier.name, phone: supplier.phone || '', notes: supplier.notes || '' }); setNotice(''); setIsFormOpen(true); };

  const submit = async (event: React.FormEvent) => {
    event.preventDefault();
    if (!form.name.trim()) { setError('اكتب اسم المورد أولًا.'); return; }
    if (!profile.organization_id) { setError('لا توجد منشأة مرتبطة بهذا المستخدم.'); return; }
    setSaving(true); setError(''); setNotice('');
    try {
      const saved = editing
        ? await api.updateSupplier(editing.id, profile.organization_id, form)
        : await api.createSupplier({ ...form, organizationId: profile.organization_id });
      setSuppliers(current => editing ? current.map(item => item.id === saved.id ? saved : item) : [saved, ...current]);
      setIsFormOpen(false); setNotice(editing ? 'تم تحديث المورد.' : 'تمت إضافة المورد.');
    } catch (err: any) { setError(err?.message || 'تعذر حفظ المورد في قاعدة البيانات.'); }
    finally { setSaving(false); }
  };

  const remove = async (supplier: Supplier) => {
    if (!profile.organization_id || !window.confirm(`حذف المورد «${supplier.name}»؟`)) return;
    setError('');
    try {
      await api.deleteSupplier(supplier.id, profile.organization_id);
      setSuppliers(current => current.filter(item => item.id !== supplier.id));
      setNotice('تم حذف المورد.');
    } catch (err: any) { setError(err?.message || 'تعذر حذف المورد.'); }
  };

  return (
    <div className="space-y-5">
      <div className="flex flex-col items-start justify-between gap-3 sm:flex-row sm:items-center">
        <div>
          <h2 className="flex items-center gap-2 text-xl font-bold text-slate-900"><Truck className="h-6 w-6 text-primary" /> الموردون والمشتريات</h2>
          <p className="text-xs text-slate-500">حسابات الموردين المسجلة في المنشأة، دون بيانات تجريبية مخفية.</p>
        </div>
        <button type="button" onClick={openCreate} className="inline-flex items-center gap-2 rounded-xl bg-primary px-4 py-2 text-xs font-bold text-white shadow-sm hover:bg-primary/90"><Plus className="h-4 w-4" /> إضافة مورد</button>
      </div>

      {(error || notice) && <div className={`rounded-xl border px-4 py-3 text-xs font-bold ${error ? 'border-rose-200 bg-rose-50 text-rose-700' : 'border-emerald-200 bg-emerald-50 text-emerald-700'}`}>{error || notice}</div>}

      <div className="rounded-2xl border border-slate-200 bg-white p-4">
        <div className="relative max-w-md"><Search className="absolute right-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" /><input type="search" placeholder="ابحث باسم المورد أو الهاتف..." value={searchTerm} onChange={event => setSearchTerm(event.target.value)} className="w-full rounded-xl border border-slate-200 py-2 pl-3 pr-9 text-xs focus:border-primary focus:outline-none" /></div>
      </div>

      {loading ? <div className="rounded-2xl border border-slate-200 bg-white p-8 text-center text-sm text-slate-500">جارٍ تحميل الموردين...</div> : filtered.length === 0 ? <div className="rounded-2xl border border-dashed border-slate-300 bg-white p-10 text-center text-sm text-slate-500">لا توجد بيانات موردين. استخدم «إضافة مورد» لإنشاء أول مورد.</div> : (
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {filtered.map(supplier => <div key={supplier.id} className="space-y-3 rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
            <div><div className="text-[11px] text-slate-400">مورد مسجل</div><h3 className="font-bold text-slate-900">{supplier.name}</h3>{supplier.phone && <p className="mt-1 text-xs text-slate-500">{supplier.phone}</p>}{supplier.notes && <p className="mt-1 text-xs text-slate-500">{supplier.notes}</p>}</div>
            <div className="flex items-center justify-between border-t border-slate-100 pt-3"><div><span className="block text-[11px] text-slate-400">رصيد المورد المستحق:</span><span className="font-mono text-xl font-black text-rose-600">{money(supplier.current_balance)} ج.م</span></div></div>
            <div className="flex gap-2 border-t border-slate-100 pt-3"><button type="button" onClick={() => openEdit(supplier)} className="inline-flex flex-1 items-center justify-center gap-1 rounded-lg border border-slate-200 px-2 py-1.5 text-xs font-bold text-slate-700 hover:bg-slate-50"><Pencil className="h-3.5 w-3.5" /> تعديل</button>{canDelete && <button type="button" onClick={() => void remove(supplier)} className="inline-flex items-center justify-center rounded-lg border border-rose-200 px-2 py-1.5 text-xs font-bold text-rose-600 hover:bg-rose-50" aria-label={`حذف ${supplier.name}`}><Trash2 className="h-3.5 w-3.5" /></button>}</div>
          </div>)}
        </div>
      )}

      {isFormOpen && <div className="fixed inset-0 z-50 grid place-items-center bg-slate-950/40 p-4" role="dialog" aria-modal="true" aria-label="بيانات المورد"><form onSubmit={submit} className="w-full max-w-lg space-y-4 rounded-2xl bg-white p-5 shadow-xl"><div className="flex items-center justify-between"><h3 className="font-bold text-slate-900">{editing ? 'تعديل مورد' : 'إضافة مورد'}</h3><button type="button" onClick={() => !saving && setIsFormOpen(false)} className="rounded-lg p-1 text-slate-500 hover:bg-slate-100" aria-label="إغلاق"><X className="h-5 w-5" /></button></div><label className="block text-xs font-bold text-slate-700">اسم المورد<input required value={form.name} onChange={event => setForm({ ...form, name: event.target.value })} className="mt-1 w-full rounded-xl border border-slate-200 px-3 py-2 text-sm focus:border-primary focus:outline-none" /></label><label className="block text-xs font-bold text-slate-700">الهاتف<input value={form.phone} onChange={event => setForm({ ...form, phone: event.target.value })} className="mt-1 w-full rounded-xl border border-slate-200 px-3 py-2 text-sm focus:border-primary focus:outline-none" inputMode="tel" /></label><label className="block text-xs font-bold text-slate-700">ملاحظات<textarea value={form.notes} onChange={event => setForm({ ...form, notes: event.target.value })} className="mt-1 min-h-20 w-full rounded-xl border border-slate-200 px-3 py-2 text-sm focus:border-primary focus:outline-none" /></label><div className="flex justify-start gap-2 border-t border-slate-100 pt-4"><button type="submit" disabled={saving} className="rounded-xl bg-primary px-5 py-2 text-xs font-bold text-white disabled:opacity-50">{saving ? 'جارٍ الحفظ...' : 'حفظ'}</button><button type="button" onClick={() => !saving && setIsFormOpen(false)} className="rounded-xl border border-slate-200 px-5 py-2 text-xs font-bold text-slate-700">إلغاء</button></div></form></div>}
    </div>
  );
};
