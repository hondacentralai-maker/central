import React, { useState, useEffect } from 'react';
import { Store, Search, Plus, ArrowUpRight, ArrowDownLeft } from 'lucide-react';
import { FastCreditAccount } from '../types';

export const FastCreditPage: React.FC = () => {
  const [accounts, setAccounts] = useState<FastCreditAccount[]>([]);
  const [searchTerm, setSearchTerm] = useState('');

  useEffect(() => {
    fetch('/migrated_data.json')
      .then(r => r.json())
      .then(d => {
        if (d.fast_credit_accounts) {
          setAccounts(d.fast_credit_accounts.map((a: any, idx: number) => ({
            id: `fc-${idx}`,
            name: a.name,
            account_type: 'partner_shop',
            current_balance: 0,
            notes: 'حساب مسجل من دفتر اليومية'
          })));
        }
      })
      .catch(() => {});
  }, []);

  const filtered = accounts.filter(a => a.name.toLowerCase().includes(searchTerm.toLowerCase()));

  return (
    <div className="space-y-5">
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3">
        <div>
          <h2 className="text-xl font-bold text-slate-900 flex items-center gap-2">
            <Store className="w-6 h-6 text-primary" />
            عملاء الأجل السريع (المحلات الزميلة)
          </h2>
          <p className="text-xs text-slate-500">
            حسابات جارية ومقاصة تشغيل بين المحلات الزميلة والمعارف ({accounts.length} حساب مسجل من الدفتر)
          </p>
        </div>
      </div>

      <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm flex items-center justify-between gap-3">
        <div className="relative w-full max-w-md">
          <Search className="w-4 h-4 absolute right-3 top-1/2 -translate-y-1/2 text-slate-400" />
          <input
            type="text"
            placeholder="ابحث باسم المحل أو الحساب..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full pr-9 pl-3 py-2 rounded-xl border border-slate-200 text-xs focus:outline-none focus:border-primary"
          />
        </div>
        <div className="text-xs font-bold text-slate-500">
          عدد الحسابات: {filtered.length}
        </div>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3.5">
        {filtered.map((acc) => (
          <div key={acc.id} className="p-4 rounded-2xl bg-white border border-slate-200 shadow-sm hover:shadow-md transition space-y-2">
            <div className="flex items-center justify-between">
              <span className="font-bold text-slate-900 text-sm">{acc.name}</span>
              <span className="text-[10px] px-2 py-0.5 rounded-full bg-slate-100 text-slate-600 font-semibold">
                محل زميل
              </span>
            </div>
            <div className="flex justify-between items-center pt-2 border-t border-slate-100 text-xs">
              <span className="text-slate-400">الرصيد الجاري:</span>
              <span className="font-bold text-slate-800 font-mono">
                {acc.current_balance.toLocaleString('en-US')} ج.م
              </span>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};
