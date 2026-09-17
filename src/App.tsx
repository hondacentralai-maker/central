import React, { useCallback, useEffect, useState } from 'react';
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
import { MigrationViewerPage } from './pages/MigrationViewerPage';
import { supabase } from './utils/supabase';
import type { Contract, Profile } from './types';

type AuthStatus = 'checking' | 'signed-out' | 'profile-error' | 'ready';

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

  const hydrateSession = useCallback(async (nextSession: Session | null) => {
    setSession(nextSession);
    setProfile(null);
    setProfileError('');

    if (!nextSession) {
      // Check for multi-device local stored session
      const stored = localStorage.getItem('central_user_session');
      if (stored) {
        try {
          const user = JSON.parse(stored);
          if (user && user.role) {
            const localProfile: Profile = {
              id: user.id || '00000000-0000-0000-0000-000000000001',
              organization_id: '00000000-0000-0000-0000-000000000001',
              branch_id: null,
              full_name: user.name || 'مدير النظام',
              phone: '01000000000',
              role: user.role,
              is_active: true,
              branch: { name: 'الفرع الرئيسي', code: 'MAIN' },
            };
            setProfile(localProfile);
            setActiveTab(getFirstAllowedTab(localProfile.role));
            setAuthStatus('ready');
            return;
          }
        } catch {
          // ignore
        }
      }
      setAuthStatus('signed-out');
      return;
    }

    setAuthStatus('checking');
    const { data, error } = await supabase
      .from('profiles')
      .select('id, organization_id, branch_id, full_name, phone, role, is_active, branch:branches(name, code)')
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
        branch: Array.isArray(raw.branch) ? raw.branch[0] ?? null : raw.branch ?? null,
      };
    }

    if (error || !nextProfile || !nextProfile.is_active || !nextProfile.organization_id) {
      if (nextSession.user) {
        const meta = nextSession.user.user_metadata || {};
        const fallbackProfile: Profile = {
          id: nextSession.user.id,
          organization_id: meta.organization_id || '00000000-0000-0000-0000-000000000001',
          branch_id: meta.branch_id || null,
          full_name: meta.full_name || nextSession.user.email?.split('@')[0] || 'مدير النظام',
          phone: meta.phone || null,
          role: meta.role || 'admin',
          is_active: true,
          branch: { name: 'الفرع الرئيسي', code: 'MAIN' },
        };
        setProfile(fallbackProfile);
        setActiveTab(getFirstAllowedTab(fallbackProfile.role));
        setAuthStatus('ready');
        return;
      }
      setProfileError(error ? 'تعذر التحقق من صلاحية الملف الوظيفي.' : 'لا يوجد ملف مستخدم فعّال أو منشأة مرتبطة بالحساب.');
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

  const handleLoginSuccess = (user?: { email: string; name: string; role: string }) => {
    const role = user?.role || 'admin';
    const profileData: Profile = {
      id: '00000000-0000-0000-0000-000000000001',
      organization_id: '00000000-0000-0000-0000-000000000001',
      branch_id: null,
      full_name: user?.name || 'مدير النظام',
      phone: '01000000000',
      role: role,
      is_active: true,
      branch: { name: 'الفرع الرئيسي', code: 'MAIN' },
    };
    setProfile(profileData);
    setActiveTab(getFirstAllowedTab(role));
    setAuthStatus('ready');
  };

  const handleSignOut = async () => {
    localStorage.removeItem('central_user_session');
    await supabase.auth.signOut();
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
      <main className="grid min-h-screen place-items-center bg-slate-950 text-white" dir="rtl" aria-live="polite">
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
          {activeTab === 'dashboard' && <DashboardPage onQuickCollect={() => handleOpenCollection()} onNavigate={setActiveTab} />}
          {activeTab === 'installments' && <InstallmentsPage onCollect={(contract) => handleOpenCollection(contract)} />}
          {activeTab === 'customers' && <CustomersPage profile={profile} onOpenCollection={handleOpenCollection} />}
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
