import React, { useState, useEffect } from 'react';
import { Users, Search, PlusCircle, Phone, CreditCard, ChevronRight, X, UserPlus, AlertCircle } from 'lucide-react';
import { api } from '../services/api';
import { Customer } from '../types';

export const CustomersPage: React.FC = () => {
  const [customers, setCustomers] = useState<Customer[]>([]);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedCustomer, setSelectedCustomer] = useState<Customer | null>(null);
  const [isAddModalOpen, setIsAddModalOpen] = useState(false);
  const [newCustName, setNewCustName] = useState('');
  const [newCustPhone, setNewCustPhone] = useState('');
  const [newCustAddress, setNewCustAddress] = useState('');
  const [newGuarantorName, setNewGuarantorName] = useState('');
  const [newGuarantorPhone, setNewGuarantorPhone] = useState('');
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    loadData();
  }, []);

  const loadData = async () => {
    setIsLoading(true);
    try {
      const data = await api.getCustomers();
      if (data && data.length > 0) {
        setCustomers(data);
      } else {
        // Load fallback from migrated_data.json
        const res = await fetch('/migrated_data.json');
        if (res.ok) {
          const json = await res.json();
          const list: Customer[] = json.customers.map((c: any, idx: number) => {
            const totAmt = c.contracts.reduce((sum: number, x: any) => sum + (x.installment_price || 0), 0);
            const remAmt = c.contracts.reduce((sum: number, x: any) => sum + (x.remaining_balance || 0), 0);
            return {
              id: `cus-${idx + 1}`,
              code: `CUS-${(idx + 1).toString().padStart(5, '0')}`,
              name: c.name,
              phone: c.phone,
              status: 'active',
              total_contracts_amount: totAmt,
              total_paid_amount: totAmt - remAmt,
              current_balance: remAmt,
              created_at: '2025-01-01'
            };
          });
          setCustomers(list);
        }
      }
    } catch {
      //
    } finally {
      setIsLoading(false);
    }
  };

  const handleCreateCustomer = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newCustName.trim()) return;

    const newCust: Customer = {
      id: `cus-${Date.now()}`,
      code: `CUS-${Math.floor(10000 + Math.random() * 90000)}`,
      name: newCustName.trim(),
      phone: newCustPhone.trim(),
      address: newCustAddress.trim(),
      status: 'active',
      total_contracts_amount: 0,
      total_paid_amount: 0,
      current_balance: 0,
      created_at: new Date().toISOString()
    };

    setCustomers([newCust, ...customers]);
    setIsAddModalOpen(false);
    setNewCustName('');
    setNewCustPhone('');
    setNewCustAddress('');
    setNewGuarantorName('');
    setNewGuarantorPhone('');
  };

  const filtered = customers.filter((c) =>
    c.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    (c.phone || '').includes(searchTerm) ||
    c.code.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="space-y-5">
      {/* Header */}
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3">
        <div>
          <h2 className="text-xl font-bold text-slate-900 flex items-center gap-2">
            <Users className="w-6 h-6 text-primary" />
            سجل العملاء والضامنين
          </h2>
          <p className="text-xs text-slate-500">دليل عملاء السنترال، أرصدة الديون، وسجل المعاملات</p>
        </div>

        <button
          onClick={() => setIsAddModalOpen(true)}
          className="px-4 py-2.5 rounded-xl bg-primary hover:bg-primary-dark text-white font-bold text-xs shadow-md shadow-primary/20 flex items-center gap-2 transition"
        >
          <UserPlus className="w-4 h-4" />
          إضافة عميل جديد
        </button>
      </div>

      {/* Search Bar */}
      <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm flex items-center justify-between gap-3">
        <div className="relative w-full max-w-md">
          <Search className="w-4 h-4 absolute right-3 top-1/2 -translate-y-1/2 text-slate-400" />
          <input
            type="text"
            placeholder="ابحث باسم العميل أو رقم الهاتف أو الكود..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full pr-9 pl-3 py-2 rounded-xl border border-slate-200 text-xs focus:outline-none focus:border-primary"
          />
        </div>

        <div className="text-xs font-bold text-slate-500">
          عدد العملاء: {filtered.length}
        </div>
      </div>

      {/* Customers List Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3.5">
        {isLoading ? (
          <div className="col-span-full p-12 text-center text-slate-400 text-sm">جاري تحميل سجل العملاء...</div>
        ) : filtered.length === 0 ? (
          <div className="col-span-full p-12 text-center space-y-2">
            <Users className="w-10 h-10 text-slate-300 mx-auto" />
            <div className="font-bold text-slate-700 text-sm">لا يوجد عميل مطابق للبحث</div>
          </div>
        ) : (
          filtered.map((c) => (
            <div
              key={c.id}
              onClick={() => setSelectedCustomer(c)}
              className="p-4 rounded-2xl bg-white border border-slate-200 shadow-sm hover:border-primary/40 hover:shadow-md transition cursor-pointer flex flex-col justify-between space-y-3"
            >
              <div className="flex items-start justify-between">
                <div>
                  <h4 className="font-bold text-slate-900 text-sm">{c.name}</h4>
                  <div className="text-slate-400 text-xs flex items-center gap-1 mt-0.5">
                    <Phone className="w-3 h-3" />
                    <span>{c.phone || 'بدون رقم هاتف'}</span>
                  </div>
                </div>
                <span className="text-[10px] font-mono px-2 py-0.5 rounded-md bg-slate-100 text-slate-600 font-bold">
                  {c.code}
                </span>
              </div>

              <div className="pt-2 border-t border-slate-100 flex items-center justify-between text-xs">
                <div>
                  <span className="text-slate-400 block text-[11px]">المتبقي عليه:</span>
                  <span className={`font-black text-sm ${c.current_balance > 0 ? 'text-primary' : 'text-emerald-600'}`}>
                    {c.current_balance.toLocaleString('ar-EG')} ج.م
                  </span>
                </div>

                <div className="text-left">
                  <span className="text-slate-400 block text-[11px]">إجمالي العقود:</span>
                  <span className="font-semibold text-slate-700">
                    {c.total_contracts_amount.toLocaleString('ar-EG')} ج.م
                  </span>
                </div>
              </div>
            </div>
          ))
        )}
      </div>

      {/* Customer Details Drawer / Modal */}
      {selectedCustomer && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/60 backdrop-blur-sm p-4">
          <div className="bg-white rounded-2xl max-w-md w-full p-5 shadow-2xl space-y-4">
            <div className="flex items-center justify-between border-b border-slate-100 pb-3">
              <div>
                <span className="text-xs text-slate-400 font-mono">{selectedCustomer.code}</span>
                <h3 className="font-bold text-slate-900 text-base">{selectedCustomer.name}</h3>
              </div>
              <button onClick={() => setSelectedCustomer(null)} className="p-1 text-slate-400 hover:text-slate-600">
                <X className="w-5 h-5" />
              </button>
            </div>

            <div className="space-y-3 text-xs">
              <div className="p-3 rounded-xl bg-slate-50 space-y-1.5">
                <div className="flex justify-between">
                  <span className="text-slate-500">رقم الهاتف:</span>
                  <span className="font-bold">{selectedCustomer.phone || 'غير مسجل'}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-slate-500">حالة العميل:</span>
                  <span className="font-bold text-emerald-600">نشط</span>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-2">
                <div className="p-3 rounded-xl bg-blue-50 text-blue-900">
                  <div className="text-[11px] text-blue-700">المتبقي حالياً:</div>
                  <div className="text-lg font-black">{selectedCustomer.current_balance.toLocaleString('ar-EG')} ج.م</div>
                </div>
                <div className="p-3 rounded-xl bg-emerald-50 text-emerald-900">
                  <div className="text-[11px] text-emerald-700">المسدد سابقاً:</div>
                  <div className="text-lg font-black">{selectedCustomer.total_paid_amount.toLocaleString('ar-EG')} ج.م</div>
                </div>
              </div>

              {selectedCustomer.phone && (
                <a
                  href={`https://api.whatsapp.com/send?phone=2${selectedCustomer.phone.replace(/[^0-9]/g, '')}`}
                  target="_blank"
                  rel="noreferrer"
                  className="w-full py-2.5 rounded-xl bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs flex items-center justify-center gap-2 transition"
                >
                  فتح محادثة WhatsApp مع العميل
                </a>
              )}
            </div>
          </div>
        </div>
      )}

      {/* Add Customer Modal */}
      {isAddModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/60 backdrop-blur-sm p-4">
          <div className="bg-white rounded-2xl max-w-md w-full p-5 shadow-2xl space-y-4">
            <div className="flex items-center justify-between border-b border-slate-100 pb-3">
              <h3 className="font-bold text-slate-900 text-sm">إضافة عميل جديد</h3>
              <button onClick={() => setIsAddModalOpen(false)} className="p-1 text-slate-400 hover:text-slate-600">
                <X className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleCreateCustomer} className="space-y-3">
              <div>
                <label className="block text-xs font-semibold text-slate-700 mb-1">اسم العميل بالكامل *</label>
                <input
                  type="text"
                  required
                  placeholder="مثال: أحمد محمد علي"
                  value={newCustName}
                  onChange={(e) => setNewCustName(e.target.value)}
                  className="w-full p-2.5 rounded-xl border border-slate-200 text-xs focus:outline-none focus:border-primary"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-slate-700 mb-1">رقم هاتف العميل</label>
                <input
                  type="tel"
                  placeholder="010xxxxxxxx"
                  value={newCustPhone}
                  onChange={(e) => setNewCustPhone(e.target.value)}
                  className="w-full p-2.5 rounded-xl border border-slate-200 text-xs focus:outline-none focus:border-primary"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-slate-700 mb-1">العنوان أو المنطقة</label>
                <input
                  type="text"
                  placeholder="العنوان..."
                  value={newCustAddress}
                  onChange={(e) => setNewCustAddress(e.target.value)}
                  className="w-full p-2.5 rounded-xl border border-slate-200 text-xs focus:outline-none focus:border-primary"
                />
              </div>

              <div className="p-3 rounded-xl bg-slate-50 border border-slate-200 space-y-2">
                <div className="text-xs font-bold text-slate-700">بيانات الضامن (اختياري للتقسيط)</div>
                <input
                  type="text"
                  placeholder="اسم الضامن..."
                  value={newGuarantorName}
                  onChange={(e) => setNewGuarantorName(e.target.value)}
                  className="w-full p-2 rounded-lg border border-slate-200 text-xs focus:outline-none focus:border-primary"
                />
                <input
                  type="tel"
                  placeholder="هاتف الضامن..."
                  value={newGuarantorPhone}
                  onChange={(e) => setNewGuarantorPhone(e.target.value)}
                  className="w-full p-2 rounded-lg border border-slate-200 text-xs focus:outline-none focus:border-primary"
                />
              </div>

              <div className="flex gap-2 pt-2">
                <button
                  type="button"
                  onClick={() => setIsAddModalOpen(false)}
                  className="flex-1 py-2 rounded-xl border border-slate-200 text-slate-600 text-xs font-semibold hover:bg-slate-50"
                >
                  إلغاء
                </button>
                <button
                  type="submit"
                  className="flex-1 py-2 rounded-xl bg-primary text-white text-xs font-bold hover:bg-primary-dark shadow-sm"
                >
                  حفظ العميل
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
