import React, { useState } from 'react';
import { Layers, Plus, DollarSign, CheckCircle2 } from 'lucide-react';
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

  const handleRecharge = (e: React.FormEvent) => {
    e.preventDefault();
    const num = parseFloat(rechargeAmt);
    if (!num || num <= 0 || !selectedMachine) return;

    setMachines(machines.map(m => m.id === selectedMachine.id ? { ...m, current_balance: m.current_balance + num } : m));
    setSelectedMachine(null);
    setRechargeAmt('');
  };

  return (
    <div className="space-y-5">
      <div>
        <h2 className="text-xl font-bold text-slate-900 flex items-center gap-2">
          <Layers className="w-6 h-6 text-primary" />
          ماكينات الدفع الإلكتروني (فوري، أمان، بساطة)
        </h2>
        <p className="text-xs text-slate-500">رصد أرصدة الماكينات الموثقة في الدفتر، شحن الرصيد، وتسجيل العمولات</p>
      </div>

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
                {m.current_balance.toLocaleString('ar-EG')} <span className="text-xs font-bold text-slate-500">ج.م</span>
              </div>
            </div>

            <button
              onClick={() => setSelectedMachine(m)}
              className="w-full py-2 rounded-xl bg-slate-50 hover:bg-slate-100 text-slate-700 font-bold text-xs border border-slate-200 transition flex items-center justify-center gap-1"
            >
              <Plus className="w-3.5 h-3.5" />
              تغذية رصيد الماكينة
            </button>
          </div>
        ))}
      </div>

      {selectedMachine && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/60 backdrop-blur-sm p-4">
          <div className="bg-white rounded-2xl max-w-sm w-full p-5 shadow-2xl space-y-4">
            <h3 className="font-bold text-slate-900 text-sm">تغذية رصيد {selectedMachine.name}</h3>
            <form onSubmit={handleRecharge} className="space-y-3">
              <div>
                <label className="text-xs font-semibold text-slate-700 block mb-1">مبلغ الشحن المضاف للماكينة (ج.م) *</label>
                <input
                  type="number"
                  required
                  placeholder="0.00"
                  value={rechargeAmt}
                  onChange={(e) => setRechargeAmt(e.target.value)}
                  className="w-full p-2.5 rounded-xl border border-slate-200 text-sm font-bold focus:outline-none focus:border-primary"
                />
              </div>
              <div className="flex gap-2 pt-2">
                <button
                  type="button"
                  onClick={() => setSelectedMachine(null)}
                  className="flex-1 py-2 rounded-xl border border-slate-200 text-slate-600 text-xs font-semibold hover:bg-slate-50"
                >
                  إلغاء
                </button>
                <button
                  type="submit"
                  className="flex-1 py-2 rounded-xl bg-primary text-white text-xs font-bold hover:bg-primary-dark shadow-sm"
                >
                  تأكيد الشحن
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
