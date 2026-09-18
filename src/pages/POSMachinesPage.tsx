import React, { useState, useEffect } from 'react';
import { 
  Layers, 
  Plus, 
  DollarSign, 
  CheckCircle2, 
  AlertCircle, 
  RefreshCw, 
  Edit3, 
  Power, 
  Smartphone, 
  PlusCircle, 
  X, 
  TrendingUp, 
  Wallet,
  ShieldCheck
} from 'lucide-react';
import { api } from '../services/api';
import { POSMachine, Profile } from '../types';

export const POSMachinesPage: React.FC<{ profile: Profile }> = ({ profile }) => {
  const canManage = ['admin', 'manager'].includes(profile.role);

  const [machines, setMachines] = useState<POSMachine[]>([]);
  const [selectedMachineForRecharge, setSelectedMachineForRecharge] = useState<POSMachine | null>(null);
  const [rechargeAmt, setRechargeAmt] = useState('');
  
  // Add Machine Modal State
  const [isAddModalOpen, setIsAddModalOpen] = useState(false);
  const [newMachineName, setNewMachineName] = useState('');
  const [newMachineNumber, setNewMachineNumber] = useState('');
  const [newMachineProvider, setNewMachineProvider] = useState('فوري');

  // Edit Machine Modal State
  const [isEditModalOpen, setIsEditModalOpen] = useState(false);
  const [editingMachine, setEditingMachine] = useState<POSMachine | null>(null);
  const [editName, setEditName] = useState('');
  const [editNumber, setEditNumber] = useState('');

  const [isLoading, setIsLoading] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [errorMsg, setErrorMsg] = useState('');
  const [successMsg, setSuccessMsg] = useState('');

  useEffect(() => {
    loadMachines();
  }, []);

  const persistMachines = (updatedList: POSMachine[]) => {
    setMachines(updatedList);
  };

  const loadMachines = async () => {
    setIsLoading(true);
    try {
      const data = await api.getPOSMachines();
      persistMachines(data);
    } catch (err: any) {
      setErrorMsg(err?.message || 'تعذر تحميل الماكينات من قاعدة البيانات.');
    } finally {
      setIsLoading(false);
    }
  };

  // Add New Machine
  const handleAddMachine = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!profile.organization_id || !newMachineName.trim()) return;
    setIsSubmitting(true); setErrorMsg('');
    try {
      const saved = await api.createPOSMachine({ organizationId: profile.organization_id, name: `${newMachineName.trim()} (${newMachineProvider})`, machineNumber: newMachineNumber });
      setMachines(current => [saved, ...current]);
      setIsAddModalOpen(false); setNewMachineName(''); setNewMachineNumber('');
      setSuccessMsg(`تمت إضافة الماكينة (${saved.name}) برصيد افتتاحي صفر. استخدم التحويل لتغذية الرصيد.`);
    } catch (err: any) { setErrorMsg(err?.message || 'تعذر إضافة الماكينة.'); }
    finally { setIsSubmitting(false); }
  };

  // Open Edit Modal
  const openEditModal = (machine: POSMachine) => {
    setEditingMachine(machine);
    setEditName(machine.name);
    setEditNumber(machine.machine_number || '');
    setIsEditModalOpen(true);
  };

  // Save Edit Machine
  const handleSaveEdit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!profile.organization_id || !editingMachine || !editName.trim()) return;
    setIsSubmitting(true); setErrorMsg('');
    try {
      const saved = await api.updatePOSMachine(editingMachine.id, profile.organization_id, { name: editName, machine_number: editNumber });
      setMachines(current => current.map(machine => machine.id === saved.id ? saved : machine));
      setIsEditModalOpen(false); setEditingMachine(null); setSuccessMsg(`تم تحديث بيانات الماكينة (${saved.name}).`);
    } catch (err: any) { setErrorMsg(err?.message || 'تعذر تحديث الماكينة.'); }
    finally { setIsSubmitting(false); }
  };

  // Toggle Active Status
  const handleToggleActive = async (machine: POSMachine) => {
    if (!profile.organization_id) return;
    try {
      const saved = await api.updatePOSMachine(machine.id, profile.organization_id, { ...machine, is_active: !machine.is_active });
      setMachines(current => current.map(item => item.id === saved.id ? saved : item));
      setSuccessMsg(saved.is_active ? 'تم تفعيل الماكينة.' : 'تم تعطيل الماكينة مع الاحتفاظ بسجلها المالي.');
    } catch (err: any) { setErrorMsg(err?.message || 'تعذر تغيير حالة الماكينة.'); }
  };

  // Feed / Recharge Balance
  const handleRecharge = async (e: React.FormEvent) => {
    e.preventDefault();
    const num = parseFloat(rechargeAmt);
    if (!num || num <= 0 || !selectedMachineForRecharge) return;

    setIsSubmitting(true);
    setErrorMsg('');
    setSuccessMsg('');

    try {
      const treasuries = await api.getTreasuries();
      const drawer = treasuries.find(t => t.treasury_type === 'drawer') || treasuries[0];

      if (!drawer) throw new Error('لا توجد خزينة فعالة لتغذية الماكينة.');
      await api.transferFunds({
          sourceType: 'treasury',
          sourceId: drawer.id,
          targetType: 'pos',
          targetId: selectedMachineForRecharge.id,
          amount: num,
          notes: `شحن وتغذية ${selectedMachineForRecharge.name} من درج الكاشير`,
      });

      setSuccessMsg(`تم اعتماد شحن ${selectedMachineForRecharge.name} بمبلغ ${num.toLocaleString('en-US')} ج.م وخصمه من الدرج.`);
      await loadMachines();
      setSelectedMachineForRecharge(null);
      setRechargeAmt('');
    } catch (err: any) {
      setErrorMsg(err?.message || 'فشل الشحن ولم يتم تعديل الرصيد.');
    } finally {
      setIsSubmitting(false);
    }
  };

  const totalBalance = machines.reduce((sum, m) => sum + (m.current_balance || 0), 0);
  const activeCount = machines.filter(m => m.is_active).length;

  return (
    <div className="space-y-6" dir="rtl">
      {/* Top Header & Actions */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-white p-5 rounded-3xl border border-slate-200 shadow-sm">
        <div>
          <h2 className="text-xl font-black text-slate-900 flex items-center gap-2">
            <Layers className="w-6 h-6 text-primary" />
            ماكينات الدفع الإلكتروني (فوري، أمان، بساطة، مصاري)
          </h2>
          <p className="text-xs text-slate-500 mt-0.5">
            إدارة كاملة للماكينات، إضافة وتعديل أسماء وأرصدة الماكينات، وشحن الرصيد الفوري من الدرج.
          </p>
        </div>

        <div className="flex items-center gap-2 flex-wrap">
          <button
            onClick={() => setIsAddModalOpen(true)}
            disabled={!canManage}
            className="px-4 py-2.5 rounded-2xl bg-primary hover:bg-primary/90 text-white font-black text-xs flex items-center gap-2 shadow-lg shadow-primary/20 transition active:scale-95 disabled:cursor-not-allowed disabled:opacity-50"
          >
            <PlusCircle className="w-4 h-4" />
            <span>إضافة ماكينة جديدة</span>
          </button>

          <button
            onClick={loadMachines}
            disabled={isLoading}
            className="p-2.5 rounded-2xl border border-slate-200 text-slate-600 hover:bg-slate-50 transition"
            title="تحديث الأرصدة"
          >
            <RefreshCw className={`w-4 h-4 ${isLoading ? 'animate-spin text-primary' : ''}`} />
          </button>
        </div>
      </div>

      {/* KPI Stats Banner */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <div className="p-5 rounded-3xl bg-white border-2 border-primary/30 shadow-sm flex items-center justify-between">
          <div>
            <span className="text-xs text-primary font-bold block mb-1">إجمالي سيولة الماكينات</span>
            <div className="text-2xl md:text-3xl font-black text-slate-900 font-mono">
              {totalBalance.toLocaleString('en-US')} <span className="text-xs text-primary font-bold">ج.م</span>
            </div>
            <span className="text-[11px] text-slate-500 mt-1 block">جاهزة لعمليات السداد وشحن الفواتير</span>
          </div>
          <div className="w-12 h-12 rounded-2xl bg-primary/10 text-primary flex items-center justify-center">
            <Wallet className="w-6 h-6" />
          </div>
        </div>

        <div className="p-5 rounded-3xl bg-white border border-slate-200 shadow-sm flex items-center justify-between">
          <div>
            <span className="text-xs text-slate-500 font-bold block mb-1">عدد الماكينات المسجلة</span>
            <div className="text-2xl font-black text-slate-900">
              {machines.length} <span className="text-xs text-slate-500">ماكينة</span>
            </div>
            <span className="text-[11px] text-emerald-600 font-bold mt-1 block">{activeCount} ماكينة نشطة تعمل حالياً</span>
          </div>
          <div className="w-12 h-12 rounded-2xl bg-emerald-50 text-emerald-600 flex items-center justify-center">
            <CheckCircle2 className="w-6 h-6" />
          </div>
        </div>

        <div className="p-5 rounded-3xl bg-white border border-slate-200 shadow-sm flex items-center justify-between">
          <div>
            <span className="text-xs text-slate-500 font-bold block mb-1">الربط المحاسبي مع الدرج</span>
            <div className="text-base font-black text-emerald-700">
              مفعل ولحظي
            </div>
            <span className="text-[11px] text-slate-400 mt-1 block">خصم مبالغ التغذية من الدرج تلقائياً</span>
          </div>
          <div className="w-12 h-12 rounded-2xl bg-blue-50 text-blue-600 flex items-center justify-center">
            <ShieldCheck className="w-6 h-6" />
          </div>
        </div>
      </div>

      {/* Notifications */}
      {errorMsg && (
        <div className="p-4 rounded-2xl bg-red-50 border border-red-200 text-red-800 text-xs flex items-center gap-2">
          <AlertCircle className="w-4 h-4 flex-shrink-0 text-red-600" />
          <span>{errorMsg}</span>
        </div>
      )}

      {successMsg && (
        <div className="p-4 rounded-2xl bg-emerald-50 border border-emerald-200 text-emerald-800 text-xs flex items-center justify-between">
          <div className="flex items-center gap-2">
            <CheckCircle2 className="w-4 h-4 flex-shrink-0 text-emerald-600" />
            <span>{successMsg}</span>
          </div>
          <button onClick={() => setSuccessMsg('')} className="text-emerald-700 hover:text-emerald-900 font-bold">
            ✕
          </button>
        </div>
      )}

      {/* POS Machines Grid Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        {machines.map((machine) => {
          const isFawry = machine.name.includes('فوري');
          const isAman = machine.name.includes('أمان');
          const isBasata = machine.name.includes('بساطة');

          return (
            <div
              key={machine.id}
              className={`rounded-3xl border transition shadow-sm p-5 flex flex-col justify-between space-y-4 ${
                machine.is_active 
                  ? 'bg-white border-slate-200 hover:border-primary/40 hover:shadow-md' 
                  : 'bg-slate-50/70 border-slate-200 opacity-60'
              }`}
            >
              <div className="space-y-3">
                {/* Card Top: Provider Icon & Actions (Edit / Power / Delete) */}
                <div className="flex items-start justify-between gap-2">
                  <div className="flex items-center gap-2.5">
                    <div className={`w-10 h-10 rounded-2xl flex items-center justify-center font-black text-sm ${
                      isFawry ? 'bg-amber-100 text-amber-800' :
                      isAman ? 'bg-blue-100 text-blue-800' :
                      isBasata ? 'bg-emerald-100 text-emerald-800' :
                      'bg-purple-100 text-purple-800'
                    }`}>
                      {isFawry ? 'ف' : isAman ? 'أ' : isBasata ? 'ب' : 'م'}
                    </div>
                    <div>
                      <h3 className="font-bold text-sm text-slate-900">{machine.name}</h3>
                      <span className="text-[11px] font-mono text-slate-400 block">{machine.machine_number}</span>
                    </div>
                  </div>

                  {/* Top action icons: Edit, Power, Delete */}
                  <div className="flex items-center gap-1">
                    <button
                      onClick={() => openEditModal(machine)}
                      disabled={!canManage}
                      title="تعديل اسم وبيانات الماكينة"
                      className="p-1.5 rounded-lg text-slate-400 hover:text-amber-600 hover:bg-amber-50 transition"
                    >
                      <Edit3 className="w-3.5 h-3.5" />
                    </button>
                    <button
                      onClick={() => void handleToggleActive(machine)}
                      disabled={!canManage}
                      title={machine.is_active ? 'تعطيل الماكينة' : 'تنشيط الماكينة'}
                      className={`p-1.5 rounded-lg transition ${
                        machine.is_active 
                          ? 'text-slate-400 hover:text-red-600 hover:bg-red-50' 
                          : 'text-red-500 bg-red-50'
                      }`}
                    >
                      <Power className="w-3.5 h-3.5" />
                    </button>
                  </div>
                </div>

                {/* Balance Display */}
                <div className="p-4 rounded-2xl bg-slate-50 border border-slate-100 space-y-1">
                  <span className="text-[11px] text-slate-400 block font-bold">الرصيد المتاح حالياً</span>
                  <div className="text-2xl font-black text-slate-900 font-mono">
                    {machine.current_balance?.toLocaleString('en-US')} <span className="text-xs font-normal text-slate-500">ج.م</span>
                  </div>
                </div>
              </div>

              {/* Bottom: Feed / Recharge Button */}
              <div className="pt-2 border-t border-slate-100">
                <button
                  onClick={() => {
                    setSelectedMachineForRecharge(machine);
                    setRechargeAmt('');
                  }}
                  className="w-full py-2.5 px-3 rounded-2xl bg-primary hover:bg-primary-dark text-white font-black text-xs flex items-center justify-center gap-1.5 shadow transition active:scale-95"
                >
                  <DollarSign className="w-4 h-4" />
                  <span>تغذية وشحن رصيد</span>
                </button>
              </div>
            </div>
          );
        })}
      </div>

      {/* ========================================================================= */}
      {/* MODAL 1: ADD NEW POS MACHINE */}
      {/* ========================================================================= */}
      {isAddModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/80 backdrop-blur-sm p-4">
          <div className="bg-white rounded-3xl shadow-2xl max-w-md w-full p-6 space-y-4 text-slate-900 border border-slate-200">
            <div className="flex items-center justify-between border-b border-slate-100 pb-3">
              <h3 className="font-bold text-base flex items-center gap-2">
                <PlusCircle className="w-5 h-5 text-primary" />
                إضافة ماكينة دفع جديدة
              </h3>
              <button onClick={() => setIsAddModalOpen(false)} className="p-1 rounded-lg hover:bg-slate-100">
                <X className="w-5 h-5 text-slate-400" />
              </button>
            </div>

            <form onSubmit={handleAddMachine} className="space-y-3.5 text-xs">
              <div>
                <label className="font-bold block text-slate-700 mb-1">اسم الماكينة *</label>
                <input
                  type="text"
                  required
                  value={newMachineName}
                  onChange={(e) => setNewMachineName(e.target.value)}
                  placeholder="مثال: ماكينة فوري 2 / ماكينة ضامن / ماكينة مصاري"
                  className="w-full p-2.5 rounded-xl border border-slate-300 font-bold focus:ring-2 focus:ring-primary/20"
                />
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="font-bold block text-slate-700 mb-1">كود أو سيريال الماكينة</label>
                  <input
                    type="text"
                    value={newMachineNumber}
                    onChange={(e) => setNewMachineNumber(e.target.value)}
                    placeholder="مثال: فوري-9955 أو كود 8833"
                    className="w-full p-2.5 rounded-xl border border-slate-300 font-mono"
                  />
                </div>
                <div>
                  <label className="font-bold block text-slate-700 mb-1">الشركة المزودة</label>
                  <select
                    value={newMachineProvider}
                    onChange={(e) => setNewMachineProvider(e.target.value)}
                    className="w-full p-2.5 rounded-xl border border-slate-300 font-bold bg-white"
                  >
                    <option value="فوري">فوري (Fawry)</option>
                    <option value="أمان">أمان (Aman)</option>
                    <option value="بساطة">بساطة (Basata)</option>
                    <option value="مصاري">مصاري (Masary)</option>
                    <option value="ضامن">ضامن (Damen)</option>
                    <option value="أخرى">شركة أخرى</option>
                  </select>
                </div>
              </div>

              <p className="rounded-xl bg-slate-50 p-3 text-[11px] text-slate-500">يبدأ الرصيد بصفر. استخدم زر التغذية لتنفيذ تحويل مالي موثق من الخزينة.</p>

              <div className="pt-2 flex items-center justify-end gap-2 border-t border-slate-100">
                <button
                  type="button"
                  onClick={() => setIsAddModalOpen(false)}
                  className="px-4 py-2 rounded-xl bg-slate-100 text-slate-700 font-bold"
                >
                  إلغاء
                </button>
                <button
                  type="submit"
                  className="px-5 py-2 rounded-xl bg-primary hover:bg-primary/90 text-white font-black shadow"
                >
                  حفظ وإضافة الماكينة
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* ========================================================================= */}
      {/* MODAL 2: EDIT POS MACHINE */}
      {/* ========================================================================= */}
      {isEditModalOpen && editingMachine && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/80 backdrop-blur-sm p-4">
          <div className="bg-white rounded-3xl shadow-2xl max-w-md w-full p-6 space-y-4 text-slate-900 border border-slate-200">
            <div className="flex items-center justify-between border-b border-slate-100 pb-3">
              <h3 className="font-bold text-base flex items-center gap-2">
                <Edit3 className="w-5 h-5 text-amber-600" />
                تعديل اسم وبيانات الماكينة
              </h3>
              <button onClick={() => setIsEditModalOpen(false)} className="p-1 rounded-lg hover:bg-slate-100">
                <X className="w-5 h-5 text-slate-400" />
              </button>
            </div>

            <form onSubmit={handleSaveEdit} className="space-y-3.5 text-xs">
              <div>
                <label className="font-bold block text-slate-700 mb-1">اسم الماكينة *</label>
                <input
                  type="text"
                  required
                  value={editName}
                  onChange={(e) => setEditName(e.target.value)}
                  className="w-full p-2.5 rounded-xl border border-slate-300 font-bold focus:ring-2 focus:ring-amber-500/20"
                />
              </div>

              <div>
                <label className="font-bold block text-slate-700 mb-1">كود أو سيريال الماكينة</label>
                <input
                  type="text"
                  value={editNumber}
                  onChange={(e) => setEditNumber(e.target.value)}
                  className="w-full p-2.5 rounded-xl border border-slate-300 font-mono"
                />
              </div>

              <p className="rounded-xl bg-amber-50 p-3 text-[11px] text-amber-800">الرصيد المالي لا يتم تعديله يدويًا؛ تعديله يكون من خلال حركات التغذية المعتمدة.</p>

              <div className="pt-2 flex items-center justify-end gap-2 border-t border-slate-100">
                <button
                  type="button"
                  onClick={() => setIsEditModalOpen(false)}
                  className="px-4 py-2 rounded-xl bg-slate-100 text-slate-700 font-bold"
                >
                  إلغاء
                </button>
                <button
                  type="submit"
                  className="px-5 py-2 rounded-xl bg-amber-600 hover:bg-amber-500 text-white font-black shadow"
                >
                  حفظ التعديلات
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* ========================================================================= */}
      {/* MODAL 3: RECHARGE / FEED MACHINE BALANCE */}
      {/* ========================================================================= */}
      {selectedMachineForRecharge && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/80 backdrop-blur-sm p-4">
          <div className="bg-white rounded-3xl shadow-2xl max-w-sm w-full p-6 space-y-4 text-slate-900 border border-slate-200">
            <div className="flex items-center justify-between border-b border-slate-100 pb-3">
              <h3 className="font-bold text-base flex items-center gap-2">
                <DollarSign className="w-5 h-5 text-primary" />
                تغذية وشحن رصيد الماكينة
              </h3>
              <button onClick={() => setSelectedMachineForRecharge(null)} className="p-1 rounded-lg hover:bg-slate-100">
                <X className="w-5 h-5 text-slate-400" />
              </button>
            </div>

            <form onSubmit={handleRecharge} className="space-y-3.5 text-xs">
              <div className="p-3.5 rounded-2xl bg-blue-50 border border-blue-100 space-y-1">
                <span className="text-[11px] text-blue-700 font-bold block">الماكينة المستهدفة:</span>
                <div className="font-bold text-sm text-blue-950">{selectedMachineForRecharge.name}</div>
                <div className="text-[11px] text-blue-600 font-mono">
                  الرصيد الحالي: {selectedMachineForRecharge.current_balance?.toLocaleString('en-US')} ج.م
                </div>
              </div>

              <div>
                <label className="font-bold block text-slate-700 mb-1">مبلغ الشحن والتغذية (ج.م) *</label>
                <input
                  type="number"
                  required
                  min="1"
                  step="any"
                  value={rechargeAmt}
                  onChange={(e) => setRechargeAmt(e.target.value)}
                  placeholder="مثال: 5000"
                  className="w-full p-2.5 rounded-xl border border-slate-300 font-black text-base text-primary focus:ring-2 focus:ring-primary/20"
                />
                <span className="text-[11px] text-slate-400 mt-1 block">
                  سيتم خصم المبلغ من درج الكاشير فورياً وتسجيل حركة تحويل معتمدة
                </span>
              </div>

              <div className="pt-2 flex items-center justify-end gap-2 border-t border-slate-100">
                <button
                  type="button"
                  onClick={() => setSelectedMachineForRecharge(null)}
                  className="px-4 py-2 rounded-xl bg-slate-100 text-slate-700 font-bold"
                >
                  إلغاء
                </button>
                <button
                  type="submit"
                  disabled={isSubmitting}
                  className="px-5 py-2 rounded-xl bg-primary hover:bg-primary/90 text-white font-black shadow disabled:opacity-50"
                >
                  {isSubmitting ? 'جاري التحويل...' : 'تأكيد الشحن والخصم من الدرج'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
