import React, { useState, useEffect } from 'react';
import { Database, CheckCircle2, FileSpreadsheet, Download, RefreshCw } from 'lucide-react';

export const MigrationViewerPage: React.FC = () => {
  const [migrationData, setMigrationData] = useState<any>(null);

  useEffect(() => {
    fetch('/migrated_data.json')
      .then(r => r.json())
      .then(setMigrationData)
      .catch(() => {});
  }, []);

  return (
    <div className="space-y-5">
      <div>
        <h2 className="text-xl font-bold text-slate-900 flex items-center gap-2">
          <Database className="w-6 h-6 text-primary" />
          تقرير مطابقة وترحيل بيانات الإكسل
        </h2>
        <p className="text-xs text-slate-500">
          استخراج وتدقيق وتحويل بيانات الدفاتر القديمة إلى جداول قاعدة البيانات السحابية
        </p>
      </div>

      {/* Migration Highlights */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="p-5 rounded-2xl bg-white border border-slate-200 shadow-sm">
          <div className="text-xs text-slate-400 font-bold mb-1">العملاء المستخرجين</div>
          <div className="text-2xl font-black text-slate-900">
            {migrationData?.summary?.total_customers || 0} <span className="text-xs font-bold text-slate-500">عميل</span>
          </div>
          <div className="text-[11px] text-slate-500 font-semibold mt-1">بيانات معاينة وليست تأكيدًا للترحيل</div>
        </div>

        <div className="p-5 rounded-2xl bg-white border border-slate-200 shadow-sm">
          <div className="text-xs text-slate-400 font-bold mb-1">عقود الأقساط الحقيقية</div>
          <div className="text-2xl font-black text-slate-900">
            {migrationData?.summary?.total_contracts || 0} <span className="text-xs font-bold text-slate-500">عقد نشط</span>
          </div>
          <div className="text-[11px] text-slate-400 mt-1">من أصل 680 خانة قالب بالإكسل</div>
        </div>

        <div className="p-5 rounded-2xl bg-white border border-slate-200 shadow-sm">
          <div className="text-xs text-slate-400 font-bold mb-1">إجمالي قيمة العقود</div>
          <div className="text-2xl font-black text-slate-900 font-mono">
            {(migrationData?.summary?.total_contract_value || 0).toLocaleString('en-US')} <span className="text-xs font-bold text-slate-500">ج.م</span>
          </div>
          <div className="text-[11px] text-slate-400 mt-1">سعر بيع الأجهزة بالتقسيط</div>
        </div>

        <div className="p-5 rounded-2xl bg-white border border-slate-200 shadow-sm">
          <div className="text-xs text-slate-400 font-bold mb-1">إجمالي ديون العملاء المتبقية</div>
          <div className="text-2xl font-black text-primary font-mono">
            {(migrationData?.summary?.total_remaining_balance || 0).toLocaleString('en-US')} <span className="text-xs font-bold text-slate-500">ج.م</span>
          </div>
          <div className="text-[11px] text-slate-400 mt-1">المتبقي الواجب تحصيله</div>
        </div>
      </div>

      {/* Verification Status Card */}
      <div className="p-6 rounded-2xl bg-white border border-slate-200 shadow-sm space-y-4">
        <div className="flex items-center justify-between border-b border-slate-100 pb-3">
          <div className="flex items-center gap-2">
            <CheckCircle2 className="w-5 h-5 text-emerald-600" />
            <h3 className="font-bold text-slate-900 text-sm">حالة الترحيل والملفات السحابية</h3>
          </div>
          <span className="text-xs px-2.5 py-1 rounded-full bg-emerald-50 text-emerald-700 font-bold border border-emerald-200">
             معاينة محلية
          </span>
        </div>

        <div className="space-y-2 text-xs text-slate-600 leading-relaxed">
          <p>
            ✅ تم فحص ملف <strong>`عملاء اجل الاقساط .xlsx`</strong> بالكامل عبر جميع الشيتات الأبجدية الـ 28.
          </p>
          <p>
             ✅ تم تجهيز ملف المعاينة لاستخدامه في مراجعة العقود قبل إدخالها إلى قاعدة البيانات.
          </p>
          <p>
             ✅ تم استخراج حسابات الموردين من شيت الموردين.
          </p>
          <p>
             ✅ تم استخراج حسابات الأجل السريع من ملف <strong>`دفتر يومية 2025.xlsx`</strong>.
          </p>
          <p>
            ✅ تم توليد ملف التهيئة السحابي الكامل: <strong>`seed_data.sql`</strong> ليكون جاهزاً للتشغيل في Supabase SQL Editor.
          </p>
        </div>
      </div>
    </div>
  );
};
