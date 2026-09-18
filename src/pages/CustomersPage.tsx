import React, { useState, useEffect } from 'react';
import { 
  Users, 
  Search, 
  Phone, 
  CreditCard, 
  ArrowRight, 
  UserPlus, 
  CheckCircle2, 
  Clock, 
  DollarSign, 
  Calendar,
  Smartphone,
  PlusCircle,
  ShieldCheck,
  MapPin,
  FileText,
  Sparkles,
  Download,
  Upload,
  Edit3,
  Trash2,
  AlertTriangle,
  FileSpreadsheet,
  ChevronLeft,
  X,
  MessageSquare,
  Zap
} from 'lucide-react';

import type { Profile, Contract } from '../types';
import { StatementModal } from '../components/StatementModal';
import { PromissoryNoteModal } from '../components/PromissoryNoteModal';
import { excelService } from '../services/excelService';
import { api } from '../services/api';

// Helper for clean English numbers throughout the interface
const formatNum = (num: number | undefined | null): string => {
  return Number(num || 0).toLocaleString('en-US');
};

const formatCurrency = (num: number | undefined | null): string => {
  return `${formatNum(num)} ج.م`;
};

interface CustomersPageProps {
  profile?: Profile;
  onOpenCollection?: (contract?: Contract) => void;
  onDirectCollect?: (data: any) => void;
  initialCustomerTarget?: string | null;
}

