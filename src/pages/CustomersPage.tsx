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
  Share2, 
  Calendar,
  Smartphone,
  PlusCircle,
  Hash,
  ShieldCheck,
  MapPin,
  FileText,
  Sparkles,
  Printer,
  Download,
  Upload,
  Edit3,
  Trash2,
  AlertTriangle,
  FileSpreadsheet,
  ChevronLeft,
  X,
  MessageCircle,
  Zap
} from 'lucide-react';

import type { Profile, Contract } from '../types';
import { StatementModal } from '../components/StatementModal';
import { PromissoryNoteModal } from '../components/PromissoryNoteModal';
import { excelService } from '../services/excelService';
import { openWhatsAppReminder } from '../utils/whatsapp';

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
  const [customersData, setCustomersData] = useState<any[]>([]);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedCustomer, setSelectedCustomer] = useState<any | null>(null);

  // Modals for PDF Statement & Promissory Note
  const [isStatementModalOpen, setIsStatementModalOpen] = useState(false);
  const [selectedContractForStatement, setSelectedContractForStatement] = useState<any | null>(null);

  const [isPromissoryModalOpen, setIsPromissoryModalOpen] = useState(false);
  const [selectedContractForPromissory, setSelectedContractForPromissory] = useState<any | null>(null);

  // Add Customer Modal State
  const [isAddModalOpen, setIsAddModalOpen] = useState(false);
  const [newCustCode, setNewCustCode] = useState('');
  const [newCustName, setNewCustName] = useState('');
  const [newCustPhone, setNewCustPhone] = useState('');
  const [newCustSecPhone, setNewCustSecPhone] = useState('');
  const [newCustNationalId, setNewCustNationalId] = useState('');
  const [newCustAddress, setNewCustAddress] = useState('');
  
  // Guarantor Info
  const [newGuarantorName, setNewGuarantorName] = useState('');
  const [newGuarantorPhone, setNewGuarantorPhone] = useState('');
  const [newGuarantorRel, setNewGuarantorRel] = useState('');
  
  // Initial Installment Contract (OPEN manual input for months!)
  const [includeContract, setIncludeContract] = useState(true);
  const [newDeviceName, setNewDeviceName] = useState('');
  const [newImei, setNewImei] = useState('');
  const [newCashPrice, setNewCashPrice] = useState('');
  const [newInstallmentPrice, setNewInstallmentPrice] = useState('');
  const [newDownPayment, setNewDownPayment] = useState('');
  const [newMonthsCount, setNewMonthsCount] = useState('10'); // OPEN MANUAL INPUT
  const [newFirstDueDate, setNewFirstDueDate] = useState('');

  // Add New Contract Modal for existing customer (OPEN manual input for months!)
  const [isNewContractModalOpen, setIsNewContractModalOpen] = useState(false);
  const [addCtrDevice, setAddCtrDevice] = useState('');
  const [addCtrImei, setAddCtrImei] = useState('');
  const [addCtrCashPrice, setAddCtrCashPrice] = useState('');
  const [addCtrInstPrice, setAddCtrInstPrice] = useState('');
  const [addCtrDownPay, setAddCtrDownPay] = useState('');
  const [addCtrMonths, setAddCtrMonths] = useState('10'); // OPEN MANUAL INPUT
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
        c.code === initialCustomerTarget ||
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
      // Check localStorage first
      const saved = localStorage.getItem('central_customers_state');
      if (saved) {
        try {
          const list = JSON.parse(saved);
          if (list && list.length > 0) {
            setCustomersData(list);
            setIsLoading(false);
            return;
          }
        } catch {}
      }

      const res = await fetch('/migrated_data.json');
      if (res.ok) {
        const json = await res.json();
        let list = (json.customers || []).map((c: any, idx: number) => ({
          ...c,
          code: c.code || `CUS-${(idx + 1).toString().padStart(5, '0')}`,
          national_id: c.national_id || '',
          credit_status: c.credit_status || 'active'
        }));

        const savedCustom = localStorage.getItem('central_custom_customers');
        if (savedCustom) {
          try {
            const customList = JSON.parse(savedCustom);
            list = [...customList, ...list];
          } catch {}
        }
        setCustomersData(list);
        localStorage.setItem('central_customers_state', JSON.stringify(list));
      }
    } catch {
      //
    } finally {
      setIsLoading(false);
    }
  };

  // Helper to persist state
  const persistCustomersState = (updatedList: any[]) => {
    setCustomersData(updatedList);
    try {
      localStorage.setItem('central_customers_state', JSON.stringify(updatedList));
    } catch {}
  };

  // Toggle Customer Credit Status (نشط / متعثر)
  const handleToggleCreditStatus = () => {
    if (!selectedCustomer) return;
    const newStatus = selectedCustomer.credit_status === 'defaulted' ? 'active' : 'defaulted';
    const updatedCust = { ...selectedCustomer, credit_status: newStatus };
    const updatedList = customersData.map(c => c.name === selectedCustomer.name ? updatedCust : c);
    persistCustomersState(updatedList);
    setSelectedCustomer(updatedCust);
  };

  // Add Customer Modal open
  const openAddCustomerModal = () => {
    const nextCode = `CUS-${(customersData.length + 1).toString().padStart(5, '0')}`;
    setNewCustCode(nextCode);
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
    const months = parseInt(newMonthsCount) || 1; // Manual open typing
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
      code: newCustCode,
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
    const months = parseInt(addCtrMonths) || 1; // Manual open typing
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

  // 1-Click Fast Pay Installment (زر سريع)
  const handleFastPayInstallment = (contractIndex: number, instIndex: number) => {
    if (!selectedCustomer) return;

    const updatedCust = { ...selectedCustomer };
    const contract = updatedCust.contracts[contractIndex];
    const inst = contract.installments[instIndex];

    const amountPaidNow = inst.remaining_amount > 0 ? inst.remaining_amount : inst.due_amount;
    
    inst.paid_amount = inst.due_amount;
    inst.remaining_amount = 0;
    inst.status = 'paid';
    inst.paid_date = new Date().toLocaleDateString('ar-EG');

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
        date: new Date().toLocaleDateString('ar-EG')
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
      inst.paid_date = new Date().toLocaleDateString('ar-EG');
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
        date: new Date().toLocaleDateString('ar-EG')
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

  // Early Settlement Submit (سداد مبكر ومخالصة)
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
      inst.paid_date = new Date().toLocaleDateString('ar-EG');
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
        date: new Date().toLocaleDateString('ar-EG')
      });
    }

    setEarlySettlementModal(null);
  };

  // Handle Excel File Upload
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

  // Filtered customers
  const filtered = customersData.filter((c) => {
    const q = searchTerm.toLowerCase().trim();
    if (!q) return true;
    return (
      (c.name || '').toLowerCase().includes(q) ||
      (c.phone || '').includes(q) ||
      (c.code || '').toLowerCase().includes(q) ||
      (c.national_id || '').includes(q)
    );
  });

  // =========================================================================
  // VIEW: SINGLE CUSTOMER FILE (Identical to User Reference Screenshot)
  // =========================================================================
  if (selectedCustomer) {
    const isDefaulted = selectedCustomer.credit_status === 'defaulted';

    return (
      <div className="space-y-6 animate-in fade-in duration-150">
        {/* Top Header Bar matching user reference: < CustomerName, PDF, تمييز كمتعثر */}
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 bg-slate-900 text-white p-4 rounded-3xl border border-slate-800 shadow-md">
          <div className="flex items-center gap-3">
            <button
              onClick={() => setSelectedCustomer(null)}
              className="p-2 rounded-xl bg-slate-800 hover:bg-slate-700 text-slate-300 font-bold text-xs flex items-center gap-1 transition active:scale-95 border border-slate-700"
            >
              <ChevronLeft className="w-5 h-5 text-cyan-400 rotate-180" />
              <span>العودة للعملاء</span>
            </button>
            <div>
              <h2 className="text-lg md:text-xl font-black text-slate-100 flex items-center gap-2">
                {selectedCustomer.name}
                <span className="text-xs font-mono font-bold px-2 py-0.5 rounded-full bg-slate-800 text-cyan-300 border border-slate-700">
                  {selectedCustomer.code}
                </span>
              </h2>
              <div className="flex items-center gap-3 text-xs text-slate-400 mt-0.5 flex-wrap">
                <span>الهاتف: <strong className="text-slate-200 font-mono">{selectedCustomer.phone || '-'}</strong></span>
                {selectedCustomer.national_id && <span>• قومي: <strong className="text-slate-200 font-mono">{selectedCustomer.national_id}</strong></span>}
                {selectedCustomer.address && <span>• {selectedCustomer.address}</span>}
              </div>
            </div>
          </div>

          <div className="flex items-center gap-2 w-full sm:w-auto flex-wrap">
            {/* 1. PDF Statement Button */}
            <button
              onClick={() => {
                setSelectedContractForStatement(null);
                setIsStatementModalOpen(true);
              }}
              className="px-3 py-2 rounded-xl bg-slate-800 hover:bg-slate-700 text-slate-200 border border-slate-700 font-bold text-xs flex items-center gap-1.5 transition active:scale-95"
            >
              <FileText className="w-4 h-4 text-cyan-400" />
              <span>PDF كشف الحساب</span>
            </button>

            {/* 2. Defaulted Toggle Button */}
            <button
              onClick={handleToggleCreditStatus}
              className={`px-3 py-2 rounded-xl font-black text-xs flex items-center gap-1.5 transition active:scale-95 ${
                isDefaulted
                  ? 'bg-rose-500 hover:bg-rose-600 text-white shadow-lg shadow-rose-500/20'
                  : 'bg-slate-800 hover:bg-slate-700 text-slate-300 border border-slate-700'
              }`}
            >
              <span className={`w-2.5 h-2.5 rounded-full ${isDefaulted ? 'bg-white animate-ping' : 'bg-rose-500'}`}></span>
              <span>{isDefaulted ? 'عميل متعثر ائتمانياً' : 'تمييز كمتعثر'}</span>
            </button>

            {/* 3. Add Another Contract Button */}
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
              className="px-3.5 py-2 rounded-xl bg-cyan-500 hover:bg-cyan-400 text-slate-950 font-black text-xs flex items-center gap-1.5 shadow transition active:scale-95"
            >
              <PlusCircle className="w-4 h-4" />
              <span>إضافة عقد جديد</span>
            </button>
          </div>
        </div>

        {/* Guarantor Card */}
        {selectedCustomer.guarantor && selectedCustomer.guarantor.name && (
          <div className="p-3.5 rounded-2xl bg-amber-50 border border-amber-200 text-xs flex items-center justify-between text-amber-900">
            <div className="flex items-center gap-2">
              <ShieldCheck className="w-4 h-4 text-amber-600 flex-shrink-0" />
              <span>
                <strong>الضامن المسجل:</strong> {selectedCustomer.guarantor.name} 
                {selectedCustomer.guarantor.phone && ` • هاتف: ${selectedCustomer.guarantor.phone}`}
                {selectedCustomer.guarantor.relationship && ` (صلة القرابة: ${selectedCustomer.guarantor.relationship})`}
              </span>
            </div>
          </div>
        )}

        {/* CONTRACTS LIST (Matching reference screenshot exactly) */}
        <div className="space-y-6">
          {(!selectedCustomer.contracts || selectedCustomer.contracts.length === 0) ? (
            <div className="p-12 text-center text-slate-400 border border-dashed border-slate-300 rounded-3xl bg-white">
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
                  className="bg-[#0f172a] text-white rounded-3xl border border-slate-800 shadow-xl overflow-hidden space-y-4 p-5 md:p-6"
                >
                  {/* Top Header Banner matching reference: [نشط] / [مكتمل] + 4 Metric boxes */}
                  <div className="space-y-4">
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-2">
                        <span className={`px-3 py-0.5 rounded-full text-xs font-black ${
                          isCompleted ? 'bg-emerald-500/20 text-emerald-300 border border-emerald-500/40' : 'bg-cyan-500/20 text-cyan-300 border border-cyan-500/40'
                        }`}>
                          {isCompleted ? 'مكتمل المسدد' : 'نشط'}
                        </span>
                        <h3 className="font-bold text-base text-slate-100">
                          {ctr.device_name} {ctr.imei ? `• IMEI: ${ctr.imei}` : ''}
                        </h3>
                      </div>
                      <span className="text-xs text-slate-400 font-mono">عقد #{ctrIdx + 1}</span>
                    </div>

                    {/* 4 Financial KPIs Grid (رأس المال، إجمالي التقسيط، المدفوع، المتبقي) */}
                    <div className="grid grid-cols-2 md:grid-cols-4 gap-2.5 p-3.5 rounded-2xl bg-slate-900/90 border border-slate-800 text-center">
                      {/* 1. رأس المال */}
                      <div className="space-y-1">
                        <span className="text-[11px] text-slate-400 block font-bold">رأس المال (الكاش)</span>
                        <span className="text-base md:text-lg font-black text-slate-200 font-mono">
                          {cashPrice.toLocaleString('ar-EG')} <span className="text-[10px] text-slate-400">ج.م</span>
                        </span>
                      </div>

                      {/* 2. إجمالي التقسيط */}
                      <div className="space-y-1 border-r border-slate-800 pr-2">
                        <span className="text-[11px] text-slate-400 block font-bold">إجمالي التقسيط</span>
                        <span className="text-base md:text-lg font-black text-cyan-300 font-mono">
                          {totalVal.toLocaleString('ar-EG')} <span className="text-[10px] text-slate-400">ج.م</span>
                        </span>
                      </div>

                      {/* 3. المدفوع */}
                      <div className="space-y-1 border-r border-slate-800 pr-2">
                        <span className="text-[11px] text-emerald-400 block font-bold">المدفوع</span>
                        <span className="text-base md:text-lg font-black text-emerald-400 font-mono">
                          {paid.toLocaleString('ar-EG')} <span className="text-[10px] text-slate-400">ج.م</span>
                        </span>
                      </div>

                      {/* 4. المتبقي */}
                      <div className="space-y-1 border-r border-slate-800 pr-2">
                        <span className="text-[11px] text-amber-400 block font-bold">المتبقي</span>
                        <span className="text-base md:text-lg font-black text-amber-400 font-mono">
                          {remaining.toLocaleString('ar-EG')} <span className="text-[10px] text-slate-400">ج.م</span>
                        </span>
                      </div>
                    </div>

                    {/* Action Buttons Bar matching user image: تجهيز سند لأمر، سداد مبكر، كشف العقد، تعديل، حذف */}
                    <div className="flex items-center justify-end gap-2 flex-wrap pt-1">
                      {/* تجهيز سند لأمر (Purple) */}
                      <button
                        onClick={() => {
                          setSelectedContractForPromissory(ctr);
                          setIsPromissoryModalOpen(true);
                        }}
                        className="px-3.5 py-1.5 rounded-xl bg-purple-600/90 hover:bg-purple-600 text-white font-bold text-xs flex items-center gap-1.5 shadow transition active:scale-95"
                      >
                        <FileText className="w-3.5 h-3.5" />
                        <span>تجهيز سند لأمر</span>
                      </button>

                      {/* سداد مبكر ومخالصة (Green) */}
                      {remaining > 0 && (
                        <button
                          onClick={() => setEarlySettlementModal({
                            isOpen: true,
                            contractIndex: ctrIdx,
                            totalRemaining: remaining,
                            discount: '0',
                            deviceName: ctr.device_name
                          })}
                          className="px-3.5 py-1.5 rounded-xl bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs flex items-center gap-1.5 shadow transition active:scale-95"
                        >
                          <Sparkles className="w-3.5 h-3.5 text-amber-300" />
                          <span>سداد مبكر</span>
                        </button>
                      )}

                      {/* كشف العقد (Blue) */}
                      <button
                        onClick={() => {
                          setSelectedContractForStatement(ctr);
                          setIsStatementModalOpen(true);
                        }}
                        className="px-3.5 py-1.5 rounded-xl bg-blue-600/90 hover:bg-blue-600 text-white font-bold text-xs flex items-center gap-1.5 shadow transition active:scale-95"
                      >
                        <FileSpreadsheet className="w-3.5 h-3.5" />
                        <span>كشف العقد</span>
                      </button>

                      {/* تعديل العقد (Amber/Orange) */}
                      <button
                        onClick={() => {
                          setEditContractIdx(ctrIdx);
                          setEditDeviceName(ctr.device_name || '');
                          setEditCashPrice(String(ctr.cash_price || ''));
                          setEditInstPrice(String(ctr.installment_price || ''));
                          setEditRemainingBalance(String(ctr.remaining_balance || ''));
                          setIsEditContractModalOpen(true);
                        }}
                        className="px-3 py-1.5 rounded-xl bg-amber-600/80 hover:bg-amber-600 text-white font-bold text-xs flex items-center gap-1.5 transition active:scale-95"
                      >
                        <Edit3 className="w-3.5 h-3.5" />
                        <span>تعديل</span>
                      </button>

                      {/* حذف العقد (Red) */}
                      <button
                        onClick={() => handleDeleteContract(ctrIdx)}
                        className="px-3 py-1.5 rounded-xl bg-rose-600/80 hover:bg-rose-600 text-white font-bold text-xs flex items-center gap-1.5 transition active:scale-95"
                      >
                        <Trash2 className="w-3.5 h-3.5" />
                        <span>حذف</span>
                      </button>
                    </div>
                  </div>

                  {/* Section: جدول الأقساط (Dark sleek rows matching user screenshot) */}
                  <div className="space-y-2 pt-2 border-t border-slate-800">
                    <div className="flex items-center justify-between text-xs text-slate-400 font-bold mb-2">
                      <span className="flex items-center gap-1.5 text-slate-200">
                        <Calendar className="w-4 h-4 text-cyan-400" />
                        جدول الأقساط ({ctr.installments?.length || 0} قسط):
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
                            className={`p-3 rounded-2xl border transition flex flex-col sm:flex-row sm:items-center justify-between gap-3 ${
                              isPaid
                                ? 'bg-slate-900/50 border-emerald-900/40 text-slate-300'
                                : isPostponed
                                ? 'bg-purple-950/20 border-purple-800/40 text-slate-100'
                                : 'bg-slate-900 border-slate-800 text-slate-100 hover:border-slate-700'
                            }`}
                          >
                            {/* Left Side: Installment Actions Group matching user screenshot */}
                            {/* [تأجيل] [زائد] [سريع] [🟢 واتساب] [نقطة الحالة / متأخر] */}
                            <div className="flex items-center gap-2 flex-wrap order-2 sm:order-1">
                              {/* Status Tag */}
                              {isPaid ? (
                                <span className="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-[11px] font-bold bg-emerald-500/20 text-emerald-400 border border-emerald-500/30">
                                  <CheckCircle2 className="w-3 h-3" />
                                  مسدد
                                </span>
                              ) : isPostponed ? (
                                <span className="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-[11px] font-bold bg-purple-500/20 text-purple-300 border border-purple-500/30">
                                  <Calendar className="w-3 h-3" />
                                  مؤجل لـ {inst.due_date}
                                </span>
                              ) : isPartial ? (
                                <span className="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-[11px] font-bold bg-blue-500/20 text-blue-300 border border-blue-500/30">
                                  سداد جزئي ({inst.paid_amount} ج.م)
                                </span>
                              ) : (
                                <span className="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-[11px] font-bold bg-rose-500/20 text-rose-400 border border-rose-500/30">
                                  <span className="w-1.5 h-1.5 rounded-full bg-rose-500"></span>
                                  متأخر
                                </span>
                              )}

                              {/* 1. Postpone Button (تأجيل) */}
                              {!isPaid && (
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
                                  className="px-2.5 py-1.5 rounded-xl bg-amber-500/20 hover:bg-amber-500/30 text-amber-300 border border-amber-500/30 font-bold text-xs transition active:scale-95"
                                >
                                  تأجيل
                                </button>
                              )}

                              {/* 2. Partial Pay Button (زائد) */}
                              {!isPaid && (
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
                                  className="px-2.5 py-1.5 rounded-xl bg-blue-500/20 hover:bg-blue-500/30 text-blue-300 border border-blue-500/30 font-bold text-xs transition active:scale-95"
                                >
                                  زائد
                                </button>
                              )}

                              {/* 3. Fast Pay Button (سريع) */}
                              {!isPaid && (
                                <button
                                  onClick={() => handleFastPayInstallment(ctrIdx, instIdx)}
                                  title="سداد فوري للقسط بالكامل"
                                  className="px-3 py-1.5 rounded-xl bg-cyan-500 hover:bg-cyan-400 text-slate-950 font-black text-xs transition shadow-sm active:scale-95 flex items-center gap-1"
                                >
                                  <Zap className="w-3.5 h-3.5 fill-current" />
                                  سريع
                                </button>
                              )}

                              {/* 4. WhatsApp Reminder Button (🟢 واتساب) */}
                              {selectedCustomer.phone && (
                                <button
                                  onClick={() => openWhatsAppReminder(
                                    selectedCustomer.phone,
                                    selectedCustomer.name,
                                    inst.remaining_amount > 0 ? inst.remaining_amount : inst.due_amount,
                                    inst.due_date || '-',
                                    ctr.device_name
                                  )}
                                  title="إرسال تذكير عبر واتساب"
                                  className="p-1.5 rounded-xl bg-emerald-600/30 hover:bg-emerald-600 text-emerald-400 hover:text-white border border-emerald-500/40 transition active:scale-95"
                                >
                                  <MessageCircle className="w-4 h-4" />
                                </button>
                              )}
                            </div>

                            {/* Right Side: Installment details matching reference screenshot */}
                            {/* [تاريخ الاستحقاق]  [المبلغ ج.م •]  [#1] */}
                            <div className="flex items-center justify-between sm:justify-end gap-4 text-right order-1 sm:order-2">
                              <div className="space-y-0.5">
                                <div className="flex items-center justify-end gap-2">
                                  <span className="text-base font-black font-mono text-slate-100">
                                    {inst.due_amount?.toLocaleString('ar-EG')} <span className="text-[11px] text-slate-400">ج.م</span>
                                  </span>
                                  <span className={`w-2 h-2 rounded-full ${
                                    isPaid ? 'bg-emerald-400' : isPostponed ? 'bg-purple-400' : 'bg-rose-500'
                                  }`}></span>
                                </div>
                                <div className="text-[11px] text-slate-400 font-mono">
                                  {inst.due_date || '-'}
                                </div>
                              </div>

                              <span className="text-xs font-mono font-bold text-slate-400 px-2 py-1 rounded-lg bg-slate-800">
                                {isDownPayment ? 'مقدم' : `#${instIdx}`}
                              </span>
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
        {/* 1. PDF Statement Modal */}
        <StatementModal
          isOpen={isStatementModalOpen}
          onClose={() => setIsStatementModalOpen(false)}
          customer={selectedCustomer}
          contract={selectedContractForStatement}
        />

        {/* 2. Promissory Note Modal */}
        <PromissoryNoteModal
          isOpen={isPromissoryModalOpen}
          onClose={() => setIsPromissoryModalOpen(false)}
          customer={selectedCustomer}
          contract={selectedContractForPromissory}
        />

        {/* 3. Add Contract Modal with OPEN manual typing for months */}
        {isNewContractModalOpen && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/80 backdrop-blur-sm p-4 overflow-y-auto">
            <div className="bg-white rounded-3xl shadow-2xl max-w-lg w-full p-6 space-y-4 text-slate-900 border border-slate-200">
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
                      className="w-full p-2.5 rounded-xl border border-slate-300"
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
                      className="w-full p-2.5 rounded-xl border border-slate-300 font-bold"
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
                      className="w-full p-2.5 rounded-xl border border-slate-300"
                    />
                  </div>
                  {/* OPEN MANUAL TYPING FOR MONTHS */}
                  <div>
                    <label className="font-bold block text-slate-700 mb-1">عدد الشهور (كتابة يدوي) *</label>
                    <input
                      type="number"
                      min="1"
                      max="120"
                      required
                      value={addCtrMonths}
                      onChange={(e) => setAddCtrMonths(e.target.value)}
                      placeholder="أدخل عدد الشهور (مثال: 6 أو 10 أو 18)"
                      className="w-full p-2.5 rounded-xl border border-slate-300 font-bold text-primary focus:ring-2 focus:ring-primary/20"
                    />
                  </div>
                </div>

                {/* Calculation preview */}
                {parseFloat(addCtrInstPrice) > 0 && (
                  <div className="p-3 rounded-xl bg-slate-50 border border-slate-200 flex items-center justify-between text-[11px]">
                    <span>المتبقي: <strong>{(parseFloat(addCtrInstPrice) - (parseFloat(addCtrDownPay) || 0)).toLocaleString('ar-EG')} ج.م</strong></span>
                    <span>القسط الشهري التقريبي: <strong className="text-primary">{Math.round((parseFloat(addCtrInstPrice) - (parseFloat(addCtrDownPay) || 0)) / Math.max(parseInt(addCtrMonths) || 1, 1)).toLocaleString('ar-EG')} ج.م/شهر</strong></span>
                  </div>
                )}

                <div>
                  <label className="font-bold block text-slate-700 mb-1">تاريخ استحقاق أول قسط</label>
                  <input
                    type="date"
                    value={addCtrFirstDueDate}
                    onChange={(e) => setAddCtrFirstDueDate(e.target.value)}
                    className="w-full p-2.5 rounded-xl border border-slate-300"
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
                    حفظ وإصدار جدول الأقساط
                  </button>
                </div>
              </form>
            </div>
          </div>
        )}

        {/* 4. Edit Contract Modal */}
        {isEditContractModalOpen && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/80 backdrop-blur-sm p-4">
            <div className="bg-white rounded-3xl shadow-2xl max-w-md w-full p-6 space-y-4 text-slate-900 border border-slate-200">
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
                      className="w-full p-2.5 rounded-xl border border-slate-300"
                    />
                  </div>
                  <div>
                    <label className="font-bold block text-slate-700 mb-1">إجمالي التقسيط</label>
                    <input
                      type="number"
                      value={editInstPrice}
                      onChange={(e) => setEditInstPrice(e.target.value)}
                      className="w-full p-2.5 rounded-xl border border-slate-300"
                    />
                  </div>
                </div>
                <div>
                  <label className="font-bold block text-slate-700 mb-1">المتبقي الحالي في الذمة</label>
                  <input
                    type="number"
                    value={editRemainingBalance}
                    onChange={(e) => setEditRemainingBalance(e.target.value)}
                    className="w-full p-2.5 rounded-xl border border-slate-300 font-black text-primary"
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

        {/* 5. Partial Payment Modal */}
        {partialModal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/80 backdrop-blur-sm p-4">
            <div className="bg-white rounded-3xl shadow-2xl max-w-sm w-full p-6 space-y-4 text-slate-900 border border-slate-200">
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
                <div className="p-3 rounded-xl bg-blue-50 text-blue-900">
                  <div className="flex justify-between font-bold">
                    <span>المبلغ المستحق للقسط:</span>
                    <span>{partialModal.currentDue?.toLocaleString('ar-EG')} ج.م</span>
                  </div>
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
                    className="w-full p-2.5 rounded-xl border border-slate-300 font-black text-base text-blue-600 focus:ring-2 focus:ring-blue-500/20"
                  />
                  <span className="text-[11px] text-slate-400 mt-1 block">
                    الحد الأقصى للسداد الجزئي: {partialModal.maxAmount} ج.م
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

        {/* 6. Postpone Modal */}
        {postponeModal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/80 backdrop-blur-sm p-4">
            <div className="bg-white rounded-3xl shadow-2xl max-w-sm w-full p-6 space-y-4 text-slate-900 border border-slate-200">
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
                    placeholder="مثال: طلب العميل التأجيل لظروف السفر أو استلام الراتب"
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

        {/* 7. Early Settlement Modal */}
        {earlySettlementModal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/80 backdrop-blur-sm p-4">
            <div className="bg-white rounded-3xl shadow-2xl max-w-md w-full p-6 space-y-4 text-slate-900 border border-slate-200">
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
                <div className="p-4 rounded-2xl bg-amber-50 border border-amber-200 space-y-1.5">
                  <div className="flex justify-between font-bold text-slate-700">
                    <span>الجهاز / العقد:</span>
                    <span>{earlySettlementModal.deviceName}</span>
                  </div>
                  <div className="flex justify-between font-bold text-slate-700">
                    <span>إجمالي المديونية المتبقية:</span>
                    <span className="font-mono text-base text-slate-900">{earlySettlementModal.totalRemaining.toLocaleString('ar-EG')} ج.م</span>
                  </div>
                </div>

                <div>
                  <label className="font-bold block text-slate-700 mb-1">خصم السداد المبكر (كاش ديسكاونت)</label>
                  <input
                    type="number"
                    value={earlySettlementModal.discount}
                    onChange={(e) => setEarlySettlementModal({ ...earlySettlementModal, discount: e.target.value })}
                    placeholder="0"
                    className="w-full p-2.5 rounded-xl border border-slate-300"
                  />
                </div>

                <div className="p-3 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-900 flex justify-between items-center">
                  <span className="font-bold">المطلوب تحصيله كاش للمخالصة:</span>
                  <span className="text-lg font-black font-mono">
                    {Math.max(earlySettlementModal.totalRemaining - (parseFloat(earlySettlementModal.discount) || 0), 0).toLocaleString('ar-EG')} ج.م
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
  // VIEW: MAIN CUSTOMERS LIST TABLE & TOOLBAR
  // =========================================================================
  return (
    <div className="space-y-6">
      {/* Top Header & Actions Toolbar */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-white p-5 rounded-3xl border border-slate-200 shadow-sm">
        <div>
          <h2 className="text-xl font-black text-slate-900 flex items-center gap-2">
            <Users className="w-6 h-6 text-primary" />
            سجل عملاء وعقود سنترال
          </h2>
          <p className="text-xs text-slate-500 mt-0.5">
            إدارة كاملة للعملاء والضامنين، جداول الأقساط، التصدير والاستيراد من وإلى Excel.
          </p>
        </div>

        {/* Action Buttons: Add Customer, Export Excel, Import Excel */}
        <div className="flex items-center gap-2 flex-wrap">
          {/* Export to Excel */}
          <button
            onClick={() => excelService.exportCentralDataToExcel(customersData)}
            className="px-3.5 py-2.5 rounded-2xl bg-emerald-600 hover:bg-emerald-500 text-white font-black text-xs flex items-center gap-1.5 shadow transition active:scale-95"
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
            className="px-3.5 py-2.5 rounded-2xl bg-slate-800 hover:bg-slate-700 text-slate-200 font-bold text-xs flex items-center gap-1.5 border border-slate-700 transition active:scale-95"
          >
            <Upload className="w-4 h-4 text-cyan-400" />
            <span>استيراد Excel</span>
          </button>

          {/* Add Customer Button */}
          <button
            onClick={openAddCustomerModal}
            className="px-4 py-2.5 rounded-2xl bg-primary hover:bg-primary/90 text-white font-black text-xs flex items-center gap-2 shadow-lg shadow-primary/20 transition active:scale-95"
          >
            <UserPlus className="w-4 h-4" />
            <span>إضافة عميل جديد</span>
          </button>
        </div>
      </div>

      {/* Search Bar */}
      <div className="relative">
        <Search className="w-5 h-5 text-slate-400 absolute right-4 top-1/2 -translate-y-1/2" />
        <input
          type="text"
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          placeholder="ابحث باسم العميل، رقم الهاتف، كود العميل، أو الرقم القومي (14 رقم)..."
          className="w-full pr-12 pl-4 py-3.5 bg-white border border-slate-200 rounded-2xl text-xs md:text-sm font-medium focus:outline-none focus:ring-2 focus:ring-primary/20 shadow-sm"
        />
      </div>

      {/* Customers Table */}
      <div className="bg-white rounded-3xl border border-slate-200 shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-right text-xs">
            <thead className="bg-slate-50 border-b border-slate-200 text-slate-600 font-bold">
              <tr>
                <th className="p-4">كود العميل</th>
                <th className="p-4">اسم العميل</th>
                <th className="p-4">رقم الهاتف</th>
                <th className="p-4">العقود والسلع</th>
                <th className="p-4">إجمالي المتبقي</th>
                <th className="p-4">الحالة الائتمانية</th>
                <th className="p-4 text-center">الإجراءات</th>
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
                      <td className="p-4 font-mono font-bold text-slate-600">
                        {c.code || `CUS-${(idx + 1).toString().padStart(5, '0')}`}
                      </td>
                      <td className="p-4 font-bold text-slate-900 text-sm">
                        {c.name}
                        {c.national_id && (
                          <span className="block text-[11px] text-slate-400 font-mono font-normal">
                            قومي: {c.national_id}
                          </span>
                        )}
                      </td>
                      <td className="p-4 text-slate-600 font-mono">
                        {c.phone || '-'}
                      </td>
                      <td className="p-4 text-slate-700 font-medium">
                        {c.contracts?.length || 0} عقد
                        {c.contracts?.[0]?.device_name && ` (${c.contracts[0].device_name})`}
                      </td>
                      <td className="p-4 font-black font-mono text-sm text-slate-900">
                        {rem.toLocaleString('ar-EG')} ج.م
                      </td>
                      <td className="p-4">
                        <span className={`px-2.5 py-1 rounded-full text-[10px] font-bold ${
                          isDefaulted ? 'bg-red-100 text-red-700' : 'bg-emerald-100 text-emerald-700'
                        }`}>
                          {isDefaulted ? 'متعثر ائتمانياً' : 'نشط وملتزم'}
                        </span>
                      </td>
                      <td className="p-4 text-center">
                        <button
                          onClick={(e) => {
                            e.stopPropagation();
                            setSelectedCustomer(c);
                          }}
                          className="px-3 py-1.5 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-800 font-bold text-xs inline-flex items-center gap-1 transition"
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

      {/* Add Customer Modal */}
      {isAddModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/80 backdrop-blur-sm p-4 overflow-y-auto">
          <div className="bg-white rounded-3xl shadow-2xl max-w-2xl w-full p-6 space-y-4 text-slate-900 border border-slate-200 my-8">
            <div className="flex items-center justify-between border-b border-slate-100 pb-3">
              <h3 className="font-bold text-base flex items-center gap-2">
                <UserPlus className="w-5 h-5 text-primary" />
                إضافة عميل وضامن جديد للسنترال
              </h3>
              <button onClick={() => setIsAddModalOpen(false)} className="p-1 rounded-lg hover:bg-slate-100">
                <X className="w-5 h-5 text-slate-400" />
              </button>
            </div>

            <form onSubmit={handleCreateCustomer} className="space-y-4 text-xs">
              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                <div>
                  <label className="font-bold block text-slate-700 mb-1">كود العميل</label>
                  <input
                    type="text"
                    readOnly
                    value={newCustCode}
                    className="w-full p-2.5 rounded-xl bg-slate-100 border border-slate-200 font-mono font-bold text-slate-600"
                  />
                </div>
                <div className="sm:col-span-2">
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
              <div className="p-3.5 rounded-2xl bg-slate-50 border border-slate-200 space-y-2">
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
                      placeholder="أخ، والد، صديق..."
                      className="w-full p-2 rounded-lg border border-slate-300 bg-white"
                    />
                  </div>
                </div>
              </div>

              {/* Initial Installment Contract (OPEN manual typing for months) */}
              <div className="p-4 rounded-2xl bg-blue-50/70 border border-blue-200 space-y-3">
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
                        <label className="text-[11px] font-bold text-slate-700 block mb-1">اسم الجهاز / السلعة *</label>
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
                      {/* OPEN MANUAL TYPING FOR MONTHS */}
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

                    {/* Quick Preview Calculation */}
                    {parseFloat(newInstallmentPrice) > 0 && (
                      <div className="p-2.5 rounded-xl bg-white border border-blue-200 flex items-center justify-between text-[11px]">
                        <span>المتبقي: <strong>{(parseFloat(newInstallmentPrice) - (parseFloat(newDownPayment) || 0)).toLocaleString('ar-EG')} ج.م</strong></span>
                        <span>القسط الشهري: <strong className="text-primary">{Math.round((parseFloat(newInstallmentPrice) - (parseFloat(newDownPayment) || 0)) / Math.max(parseInt(newMonthsCount) || 1, 1)).toLocaleString('ar-EG')} ج.م</strong></span>
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
                  className="px-6 py-2.5 rounded-xl bg-primary hover:bg-primary/90 text-white font-black shadow-lg shadow-primary/20"
                >
                  حفظ العميل والعقد بنجاح
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Import from Excel Modal */}
      {isImportModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/80 backdrop-blur-sm p-4">
          <div className="bg-white rounded-3xl shadow-2xl max-w-lg w-full p-6 space-y-4 text-slate-900 border border-slate-200">
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
              <div className="p-3.5 rounded-2xl bg-slate-50 border border-slate-200 flex items-center justify-between">
                <div>
                  <span className="font-bold text-slate-800 block">نموذج الإكسل الجاهز:</span>
                  <span className="text-[11px] text-slate-500">حمل النموذج الفارغ لتعبئة بياناتك عليه بكل سهولة</span>
                </div>
                <button
                  onClick={() => excelService.downloadImportTemplate()}
                  className="px-3 py-1.5 rounded-xl bg-slate-200 hover:bg-slate-300 text-slate-800 font-bold text-xs flex items-center gap-1"
                >
                  <Download className="w-3.5 h-3.5" />
                  تحميل النموذج
                </button>
              </div>

              {/* Upload Input */}
              <div className="border-2 border-dashed border-slate-300 hover:border-primary/50 rounded-2xl p-6 text-center space-y-2 cursor-pointer bg-slate-50/50">
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
