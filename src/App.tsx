import React, { useState } from 'react';
import { Header } from './components/common/Header';
import { Sidebar, NavTab } from './components/common/Sidebar';
import { BottomNav } from './components/common/BottomNav';
import { QuickCollectionModal } from './components/common/QuickCollectionModal';
import { ReceiptModal } from './components/common/ReceiptModal';
import { DashboardPage } from './pages/DashboardPage';
import { InstallmentsPage } from './pages/InstallmentsPage';
import { CustomersPage } from './pages/CustomersPage';
import { TreasuryPage } from './pages/TreasuryPage';
import { DailyClosingPage } from './pages/DailyClosingPage';
import { WalletsPage } from './pages/WalletsPage';
import { POSMachinesPage } from './pages/POSMachinesPage';
import { FastCreditPage } from './pages/FastCreditPage';
import { SuppliersPage } from './pages/SuppliersPage';
import { ReportsPage } from './pages/ReportsPage';
import { MigrationViewerPage } from './pages/MigrationViewerPage';
import { Contract } from './types';

export default function App() {
  const [activeTab, setActiveTab] = useState<NavTab>('dashboard');
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const [isCollectionModalOpen, setIsCollectionModalOpen] = useState(false);
  const [selectedContractForCollection, setSelectedContractForCollection] = useState<Contract | null>(null);
  const [receiptData, setReceiptData] = useState<any>(null);
  const [isReceiptModalOpen, setIsReceiptModalOpen] = useState(false);

  const handleOpenCollection = (contract?: Contract) => {
    if (contract) {
      setSelectedContractForCollection(contract);
    } else {
      setSelectedContractForCollection(null);
    }
    setIsCollectionModalOpen(true);
  };

  const handleCollectionSuccess = (data: any) => {
    setReceiptData(data);
    setIsReceiptModalOpen(true);
  };

  return (
    <div className="min-h-screen bg-[#F8FAFC] text-slate-900 flex flex-col font-sans antialiased selection:bg-primary selection:text-white" dir="rtl">
      {/* Top Header */}
      <Header 
        isOnline={true} 
        onRefresh={() => window.location.reload()} 
      />

      {/* Main Body with Responsive Sidebar */}
      <div className="flex-1 flex overflow-hidden">
        <Sidebar
          activeTab={activeTab}
          onTabChange={setActiveTab}
          isOpenMobile={isMobileMenuOpen}
          onCloseMobile={() => setIsMobileMenuOpen(false)}
        />

        {/* Content View Area */}
        <main className="flex-1 overflow-y-auto p-4 md:p-6 lg:p-8 max-w-7xl w-full mx-auto pb-24 md:pb-8">
          {activeTab === 'dashboard' && (
            <DashboardPage 
              onQuickCollect={() => handleOpenCollection()} 
              onNavigate={(tab) => setActiveTab(tab)} 
            />
          )}

          {activeTab === 'installments' && (
            <InstallmentsPage onCollect={(ctr) => handleOpenCollection(ctr)} />
          )}

          {activeTab === 'customers' && <CustomersPage />}

          {activeTab === 'treasury' && <TreasuryPage />}

          {activeTab === 'closing' && <DailyClosingPage />}

          {activeTab === 'wallets' && <WalletsPage />}

          {activeTab === 'pos' && <POSMachinesPage />}

          {activeTab === 'fast_credit' && <FastCreditPage />}

          {activeTab === 'suppliers' && <SuppliersPage />}

          {activeTab === 'reports' && <ReportsPage />}

          {activeTab === 'migration' && <MigrationViewerPage />}
        </main>
      </div>

      {/* Mobile Bottom Navigation Bar */}
      <BottomNav
        activeTab={activeTab}
        onTabChange={setActiveTab}
        onOpenMobileMenu={() => setIsMobileMenuOpen(true)}
        onQuickCollect={() => handleOpenCollection()}
      />

      {/* Modals */}
      <QuickCollectionModal
        isOpen={isCollectionModalOpen}
        onClose={() => setIsCollectionModalOpen(false)}
        onSuccess={handleCollectionSuccess}
        preselectedContract={selectedContractForCollection}
      />

      <ReceiptModal
        isOpen={isReceiptModalOpen}
        onClose={() => setIsReceiptModalOpen(false)}
        receiptData={receiptData}
      />
    </div>
  );
}