export const CustomersPage: React.FC<CustomersPageProps> = ({ 
  profile: _profile, 
  onOpenCollection: _onOpenCollection, 
  onDirectCollect,
  initialCustomerTarget 
}) => {
  const customerCacheKey = _profile?.id ? `central_customers_state:${_profile.id}` : null;
  const [customersData, setCustomersData] = useState<any[]>([]);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedCustomer, setSelectedCustomer] = useState<any | null>(null);

  // Modals for PDF Statement & Promissory Note
  const [isStatementModalOpen, setIsStatementModalOpen] = useState(false);
  const [selectedContractForStatement, setSelectedContractForStatement] = useState<any | null>(null);

  const [isPromissoryModalOpen, setIsPromissoryModalOpen] = useState(false);
  const [selectedContractForPromissory, setSelectedContractForPromissory] = useState<any | null>(null);

  // Add Customer Modal State (NO CUSTOMER CODE)
  const [isAddModalOpen, setIsAddModalOpen] = useState(false);
  const [newCustName, setNewCustName] = useState('');
  const [newCustPhone, setNewCustPhone] = useState('');
  const [newCustSecPhone, setNewCustSecPhone] = useState('');
  const [newCustNationalId, setNewCustNationalId] = useState('');
  const [newCustAddress, setNewCustAddress] = useState('');
  
  // Guarantor Info
  const [newGuarantorName, setNewGuarantorName] = useState('');
  const [newGuarantorPhone, setNewGuarantorPhone] = useState('');
  const [newGuarantorRel, setNewGuarantorRel] = useState('');
  
  // Initial Installment Contract (OPEN manual input for months)
  const [includeContract, setIncludeContract] = useState(true);
  const [newDeviceName, setNewDeviceName] = useState('');
  const [newImei, setNewImei] = useState('');
  const [newCashPrice, setNewCashPrice] = useState('');
  const [newInstallmentPrice, setNewInstallmentPrice] = useState('');
  const [newDownPayment, setNewDownPayment] = useState('');
  const [newMonthsCount, setNewMonthsCount] = useState('10'); // OPEN MANUAL TYPING
  const [newFirstDueDate, setNewFirstDueDate] = useState('');

  // Add New Contract Modal for existing customer
  const [isNewContractModalOpen, setIsNewContractModalOpen] = useState(false);
  const [addCtrDevice, setAddCtrDevice] = useState('');
  const [addCtrImei, setAddCtrImei] = useState('');
  const [addCtrCashPrice, setAddCtrCashPrice] = useState('');
  const [addCtrInstPrice, setAddCtrInstPrice] = useState('');
  const [addCtrDownPay, setAddCtrDownPay] = useState('');
  const [addCtrMonths, setAddCtrMonths] = useState('10'); // OPEN MANUAL TYPING
  const [addCtrFirstDueDate, setAddCtrFirstDueDate] = useState('');

  // Edit Contract Modal
  const [isEditContractModalOpen, setIsEditContractModalOpen] = useState(false);
  const [editContractIdx, setEditContractIdx] = useState<number | null>(null);
  const [editDeviceName, setEditDeviceName] = useState('');
  const [editCashPrice, setEditCashPrice] = useState('');
  const [editInstPrice, setEditInstPrice] = useState('');
  const [editRemainingBalance, setEditRemainingBalance] = useState('');

  // Excel Import Modal
  const [isImportModalOpen, setIsImportModalOpen] = useState(false);
  const [importLoading, setImportLoading] = useState(false);
  const [importErrors, setImportErrors] = useState<string[]>([]);
  const [importSuccessMsg, setImportSuccessMsg] = useState('');

  // Installment Action Modals (Partial, Postpone, Early Settlement)
  const [partialModal, setPartialModal] = useState<{
    isOpen: boolean;
    contractIndex: number;
    instIndex: number;
    amount: string;
    maxAmount: number;
    currentDue: number;
  } | null>(null);

  const [postponeModal, setPostponeModal] = useState<{
    isOpen: boolean;
    contractIndex: number;
    instIndex: number;
    newDueDate: string;
    reason: string;
  } | null>(null);

  const [installmentNoteModal, setInstallmentNoteModal] = useState<{
    contractIndex: number;
    instIndex: number;
    text: string;
  } | null>(null);

  const [earlySettlementModal, setEarlySettlementModal] = useState<{
    isOpen: boolean;
    contractIndex: number;
    totalRemaining: number;
    discount: string;
    deviceName: string;
  } | null>(null);

  const [isLoading, setIsLoading] = useState(true);

  // Load customers
  useEffect(() => {
    loadCustomers();
  }, []);

  // Handle target customer navigation from Dashboard
  useEffect(() => {
    if (initialCustomerTarget && customersData.length > 0) {
      const match = customersData.find(c => 
        c.name === initialCustomerTarget || 
        (c.phone && c.phone === initialCustomerTarget)
      );
      if (match) {
        setSelectedCustomer(match);
      }
    }
  }, [initialCustomerTarget, customersData]);

  const loadCustomers = async () => {
    setIsLoading(true);
    try {
      const saved = customerCacheKey ? localStorage.getItem(customerCacheKey) : null;
      if (saved) {
        try {
          const cached = JSON.parse(saved);
          if (Array.isArray(cached) && cached.length > 0) {
            setCustomersData(cached);
            return;
          }
        } catch {}
      }

      const [customers, contracts, installments] = await Promise.all([
        api.getCustomers('', _profile?.organization_id, 500),
        api.getContracts(undefined, _profile?.organization_id),
        api.getInstallments(),
      ]);

      const list = customers.map((customer: any) => ({
        ...customer,
        national_id: customer.national_id || '',
        credit_status: customer.status === 'blocked' ? 'defaulted' : 'active',
        contracts: contracts
          .filter((contract: any) => contract.customer_id === customer.id)
          .map((contract: any) => ({
            ...contract,
            installment_price: contract.total_installment_price,
            installments: installments.filter((installment: any) => installment.contract_id === contract.id),
          })),
      }));
      setCustomersData(list);
      if (customerCacheKey) localStorage.setItem(customerCacheKey, JSON.stringify(list));
    } catch {
      //
    } finally {
      setIsLoading(false);
    }
  };

  const persistCustomersState = (updatedList: any[]) => {
    setCustomersData(updatedList);
    if (customerCacheKey) localStorage.setItem(customerCacheKey, JSON.stringify(updatedList));
  };

  // Toggle Customer Credit Status
  const handleToggleCreditStatus = () => {
    if (!selectedCustomer) return;
    const newStatus = selectedCustomer.credit_status === 'defaulted' ? 'active' : 'defaulted';
    const updatedCust = { ...selectedCustomer, credit_status: newStatus };
    const updatedList = customersData.map(c => c.name === selectedCustomer.name ? updatedCust : c);
    persistCustomersState(updatedList);
    setSelectedCustomer(updatedCust);
  };

  // Open Add Customer Modal
  const openAddCustomerModal = () => {
    setNewCustName('');
    setNewCustPhone('');
    setNewCustSecPhone('');
    setNewCustNationalId('');
    setNewCustAddress('');
    setNewGuarantorName('');
    setNewGuarantorPhone('');
    setNewGuarantorRel('');
    setNewDeviceName('');
    setNewImei('');
    setNewCashPrice('');
    setNewInstallmentPrice('');
    setNewDownPayment('');
    setNewMonthsCount('10');
    setNewFirstDueDate(new Date(Date.now() + 30*24*60*60*1000).toISOString().slice(0, 10));
    setIsAddModalOpen(true);
  };

  // Create Customer with open months input
  const handleCreateCustomer = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newCustName.trim()) return;

    const contracts = [];
    const instPrice = parseFloat(newInstallmentPrice) || 0;
    const downPay = parseFloat(newDownPayment) || 0;
    const months = parseInt(newMonthsCount) || 1;
    const remaining = Math.max(instPrice - downPay, 0);

    if (includeContract && instPrice > 0) {
      const installments = [];
      if (downPay > 0) {
        installments.push({
          item_type: 'down_payment',
          due_amount: downPay,
          paid_amount: downPay,
          remaining_amount: 0,
          due_date: new Date().toISOString().slice(0, 10),
          paid_date: new Date().toISOString().slice(0, 10),
          status: 'paid'
        });
      }

      const monthlyAmt = Math.round(remaining / Math.max(months, 1));
      for (let m = 1; m <= months; m++) {
        const dueDate = new Date(newFirstDueDate || Date.now());
        dueDate.setMonth(dueDate.getMonth() + (m - 1));
        installments.push({
          item_type: 'installment',
          due_amount: monthlyAmt,
          paid_amount: 0,
          remaining_amount: monthlyAmt,
          due_date: dueDate.toISOString().slice(0, 10),
          status: 'pending'
        });
      }

      contracts.push({
        device_name: newDeviceName.trim() || 'جهاز هاتف ذكي',
        imei: newImei.trim(),
        cash_price: parseFloat(newCashPrice) || 0,
        installment_price: instPrice,
        down_payment: downPay,
        remaining_balance: remaining,
        installment_count: months,
        installments: installments,
        status: 'active'
      });
    }

    const newCustomer = {
      name: newCustName.trim(),
      phone: newCustPhone.trim(),
      secondary_phone: newCustSecPhone.trim(),
      national_id: newCustNationalId.trim(),
      address: newCustAddress.trim(),
      sheet: 'عملاء جدد',
      credit_status: 'active',
      guarantor: {
        name: newGuarantorName.trim(),
        phone: newGuarantorPhone.trim(),
        relationship: newGuarantorRel.trim(),
      },
      contracts: contracts
    };

    const updated = [newCustomer, ...customersData];
    persistCustomersState(updated);
    setIsAddModalOpen(false);
    setSelectedCustomer(newCustomer);
  };

  // Add New Contract to Existing Customer
  const handleAddNewContractToCustomer = (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedCustomer || !addCtrDevice.trim()) return;

    const instPrice = parseFloat(addCtrInstPrice) || 0;
    const downPay = parseFloat(addCtrDownPay) || 0;
    const months = parseInt(addCtrMonths) || 1;
    const remaining = Math.max(instPrice - downPay, 0);

    const installments = [];
    if (downPay > 0) {
      installments.push({
        item_type: 'down_payment',
        due_amount: downPay,
        paid_amount: downPay,
        remaining_amount: 0,
        due_date: new Date().toISOString().slice(0, 10),
        paid_date: new Date().toISOString().slice(0, 10),
        status: 'paid'
      });
    }

    const monthlyAmt = Math.round(remaining / Math.max(months, 1));
    for (let m = 1; m <= months; m++) {
      const dueDate = new Date(addCtrFirstDueDate || Date.now());
      dueDate.setMonth(dueDate.getMonth() + (m - 1));
      installments.push({
        item_type: 'installment',
        due_amount: monthlyAmt,
        paid_amount: 0,
        remaining_amount: monthlyAmt,
        due_date: dueDate.toISOString().slice(0, 10),
        status: 'pending'
      });
    }

    const newContract = {
      device_name: addCtrDevice.trim(),
      imei: addCtrImei.trim(),
      cash_price: parseFloat(addCtrCashPrice) || 0,
      installment_price: instPrice,
      down_payment: downPay,
      remaining_balance: remaining,
      installment_count: months,
      installments: installments,
      status: 'active'
    };

    const updatedCust = {
      ...selectedCustomer,
      contracts: [...(selectedCustomer.contracts || []), newContract]
    };

    const updatedList = customersData.map(c => c.name === selectedCustomer.name ? updatedCust : c);
    persistCustomersState(updatedList);
    setSelectedCustomer(updatedCust);
    setIsNewContractModalOpen(false);
  };

  // Edit Contract Details
  const handleSaveContractEdit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedCustomer || editContractIdx === null) return;

    const updatedCust = { ...selectedCustomer };
    const ctr = updatedCust.contracts[editContractIdx];
    ctr.device_name = editDeviceName.trim() || ctr.device_name;
    ctr.cash_price = parseFloat(editCashPrice) || ctr.cash_price;
    ctr.installment_price = parseFloat(editInstPrice) || ctr.installment_price;
    ctr.remaining_balance = parseFloat(editRemainingBalance) || ctr.remaining_balance;

    const updatedList = customersData.map(c => c.name === selectedCustomer.name ? updatedCust : c);
    persistCustomersState(updatedList);
    setSelectedCustomer(updatedCust);
    setIsEditContractModalOpen(false);
  };

  // Delete Contract
  const handleDeleteContract = (contractIndex: number) => {
    if (!selectedCustomer) return;
    if (!window.confirm('هل أنت متأكد من رغبتك في حذف هذا العقد نهائياً؟')) return;

    const updatedCust = { ...selectedCustomer };
    updatedCust.contracts.splice(contractIndex, 1);

    const updatedList = customersData.map(c => c.name === selectedCustomer.name ? updatedCust : c);
    persistCustomersState(updatedList);
    setSelectedCustomer(updatedCust);
  };

  // 1-Click Fast Pay Installment
  const handleFastPayInstallment = (contractIndex: number, instIndex: number) => {
    if (!selectedCustomer) return;

    const updatedCust = { ...selectedCustomer };
    const contract = updatedCust.contracts[contractIndex];
    const inst = contract.installments[instIndex];

    const amountPaidNow = inst.remaining_amount > 0 ? inst.remaining_amount : inst.due_amount;
    
    inst.paid_amount = inst.due_amount;
    inst.remaining_amount = 0;
    inst.status = 'paid';
    inst.paid_date = new Date().toISOString().slice(0, 10);

    contract.remaining_balance = Math.max(contract.remaining_balance - amountPaidNow, 0);
    if (contract.remaining_balance === 0) {
      contract.status = 'completed';
    }

    const updatedList = customersData.map(c => c.name === selectedCustomer.name ? updatedCust : c);
    persistCustomersState(updatedList);
    setSelectedCustomer(updatedCust);

    if (onDirectCollect) {
      onDirectCollect({
        receiptNumber: 'REC-' + Math.floor(1000 + Math.random() * 9000),
        customerName: selectedCustomer.name,
        customerPhone: selectedCustomer.phone,
        contractNumber: `CTR-${contractIndex + 1}`,
        deviceName: contract.device_name,
        amount: amountPaidNow,
        remainingBalance: contract.remaining_balance,
        paymentMethod: 'كاش الدرج',
        date: new Date().toISOString().slice(0, 10)
      });
    }
  };

  // Partial Payment Submit
  const handlePartialPaymentSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!partialModal || !selectedCustomer) return;

    const num = parseFloat(partialModal.amount);
    if (!num || num <= 0 || num > partialModal.maxAmount) return;

    const updatedCust = { ...selectedCustomer };
    const contract = updatedCust.contracts[partialModal.contractIndex];
    const inst = contract.installments[partialModal.instIndex];

    inst.paid_amount = (inst.paid_amount || 0) + num;
    inst.remaining_amount = Math.max((inst.remaining_amount !== undefined ? inst.remaining_amount : inst.due_amount) - num, 0);

    if (inst.remaining_amount === 0) {
      inst.status = 'paid';
      inst.paid_date = new Date().toISOString().slice(0, 10);
    } else {
      inst.status = 'partially_paid';
    }

    contract.remaining_balance = Math.max(contract.remaining_balance - num, 0);

    const updatedList = customersData.map(c => c.name === selectedCustomer.name ? updatedCust : c);
    persistCustomersState(updatedList);
    setSelectedCustomer(updatedCust);

    if (onDirectCollect) {
      onDirectCollect({
        receiptNumber: 'REC-PART-' + Math.floor(1000 + Math.random() * 9000),
        customerName: selectedCustomer.name,
        customerPhone: selectedCustomer.phone,
        contractNumber: `CTR-${partialModal.contractIndex + 1}`,
        deviceName: `${contract.device_name} (سداد جزئي)`,
        amount: num,
        remainingBalance: contract.remaining_balance,
        paymentMethod: 'كاش الدرج (سداد جزئي)',
        date: new Date().toISOString().slice(0, 10)
      });
    }

    setPartialModal(null);
  };

  // Postpone Installment Submit
  const handlePostponeSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!postponeModal || !selectedCustomer) return;

    const updatedCust = { ...selectedCustomer };
    const contract = updatedCust.contracts[postponeModal.contractIndex];
    const inst = contract.installments[postponeModal.instIndex];

    inst.due_date = postponeModal.newDueDate;
    inst.status = 'postponed';
    inst.postpone_reason = postponeModal.reason;

    const updatedList = customersData.map(c => c.name === selectedCustomer.name ? updatedCust : c);
    persistCustomersState(updatedList);
    setSelectedCustomer(updatedCust);
    setPostponeModal(null);
  };

  const handleInstallmentNoteSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!installmentNoteModal || !selectedCustomer) return;

    const updatedCust = { ...selectedCustomer };
    const contract = updatedCust.contracts[installmentNoteModal.contractIndex];
    const inst = contract.installments[installmentNoteModal.instIndex];
    inst.notes = installmentNoteModal.text.trim();

    const updatedList = customersData.map(c => c.name === selectedCustomer.name ? updatedCust : c);
    persistCustomersState(updatedList);
    setSelectedCustomer(updatedCust);
    setInstallmentNoteModal(null);
  };

  // Early Settlement Submit
  const handleEarlySettlementSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!earlySettlementModal || !selectedCustomer) return;

    const discount = parseFloat(earlySettlementModal.discount) || 0;
    const netAmount = Math.max(earlySettlementModal.totalRemaining - discount, 0);

    const updatedCust = { ...selectedCustomer };
    const contract = updatedCust.contracts[earlySettlementModal.contractIndex];

    (contract.installments || []).forEach((inst: any) => {
      inst.paid_amount = inst.due_amount;
      inst.remaining_amount = 0;
      inst.status = 'paid';
      inst.paid_date = new Date().toISOString().slice(0, 10);
    });

    contract.remaining_balance = 0;
    contract.status = 'completed';

    const updatedList = customersData.map(c => c.name === selectedCustomer.name ? updatedCust : c);
    persistCustomersState(updatedList);
    setSelectedCustomer(updatedCust);

    if (onDirectCollect) {
      onDirectCollect({
        receiptNumber: 'REC-FINAL-' + Math.floor(1000 + Math.random() * 9000),
        customerName: selectedCustomer.name,
        customerPhone: selectedCustomer.phone,
        contractNumber: `CTR-${earlySettlementModal.contractIndex + 1}`,
        deviceName: `${contract.device_name} (مخالصة وسداد مبكر)`,
        amount: netAmount,
        remainingBalance: 0,
        paymentMethod: 'كاش الدرج (مخالصة نهائية)',
        date: new Date().toISOString().slice(0, 10)
      });
    }

    setEarlySettlementModal(null);
  };

  // Excel Upload
  const handleFileUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    setImportLoading(true);
    setImportErrors([]);
    setImportSuccessMsg('');

    try {
      const result = await excelService.parseExcelFile(file);
      if (result.customers.length > 0) {
        const merged = [...result.customers, ...customersData];
        persistCustomersState(merged);
        setImportSuccessMsg(`تم استيراد ${result.customers.length} عميل وعقودهم بنجاح!`);
      }
      if (result.errors.length > 0) {
        setImportErrors(result.errors);
      }
    } catch (err: any) {
      setImportErrors([err.message || 'حدث خطأ أثناء معالجة ملف الإكسل']);
    } finally {
      setImportLoading(false);
    }
  };

  // Filtered customers (search by name, phone, national ID)
  const filtered = customersData.filter((c) => {
    const q = searchTerm.toLowerCase().trim();
    if (!q) return true;
    return (
      (c.name || '').toLowerCase().includes(q) ||
      (c.phone || '').includes(q) ||
      (c.national_id || '').includes(q)
    );
  });

  // =========================================================================
  // VIEW: SINGLE CUSTOMER FILE (100% White Theme, English numbers, RTL flow)
  // =========================================================================
  if (selectedCustomer) {
    const isDefaulted = selectedCustomer.credit_status === 'defaulted';

    return (
      <div className="space-y-5 animate-in fade-in duration-150" dir="rtl">
        {/* Top Header: Pure White, Clean, No Customer Code */}
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 bg-white p-5 rounded-2xl border border-slate-200/90 shadow-sm">
          <div className="flex items-center gap-3">
            <button
              onClick={() => setSelectedCustomer(null)}
              className="p-2.5 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold text-xs flex items-center gap-1.5 transition active:scale-95 border border-slate-200"
            >
              <ArrowRight className="w-4 h-4 text-primary" />
              <span>العودة للعملاء</span>
            </button>
            <div>
              <h2 className="text-xl font-black text-slate-900 flex items-center gap-2">
                {selectedCustomer.name}
              </h2>
              <div className="flex items-center gap-3 text-xs text-slate-500 mt-1 flex-wrap font-sans">
                <span>الهاتف: <strong className="text-slate-800 font-mono">{selectedCustomer.phone || '-'}</strong></span>
                {selectedCustomer.national_id && <span>• الرقم القومي: <strong className="text-slate-800 font-mono">{selectedCustomer.national_id}</strong></span>}
                {selectedCustomer.address && <span>• العنوان: {selectedCustomer.address}</span>}
              </div>
            </div>
          </div>

          <div className="flex items-center gap-2 w-full sm:w-auto flex-wrap">
            {/* PDF Statement Button */}
            <button
              onClick={() => {
                setSelectedContractForStatement(null);
                setIsStatementModalOpen(true);
              }}
              className="px-3.5 py-2 rounded-xl bg-white hover:bg-slate-50 text-slate-700 border border-slate-200 font-bold text-xs flex items-center gap-1.5 shadow-sm transition active:scale-95"
            >
              <FileText className="w-4 h-4 text-primary" />
              <span>PDF كشف الحساب</span>
            </button>

            {/* Defaulted Toggle Button */}
            <button
              onClick={handleToggleCreditStatus}
              className={`px-3.5 py-2 rounded-xl font-bold text-xs flex items-center gap-1.5 transition active:scale-95 ${
                isDefaulted
                  ? 'bg-rose-50 text-rose-700 border border-rose-200 shadow-sm'
                  : 'bg-white hover:bg-slate-50 text-slate-600 border border-slate-200'
              }`}
            >
              <span className={`w-2 h-2 rounded-full ${isDefaulted ? 'bg-rose-600 animate-ping' : 'bg-slate-400'}`}></span>
              <span>{isDefaulted ? 'عميل متعثر ائتمانياً' : 'تمييز كمتعثر'}</span>
            </button>

            {/* Add Another Contract Button */}
            <button
              onClick={() => {
                setAddCtrDevice('');
                setAddCtrImei('');
                setAddCtrCashPrice('');
                setAddCtrInstPrice('');
                setAddCtrDownPay('');
                setAddCtrMonths('10');
                setAddCtrFirstDueDate(new Date().toISOString().slice(0, 10));
                setIsNewContractModalOpen(true);
              }}
              className="px-4 py-2 rounded-xl bg-primary hover:bg-primary/90 text-white font-black text-xs flex items-center gap-1.5 shadow transition active:scale-95"
            >
              <PlusCircle className="w-4 h-4" />
              <span>إضافة عقد جديد</span>
            </button>
          </div>
        </div>

        {/* Guarantor Card if available */}
        {selectedCustomer.guarantor && selectedCustomer.guarantor.name && (
          <div className="p-4 rounded-2xl bg-amber-50/70 border border-amber-200/80 text-xs flex items-center justify-between text-amber-950">
            <div className="flex items-center gap-2">
              <ShieldCheck className="w-4 h-4 text-amber-600 flex-shrink-0" />
              <span>
                <strong>بيانات الضامن:</strong> {selectedCustomer.guarantor.name} 
                {selectedCustomer.guarantor.phone && ` • هاتف: ${selectedCustomer.guarantor.phone}`}
                {selectedCustomer.guarantor.relationship && ` (صلة القرابة: ${selectedCustomer.guarantor.relationship})`}
              </span>
            </div>
          </div>
        )}

        {/* CONTRACTS LIST (White Cards, English numbers) */}
        <div className="space-y-6">
          {(!selectedCustomer.contracts || selectedCustomer.contracts.length === 0) ? (
            <div className="p-12 text-center text-slate-400 border border-dashed border-slate-200 rounded-2xl bg-white">
              لا توجد عقود تقسيط مسجلة لهذا العميل حالياً.
              <div className="mt-3">
                <button
                  onClick={() => setIsNewContractModalOpen(true)}
                  className="px-4 py-2 rounded-xl bg-primary text-white font-bold text-xs shadow"
                >
                  إضافة أول عقد الآن
                </button>
              </div>
            </div>
          ) : (
            selectedCustomer.contracts.map((ctr: any, ctrIdx: number) => {
              const totalVal = Number(ctr.installment_price || 0);
              const remaining = Number(ctr.remaining_balance || 0);
              const paid = totalVal - remaining;
              const cashPrice = Number(ctr.cash_price || 0);
              const isCompleted = remaining <= 0;

              return (
                <div 
                  key={ctrIdx} 
                  className="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden p-5 md:p-6 space-y-4"
                >
                  {/* Contract Header: Status & Device */}
                  <div className="space-y-4">
                    <div className="flex items-center justify-between border-b border-slate-100 pb-3">
                      <div className="flex items-center gap-2.5">
                        <span className={`px-2.5 py-0.5 rounded-full text-xs font-bold ${
                          isCompleted ? 'bg-emerald-100 text-emerald-800' : 'bg-blue-100 text-blue-800'
                        }`}>
                          {isCompleted ? 'مكتمل المسدد' : 'نشط'}
                        </span>
                        <h3 className="font-bold text-base text-slate-900">
                          {ctr.device_name} {ctr.imei ? `• IMEI: ${ctr.imei}` : ''}
                        </h3>
                      </div>
                      <span className="text-xs text-slate-400 font-mono">عقد #{ctrIdx + 1}</span>
                    </div>

                    {/* 4 Financial KPIs Grid (English numbers) */}
                    <div className="grid grid-cols-2 md:grid-cols-4 gap-3 text-center">
                      {/* 1. رأس المال */}
                      <div className="p-3.5 rounded-xl bg-slate-50 border border-slate-200 space-y-1">
                        <span className="text-xs text-slate-500 font-bold block">رأس المال (الكاش)</span>
                        <div className="text-lg font-black text-slate-900 font-mono">
                          {formatCurrency(cashPrice)}
                        </div>
                      </div>

                      {/* 2. إجمالي التقسيط */}
                      <div className="p-3.5 rounded-xl bg-blue-50/60 border border-blue-100 space-y-1">
                        <span className="text-xs text-blue-700 font-bold block">إجمالي التقسيط</span>
                        <div className="text-lg font-black text-blue-950 font-mono">
                          {formatCurrency(totalVal)}
                        </div>
                      </div>

                      {/* 3. المدفوع */}
                      <div className="p-3.5 rounded-xl bg-emerald-50/60 border border-emerald-100 space-y-1">
                        <span className="text-xs text-emerald-700 font-bold block">المدفوع</span>
                        <div className="text-lg font-black text-emerald-700 font-mono">
                          {formatCurrency(paid)}
                        </div>
                      </div>

                      {/* 4. المتبقي */}
                      <div className="p-3.5 rounded-xl bg-amber-50/60 border border-amber-100 space-y-1">
                        <span className="text-xs text-amber-700 font-bold block">المتبقي</span>
                        <div className="text-lg font-black text-amber-700 font-mono">
                          {formatCurrency(remaining)}
                        </div>
                      </div>
                    </div>

                    {/* Contract Action Toolbar */}
                    <div className="flex items-center justify-end gap-2 flex-wrap pt-1">
                      {/* تجهيز سند لأمر */}
                      <button
                        onClick={() => {
                          setSelectedContractForPromissory(ctr);
                          setIsPromissoryModalOpen(true);
                        }}
                        className="px-3 py-1.5 rounded-xl bg-purple-50 hover:bg-purple-100 text-purple-700 border border-purple-200 font-bold text-xs flex items-center gap-1.5 transition active:scale-95"
                      >
                        <FileText className="w-3.5 h-3.5" />
                        <span>تجهيز سند لأمر</span>
                      </button>

                      {/* سداد مبكر ومخالصة */}
                      {remaining > 0 && (
                        <button
                          onClick={() => setEarlySettlementModal({
                            isOpen: true,
                            contractIndex: ctrIdx,
                            totalRemaining: remaining,
                            discount: '0',
                            deviceName: ctr.device_name
                          })}
                          className="px-3 py-1.5 rounded-xl bg-emerald-50 hover:bg-emerald-100 text-emerald-700 border border-emerald-200 font-bold text-xs flex items-center gap-1.5 transition active:scale-95"
                        >
                          <Sparkles className="w-3.5 h-3.5 text-emerald-600" />
                          <span>سداد مبكر</span>
                        </button>
                      )}

                      {/* كشف العقد */}
                      <button
                        onClick={() => {
                          setSelectedContractForStatement(ctr);
                          setIsStatementModalOpen(true);
                        }}
                        className="px-3 py-1.5 rounded-xl bg-blue-50 hover:bg-blue-100 text-blue-700 border border-blue-200 font-bold text-xs flex items-center gap-1.5 transition active:scale-95"
                      >
                        <FileSpreadsheet className="w-3.5 h-3.5" />
                        <span>كشف العقد</span>
                      </button>

                      {/* تعديل */}
                      <button
                        onClick={() => {
                          setEditContractIdx(ctrIdx);
                          setEditDeviceName(ctr.device_name || '');
                          setEditCashPrice(String(ctr.cash_price || ''));
                          setEditInstPrice(String(ctr.installment_price || ''));
                          setEditRemainingBalance(String(ctr.remaining_balance || ''));
                          setIsEditContractModalOpen(true);
                        }}
                        className="px-3 py-1.5 rounded-xl bg-amber-50 hover:bg-amber-100 text-amber-700 border border-amber-200 font-bold text-xs flex items-center gap-1.5 transition active:scale-95"
                      >
                        <Edit3 className="w-3.5 h-3.5" />
                        <span>تعديل</span>
                      </button>

                      {/* حذف */}
                      <button
                        onClick={() => handleDeleteContract(ctrIdx)}
                        className="px-3 py-1.5 rounded-xl bg-rose-50 hover:bg-rose-100 text-rose-700 border border-rose-200 font-bold text-xs flex items-center gap-1.5 transition active:scale-95"
                      >
                        <Trash2 className="w-3.5 h-3.5" />
                        <span>حذف</span>
                      </button>
                    </div>
                  </div>

                  {/* Section: جدول الأقساط (RTL: Payment buttons on the right, numbers in English) */}
                  <div className="space-y-2.5 pt-3 border-t border-slate-100">
                    <div className="flex items-center justify-between text-xs text-slate-500 font-bold">
                      <span className="flex items-center gap-1.5 text-slate-800">
                        <Calendar className="w-4 h-4 text-primary" />
                        جدول الأقساط ({formatNum(ctr.installments?.length || 0)} قسط):
                      </span>
                    </div>

                    <div className="space-y-2">
                      {ctr.installments?.map((inst: any, instIdx: number) => {
                        const isPaid = inst.status === 'paid' || (inst.paid_amount >= inst.due_amount && inst.due_amount > 0);
                        const isDownPayment = inst.item_type === 'down_payment';
                        const isPostponed = inst.status === 'postponed';
                        const isPartial = !isPaid && inst.paid_amount > 0;

                        return (
                          <div
                            key={instIdx}
                            className={`p-3.5 rounded-xl border transition flex flex-col sm:flex-row sm:items-center justify-between gap-3 ${
                              isPaid
                                ? 'bg-slate-50/60 border-slate-200 text-slate-500'
                                : isPostponed
                                ? 'bg-purple-50/40 border-purple-200 text-slate-800'
                                : 'bg-white border-slate-200/90 text-slate-900 hover:border-primary/40 shadow-sm'
                            }`}
                          >
                            {/* RIGHT-TO-LEFT ROW: رقم القسط، المبلغ بالإنجليزي، التاريخ، الحالة، ثم أزرار السداد على اليمين */}
                            <div className="flex items-center gap-3 sm:gap-4 flex-wrap" dir="rtl">
                              {/* 1. Installment Badge */}
                              <span className="px-2.5 py-1 rounded-lg bg-slate-100 border border-slate-200 text-slate-900 font-mono font-bold text-xs">
                                {isDownPayment ? 'مقدم' : `#${instIdx}`}
                              </span>

                              {/* 2. Amount in English */}
                              <div className="font-mono font-black text-sm text-slate-900 flex items-center gap-1">
                                <span>{formatCurrency(inst.due_amount)}</span>
                              </div>

                              {/* 3. Due Date in English */}
                              <div className="text-xs text-slate-500 font-mono flex items-center gap-1">
                                <Clock className="w-3 h-3 text-slate-400" />
                                <span>{inst.due_date || '-'}</span>
                              </div>

                              {/* 4. Status Badge */}
                              {isPaid ? (
                                <span className="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs font-bold bg-emerald-100 text-emerald-800">
                                  <CheckCircle2 className="w-3.5 h-3.5 text-emerald-600" />
                                  مسدد
                                </span>
                              ) : isPostponed ? (
                                <span className="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs font-bold bg-purple-100 text-purple-800">
                                  <Calendar className="w-3.5 h-3.5 text-purple-600" />
                                  مؤجل لـ {inst.due_date}
                                </span>
                              ) : isPartial ? (
                                <span className="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs font-bold bg-blue-100 text-blue-800">
                                  سداد جزئي ({formatCurrency(inst.paid_amount)})
                                </span>
                              ) : (
                                <span className="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs font-bold bg-rose-100 text-rose-800">
                                  <span className="w-1.5 h-1.5 rounded-full bg-rose-600"></span>
                                  متأخر
                                </span>
                              )}

                              {/* 5. PAYMENT ACTION BUTTONS (ثم أزرار السداد على اليمين مباشرة) */}
                              {!isPaid && (
                                <div className="flex shrink-0 items-center gap-1.5 mr-1" dir="rtl" aria-label="إجراءات القسط">
                                  {/* Fast Pay (سريع) */}
                                  <button
                                    onClick={() => handleFastPayInstallment(ctrIdx, instIdx)}
                                    title="سداد فوري للقسط بالكامل وتوريده للدرج"
                                    className="px-3 py-1.5 rounded-lg bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs transition shadow-sm active:scale-95 flex items-center gap-1"
                                  >
                                    <Zap className="w-3 h-3 fill-current" />
                                    <span>سريع</span>
                                  </button>

                                  {/* Partial Pay (زائد) */}
                                  <button
                                    onClick={() => setPartialModal({
                                      isOpen: true,
                                      contractIndex: ctrIdx,
                                      instIndex: instIdx,
                                      amount: '',
                                      maxAmount: inst.remaining_amount > 0 ? inst.remaining_amount : inst.due_amount,
                                      currentDue: inst.remaining_amount > 0 ? inst.remaining_amount : inst.due_amount,
                                    })}
                                    title="سداد جزئي أو دفعة إضافية"
                                    className="px-2.5 py-1.5 rounded-lg bg-blue-50 hover:bg-blue-100 text-blue-700 border border-blue-200 font-bold text-xs transition active:scale-95"
                                  >
                                    <span>زائد</span>
                                  </button>

                                  {/* Postpone (تأجيل) */}
                                  <button
                                    onClick={() => {
                                      const nextM = new Date();
                                      nextM.setMonth(nextM.getMonth() + 1);
                                      setPostponeModal({
                                        isOpen: true,
                                        contractIndex: ctrIdx,
                                        instIndex: instIdx,
                                        newDueDate: nextM.toISOString().slice(0, 10),
                                        reason: ''
                                      });
                                    }}
                                    title="تأجيل موعد استحقاق القسط"
                                    className="px-2.5 py-1.5 rounded-lg bg-amber-50 hover:bg-amber-100 text-amber-700 border border-amber-200 font-bold text-xs transition active:scale-95"
                                  >
                                    <span>تأجيل</span>
                                  </button>

                                  {/* Installment note: visually the left-most action in RTL */}
                                  <button
                                    onClick={() => setInstallmentNoteModal({
                                      contractIndex: ctrIdx,
                                      instIndex,
                                      text: inst.notes || '',
                                    })}
                                    title="إضافة أو تعديل ملاحظة القسط"
                                    aria-label="إضافة أو تعديل ملاحظة القسط"
                                    className={`p-1.5 rounded-lg border transition active:scale-95 ${inst.notes ? 'bg-blue-50 border-blue-200 text-blue-700' : 'bg-white border-slate-200 text-slate-500 hover:bg-slate-50'}`}
                                  >
                                    <MessageSquare className="w-3.5 h-3.5" />
                                  </button>
                                </div>
                              )}
                            </div>

                            {/* LEFT SIDE (أقصى اليسار): توضيح إضافي إن وجد */}
                            <div className="flex items-center justify-end font-mono text-xs">
                              {isPaid ? (
                                <span className="text-emerald-700 font-bold bg-emerald-50/80 px-2.5 py-1 rounded-lg border border-emerald-200">
                                  مسدد بالكامل ✓
                                </span>
                              ) : isPartial ? (
                                <span className="text-blue-700 font-bold">
                                  المتبقي: {formatCurrency(inst.remaining_amount)}
                                </span>
                              ) : (
                                <span className="text-slate-400 text-[11px]">
                                  {ctr.device_name}
                                </span>
                              )}
                            </div>
                          </div>
                        );
                      })}
                    </div>
                  </div>
                </div>
              );
            })
          )}
        </div>

        {/* Modals */}
        <StatementModal
          isOpen={isStatementModalOpen}
          onClose={() => setIsStatementModalOpen(false)}
          customer={selectedCustomer}
          contract={selectedContractForStatement}
        />

        <PromissoryNoteModal
          isOpen={isPromissoryModalOpen}
          onClose={() => setIsPromissoryModalOpen(false)}
          customer={selectedCustomer}
          contract={selectedContractForPromissory}
        />

        {/* Add Contract Modal */}
        {isNewContractModalOpen && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/60 backdrop-blur-sm p-4 overflow-y-auto">
            <div className="bg-white rounded-2xl shadow-2xl max-w-lg w-full p-6 space-y-4 text-slate-900 border border-slate-200">
              <div className="flex items-center justify-between border-b border-slate-100 pb-3">
                <h3 className="font-bold text-base flex items-center gap-2">
                  <PlusCircle className="w-5 h-5 text-primary" />
                  إضافة عقد تقسيط جديد لـ {selectedCustomer.name}
                </h3>
                <button onClick={() => setIsNewContractModalOpen(false)} className="p-1 rounded-lg hover:bg-slate-100">
                  <X className="w-5 h-5 text-slate-400" />
                </button>
              </div>

              <form onSubmit={handleAddNewContractToCustomer} className="space-y-3.5 text-xs">
                <div>
                  <label className="font-bold block text-slate-700 mb-1">اسم الجهاز / السلعة *</label>
                  <input
                    type="text"
                    required
                    value={addCtrDevice}
                    onChange={(e) => setAddCtrDevice(e.target.value)}
                    placeholder="مثال: ريلمي C67 256GB"
                    className="w-full p-2.5 rounded-xl border border-slate-300 focus:ring-2 focus:ring-primary/20"
                  />
                </div>

                <div className="grid grid-cols-2 gap-3">
                  <div>
                    <label className="font-bold block text-slate-700 mb-1">سعر الكاش (رأس المال)</label>
                    <input
                      type="number"
                      value={addCtrCashPrice}
                      onChange={(e) => setAddCtrCashPrice(e.target.value)}
                      placeholder="0"
                      className="w-full p-2.5 rounded-xl border border-slate-300 font-mono"
                    />
                  </div>
                  <div>
                    <label className="font-bold block text-slate-700 mb-1">إجمالي سعر التقسيط *</label>
                    <input
                      type="number"
                      required
                      value={addCtrInstPrice}
                      onChange={(e) => setAddCtrInstPrice(e.target.value)}
                      placeholder="مثال: 12000"
                      className="w-full p-2.5 rounded-xl border border-slate-300 font-bold font-mono"
                    />
                  </div>
                </div>

                <div className="grid grid-cols-2 gap-3">
                  <div>
                    <label className="font-bold block text-slate-700 mb-1">الدفعة المقدمة</label>
                    <input
                      type="number"
                      value={addCtrDownPay}
                      onChange={(e) => setAddCtrDownPay(e.target.value)}
                      placeholder="0"
                      className="w-full p-2.5 rounded-xl border border-slate-300 font-mono"
                    />
                  </div>
                  <div>
                    <label className="font-bold block text-slate-700 mb-1">عدد الشهور (يدوي) *</label>
                    <input
                      type="number"
                      min="1"
                      max="120"
                      required
                      value={addCtrMonths}
                      onChange={(e) => setAddCtrMonths(e.target.value)}
                      placeholder="مثال: 6 أو 10 أو 18"
                      className="w-full p-2.5 rounded-xl border border-slate-300 font-bold font-mono text-primary"
                    />
                  </div>
                </div>

                {parseFloat(addCtrInstPrice) > 0 && (
                  <div className="p-3 rounded-xl bg-slate-50 border border-slate-200 flex items-center justify-between text-xs font-mono">
                    <span>المتبقي: <strong>{formatCurrency(parseFloat(addCtrInstPrice) - (parseFloat(addCtrDownPay) || 0))}</strong></span>
                    <span>القسط الشهري: <strong className="text-primary">{formatCurrency(Math.round((parseFloat(addCtrInstPrice) - (parseFloat(addCtrDownPay) || 0)) / Math.max(parseInt(addCtrMonths) || 1, 1)))}</strong></span>
                  </div>
                )}

                <div>
                  <label className="font-bold block text-slate-700 mb-1">تاريخ استحقاق أول قسط</label>
                  <input
                    type="date"
                    value={addCtrFirstDueDate}
                    onChange={(e) => setAddCtrFirstDueDate(e.target.value)}
                    className="w-full p-2.5 rounded-xl border border-slate-300 font-mono"
                  />
                </div>

                <div className="pt-2 flex items-center justify-end gap-2">
                  <button
                    type="button"
                    onClick={() => setIsNewContractModalOpen(false)}
                    className="px-4 py-2 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold"
                  >
                    إلغاء
                  </button>
                  <button
                    type="submit"
                    className="px-5 py-2 rounded-xl bg-primary hover:bg-primary/90 text-white font-black shadow"
                  >
                    حفظ العقد
                  </button>
                </div>
              </form>
            </div>
          </div>
        )}

        {/* Edit Contract Modal */}
        {isEditContractModalOpen && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/60 backdrop-blur-sm p-4">
            <div className="bg-white rounded-2xl shadow-2xl max-w-md w-full p-6 space-y-4 text-slate-900 border border-slate-200">
              <div className="flex items-center justify-between border-b border-slate-100 pb-3">
                <h3 className="font-bold text-base flex items-center gap-2">
                  <Edit3 className="w-5 h-5 text-amber-600" />
                  تعديل بيانات العقد
                </h3>
                <button onClick={() => setIsEditContractModalOpen(false)} className="p-1 rounded-lg hover:bg-slate-100">
                  <X className="w-5 h-5 text-slate-400" />
                </button>
              </div>

              <form onSubmit={handleSaveContractEdit} className="space-y-3 text-xs">
                <div>
                  <label className="font-bold block text-slate-700 mb-1">اسم الجهاز</label>
                  <input
                    type="text"
                    value={editDeviceName}
                    onChange={(e) => setEditDeviceName(e.target.value)}
                    className="w-full p-2.5 rounded-xl border border-slate-300"
                  />
                </div>
                <div className="grid grid-cols-2 gap-3">
                  <div>
                    <label className="font-bold block text-slate-700 mb-1">رأس المال (سعر الكاش)</label>
                    <input
                      type="number"
                      value={editCashPrice}
                      onChange={(e) => setEditCashPrice(e.target.value)}
                      className="w-full p-2.5 rounded-xl border border-slate-300 font-mono"
                    />
                  </div>
                  <div>
                    <label className="font-bold block text-slate-700 mb-1">إجمالي التقسيط</label>
                    <input
                      type="number"
                      value={editInstPrice}
                      onChange={(e) => setEditInstPrice(e.target.value)}
                      className="w-full p-2.5 rounded-xl border border-slate-300 font-mono"
                    />
                  </div>
                </div>
                <div>
                  <label className="font-bold block text-slate-700 mb-1">المتبقي الحالي في الذمة</label>
                  <input
                    type="number"
                    value={editRemainingBalance}
                    onChange={(e) => setEditRemainingBalance(e.target.value)}
                    className="w-full p-2.5 rounded-xl border border-slate-300 font-black text-primary font-mono"
                  />
                </div>
                <div className="pt-2 flex items-center justify-end gap-2">
                  <button
                    type="button"
                    onClick={() => setIsEditContractModalOpen(false)}
                    className="px-4 py-2 rounded-xl bg-slate-100 text-slate-700 font-bold"
                  >
                    إلغاء
                  </button>
                  <button
                    type="submit"
                    className="px-5 py-2 rounded-xl bg-amber-600 hover:bg-amber-500 text-white font-black"
                  >
                    حفظ التعديلات
                  </button>
                </div>
              </form>
            </div>
          </div>
        )}

        {/* Partial Payment Modal */}
        {partialModal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/60 backdrop-blur-sm p-4">
            <div className="bg-white rounded-2xl shadow-2xl max-w-sm w-full p-6 space-y-4 text-slate-900 border border-slate-200">
              <div className="flex items-center justify-between border-b border-slate-100 pb-3">
                <h3 className="font-bold text-base flex items-center gap-2">
                  <DollarSign className="w-5 h-5 text-blue-600" />
                  تسجيل سداد جزئي
                </h3>
                <button onClick={() => setPartialModal(null)} className="p-1 rounded-lg hover:bg-slate-100">
                  <X className="w-5 h-5 text-slate-400" />
                </button>
              </div>

              <form onSubmit={handlePartialPaymentSubmit} className="space-y-3 text-xs">
                <div className="p-3 rounded-xl bg-blue-50 text-blue-900 font-mono flex justify-between font-bold">
                  <span>المبلغ المستحق للقسط:</span>
                  <span>{formatCurrency(partialModal.currentDue)}</span>
                </div>

                <div>
                  <label className="font-bold block text-slate-700 mb-1">المبلغ المدفوع كاش الآن *</label>
                  <input
                    type="number"
                    step="any"
                    required
                    max={partialModal.maxAmount}
                    value={partialModal.amount}
                    onChange={(e) => setPartialModal({ ...partialModal, amount: e.target.value })}
                    placeholder="مثال: 500"
                    className="w-full p-2.5 rounded-xl border border-slate-300 font-black text-base text-blue-600 font-mono"
                  />
                  <span className="text-xs text-slate-500 mt-1 block font-mono">
                    الحد الأقصى للسداد: {formatCurrency(partialModal.maxAmount)}
                  </span>
                </div>

                <div className="pt-2 flex items-center justify-end gap-2">
                  <button
                    type="button"
                    onClick={() => setPartialModal(null)}
                    className="px-4 py-2 rounded-xl bg-slate-100 text-slate-700 font-bold"
                  >
                    إلغاء
                  </button>
                  <button
                    type="submit"
                    className="px-5 py-2 rounded-xl bg-blue-600 hover:bg-blue-500 text-white font-black"
                  >
                    تأكيد السداد وتحديث الدرج
                  </button>
                </div>
              </form>
            </div>
          </div>
        )}

        {/* Postpone Modal */}
        {postponeModal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/60 backdrop-blur-sm p-4">
            <div className="bg-white rounded-2xl shadow-2xl max-w-sm w-full p-6 space-y-4 text-slate-900 border border-slate-200">
              <div className="flex items-center justify-between border-b border-slate-100 pb-3">
                <h3 className="font-bold text-base flex items-center gap-2">
                  <Calendar className="w-5 h-5 text-amber-600" />
                  تأجيل استحقاق القسط
                </h3>
                <button onClick={() => setPostponeModal(null)} className="p-1 rounded-lg hover:bg-slate-100">
                  <X className="w-5 h-5 text-slate-400" />
                </button>
              </div>

              <form onSubmit={handlePostponeSubmit} className="space-y-3 text-xs">
                <div>
                  <label className="font-bold block text-slate-700 mb-1">الموعد الجديد للاستحقاق *</label>
                  <input
                    type="date"
                    required
                    value={postponeModal.newDueDate}
                    onChange={(e) => setPostponeModal({ ...postponeModal, newDueDate: e.target.value })}
                    className="w-full p-2.5 rounded-xl border border-slate-300 font-mono"
                  />
                </div>

                <div>
                  <label className="font-bold block text-slate-700 mb-1">سبب التأجيل (اختياري)</label>
                  <textarea
                    rows={2}
                    value={postponeModal.reason}
                    onChange={(e) => setPostponeModal({ ...postponeModal, reason: e.target.value })}
                    placeholder="مثال: طلب العميل التأجيل لظروف السفر"
                    className="w-full p-2.5 rounded-xl border border-slate-300"
                  />
                </div>

                <div className="pt-2 flex items-center justify-end gap-2">
                  <button
                    type="button"
                    onClick={() => setPostponeModal(null)}
                    className="px-4 py-2 rounded-xl bg-slate-100 text-slate-700 font-bold"
                  >
                    إلغاء
                  </button>
                  <button
                    type="submit"
                    className="px-5 py-2 rounded-xl bg-amber-600 hover:bg-amber-500 text-white font-black"
                  >
                    اعتماد التأجيل
                  </button>
                </div>
              </form>
            </div>
          </div>
        )}

        {/* Installment Note Modal */}
        {installmentNoteModal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/60 backdrop-blur-sm p-4">
            <div className="bg-white rounded-2xl shadow-2xl max-w-sm w-full p-6 space-y-4 text-slate-900 border border-slate-200">
              <div className="flex items-center justify-between border-b border-slate-100 pb-3">
                <h3 className="font-bold text-base flex items-center gap-2">
                  <MessageSquare className="w-5 h-5 text-primary" />
                  ملاحظة على القسط
                </h3>
                <button type="button" onClick={() => setInstallmentNoteModal(null)} className="p-1 rounded-lg hover:bg-slate-100" aria-label="إغلاق">
                  <X className="w-5 h-5 text-slate-400" />
                </button>
              </div>

              <form onSubmit={handleInstallmentNoteSubmit} className="space-y-3 text-xs">
                <label className="font-bold block text-slate-700">
                  تفاصيل القسط أو ملاحظة المحصل
                  <textarea
                    rows={4}
                    autoFocus
                    value={installmentNoteModal.text}
                    onChange={(e) => setInstallmentNoteModal({ ...installmentNoteModal, text: e.target.value })}
                    placeholder="مثال: العميل طلب التواصل بعد نزول المرتب"
                    className="mt-1.5 w-full p-2.5 rounded-xl border border-slate-300 focus:border-primary focus:outline-none"
                  />
                </label>

                <div className="pt-2 flex items-center justify-end gap-2">
                  <button type="button" onClick={() => setInstallmentNoteModal(null)} className="px-4 py-2 rounded-xl bg-slate-100 text-slate-700 font-bold">
                    إلغاء
                  </button>
                  <button type="submit" className="px-5 py-2 rounded-xl bg-primary hover:bg-primary-dark text-white font-black">
                    حفظ الملاحظة
                  </button>
                </div>
              </form>
            </div>
          </div>
        )}

        {/* Early Settlement Modal */}
        {earlySettlementModal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/60 backdrop-blur-sm p-4">
            <div className="bg-white rounded-2xl shadow-2xl max-w-md w-full p-6 space-y-4 text-slate-900 border border-slate-200">
              <div className="flex items-center justify-between border-b border-slate-100 pb-3">
                <h3 className="font-bold text-base flex items-center gap-2">
                  <Sparkles className="w-5 h-5 text-amber-600" />
                  سداد مبكر وإصدار مخالصة نهائية
                </h3>
                <button onClick={() => setEarlySettlementModal(null)} className="p-1 rounded-lg hover:bg-slate-100">
                  <X className="w-5 h-5 text-slate-400" />
                </button>
              </div>

              <form onSubmit={handleEarlySettlementSubmit} className="space-y-3.5 text-xs">
                <div className="p-4 rounded-xl bg-amber-50 border border-amber-200 space-y-1.5 font-mono">
                  <div className="flex justify-between font-bold text-slate-700">
                    <span>الجهاز / العقد:</span>
                    <span>{earlySettlementModal.deviceName}</span>
                  </div>
                  <div className="flex justify-between font-bold text-slate-700">
                    <span>إجمالي المتبقي:</span>
                    <span className="text-base text-slate-900">{formatCurrency(earlySettlementModal.totalRemaining)}</span>
                  </div>
                </div>

                <div>
                  <label className="font-bold block text-slate-700 mb-1">خصم السداد المبكر (كاش ديسكاونت)</label>
                  <input
                    type="number"
                    value={earlySettlementModal.discount}
                    onChange={(e) => setEarlySettlementModal({ ...earlySettlementModal, discount: e.target.value })}
                    placeholder="0"
                    className="w-full p-2.5 rounded-xl border border-slate-300 font-mono"
                  />
                </div>

                <div className="p-3 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-900 flex justify-between items-center font-mono">
                  <span className="font-bold">المطلوب تحصيله كاش للمخالصة:</span>
                  <span className="text-lg font-black">
                    {formatCurrency(Math.max(earlySettlementModal.totalRemaining - (parseFloat(earlySettlementModal.discount) || 0), 0))}
                  </span>
                </div>

                <div className="pt-2 flex items-center justify-end gap-2">
                  <button
                    type="button"
                    onClick={() => setEarlySettlementModal(null)}
                    className="px-4 py-2 rounded-xl bg-slate-100 text-slate-700 font-bold"
                  >
                    إلغاء
                  </button>
                  <button
                    type="submit"
                    className="px-5 py-2 rounded-xl bg-emerald-600 hover:bg-emerald-500 text-white font-black"
                  >
                    تأكيد المخالصة وإغلاق العقد
                  </button>
                </div>
              </form>
            </div>
          </div>
        )}
      </div>
    );
  }

  // =========================================================================
  // VIEW: MAIN CUSTOMERS LIST TABLE (NO CUSTOMER CODE, English numbers)
  // =========================================================================
  return (
    <div className="space-y-5" dir="rtl">
      {/* Top Header & Actions Toolbar */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-white p-5 rounded-2xl border border-slate-200 shadow-sm">
        <div>
          <h2 className="text-xl font-black text-slate-900 flex items-center gap-2">
            <Users className="w-6 h-6 text-primary" />
            سجل العملاء وعقود التقسيط
          </h2>
          <p className="text-xs text-slate-500 mt-0.5">
            إدارة مباشرة لبيانات العملاء والضامنين، جداول الأقساط، والتصدير والاستيراد من Excel.
          </p>
        </div>

        {/* Action Buttons */}
        <div className="flex items-center gap-2 flex-wrap">
          {/* Export to Excel */}
          <button
            onClick={() => excelService.exportCentralDataToExcel(customersData)}
            className="px-3.5 py-2.5 rounded-xl bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs flex items-center gap-1.5 shadow transition active:scale-95"
          >
            <Download className="w-4 h-4" />
            <span>تصدير Excel (.xlsx)</span>
          </button>

          {/* Import from Excel */}
          <button
            onClick={() => {
              setImportErrors([]);
              setImportSuccessMsg('');
              setIsImportModalOpen(true);
            }}
            className="px-3.5 py-2.5 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-800 font-bold text-xs flex items-center gap-1.5 border border-slate-200 transition active:scale-95"
          >
            <Upload className="w-4 h-4 text-primary" />
            <span>استيراد Excel</span>
          </button>

          {/* Add Customer Button */}
          <button
            onClick={openAddCustomerModal}
            className="px-4 py-2.5 rounded-xl bg-primary hover:bg-primary/90 text-white font-black text-xs flex items-center gap-2 shadow transition active:scale-95"
          >
            <UserPlus className="w-4 h-4" />
            <span>إضافة عميل جديد</span>
          </button>
        </div>
      </div>

      {/* Search Bar (NO customer code in placeholder) */}
      <div className="relative">
        <Search className="w-5 h-5 text-slate-400 absolute right-4 top-1/2 -translate-y-1/2" />
        <input
          type="text"
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          placeholder="ابحث باسم العميل، رقم الهاتف، أو الرقم القومي (14 رقم)..."
          className="w-full pr-12 pl-4 py-3 bg-white border border-slate-200 rounded-xl text-xs md:text-sm font-medium focus:outline-none focus:ring-2 focus:ring-primary/20 shadow-sm"
        />
      </div>

      {/* Customers Table (NO CUSTOMER CODE COLUMN) */}
      <div className="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-right text-xs">
            <thead className="bg-slate-50 border-b border-slate-200 text-slate-600 font-bold">
              <tr>
                <th className="p-3.5">اسم العميل</th>
                <th className="p-3.5">رقم الهاتف</th>
                <th className="p-3.5">الرقم القومي</th>
                <th className="p-3.5">العقود والسلع</th>
                <th className="p-3.5">إجمالي المتبقي</th>
                <th className="p-3.5">الحالة</th>
                <th className="p-3.5 text-center">الإجراءات</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {isLoading ? (
                <tr>
                  <td colSpan={7} className="p-8 text-center text-slate-400">
                    جاري تحميل سجل العملاء...
                  </td>
                </tr>
              ) : filtered.length === 0 ? (
                <tr>
                  <td colSpan={7} className="p-8 text-center text-slate-400">
                    لم يتم العثور على عملاء مطابقين للبحث.
                  </td>
                </tr>
              ) : (
                filtered.map((c, idx) => {
                  const rem = (c.contracts || []).reduce((sum: number, ctr: any) => sum + (ctr.remaining_balance || 0), 0);
                  const isDefaulted = c.credit_status === 'defaulted';

                  return (
                    <tr 
                      key={idx} 
                      onClick={() => setSelectedCustomer(c)}
                      className="hover:bg-slate-50/80 transition cursor-pointer"
                    >
                      <td className="p-3.5 font-bold text-slate-900 text-sm">
                        {c.name}
                      </td>
                      <td className="p-3.5 text-slate-600 font-mono">
                        {c.phone || '-'}
                      </td>
                      <td className="p-3.5 text-slate-500 font-mono">
                        {c.national_id || '-'}
                      </td>
                      <td className="p-3.5 text-slate-700 font-medium">
                        {formatNum(c.contracts?.length || 0)} عقد
                        {c.contracts?.[0]?.device_name && ` (${c.contracts[0].device_name})`}
                      </td>
                      <td className="p-3.5 font-black font-mono text-sm text-slate-900">
                        {formatCurrency(rem)}
                      </td>
                      <td className="p-3.5">
                        <span className={`px-2.5 py-1 rounded-full text-[11px] font-bold ${
                          isDefaulted ? 'bg-red-100 text-red-700' : 'bg-emerald-100 text-emerald-700'
                        }`}>
                          {isDefaulted ? 'متعثر ائتمانياً' : 'نشط وملتزم'}
                        </span>
                      </td>
                      <td className="p-3.5 text-center">
                        <button
                          onClick={(e) => {
                            e.stopPropagation();
                            setSelectedCustomer(c);
                          }}
                          className="px-3 py-1.5 rounded-lg bg-slate-100 hover:bg-slate-200 text-slate-800 font-bold text-xs inline-flex items-center gap-1 transition"
                        >
                          عرض الملف
                          <ChevronLeft className="w-3.5 h-3.5" />
                        </button>
                      </td>
                    </tr>
                  );
                })
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Add Customer Modal (NO CUSTOMER CODE) */}
      {isAddModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/60 backdrop-blur-sm p-4 overflow-y-auto">
          <div className="bg-white rounded-2xl shadow-2xl max-w-xl w-full p-6 space-y-4 text-slate-900 border border-slate-200 my-8">
            <div className="flex items-center justify-between border-b border-slate-100 pb-3">
              <h3 className="font-bold text-base flex items-center gap-2">
                <UserPlus className="w-5 h-5 text-primary" />
                إضافة عميل جديد
              </h3>
              <button onClick={() => setIsAddModalOpen(false)} className="p-1 rounded-lg hover:bg-slate-100">
                <X className="w-5 h-5 text-slate-400" />
              </button>
            </div>

            <form onSubmit={handleCreateCustomer} className="space-y-4 text-xs">
              <div>
                <label className="font-bold block text-slate-700 mb-1">اسم العميل بالكامل *</label>
                <input
                  type="text"
                  required
                  value={newCustName}
                  onChange={(e) => setNewCustName(e.target.value)}
                  placeholder="الاسم الثلاثي أو الرباعي"
                  className="w-full p-2.5 rounded-xl border border-slate-300 font-bold focus:ring-2 focus:ring-primary/20"
                />
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                <div>
                  <label className="font-bold block text-slate-700 mb-1">رقم الهاتف الأساسي *</label>
                  <input
                    type="tel"
                    required
                    value={newCustPhone}
                    onChange={(e) => setNewCustPhone(e.target.value)}
                    placeholder="010..."
                    className="w-full p-2.5 rounded-xl border border-slate-300 font-mono"
                  />
                </div>
                <div>
                  <label className="font-bold block text-slate-700 mb-1">هاتف بديل</label>
                  <input
                    type="tel"
                    value={newCustSecPhone}
                    onChange={(e) => setNewCustSecPhone(e.target.value)}
                    placeholder="011..."
                    className="w-full p-2.5 rounded-xl border border-slate-300 font-mono"
                  />
                </div>
                <div>
                  <label className="font-bold block text-slate-700 mb-1">الرقم القومي (14 رقم)</label>
                  <input
                    type="text"
                    maxLength={14}
                    value={newCustNationalId}
                    onChange={(e) => setNewCustNationalId(e.target.value)}
                    placeholder="2980101..."
                    className="w-full p-2.5 rounded-xl border border-slate-300 font-mono"
                  />
                </div>
              </div>

              <div>
                <label className="font-bold block text-slate-700 mb-1">العنوان ومحل الإقامة</label>
                <input
                  type="text"
                  value={newCustAddress}
                  onChange={(e) => setNewCustAddress(e.target.value)}
                  placeholder="المدينة / المركز / الشارع"
                  className="w-full p-2.5 rounded-xl border border-slate-300"
                />
              </div>

              {/* Guarantor Section */}
              <div className="p-3.5 rounded-xl bg-slate-50 border border-slate-200 space-y-2">
                <span className="font-bold text-slate-800 block text-xs flex items-center gap-1.5">
                  <ShieldCheck className="w-4 h-4 text-primary" />
                  بيانات الضامن (اختياري):
                </span>
                <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                  <div>
                    <label className="text-[11px] text-slate-600 block mb-1">اسم الضامن</label>
                    <input
                      type="text"
                      value={newGuarantorName}
                      onChange={(e) => setNewGuarantorName(e.target.value)}
                      placeholder="اسم الضامن"
                      className="w-full p-2 rounded-lg border border-slate-300 bg-white"
                    />
                  </div>
                  <div>
                    <label className="text-[11px] text-slate-600 block mb-1">هاتف الضامن</label>
                    <input
                      type="tel"
                      value={newGuarantorPhone}
                      onChange={(e) => setNewGuarantorPhone(e.target.value)}
                      placeholder="01..."
                      className="w-full p-2 rounded-lg border border-slate-300 bg-white font-mono"
                    />
                  </div>
                  <div>
                    <label className="text-[11px] text-slate-600 block mb-1">صلة القرابة</label>
                    <input
                      type="text"
                      value={newGuarantorRel}
                      onChange={(e) => setNewGuarantorRel(e.target.value)}
                      placeholder="أخ، والد..."
                      className="w-full p-2 rounded-lg border border-slate-300 bg-white"
                    />
                  </div>
                </div>
              </div>

              {/* Initial Contract Section (OPEN manual typing for months) */}
              <div className="p-4 rounded-xl bg-blue-50/60 border border-blue-200 space-y-3">
                <div className="flex items-center justify-between">
                  <span className="font-bold text-blue-950 flex items-center gap-1.5">
                    <Smartphone className="w-4 h-4 text-primary" />
                    تسجيل أول عقد تقسيط للعميل فوراً
                  </span>
                  <input
                    type="checkbox"
                    checked={includeContract}
                    onChange={(e) => setIncludeContract(e.target.checked)}
                    className="w-4 h-4 accent-primary rounded"
                  />
                </div>

                {includeContract && (
                  <div className="space-y-3 pt-2">
                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                      <div>
                        <label className="text-[11px] font-bold text-slate-700 block mb-1">اسم الجهاز *</label>
                        <input
                          type="text"
                          required={includeContract}
                          value={newDeviceName}
                          onChange={(e) => setNewDeviceName(e.target.value)}
                          placeholder="مثال: ريدمي 13C 128GB"
                          className="w-full p-2 rounded-lg border border-slate-300 bg-white"
                        />
                      </div>
                      <div>
                        <label className="text-[11px] font-bold text-slate-700 block mb-1">IMEI السيريال</label>
                        <input
                          type="text"
                          value={newImei}
                          onChange={(e) => setNewImei(e.target.value)}
                          placeholder="86..."
                          className="w-full p-2 rounded-lg border border-slate-300 bg-white font-mono"
                        />
                      </div>
                    </div>

                    <div className="grid grid-cols-1 sm:grid-cols-4 gap-3">
                      <div>
                        <label className="text-[11px] font-bold text-slate-700 block mb-1">سعر الكاش</label>
                        <input
                          type="number"
                          value={newCashPrice}
                          onChange={(e) => setNewCashPrice(e.target.value)}
                          placeholder="0"
                          className="w-full p-2 rounded-lg border border-slate-300 bg-white font-mono"
                        />
                      </div>
                      <div>
                        <label className="text-[11px] font-bold text-slate-700 block mb-1">إجمالي التقسيط *</label>
                        <input
                          type="number"
                          required={includeContract}
                          value={newInstallmentPrice}
                          onChange={(e) => setNewInstallmentPrice(e.target.value)}
                          placeholder="مثال: 9500"
                          className="w-full p-2 rounded-lg border border-slate-300 bg-white font-mono font-bold"
                        />
                      </div>
                      <div>
                        <label className="text-[11px] font-bold text-slate-700 block mb-1">المقدم المدفوع</label>
                        <input
                          type="number"
                          value={newDownPayment}
                          onChange={(e) => setNewDownPayment(e.target.value)}
                          placeholder="0"
                          className="w-full p-2 rounded-lg border border-slate-300 bg-white font-mono"
                        />
                      </div>
                      <div>
                        <label className="text-[11px] font-bold text-slate-700 block mb-1">عدد الشهور (يدوي) *</label>
                        <input
                          type="number"
                          min="1"
                          max="120"
                          required={includeContract}
                          value={newMonthsCount}
                          onChange={(e) => setNewMonthsCount(e.target.value)}
                          placeholder="مثال: 10"
                          className="w-full p-2 rounded-lg border border-slate-300 bg-white font-mono font-bold text-primary"
                        />
                      </div>
                    </div>

                    {parseFloat(newInstallmentPrice) > 0 && (
                      <div className="p-2.5 rounded-xl bg-white border border-blue-200 flex items-center justify-between text-xs font-mono">
                        <span>المتبقي: <strong>{formatCurrency(parseFloat(newInstallmentPrice) - (parseFloat(newDownPayment) || 0))}</strong></span>
                        <span>القسط الشهري: <strong className="text-primary">{formatCurrency(Math.round((parseFloat(newInstallmentPrice) - (parseFloat(newDownPayment) || 0)) / Math.max(parseInt(newMonthsCount) || 1, 1)))}</strong></span>
                      </div>
                    )}
                  </div>
                )}
              </div>

              <div className="pt-2 flex items-center justify-end gap-2 border-t border-slate-100">
                <button
                  type="button"
                  onClick={() => setIsAddModalOpen(false)}
                  className="px-4 py-2 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold"
                >
                  إلغاء
                </button>
                <button
                  type="submit"
                  className="px-6 py-2.5 rounded-xl bg-primary hover:bg-primary/90 text-white font-black shadow"
                >
                  حفظ العميل بنجاح
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Import from Excel Modal */}
      {isImportModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/60 backdrop-blur-sm p-4">
          <div className="bg-white rounded-2xl shadow-2xl max-w-lg w-full p-6 space-y-4 text-slate-900 border border-slate-200">
            <div className="flex items-center justify-between border-b border-slate-100 pb-3">
              <h3 className="font-bold text-base flex items-center gap-2">
                <FileSpreadsheet className="w-5 h-5 text-emerald-600" />
                استيراد بيانات العملاء والأقساط من Excel
              </h3>
              <button onClick={() => setIsImportModalOpen(false)} className="p-1 rounded-lg hover:bg-slate-100">
                <X className="w-5 h-5 text-slate-400" />
              </button>
            </div>

            <div className="space-y-3 text-xs">
              <p className="text-slate-600">
                يمكنك رفع ملف إكسل يحتوي على بيانات العملاء والعقود وسيقوم النظام بتسجيلهم وتوليد جداول الأقساط تلقائياً.
              </p>

              {/* Template Download */}
              <div className="p-3.5 rounded-xl bg-slate-50 border border-slate-200 flex items-center justify-between">
                <div>
                  <span className="font-bold text-slate-800 block">نموذج الإكسل الجاهز:</span>
                  <span className="text-[11px] text-slate-500">حمل النموذج الفارغ لتعبئة بياناتك عليه بكل سهولة</span>
                </div>
                <button
                  onClick={() => excelService.downloadImportTemplate()}
                  className="px-3 py-1.5 rounded-lg bg-slate-200 hover:bg-slate-300 text-slate-800 font-bold text-xs flex items-center gap-1"
                >
                  <Download className="w-3.5 h-3.5" />
                  تحميل النموذج
                </button>
              </div>

              {/* Upload Input */}
              <div className="border-2 border-dashed border-slate-300 hover:border-primary/50 rounded-xl p-6 text-center space-y-2 cursor-pointer bg-slate-50/50">
                <Upload className="w-8 h-8 text-slate-400 mx-auto" />
                <label className="block font-bold text-slate-800 cursor-pointer">
                  اختر ملف Excel (.xlsx أو .xls)
                  <input
                    type="file"
                    accept=".xlsx, .xls, .csv"
                    onChange={handleFileUpload}
                    className="hidden"
                  />
                </label>
                <span className="text-[11px] text-slate-400 block">
                  سيتم دمج البيانات المرفوعة مع السجل الحالي دون فقد أي بيانات سابقة
                </span>
              </div>

              {importLoading && (
                <div className="text-center py-2 text-primary font-bold">
                  جاري قراءة ومعالجة ملف الإكسل...
                </div>
              )}

              {importSuccessMsg && (
                <div className="p-3 rounded-xl bg-emerald-50 text-emerald-800 border border-emerald-200 font-bold">
                  {importSuccessMsg}
                </div>
              )}

              {importErrors.length > 0 && (
                <div className="p-3 rounded-xl bg-red-50 text-red-800 border border-red-200 space-y-1">
                  {importErrors.map((err, i) => (
                    <p key={i}>• {err}</p>
                  ))}
                </div>
              )}

              <div className="pt-2 flex justify-end">
                <button
                  onClick={() => setIsImportModalOpen(false)}
                  className="px-5 py-2 rounded-xl bg-slate-800 hover:bg-slate-700 text-white font-bold"
                >
                  إغلاق
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
