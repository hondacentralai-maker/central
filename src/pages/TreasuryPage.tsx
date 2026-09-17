import React, { useState } from 'react';
import { Wallet, ArrowDownLeft, ArrowUpRight, Plus, Minus, History, CheckCircle2 } from 'lucide-react';

export const TreasuryPage: React.FC = () => {
  const [drawerBalance, setDrawerBalance] = useState(35420);
  const [custodyBalance, setCustodyBalance] = useState(15000);
  const [movements, setMovements] = useState<any[]>([
    { id: '1', type: 'in', desc: 'تحصيل قسط عميل (أحمد سمير)', amount: 800, time: '14:30', bal: 35420 },
    { id: '2', type: 'in', desc: 'عمولة تحويل فودافون كاش', amount: 35, time: '13:15', bal: 34620 },
    { id: '3', type: 'out', desc: 'سحب مصروفات بوفيه وكهرباء', amount: 120, time: '11:45', bal: 34585 },
    { id: '4', type: 'in', desc: 'رصيد افتتاحي للدرج الصباحي', amount: 10000, time: '09:00', bal: 34705 },
  ]);

  const [modalType, setModalType] = useState<'in' | 'out' | null>(null);
  const [amount, setAmount] = useState('');
  const [desc, setDesc] = useState('');

  const handleSaveMovement = (e: React.FormEvent) => {
    e.preventDefault();
    const num = parseFloat(amount);
    if (!num || num <= 0 || !modalType) return;

    const newBal = modalType === 'in' ? drawerBalance + num : drawerBalance - num;
    setDrawerBalance(newBal);

    const newMov = {
      id: Date.now().toString(),
      type: modalType,
      desc: desc || (modalType === 'in' ? 'إيداع نقدية في الدرج' : 'صرف نقدية من الدرج'),
      amount: num,
      time: new Date().toLocaleTimeString('ar-EG', { hour: '2-digit', minute: '2-digit' }),
      bal: newBal
    };
    setMovements([newMov, ...movements]);
    setModalType(null);
    setAmount('');
    setDesc('');
  };

  return (
    <div className="space-y-5">
      {/* Header */}
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3">
        <div>
          <h2 className="text-xl font-bold text-slate-900 flex items-center gap-2">
            <Wallet className="w-6 h-6 text-primary" />
            الخزينة وحركة الدرج اليومية
          </h2>
          <p className="text-xs text-slate-500">متابعة النقدية اللحظية، الوارد والمنصرف، وأرصدة العهدة</p>
        </div>

        <div className="flex items-center gap-2">
          <button
            onClick={() => setModalType('in')}
            className="px-3.5 py-2 rounded-xl bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs shadow-sm flex items-center gap-1.5 transition"
          >
            <Plus className="w-4 h-4" />
            إيداع نقدي بالدرج
          </button>
          <button
            onClick={() => setModalType('out')}
            className="px-3.5 py-2 rounded-xl bg-slate-800 hover:bg-slate-700 text-white font-bold text-xs shadow-sm flex items-center gap-1.5 transition"
          >
            <Minus className="w-4 h-4" />
            صرف نقدية / مصروف
          </button>
        </div>
      </div>

      {/* Treasuries Summary Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
        {/* Main Cash Drawer */}
        <div className="p-5 rounded-2xl bg-white border border-slate-200 shadow-sm">
          <div className="flex items-center justify-between text-slate-500 mb-2">
            <span className="text-xs font-bold">الدرج النقدي الرئيسي (الكاش)</span>
            <span className="w-2.5 h-2.5 rounded-full bg-emerald-500"></span>
          </div>
          <div className="text-3xl font-black text-slate-900">
            {drawerBalance.toLocaleString('ar-EG')} <span className="text-sm font-bold text-slate-500">ج.م</span>
          </div>
          <p className="text-xs text-slate-400 mt-2">جاهز للمطابقة والتقفيل اليومي</p>
        </div>

        {/* Store Custody */}
        <div className="p-5 rounded-2xl bg-white border border-slate-200 shadow-sm">
          <div className="flex items-center justify-between text-slate-500 mb-2">
            <span className="text-xs font-bold">العهدة الإضافية للمحل</span>
            <span className="w-2.5 h-2.5 rounded-full bg-blue-500"></span>
          </div>
          <div className="text-3xl font-black text-slate-900">
            {custodyBalance.toLocaleString('ar-EG')} <span className="text-sm font-bold text-slate-500">ج.م</span>
          </div>
          <p className="text-xs text-slate-400 mt-2">عهدة احتياطية ومصروفات الطوارئ</p>
        </div>

        {/* Total Cash in Hand */}
        <div className="p-5 rounded-2xl bg-gradient-to-br from-slate-900 to-slate-800 text-white shadow-sm">
          <div className="text-xs text-slate-300 mb-2">إجمالي النقدية المتوفرة حالياً</div>
          <div className="text-3xl font-black text-white">
            {(drawerBalance + custodyBalance).toLocaleString('ar-EG')} <span className="text-sm font-bold text-slate-400">ج.م</span>
          </div>
          <p className="text-xs text-slate-400 mt-2">الدرج + العهدة الاحتياطية</p>
        </div>
      </div>

      {/* Movements Table */}
      <div className="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div className="p-4 border-b border-slate-100 flex items-center justify-between">
          <h3 className="font-bold text-slate-800 text-sm flex items-center gap-2">
            <History className="w-4 h-4 text-primary" />
            سجل حركات النقدية والدرج
          </h3>
          <span className="text-xs text-slate-400">اليوم</span>
        </div>

        <div className="divide-y divide-slate-100">
          {movements.map((m) => (
            <div key={m.id} className="p-4 flex items-center justify-between hover:bg-slate-50 transition">
              <div className="flex items-center gap-3">
                <div className={`w-8 h-8 rounded-xl flex items-center justify-center ${
                  m.type === 'in' ? 'bg-emerald-50 text-emerald-600' : 'bg-rose-50 text-rose-600'
                }`}>
                  {m.type === 'in' ? <ArrowUpRight className="w-4 h-4" /> : <ArrowDownLeft className="w-4 h-4" />}
                </div>
                <div>
                  <div className="font-bold text-slate-800 text-xs sm:text-sm">{m.desc}</div>
                  <div className="text-[11px] text-slate-400">{m.time}</div>
                </div>
              </div>

              <div className="text-left">
                <div className={`font-black text-sm ${m.type === 'in' ? 'text-emerald-600' : 'text-rose-600'}`}>
                  {m.type === 'in' ? '+' : '-'}{m.amount.toLocaleString('ar-EG')} ج.م
                </div>
                <div className="text-[10px] text-slate-400">
                  الرصيد بعدها: {m.bal.toLocaleString('ar-EG')} ج.م
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Modal for In/Out */}
      {modalType && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/60 backdrop-blur-sm p-4">
          <div className="bg-white rounded-2xl max-w-sm w-full p-5 shadow-2xl space-y-4">
            <h3 className="font-bold text-slate-800 text-sm">
              {modalType === 'in' ? 'إيداع نقدية في الدرج' : 'صرف نقدية من الدرج'}
            </h3>
            <form onSubmit={handleSaveMovement} className="space-y-3">
              <div>
                <label className="text-xs font-semibold text-slate-700 block mb-1">المبلغ (ج.م) *</label>
                <input
                  type="number"
                  required
                  placeholder="0.00"
                  value={amount}
                  onChange={(e) => setAmount(e.target.value)}
                  className="w-full p-2.5 rounded-xl border border-slate-200 text-base font-bold focus:outline-none focus:border-primary"
                />
              </div>
              <div>
                <label className="text-xs font-semibold text-slate-700 block mb-1">البيان / السبب</label>
                <input
                  type="text"
                  placeholder="مثال: سداد بوفيه، عهدة إضافية..."
                  value={desc}
                  onChange={(e) => setDesc(e.target.value)}
                  className="w-full p-2.5 rounded-xl border border-slate-200 text-xs focus:outline-none focus:border-primary"
                />
              </div>
              <div className="flex gap-2 pt-2">
                <button
                  type="button"
                  onClick={() => setModalType(null)}
                  className="flex-1 py-2 rounded-xl border border-slate-200 text-slate-600 text-xs font-semibold hover:bg-slate-50"
                >
                  إلغاء
                </button>
                <button
                  type="submit"
                  className="flex-1 py-2 rounded-xl bg-primary text-white text-xs font-bold hover:bg-primary-dark shadow-sm"
                >
                  حفظ الحركة
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
