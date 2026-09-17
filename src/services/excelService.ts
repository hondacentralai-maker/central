import * as XLSX from 'xlsx';

export interface CustomerExportData {
  code: string;
  name: string;
  phone: string;
  secondary_phone?: string;
  national_id?: string;
  address?: string;
  guarantor_name?: string;
  guarantor_phone?: string;
  guarantor_rel?: string;
  contracts_count: number;
  total_contracts_value: number;
  total_paid: number;
  total_remaining: number;
  credit_status: string;
}

export interface ContractExportData {
  customer_code: string;
  customer_name: string;
  customer_phone: string;
  device_name: string;
  imei?: string;
  cash_price: number;
  installment_price: number;
  down_payment: number;
  remaining_balance: number;
  months_count: number;
  status: string;
}

export interface InstallmentExportData {
  customer_code: string;
  customer_name: string;
  customer_phone: string;
  device_name: string;
  installment_number: string;
  due_date: string;
  due_amount: number;
  paid_amount: number;
  remaining_amount: number;
  status: string;
  paid_date?: string;
}

export const excelService = {
  // 1. Full Central Data Export to .xlsx
  exportCentralDataToExcel: (customers: any[], fileName = 'سنترال_بيانات_العملاء_والأقساط.xlsx') => {
    const wb = XLSX.utils.book_new();

    // Sheet 1: Customers Summary
    const custRows: CustomerExportData[] = customers.map((c, idx) => {
      let totalContractsVal = 0;
      let totalRemaining = 0;
      let totalPaid = 0;

      (c.contracts || []).forEach((ctr: any) => {
        totalContractsVal += Number(ctr.installment_price || 0);
        totalRemaining += Number(ctr.remaining_balance || 0);
        totalPaid += (Number(ctr.installment_price || 0) - Number(ctr.remaining_balance || 0));
      });

      return {
        code: c.code || `CUS-${(idx + 1).toString().padStart(5, '0')}`,
        name: c.name || '',
        phone: c.phone || '',
        secondary_phone: c.secondary_phone || '',
        national_id: c.national_id || '',
        address: c.address || '',
        guarantor_name: c.guarantor?.name || '',
        guarantor_phone: c.guarantor?.phone || '',
        guarantor_rel: c.guarantor?.relationship || '',
        contracts_count: c.contracts?.length || 0,
        total_contracts_value: totalContractsVal,
        total_paid: totalPaid,
        total_remaining: totalRemaining,
        credit_status: c.credit_status === 'defaulted' ? 'متعثر ائتمانياً' : 'نشط وملتزم'
      };
    });

    const wsCustomers = XLSX.utils.json_to_sheet(custRows, {
      header: [
        'code', 'name', 'phone', 'secondary_phone', 'national_id', 'address',
        'guarantor_name', 'guarantor_phone', 'guarantor_rel',
        'contracts_count', 'total_contracts_value', 'total_paid', 'total_remaining', 'credit_status'
      ]
    });
    // Set headers in Arabic
    XLSX.utils.sheet_add_aoa(wsCustomers, [[
      'كود العميل', 'اسم العميل', 'رقم الهاتف', 'هاتف بديل', 'الرقم القومي', 'العنوان',
      'اسم الضامن', 'هاتف الضامن', 'صلة القرابة',
      'عدد العقود', 'إجمالي قيمة العقود', 'المدفوع', 'المتبقي', 'الحالة الائتمانية'
    ]], { origin: 'A1' });

    // Sheet 2: Contracts Detailed
    const contractRows: ContractExportData[] = [];
    const installmentRows: InstallmentExportData[] = [];

    customers.forEach((c, idx) => {
      const custCode = c.code || `CUS-${(idx + 1).toString().padStart(5, '0')}`;
      (c.contracts || []).forEach((ctr: any, ctrIdx: number) => {
        contractRows.push({
          customer_code: custCode,
          customer_name: c.name,
          customer_phone: c.phone,
          device_name: ctr.device_name || 'جهاز تقسيط',
          imei: ctr.imei || '',
          cash_price: Number(ctr.cash_price || 0),
          installment_price: Number(ctr.installment_price || 0),
          down_payment: Number(ctr.down_payment || 0),
          remaining_balance: Number(ctr.remaining_balance || 0),
          months_count: ctr.installment_count || ctr.installments?.length || 10,
          status: ctr.remaining_balance <= 0 ? 'مكتمل المسدد' : 'نشط جاري السداد'
        });

        (ctr.installments || []).forEach((inst: any, instIdx: number) => {
          const isDownPay = inst.item_type === 'down_payment';
          installmentRows.push({
            customer_code: custCode,
            customer_name: c.name,
            customer_phone: c.phone,
            device_name: ctr.device_name,
            installment_number: isDownPay ? 'الدفعة المقدمة' : `قسط شهر ${instIdx}`,
            due_date: inst.due_date || '',
            due_amount: Number(inst.due_amount || 0),
            paid_amount: Number(inst.paid_amount || 0),
            remaining_amount: Number(inst.remaining_amount !== undefined ? inst.remaining_amount : (inst.due_amount - (inst.paid_amount || 0))),
            status: inst.status === 'paid' ? 'مسدد' : (inst.status === 'postponed' ? 'مؤجل' : (inst.paid_amount > 0 ? 'سداد جزئي' : 'مستحق')),
            paid_date: inst.paid_date || ''
          });
        });
      });
    });

    const wsContracts = XLSX.utils.json_to_sheet(contractRows);
    XLSX.utils.sheet_add_aoa(wsContracts, [[
      'كود العميل', 'اسم العميل', 'رقم الهاتف', 'الجهاز / السلعة', 'IMEI السيريال',
      'سعر الكاش (رأس المال)', 'إجمالي التقسيط', 'المقدم المدفوع', 'المتبقي', 'عدد الأقساط', 'حالة العقد'
    ]], { origin: 'A1' });

    const wsInstallments = XLSX.utils.json_to_sheet(installmentRows);
    XLSX.utils.sheet_add_aoa(wsInstallments, [[
      'كود العميل', 'اسم العميل', 'رقم الهاتف', 'اسم الجهاز', 'رقم القسط / الدفعة',
      'تاريخ الاستحقاق', 'المبلغ المطلوب', 'المسدد', 'المتبقي', 'الحالة', 'تاريخ السداد الفعلي'
    ]], { origin: 'A1' });

    XLSX.utils.book_append_sheet(wb, wsCustomers, 'سجل العملاء');
    XLSX.utils.book_append_sheet(wb, wsContracts, 'عقود التقسيط');
    XLSX.utils.book_append_sheet(wb, wsInstallments, 'جدول الأقساط المفصل');

    XLSX.writeFile(wb, fileName);
  },

  // 2. Download Excel Template for easy data entry
  downloadImportTemplate: () => {
    const wb = XLSX.utils.book_new();

    const sampleCustomers = [
      {
        'كود العميل': 'CUS-00001',
        'اسم العميل': 'محمد أحمد محمود',
        'رقم الهاتف': '01012345678',
        'الرقم القومي (14 رقم)': '29801011234567',
        'العنوان': 'شارع الجمهورية - مركز المحمودية',
        'اسم الجهاز': 'سامسونج A54 128GB',
        'سعر الكاش (رأس المال)': 12000,
        'إجمالي سعر التقسيط': 16000,
        'المقدم المدفوع': 4000,
        'عدد الشهور': 10,
        'القسط الشهري': 1200,
        'تاريخ أول قسط (YYYY-MM-DD)': '2026-10-01',
        'اسم الضامن': 'محمود أحمد محمود',
        'هاتف الضامن': '01123456789',
        'صلة القرابة': 'أخ'
      },
      {
        'كود العميل': 'CUS-00002',
        'اسم العميل': 'علي حسن إبراهيم',
        'رقم الهاتف': '01298765432',
        'الرقم القومي (14 رقم)': '29505051234567',
        'العنوان': 'شارع الثورة - دمنهور',
        'اسم الجهاز': 'ريدمي نوت 13 برو',
        'سعر الكاش (رأس المال)': 10500,
        'إجمالي سعر التقسيط': 14000,
        'المقدم المدفوع': 3500,
        'عدد الشهور': 8,
        'القسط الشهري': 1312,
        'تاريخ أول قسط (YYYY-MM-DD)': '2026-10-05',
        'اسم الضامن': 'إبراهيم علي حسن',
        'هاتف الضامن': '01099887766',
        'صلة القرابة': 'والد'
      }
    ];

    const ws = XLSX.utils.json_to_sheet(sampleCustomers);
    XLSX.utils.book_append_sheet(wb, ws, 'نموذج_إدخال_العملاء');
    XLSX.writeFile(wb, 'نموذج_استيراد_عملاء_السنترال.xlsx');
  },

  // 3. Import and Parse Excel File
  parseExcelFile: async (file: File): Promise<{ customers: any[]; totalCount: number; errors: string[] }> => {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();

      reader.onload = (e) => {
        try {
          const data = new Uint8Array(e.target?.result as ArrayBuffer);
          const workbook = XLSX.read(data, { type: 'array' });
          const firstSheetName = workbook.SheetNames[0];
          const worksheet = workbook.Sheets[firstSheetName];
          const rawRows: any[] = XLSX.utils.sheet_to_json(worksheet);

          const errors: string[] = [];
          const parsedCustomers: any[] = [];

          rawRows.forEach((row, idx) => {
            const name = row['اسم العميل'] || row['الاسم'] || row['name'] || row['Name'];
            if (!name) {
              errors.push(`السطر ${idx + 2}: لم يتم العثور على اسم العميل.`);
              return;
            }

            const phone = String(row['رقم الهاتف'] || row['الهاتف'] || row['phone'] || '').trim();
            const nationalId = String(row['الرقم القومي (14 رقم)'] || row['الرقم القومي'] || row['national_id'] || '').trim();
            const address = String(row['العنوان'] || row['address'] || '').trim();
            const code = row['كود العميل'] || `CUS-${(idx + 1000).toString()}`;

            // Contract Info
            const deviceName = row['اسم الجهاز'] || row['الجهاز'] || 'هاتف ذكي';
            const cashPrice = parseFloat(row['سعر الكاش (رأس المال)'] || row['سعر الكاش'] || 0) || 0;
            const installmentPrice = parseFloat(row['إجمالي سعر التقسيط'] || row['سعر التقسيط'] || row['إجمالي التقسيط'] || 0) || 0;
            const downPayment = parseFloat(row['المقدم المدفوع'] || row['المقدم'] || 0) || 0;
            const months = parseInt(row['عدد الشهور'] || 10) || 10;
            const remaining = Math.max(installmentPrice - downPayment, 0);
            const firstDueDate = row['تاريخ أول قسط (YYYY-MM-DD)'] || '2026-10-01';

            // Generate Installments
            const installments: any[] = [];
            if (downPayment > 0) {
              installments.push({
                item_type: 'down_payment',
                due_amount: downPayment,
                paid_amount: downPayment,
                remaining_amount: 0,
                due_date: new Date().toISOString().slice(0, 10),
                paid_date: new Date().toISOString().slice(0, 10),
                status: 'paid'
              });
            }

            const monthlyAmt = Math.round(remaining / Math.max(months, 1));
            for (let m = 1; m <= months; m++) {
              const d = new Date(firstDueDate);
              if (isNaN(d.getTime())) {
                d.setTime(Date.now() + m * 30 * 24 * 60 * 60 * 1000);
              } else {
                d.setMonth(d.getMonth() + (m - 1));
              }

              installments.push({
                item_type: 'installment',
                due_amount: monthlyAmt,
                paid_amount: 0,
                remaining_amount: monthlyAmt,
                due_date: d.toISOString().slice(0, 10),
                status: 'pending'
              });
            }

            parsedCustomers.push({
              code,
              name: String(name).trim(),
              phone,
              national_id: nationalId,
              address,
              sheet: 'استيراد إكسل',
              credit_status: 'active',
              guarantor: {
                name: row['اسم الضامن'] || '',
                phone: row['هاتف الضامن'] || '',
                relationship: row['صلة القرابة'] || ''
              },
              contracts: [
                {
                  device_name: deviceName,
                  cash_price: cashPrice,
                  installment_price: installmentPrice,
                  down_payment: downPayment,
                  remaining_balance: remaining,
                  installment_count: months,
                  installments
                }
              ]
            });
          });

          resolve({
            customers: parsedCustomers,
            totalCount: parsedCustomers.length,
            errors
          });
        } catch (err: any) {
          reject(new Error(err.message || 'فشل في قراءة ملف الإكسل'));
        }
      };

      reader.onerror = () => reject(new Error('حدث خطأ أثناء قراءة الملف'));
      reader.readAsArrayBuffer(file);
    });
  }
};
