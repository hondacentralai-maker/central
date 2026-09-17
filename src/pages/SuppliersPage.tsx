import React, { useState, useEffect } from 'react';
import { Truck, Plus, DollarSign, Search } from 'lucide-react';
import { Supplier } from '../types';

export const SuppliersPage: React.FC = () => {
  const initialSuppliers: Supplier[] = [
    { id: 's1', name: 'حمادة ابو علي', current_balance: 14500, notes: 'مورد أجهزة هواتف' },
    { id: 's2', name: 'علي مدحتكو', current_balance: 10700, notes: 'مورد هواتف واكسسوارات' },
    { id: 's3', name: 'مجدي السلطان', current_balance: 9025, notes: 'مورد أجهزة' },
    { id: 's4', name: 'عمر مدحتكو', current_balance: 4475, notes: 'مورد أجهزة' },
    { id: 's5', name: 'الشهاوي', current_balance: 5125, notes: 'مورد هواتف' },
    { id: 's6', name: 'ابراهيم (محل اليمان)', current_balance: 15515, notes: 'مورد أجهزة ومحافظ' },
  ];

  const [suppliers, setSuppliers] = useState<Supplier[]>(initialSuppliers);

  return (
    <div className="space-y-5">
      <div>
        <h2 className="text-xl font-bold text-slate-900 flex items-center gap-2">
          <Truck className="w-6 h-6 text-primary" />
          الموردين والمشتريات
        </h2>
        <p className="text-xs text-slate-500">حسابات موردي الهواتف الذكية والأجهزة الموثقة من الدفتر</p>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
        {suppliers.map((s) => (
          <div key={s.id} className="p-5 rounded-2xl bg-white border border-slate-200 shadow-sm flex flex-col justify-between space-y-3">
            <div>
              <div className="text-[11px] text-slate-400">مورد مسجل</div>
              <h3 className="font-bold text-slate-900 text-base">{s.name}</h3>
              <p className="text-xs text-slate-500 mt-1">{s.notes}</p>
            </div>

            <div className="pt-3 border-t border-slate-100 flex items-center justify-between">
              <div>
                <span className="text-[11px] text-slate-400 block">رصيد المورد المستحق:</span>
                <span className="text-xl font-black text-rose-600 font-mono">
                  {s.current_balance.toLocaleString('en-US')} ج.م
                </span>
              </div>

              <button className="px-3 py-1.5 rounded-xl bg-slate-900 hover:bg-slate-800 text-white font-bold text-xs transition">
                سداد دفعة
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};
