import React, { useState, useEffect } from 'react';
import { Smartphone, ArrowDownLeft, ArrowUpRight, DollarSign, Plus, CheckCircle2 } from 'lucide-react';
import { api } from '../services/api';
import { CashWallet, WalletTransaction } from '../types';

export const WalletsPage: React.FC = () => {
  const initialWallets: CashWallet[] = [
    { id: 'w1', phone_number: '01091576032', provider: 'vodafone_cash', account_label: 'خط كاش 1 (رئيسي)', current_balance: 28540, is_active: true },
    { id: 'w2', phone_number: '01002919441', provider: 'vodafone_cash', account_label: 'خط كاش 2', current_balance: 19530, is_active: true },
    { id: 'w3', phone_number: '01033307821', provider: 'vodafone_cash', account_label: 'خط كاش 3', current_balance: 12400, is_active: true },
    { id: 'w4', phone_number: '01098968373', provider: 'vodafone_cash', account_label: 'خط كاش 4', current_balance: 36520, is_active: true },
    { id: 'w5', phone_number: '01090067941', provider: 'vodafone_cash', account_label: 'خط كاش 5', current_balance: 8900, is_active: true },
    { id: 'w6', phone_number: '01005168098', provider: 'vodafone_cash', account_label: 'خط كاش 6', current_balance: 15750, is_active: true },
  ];

  const [wallets, setWallets] = useState<CashWallet[]>(initialWallets);
  const [selectedWallet, setSelectedWallet] = useState<CashWallet | null>(wallets[0]);
  const [txType, setTxType] = useState<'deposit' | 'cash_out'>('deposit');
  const [amount, setAmount] = useState('');
  const [commission, setCommission] = useState('5');
  const [clientPhone, setClientPhone] = useState('');
  const [recentTx, setRecentTx] = useState<any[]>([]);
  const [successMsg, setSuccessMsg] = useState('');

  // Auto-calculate standard commission
  useEffect(() => {
    const num = parseFloat(amount);
    if (num > 0) {
      // Standard Egypt cash commission: 5 EGP per 1000
      const comm = Math.max(5, Math.ceil(num / 1000) * 5);
      setCommission(comm.toString());
    }
  }, [amount]);

  const handleExecuteTx = (e: React.FormEvent) => {
    e.preventDefault();
    const numAmt = parseFloat(amount);
    const numComm = parseFloat(commission) || 0;
    if (!numAmt || numAmt <= 0 || !selectedWallet) return;

    // Update wallet balance in UI
    const updated = wallets.map((w) => {
      if (w.id === selectedWallet.id) {
        const newBal = txType === 'deposit' ? w.current_balance - numAmt : w.current_balance + numAmt;
        return { ...w, current_balance: newBal };
      }
      return w;
    });

    setWallets(updated);
    const newTx = {
      id: Date.now().toString(),
      wallet_label: selectedWallet.account_label,
      phone_number: selectedWallet.phone_number,
      type: txType,
      amount: numAmt,
      commission: numComm,
      client_phone: clientPhone,
      time: new Date().toLocaleTimeString('ar-EG', { hour: '2-digit', minute: '2-digit' })
    };
    setRecentTx([newTx, ...recentTx]);

    setSuccessMsg(txType === 'deposit' ? 'تم تسجيل الإيداع بنجاح' : 'تم تسجيل الكاش أوت وسحب النقدية بنجاح');
    setAmount('');
    setClientPhone('');
    setTimeout(() => setSuccessMsg(''), 4000);
  };

  return (
    <div className="space-y-5">
      {/* Header */}
      <div>
        <h2 className="text-xl font-bold text-slate-900 flex items-center gap-2">
          <Smartphone className="w-6 h-6 text-primary" />
          خطوط ومحافظ الكاش (فودافون كاش)
        </h2>
        <p className="text-xs text-slate-500">إدارة الخطوط الموثقة، حاسبة العمولات السريعة، وعمليات السحب والإيداع</p>
      </div>

      {/* Wallets Cards Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3.5">
        {wallets.map((w) => (
          <div
            key={w.id}
            onClick={() => setSelectedWallet(w)}
            className={`p-4 rounded-2xl border transition cursor-pointer ${
              selectedWallet?.id === w.id
                ? 'bg-primary text-white border-primary shadow-md shadow-primary/20'
                : 'bg-white text-slate-800 border-slate-200 hover:border-slate-300'
            }`}
          >
            <div className="flex items-center justify-between mb-2">
              <span className={`text-xs font-bold ${selectedWallet?.id === w.id ? 'text-blue-100' : 'text-slate-500'}`}>
                {w.account_label}
              </span>
              <span className={`text-[11px] font-mono px-2 py-0.5 rounded-md ${
                selectedWallet?.id === w.id ? 'bg-white/20 text-white' : 'bg-slate-100 text-slate-700'
              }`}>
                {w.phone_number}
              </span>
            </div>
            <div className="text-xl font-black font-mono">
              {w.current_balance.toLocaleString('en-US')} <span className="text-xs font-bold">ج.م</span>
            </div>
            <div className={`mt-2 text-[11px] flex justify-between ${
              selectedWallet?.id === w.id ? 'text-blue-100' : 'text-slate-400'
            }`}>
              <span>فودافون كاش</span>
              <span className="font-semibold">نشط</span>
            </div>
          </div>
        ))}
      </div>

      {/* Operation Area */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-5">
        {/* Instant Transaction Form */}
        <div className="lg:col-span-1 bg-white p-5 rounded-2xl border border-slate-200 shadow-sm space-y-4">
          <div className="border-b border-slate-100 pb-3">
            <h3 className="font-bold text-slate-900 text-sm">حاسبة وتسجيل العملية</h3>
            <p className="text-xs text-slate-500">الخط: <span className="font-bold text-primary">{selectedWallet?.phone_number}</span></p>
          </div>

          {successMsg && (
            <div className="p-3 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-800 text-xs flex items-center gap-2">
              <CheckCircle2 className="w-4 h-4 text-emerald-600 flex-shrink-0" />
              <span>{successMsg}</span>
            </div>
          )}

          <form onSubmit={handleExecuteTx} className="space-y-3.5">
            {/* Type tabs */}
            <div className="grid grid-cols-2 gap-2">
              <button
                type="button"
                onClick={() => setTxType('deposit')}
                className={`py-2 px-3 rounded-xl text-xs font-bold transition flex items-center justify-center gap-1.5 ${
                  txType === 'deposit'
                    ? 'bg-emerald-600 text-white shadow-sm'
                    : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
                }`}
              >
                <ArrowUpRight className="w-4 h-4" />
                إيداع للعميل
              </button>
              <button
                type="button"
                onClick={() => setTxType('cash_out')}
                className={`py-2 px-3 rounded-xl text-xs font-bold transition flex items-center justify-center gap-1.5 ${
                  txType === 'cash_out'
                    ? 'bg-indigo-600 text-white shadow-sm'
                    : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
                }`}
              >
                <ArrowDownLeft className="w-4 h-4" />
                سحب كاش أوت
              </button>
            </div>

            {/* Amount */}
            <div className="space-y-1">
              <label className="text-xs font-semibold text-slate-700">المبلغ المحول (ج.م) *</label>
              <input
                type="number"
                required
                placeholder="أدخل المبلغ..."
                value={amount}
                onChange={(e) => setAmount(e.target.value)}
                className="w-full p-2.5 rounded-xl border border-slate-200 text-base font-bold focus:outline-none focus:border-primary"
              />
            </div>

            {/* Commission */}
            <div className="space-y-1">
              <label className="text-xs font-semibold text-slate-700">عمولة السنترال (ج.م)</label>
              <input
                type="number"
                value={commission}
                onChange={(e) => setCommission(e.target.value)}
                className="w-full p-2.5 rounded-xl border border-slate-200 text-sm font-bold text-emerald-600 focus:outline-none focus:border-primary"
              />
            </div>

            {/* Client phone */}
            <div className="space-y-1">
              <label className="text-xs font-semibold text-slate-700">رقم هاتف العميل (اختياري)</label>
              <input
                type="tel"
                placeholder="010xxxxxxxx"
                value={clientPhone}
                onChange={(e) => setClientPhone(e.target.value)}
                className="w-full p-2.5 rounded-xl border border-slate-200 text-xs focus:outline-none focus:border-primary"
              />
            </div>

            <button
              type="submit"
              className="w-full py-2.5 rounded-xl bg-primary hover:bg-primary-dark text-white font-bold text-xs shadow-md shadow-primary/20 transition flex items-center justify-center gap-2"
            >
              <DollarSign className="w-4 h-4" />
              تنفيذ العملية وتحديث الدرج
            </button>
          </form>
        </div>

        {/* Recent Transactions List */}
        <div className="lg:col-span-2 bg-white p-5 rounded-2xl border border-slate-200 shadow-sm space-y-4">
          <div className="border-b border-slate-100 pb-3 flex items-center justify-between">
            <h3 className="font-bold text-slate-900 text-sm">حركات المحافظ اليومية</h3>
            <span className="text-xs text-slate-400">اليوم</span>
          </div>

          {recentTx.length === 0 ? (
            <div className="p-8 text-center text-slate-400 text-xs">
              لم تسجل عمليات محافظ جديدة اليوم بعد. استخدم الحاسبة بالأعلى لإجراء عملية سحب أو إيداع.
            </div>
          ) : (
            <div className="divide-y divide-slate-100">
              {recentTx.map((tx) => (
                <div key={tx.id} className="py-3 flex items-center justify-between text-xs">
                  <div className="flex items-center gap-2.5">
                    <div className={`w-8 h-8 rounded-lg flex items-center justify-center ${
                      tx.type === 'deposit' ? 'bg-emerald-50 text-emerald-600' : 'bg-indigo-50 text-indigo-600'
                    }`}>
                      {tx.type === 'deposit' ? <ArrowUpRight className="w-4 h-4" /> : <ArrowDownLeft className="w-4 h-4" />}
                    </div>
                    <div>
                      <div className="font-bold text-slate-800">
                        {tx.type === 'deposit' ? 'إيداع محفظة' : 'سحب كاش أوت'} • {tx.wallet_label}
                      </div>
                      <div className="text-[11px] text-slate-400">
                        {tx.client_phone ? `عميل: ${tx.client_phone}` : tx.phone_number} • {tx.time}
                      </div>
                    </div>
                  </div>

                  <div className="text-left font-mono">
                    <div className="font-black text-slate-900 text-sm">
                      {tx.amount.toLocaleString('en-US')} ج.م
                    </div>
                    <div className="text-[10px] font-bold text-emerald-600">
                      عمولة: +{tx.commission} ج.م
                    </div>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
};
