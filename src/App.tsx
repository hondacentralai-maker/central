import React, { useCallback, useEffect, useRef, useState } from 'react';
import type { Session } from '@supabase/supabase-js';
import { Loader2 } from 'lucide-react';
import { Header } from './components/common/Header';
import { Sidebar, NavTab } from './components/common/Sidebar';
import { BottomNav } from './components/common/BottomNav';
import { QuickCollectionModal } from './components/common/QuickCollectionModal';
import { ReceiptModal } from './components/common/ReceiptModal';
import { LoginPage } from './components/auth/LoginPage';
import { ProfileMissingState } from './components/auth/ProfileMissingState';
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
import { SubscriptionPage } from './pages/SubscriptionPage';
import { supabase } from './utils/supabase';
import type { Contract, Profile } from './types';

type AuthStatus = 'checking' | 'signed-out' | 'profile-error' | 'ready';

const CLIENT_CACHE_KEYS = ['central_customers_state', 'central_custom_customers', 'central_payment_promises'];

const clearClientCache = () => {
  CLIENT_CACHE_KEYS.forEach((key) => window.localStorage.removeItem(key));
};

const getFirstAllowedTab = (role: string): NavTab => {
  if (role === 'collector') return 'installments';
  if (role === 'reports') return 'reports';
  return 'dashboard';
};

