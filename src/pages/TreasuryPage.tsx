import React, { useState, useEffect } from 'react';
import { 
  Wallet, 
  ArrowDownLeft, 
  ArrowUpRight, 
  Plus, 
  Minus, 
  History, 
  CheckCircle2, 
  AlertCircle,
  RefreshCw,
  Send,
  Loader2
} from 'lucide-react';
import { api } from '../services/api';
import { Profile, Treasury, TreasuryTransaction, CashWallet, POSMachine } from '../types';

export const TreasuryPage: React.FC<{ profile: Profile }> = ({ profile }) => {
  const [treasuries, setTreasuries] = useState<Treasury[]>([]);
  const [movements, setMovements] = useState<TreasuryTransaction[]>([]);
  const [wallets, setWallets] = useState<CashWallet[]>([]);
  const [posMachines, setPosMachines] = useState<POSMachine[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [errorMsg, setErrorMsg] = useState('');
  const [successMsg, setSuccessMsg] = useState('');

  // Modals
  const [modalType, setModalType] = useState<'in' | 'out' | 'transfer' | null>(null);
  const [amount, setAmount] = useState('');
  const [desc, setDesc] = useState('');

  // Transfer State
  const [transferTargetType, setTransferTargetType] = useState<'wallet' | 'pos'>('wallet');
  const [transferTargetId, setTransferTargetId] = useState('');

  const drawer = treasuries.find(t => t.treasury_type === 'drawer') || treasuries[0];
  const custody = treasuries.find(t => t.treasury_type === 'custody');

  useEffect(() => {
    loadTreasuryData();
  }, []);

  const loadTreasuryData = async () => {
    setIsLoading(true);
    setErrorMsg('');
    try {
      const [tList, txList, wList, pList] = await Promise.all([
        api.getTreasuries(),
        api.getTreasuryTransactions(40),
        api.getCashWallets(),
        api.getPOSMachines(),
      ]);
      setTreasuries(tList);
      setMovements(txList);
      setWallets(wList);
      setPosMachines(pList);
      if (wList.length > 0) setTransferTargetId(wList[0].id);
    } catch (err: any) {
      setErrorMsg(err.message || 'تعذر تحميل بيانات الخزينة من الخادم.');
    } finally {
      setIsLoading(false);
    }
  };

  const handleSaveMovement = async (e: React.FormEvent) => {
    e.preventDefault();
    const num = parseFloat(amount);
    if (!num || num <= 0 || !modalType) return;
    if (!profile.organization_id || !drawer) {
      setErrorMsg('لا توجد خزينة فعالة مرتبطة بالمنشأة الحالية.');
      return;
    }

    setIsSubmitting(true);
    setErrorMsg('');
    setSuccessMsg('');

    try {
      if (modalType === 'in' || modalType === 'out') {
        const type = modalType === 'in' ? 'cash_in' : 'cash_out';
        const defaultDesc = modalType === 'in' ? 'إيداع نقدية في الدرج' : 'صرف نقدية / مصروف';
        
        await api.recordTreasuryMovement({
          organizationId: profile.organization_id,
          treasuryId: drawer.id,
          type: type,
          amount: num,
          description: desc.trim() || defaultDesc,
          userId: profile.id,
        });

        setSuccessMsg(modalType === 'in' ? 'تم تسجيل الإيداع وتحديث رصيد الدرج بنجاح.' : 'تم تسجيل الصرف وخصم المبلغ من الدرج.');
      } else if (modalType === 'transfer') {
        if (!transferTargetId) throw new Error('يرجى تحديد الحساب أو الماكينة المستلمة.');
        
        await api.transferFunds({
          sourceType: 'treasury',
          sourceId: drawer.id,
          targetType: transferTargetType,
          targetId: transferTargetId,
          amount: num,
          notes: desc.trim() || `تحويل نقدية من الدرج إلى ${transferTargetType === 'wallet' ? 'محفظة كاش' : 'ماكينة دفع'}`,
        });

        setSuccessMsg('تم تحويل النقدية بنجاح وتحديث أرصدة الطرفين.');
      }

      setModalType(null);
      setAmount('');
      setDesc('');
      await loadTreasuryData();
    } catch (err: any) {
      setErrorMsg(err.message || 'فشلت العملية المالية. لم يتم تعديل الرصيد.');
    } finally {
      setIsSubmitting(false);
    }
  };

  const drawerBal = Number(drawer?.current_balance || 0);
  const custodyBal = Number(custody?.current_balance || 0);

  return (
    <div className="space-y-5" dir="rtl">
      {/* Header */}
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3">
        <div>
          <h2 className="text-xl font-bold text-slate-900 flex items-center gap-2">
            <Wallet className="w-6 h-6 text-primary" />
            الخزينة والدرج والتحويلات المالية
          </h2>
          <p className="text-xs text-slate-500">متابعة النقدية اللحظية بالدرج، حركة الوارد والمنصرف، وتغذية المحافظ والماكينات</p>
        </div>

        <div className="flex items-center gap-2">
          <button
            onClick={loadTreasuryData}
            title="تحديث الأرصدة"
            disabled={isLoading}
            className="p-2.5 rounded-xl border border-slate-200 text-slate-600 hover:bg-slate-50 transition"
          >
            <RefreshCw className={`w-4 h-4 ${isLoading ? 'animate-spin' : ''}`} />
          </button>
          <button
            onClick={() => { setModalType('in'); setErrorMsg(''); }}
            className="px-3.5 py-2 rounded-xl bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs shadow-sm flex items-center gap-1.5 transition"
          >
            <Plus className="w-4 h-4" />
            إيداع نقدي بالدرج
          </button>
          <button
            onClick={() => { setModalType('out'); setErrorMsg(''); }}
            className="px-3.5 py-2 rounded-xl bg-rose-600 hover:bg-rose-500 text-white font-bold text-xs shadow-sm flex items-center gap-1.5 transition"
          >
            <Minus className="w-4 h-4" />
            صرف نقدية / مصروف
          </button>
          <button
            onClick={() => { setModalType('transfer'); setErrorMsg(''); }}
            className="px-3.5 py-2 rounded-xl bg-slate-900 hover:bg-slate-800 text-white font-bold text-xs shadow-sm flex items-center gap-1.5 transition"
          >
            <Send className="w-3.5 h-3.5" />
            تحويل لمحافظ / ماكينات
          </button>
        </div>
      </div>

      {/* Notifications */}
      {errorMsg && (
        <div className="p-3.5 rounded-xl bg-danger/10 border border-danger/20 text-danger text-xs flex items-center gap-2 animate-in fade-in">
          <AlertCircle className="w-4 h-4 flex-shrink-0" />
          <span>{errorMsg}</span>
        </div>
      )}
      {successMsg && (
        <div className="p-3.5 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-800 text-xs flex items-center gap-2 animate-in fade-in">
          <CheckCircle2 className="w-4 h-4 flex-shrink-0 text-emerald-600" />
          <span>{successMsg}</span>
        </div>
      )}

      {/* Treasuries Summary Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
        {/* Main Cash Drawer */}
        <div className="p-5 rounded-2xl bg-white border border-slate-200 shadow-sm">
          <div className="flex items-center justify-between text-slate-500 mb-2">
            <span className="text-xs font-bold">الدرج النقدي الرئيسي (الكاش الفعلي)</span>
            <span className="w-2.5 h-2.5 rounded-full bg-emerald-500 animate-pulse"></span>
          </div>
          <div className="text-3xl font-black text-slate-900 font-mono">
            {drawerBal.toLocaleString('en-US')} <span className="text-sm font-bold text-slate-500">ج.م</span>
          </div>
          <p className="text-xs text-slate-400 mt-2">رصيد حي موثق في قاعدة البيانات</p>
        </div>

        {/* Store Custody */}
        <div className="p-5 rounded-2xl bg-white border border-slate-200 shadow-sm">
          <div className="flex items-center justify-between text-slate-500 mb-2">
            <span className="text-xs font-bold">العهدة الإضافية للمحل</span>
            <span className="w-2.5 h-2.5 rounded-full bg-blue-500"></span>
          </div>
          <div className="text-3xl font-black text-slate-900 font-mono">
            {custodyBal.toLocaleString('en-US')} <span className="text-sm font-bold text-slate-500">ج.م</span>
          </div>
          <p className="text-xs text-slate-400 mt-2">عهدة احتياطية ومصروفات الطوارئ</p>
        </div>

        {/* Total Cash in Hand (Clean White Theme with subtle Primary Border) */}
        <div className="p-5 rounded-2xl bg-white border-2 border-primary/30 shadow-sm">
          <div className="text-xs text-primary font-bold mb-2">إجمالي النقدية المتوفرة حالياً</div>
          <div className="text-3xl font-black text-slate-900 font-mono">
            {(drawerBal + custodyBal).toLocaleString('en-US')} <span className="text-sm font-bold text-primary">ج.م</span>
          </div>
          <p className="text-xs text-slate-500 mt-2">نقدية الدرج + العهدة الاحتياطية</p>
        </div>
      </div>

      {/* Movements Table */}
      <div className="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div className="p-4 border-b border-slate-100 flex items-center justify-between">
          <h3 className="font-bold text-slate-800 text-sm flex items-center gap-2">
            <History className="w-4 h-4 text-primary" />
            سجل حركات النقدية والدرج الموثقة
          </h3>
          <span className="text-xs text-slate-400">أحدث {movements.length} حركة مسجلة</span>
        </div>

        {isLoading ? (
          <div className="p-8 text-center text-slate-400 flex items-center justify-center gap-2 text-xs">
            <Loader2 className="w-4 h-4 animate-spin text-primary" />
            جاري تحميل حركات الخزينة من الخادم...
          </div>
        ) : movements.length === 0 ? (
          <div className="p-8 text-center text-slate-400 text-xs">لا توجد حركات مسجلة مؤخراً</div>
        ) : (
          <div className="divide-y divide-slate-100">
            {movements.map((m: any) => {
              const isPositive = Number(m.amount) >= 0;
              return (
                <div key={m.id} className="p-4 flex items-center justify-between hover:bg-slate-50 transition">
                  <div className="flex items-center gap-3">
                    <div className={`w-8 h-8 rounded-xl flex items-center justify-center ${
                      isPositive ? 'bg-emerald-50 text-emerald-600' : 'bg-rose-50 text-rose-600'
                    }`}>
                      {isPositive ? <ArrowUpRight className="w-4 h-4" /> : <ArrowDownLeft className="w-4 h-4" />}
                    </div>
                    <div>
                      <div className="font-bold text-slate-800 text-xs sm:text-sm">
                        {m.description || (isPositive ? 'إيداع نقدي بالدرج' : 'صرف نقدية')}
                      </div>
                      <div className="text-[11px] text-slate-400 font-mono">
                        {m.created_at ? new Date(m.created_at).toLocaleString('en-US') : '-'}
                      </div>
                    </div>
                  </div>

                  <div className="text-left">
                    <div className={`font-black text-sm ${isPositive ? 'text-emerald-600' : 'text-rose-600'}`}>
                      {isPositive ? '+' : ''}{Number(m.amount).toLocaleString('en-US')} ج.م
                    </div>
                    <div className="text-[10px] text-slate-400">
                      الرصيد بعدها: {Number(m.balance_after || 0).toLocaleString('en-US')} ج.م
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>

      {/* Modal for In/Out/Transfer */}
      {modalType && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/60 backdrop-blur-sm p-4">
          <div className="bg-white rounded-2xl max-w-sm w-full p-5 shadow-2xl space-y-4 animate-in fade-in zoom-in-95">
            <h3 className="font-bold text-slate-800 text-sm">
              {modalType === 'in' && 'إيداع نقدية في الدرج'}
              {modalType === 'out' && 'صرف نقدية / مصروف من الدرج'}
              {modalType === 'transfer' && 'تحويل وتغذية من الدرج'}
            </h3>

            <form onSubmit={handleSaveMovement} className="space-y-3">
              {modalType === 'transfer' && (
                <>
                  <div>
                    <label className="text-xs font-semibold text-slate-700 block mb-1">جهة التحويل</label>
                    <div className="grid grid-cols-2 gap-2">
                      <button
                        type="button"
                        onClick={() => {
                          setTransferTargetType('wallet');
                          if (wallets.length > 0) setTransferTargetId(wallets[0].id);
                        }}
                        className={`py-2 rounded-xl text-xs font-bold border transition ${
                          transferTargetType === 'wallet' ? 'bg-primary text-white border-primary' : 'bg-slate-50 text-slate-700 border-slate-200'
                        }`}
                      >
                        محفظة كاش
                      </button>
                      <button
                        type="button"
                        onClick={() => {
                          setTransferTargetType('pos');
                          if (posMachines.length > 0) setTransferTargetId(posMachines[0].id);
                        }}
                        className={`py-2 rounded-xl text-xs font-bold border transition ${
                          transferTargetType === 'pos' ? 'bg-primary text-white border-primary' : 'bg-slate-50 text-slate-700 border-slate-200'
                        }`}
                      >
                        ماكينة دفع (فوري/أمان)
                      </button>
                    </div>
                  </div>

                  <div>
                    <label className="text-xs font-semibold text-slate-700 block mb-1">
                      {transferTargetType === 'wallet' ? 'اختر خط المحفظة' : 'اختر الماكينة'}
                    </label>
                    <select
                      value={transferTargetId}
                      onChange={(e) => setTransferTargetId(e.target.value)}
                      className="w-full p-2.5 rounded-xl border border-slate-200 text-xs focus:outline-none focus:border-primary font-bold"
                    >
                      {transferTargetType === 'wallet'
                        ? wallets.map(w => (
                            <option key={w.id} value={w.id}>
                              {w.account_label || w.phone_number} ({Number(w.current_balance || 0).toLocaleString('en-US')} ج.م)
                            </option>
                          ))
                        : posMachines.map(p => (
                            <option key={p.id} value={p.id}>
                              {p.name} ({Number(p.current_balance || 0).toLocaleString('en-US')} ج.م)
                            </option>
                          ))}
                    </select>
                  </div>
                </>
              )}

              <div>
                <label className="text-xs font-semibold text-slate-700 block mb-1">المبلغ (ج.م) *</label>
                <input
                  type="number"
                  step="0.01"
                  required
                  min="1"
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
                  placeholder="مثال: سداد بوفيه، عهدة إضافية، تغذية فودافون كاش..."
                  value={desc}
                  onChange={(e) => setDesc(e.target.value)}
                  className="w-full p-2.5 rounded-xl border border-slate-200 text-xs focus:outline-none focus:border-primary"
                />
              </div>

              <div className="flex gap-2 pt-2">
                <button
                  type="button"
                  disabled={isSubmitting}
                  onClick={() => setModalType(null)}
                  className="flex-1 py-2.5 rounded-xl border border-slate-200 text-slate-600 text-xs font-semibold hover:bg-slate-50 transition"
                >
                  إلغاء
                </button>
                <button
                  type="submit"
                  disabled={isSubmitting}
                  className="flex-1 py-2.5 rounded-xl bg-primary hover:bg-primary-dark text-white text-xs font-bold shadow-sm transition flex items-center justify-center gap-1.5 disabled:opacity-50"
                >
                  {isSubmitting ? (
                    <>
                      <Loader2 className="w-3.5 h-3.5 animate-spin" />
                      جاري الحفظ...
                    </>
                  ) : (
                    'تأكيد وحفظ الحركة'
                  )}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
