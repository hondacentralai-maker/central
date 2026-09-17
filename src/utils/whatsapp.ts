// Utility functions for WhatsApp notifications and customer communication

export const formatEgyptianPhoneNumber = (phone: string): string => {
  if (!phone) return '';
  let clean = phone.replace(/\D/g, '');
  if (clean.startsWith('0')) {
    clean = '2' + clean;
  } else if (!clean.startsWith('20') && clean.length === 10) {
    clean = '20' + clean;
  }
  return clean;
};

export const openWhatsAppReminder = (
  phone: string,
  customerName: string,
  amount: number,
  dueDate: string,
  deviceName?: string
) => {
  const cleanPhone = formatEgyptianPhoneNumber(phone);
  const msg = 
`السلام عليكم ورحمة الله وبركاته،
أهلاً بك أستاذ *${customerName}*،
نود تذكير سيادتكم بموعد استحقاق قسط ${deviceName ? `جهاز (*${deviceName}*)` : 'العقد'}
المبلغ المستحق: *${amount.toLocaleString('ar-EG')} ج.م*
تاريخ الاستحقاق: *${dueDate}*

يرجى التكرم بزيارة السنترال للسداد أو التحويل عبر فودافون كاش أو إنستاباي.
شاكرين ومقدرين حسن تعاونكم الدائم معنا.
*إدارة سنترال للاتصالات*`;

  const encoded = encodeURIComponent(msg);
  const url = cleanPhone ? `https://wa.me/${cleanPhone}?text=${encoded}` : `https://wa.me/?text=${encoded}`;
  window.open(url, '_blank');
};

export const openWhatsAppPaymentReceipt = (
  phone: string,
  customerName: string,
  paidAmount: number,
  receiptNo: string,
  remainingDebt: number,
  deviceName?: string
) => {
  const cleanPhone = formatEgyptianPhoneNumber(phone);
  const msg = 
`*إيصال استلام نقدية إلكتروني - سنترال*
رقم الإيصال: *${receiptNo}*
التاريخ: *${new Date().toLocaleDateString('ar-EG')}*
----------------------------
تم بحمد الله استلام مبلغ: *${paidAmount.toLocaleString('ar-EG')} ج.م*
من الأستاذ: *${customerName}*
بخصوص: قسط ${deviceName ? `جهاز (*${deviceName}*)` : 'العقد'}
المتبقي بعد السداد: *${remainingDebt.toLocaleString('ar-EG')} ج.م*
طريقة السداد: نقدياً بالدرج

شكراً لالتزامكم، ويسعدنا دائماً خدمتكم.
*سنترال للاتصالات*`;

  const encoded = encodeURIComponent(msg);
  const url = cleanPhone ? `https://wa.me/${cleanPhone}?text=${encoded}` : `https://wa.me/?text=${encoded}`;
  window.open(url, '_blank');
};