export default function App() {
  const [authStatus, setAuthStatus] = useState<AuthStatus>('checking');
  const [session, setSession] = useState<Session | null>(null);
  const [profile, setProfile] = useState<Profile | null>(null);
  const [profileError, setProfileError] = useState('');
  const [activeTab, setActiveTab] = useState<NavTab>('dashboard');
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const [isCollectionModalOpen, setIsCollectionModalOpen] = useState(false);
  const [selectedContractForCollection, setSelectedContractForCollection] = useState<Contract | null>(null);
  const [receiptData, setReceiptData] = useState<any>(null);
  const [isReceiptModalOpen, setIsReceiptModalOpen] = useState(false);
  const [targetCustomerForCustomersPage, setTargetCustomerForCustomersPage] = useState<string | null>(null);
  const lastUserId = useRef<string | null>(null);

  const handleNavigateWithTarget = (tab: NavTab, customerTarget?: string) => {
    setActiveTab(tab);
    if (customerTarget) {
      setTargetCustomerForCustomersPage(customerTarget);
    }
  };

  const handleDirectCollectReceipt = (receipt: any) => {
    setReceiptData(receipt);
    setIsReceiptModalOpen(true);
  };

  const hydrateSession = useCallback(async (nextSession: Session | null) => {
    const nextUserId = nextSession?.user.id ?? null;
    if (lastUserId.current !== nextUserId) clearClientCache();
    lastUserId.current = nextUserId;
    setSession(nextSession);
    setProfile(null);
    setProfileError('');

    if (!nextSession) {
      setAuthStatus('signed-out');
      return;
    }

    setAuthStatus('checking');
    const { data, error } = await supabase
      .from('profiles')
      .select('id, organization_id, branch_id, full_name, phone, role, is_active, trial_ends_at, branch:branches(name, code)')
      .eq('id', nextSession.user.id)
      .maybeSingle();

    const raw = data as any;
    let nextProfile: Profile | null = null;
    if (raw) {
      nextProfile = {
        id: raw.id,
        organization_id: raw.organization_id,
        branch_id: raw.branch_id,
        full_name: raw.full_name,
        phone: raw.phone,
        role: raw.role,
        is_active: raw.is_active,
        trial_ends_at: raw.trial_ends_at,
        branch: Array.isArray(raw.branch) ? raw.branch[0] ?? null : raw.branch ?? null,
      };
    }

    const trialExpired = Boolean(
      nextProfile?.trial_ends_at && new Date(nextProfile.trial_ends_at).getTime() <= Date.now()
    );
    let hasSubscriptionAccess = false;
    if (trialExpired) {
      const { data: subscriptionStatus } = await supabase.rpc('get_subscription_status');
      hasSubscriptionAccess = Boolean(
        subscriptionStatus?.effective_until && new Date(subscriptionStatus.effective_until).getTime() > Date.now()
      );
    }

    if (error || !nextProfile || !nextProfile.is_active || (trialExpired && !hasSubscriptionAccess) || !nextProfile.organization_id) {
      const trialDate = nextProfile?.trial_ends_at
        ? new Intl.DateTimeFormat('ar-EG', { dateStyle: 'medium' }).format(new Date(nextProfile.trial_ends_at))
        : '';
      setProfileError(
        error
          ? 'تعذر التحقق من صلاحية الملف الوظيفي.'
          : trialExpired
            ? `انتهت فترة السماح المجانية في ${trialDate}. تواصل معنا لتجديد الحساب.`
            : !nextProfile?.is_active
              ? 'هذا الحساب غير مفعّل.'
              : 'لا توجد منشأة مرتبطة بهذا الحساب.'
      );
      setAuthStatus('profile-error');
      return;
    }

    setProfile(nextProfile);
    setActiveTab(getFirstAllowedTab(nextProfile.role));
    setAuthStatus('ready');
  }, []);

  useEffect(() => {
    void supabase.auth.getSession().then(({ data }) => hydrateSession(data.session));
    const { data: listener } = supabase.auth.onAuthStateChange((_event, nextSession) => {
      void hydrateSession(nextSession);
    });
    return () => listener.subscription.unsubscribe();
  }, [hydrateSession]);

  const handleLoginSuccess = () => setAuthStatus('checking');

  const handleSignOut = async () => {
    await supabase.auth.signOut();
    clearClientCache();
    setSession(null);
    setProfile(null);
    setAuthStatus('signed-out');
  };

  const handleOpenCollection = (contract?: Contract) => {
    setSelectedContractForCollection(contract ?? null);
    setIsCollectionModalOpen(true);
  };

  const handleCollectionSuccess = (data: any) => {
    setReceiptData(data);
    setIsReceiptModalOpen(true);
  };

  if (authStatus === 'checking') {
     return (
       <main className="grid min-h-screen place-items-center bg-slate-50 text-slate-900" dir="rtl" aria-live="polite">
        <div className="flex items-center gap-3 text-sm font-bold">
          <Loader2 className="h-5 w-5 animate-spin text-blue-300" aria-hidden="true" />
          جارِ التحقق من الجلسة والصلاحيات...
        </div>
      </main>
    );
  }

  if (authStatus === 'signed-out') return <LoginPage onLoginSuccess={handleLoginSuccess} />;
  if (authStatus === 'profile-error') return <ProfileMissingState reason={profileError} onSignOut={handleSignOut} />;
  if (!profile) return null;

  return (
    <div className="flex min-h-screen flex-col bg-[#F8FAFC] font-sans text-slate-900 antialiased selection:bg-primary selection:text-white" dir="rtl">
      <Header profile={profile} isOnline={navigator.onLine} onRefresh={() => window.location.reload()} onSignOut={handleSignOut} />

      <div className="flex flex-1 overflow-hidden">
        <Sidebar
          activeTab={activeTab}
          onTabChange={setActiveTab}
          isOpenMobile={isMobileMenuOpen}
          onCloseMobile={() => setIsMobileMenuOpen(false)}
          role={profile.role}
        />

        <main className="mx-auto w-full max-w-7xl flex-1 overflow-y-auto p-4 pb-24 md:p-6 md:pb-8 lg:p-8">
          {activeTab === 'dashboard' && (
            <DashboardPage 
              onQuickCollect={() => handleOpenCollection()} 
              onNavigate={handleNavigateWithTarget} 
              onDirectCollect={handleDirectCollectReceipt}
            />
          )}
          {activeTab === 'installments' && <InstallmentsPage onCollect={(contract) => handleOpenCollection(contract)} />}
          {activeTab === 'customers' && (
            <CustomersPage 
              profile={profile} 
              onOpenCollection={handleOpenCollection} 
              onDirectCollect={handleDirectCollectReceipt}
              initialCustomerTarget={targetCustomerForCustomersPage}
            />
          )}
          {activeTab === 'treasury' && <TreasuryPage profile={profile} />}
          {activeTab === 'closing' && <DailyClosingPage />}
          {activeTab === 'wallets' && <WalletsPage profile={profile} />}
          {activeTab === 'pos' && <POSMachinesPage profile={profile} />}
          {activeTab === 'fast_credit' && <FastCreditPage profile={profile} />}
          {activeTab === 'suppliers' && <SuppliersPage profile={profile} />}
          {activeTab === 'reports' && <ReportsPage />}
          {activeTab === 'subscription' && <SubscriptionPage profile={profile} />}
        </main>
      </div>

      <BottomNav
        activeTab={activeTab}
        onTabChange={setActiveTab}
        onOpenMobileMenu={() => setIsMobileMenuOpen(true)}
        onQuickCollect={() => handleOpenCollection()}
        role={profile.role}
      />

      <QuickCollectionModal
        isOpen={isCollectionModalOpen}
        onClose={() => setIsCollectionModalOpen(false)}
        onSuccess={handleCollectionSuccess}
        preselectedContract={selectedContractForCollection}
        profile={profile}
      />

      <ReceiptModal isOpen={isReceiptModalOpen} onClose={() => setIsReceiptModalOpen(false)} receiptData={receiptData} />
    </div>
  );
}
