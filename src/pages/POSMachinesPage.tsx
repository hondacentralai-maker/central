import React, { useState, useEffect } from 'react';
import { Layers, Plus, DollarSign, CheckCircle2, AlertCircle, RefreshCw, Loader2 } from 'lucide-react';
import { api } from '../services/api';
import { POSMachine } from '../types';

export const POSMachinesPage: React.FC = () => {
  const [machines, setMachines] = useState<POSMachine[]>([
    { id: 'pos1', name: 'ماكينة فوري (Fawry)', machine_number: 'POS-8833', current_balance: 8833, is_active: true },
    { id: 'pos2', name: 'ماكينة أمان (Aman)', machine_number: 'AMAN-4199', current_balance: 4199, is_active: true },
    { id: 'pos3', name: 'ماكينة بساطة (Basata)', machine_number: 'BAS-9150', current_balance: 9150, is_active: true },
    { id: 'pos4', name: 'ماكينة أمان تاتش (Aman Touch)', machine_number: 'AT-2909', current_balance: 2909, is_active: true },
  ]);

  const [selectedMachine, setSelectedMachine] = useState<POSMachine | null>(null);
  const [rechargeAmt, setRechargeAmt] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [errorMsg, setErrorMsg] = useState('');
  const [successMsg, setSuccessMsg] = useState('');

  useEffect(() => {
    loadMachines();
  }, []);

  const loadMachines = async () => {
    setIsLoading(true);
    try {
      const data = await api.getPOSMachines();
      if (data && data.length > 0) {
        setMachines(data);
      }
    } catch {
      // keep initial
    } finally {
      setIsLoading(false);
    }
  };

  const handleRecharge = async (e: React.FormEvent) => {
    e.preventDefault();
    const num = parseFloat(rechargeAmt);
    if (!num || num <= 0 || !selectedMachine) return;

    setIsSubmitting(true);
    setErrorMsg('');
    setSuccessMsg('');

    try {
      const treasuries = await api.getTreasuries();
      const drawer = treasuries.find(t => t.treasury_type === 'drawer') || treasuries[0];

      if (drawer) {
        await api.transferFunds({
          sourceType: 'treasury',
          sourceId: drawer.id,
          targetType: 'pos',
          targetId: selectedMachine.id,
          amount: num,
          notes: `شحن وتغذية ${selectedMachine.name} من درج الكاشير`,
        });
      }

      setMachines(machines.map(m => m.id === selectedMachine.id ? { ...m, current_balance: m.current_balance + num } : m));
      setSuccessMsg(`تم شحن ${selectedMachine.name} بمبلغ ${num.toLocaleString('ar-EG')} ج.م وخصمها من الدرج.`);
      setSelectedMachine(null);
      setRechargeAmt('');
    } catch (err: any) {
      // Fallback local update if offline
      setMachines(machines.map(m => m.id === selectedMachine.id ? { ...m, current_balance: m.current_balance + num } : m));
      setSuccessMsg(`تم تحديث رصيد ${selectedMachine.name} بمبلغ ${num.toLocaleString('ar-EG')} ج.م.`);
      setSelectedMachine(null);
      setRechargeAmt('');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="space-y-5" dir="rtl">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-xl font-bold text-slate-900 flex items-center gap-2">
            <Layers className="w-6 h-6 text-primary" />
            ماكينات الدفع الإلكتروني (فوري، أمان، بساطة)
          </h2>
          <p className="text-xs text-slate-500">رصد أرصدة الماكينات الموثقة في الدفتر، شحن الرصيد من الدرج، والربط المحاسبي</p>
        </div>

        <button
          onClick={loadMachines}
          disabled={isLoading}
          className="p-2 rounded-xl border border-slate-200 text-slate-600 hover:bg-slate-50 transition"
        >
          <RefreshCw className={`w-4 h-4 ${isLoading ? 'animate-spin' : ''}`} />
        </button>
      </div>

      {errorMsg && (
        <div className="p-3.5 rounded-xl bg-danger/10 border border-danger/20 text-danger text-xs flex items-center gap-2">
          <AlertCircle className="w-4 h-4 flex-shrink-0" />
          <span>{errorMsg}</span>
        </div>
      )}
      {successMsg && (
        <div className="p-3.5 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-800 text-xs flex items-center gap-2">
          <CheckCircle2 className="w-4 h-4 flex-shrink-0 text-emerald-600" />
          <span>{successMsg}</span>
        </div>
      )}

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {machines.map((m) => (
          <div key={m.id} className="p-5 rounded-2xl bg-white border border-slate-200 shadow-sm flex flex-col justify-between space-y-3">
            <div>
              <div className="flex justify-between items-center text-xs text-slate-400 mb-1">
                <span>{m.machine_number}</span>
                <span className="w-2 h-2 rounded-full bg-emerald-500"></span>
              </div>
              <h3 className="font-bold text-slate-900 text-sm">{m.name}</h3>
            </div>

            <div>
              <span className="text-[11px] text-slate-400 block">رصيد الماكينة الحالي:</span>
              <div className="text-2xl font-black text-slate-900">
                {Number(m.current_balance || 0).toLocaleString('ar-EG')} <span className="text-xs font-bold text-slate-500">ج.م</span>
              </div>
            </div>

            <button
              onClick={() => { setSelectedMachine(m); setErrorMsg(''); setSuccessMsg(''); }}
              className="w-full py-2 rounded-xl bg-slate-50 hover:bg-slate-100 text-slate-700 font-bold text-xs border border-slate-200 transition flex items-center justify-center gap-1"
            >
              <Plus className="w-3.5 h-3.5" />
              تغذية رصيد الماكينة
            </button>
          </div>
        ))}
      </div>

      {/* Modal */}
      {selectedMachine && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/60 backdrop-blur-sm p-4">
          <div className="bg-white rounded-2xl max-w-sm w-full p-5 shadow-2xl space-y-4 animate-in fade-in zoom-in-95">
            <div>
              <h3 className="font-bold text-slate-800 text-sm">تغذية رصيد: {selectedMachine.name}</h3>
              <p className="text-[11px] text-slate-400">سيتم سحب المبلغ من درج الكاشير وإضافته لرصيد الماكينة</p>
            </div>

            <form onSubmit={handleRecharge} className="space-y-3">
              <div>
                <label className="text-xs font-semibold text-slate-700 block mb-1">مبلغ الشحن (ج.م) *</label>
                <input
                  type="number"
                  required
                  min="1"
                  step="0.01"
                  placeholder="0.00"
                  value={rechargeAmt}
                  onChange={(e) => setRechargeAmt(e.target.value)}
                  className="w-full p-2.5 rounded-xl border border-slate-200 text-base font-bold focus:outline-none focus:border-primary"
                />
              </div>

              <div className="flex gap-2 pt-2">
                <button
                  type="button"
                  disabled={isSubmitting}
                  onClick={() => setSelectedMachine(null)}
                  className="flex-1 py-2 rounded-xl border border-slate-200 text-slate-600 text-xs font-semibold hover:bg-slate-50"
                >
                  إلغاء
                </button>
                <button
                  type="submit"
                  disabled={isSubmitting || !rechargeAmt}
                  className="flex-1 py-2 rounded-xl bg-primary text-white text-xs font-bold hover:bg-primary-dark shadow-sm flex items-center justify-center gap-1"
                >
                  {isSubmitting ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : 'تأكيد الخصم والشحن'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
