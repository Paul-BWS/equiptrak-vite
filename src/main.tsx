import { createRoot } from 'react-dom/client';
import { createBrowserRouter, RouterProvider } from 'react-router-dom';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { ThemeProvider } from '@/components/theme-provider';
import { Layout } from '@/components/Layout';
import { Toaster } from '@/components/ui/sonner';
import { AuthProvider } from '@/contexts/AuthContext';
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";
import { AlertCircle } from "lucide-react";
import { ProtectedRoute } from '@/components/auth/ProtectedRoute';

// Force light mode and ensure it persists
localStorage.setItem('vite-ui-theme', 'light');
document.documentElement.classList.remove('dark');
document.documentElement.classList.add('light');

// Pages
import Login from '@/pages/Login';
import Dashboard from '@/pages/Dashboard';
import Admin from '@/pages/Admin';
import AdminEquipment from '@/pages/AdminEquipment';
import CustomerEquipmentDashboard from '@/pages/CustomerEquipmentDashboard';
import EquipmentTypes from '@/pages/EquipmentTypes';
import AdminService from '@/pages/AdminService';
import ServiceCertificatePage from '@/pages/ServiceCertificatePage';
import CompanyDetails from '@/pages/CompanyDetails';
import SpotWelderCertificatePage from '@/pages/SpotWelderCertificatePage';
import CompressorListPage from '@/pages/CompressorListPage';
import { RivetToolList } from '@/components/equipment/lists/RivetToolList';
import { RivetToolCertificatePage } from '@/components/equipment/RivetToolCertificatePage';
import SpotWelderList from '@/pages/SpotWelderList';
import CompressorCertificatePage from '@/pages/CompressorCertificatePage';
import LolerList from '@/pages/LolerList';
import LolerCertificatePage from '@/pages/LolerCertificatePage';
import ChatPage from '@/pages/ChatPage';
import PersonnelPage from '@/pages/PersonnelPage';

import './index.css';

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      retry: 1,
      refetchOnWindowFocus: false,
      staleTime: 5 * 60 * 1000, // 5 minutes
      gcTime: 10 * 60 * 1000, // 10 minutes
    },
  },
});

const router = createBrowserRouter([
  {
    path: "/",
    element: <Layout />,
    errorElement: <ErrorBoundary />,
    children: [
      {
        path: "/",
        element: <Login />,
      },
      {
        path: "/login",
        element: <Login />,
      },
      {
        path: "/dashboard",
        element: <ProtectedRoute><Dashboard /></ProtectedRoute>,
      },
      {
        path: "/admin",
        element: <ProtectedRoute><Admin /></ProtectedRoute>,
      },
      {
        path: "/admin/equipment",
        element: <ProtectedRoute><AdminEquipment /></ProtectedRoute>,
      },
      {
        path: "/admin/customer/:customerId/equipment",
        element: <ProtectedRoute><CustomerEquipmentDashboard /></ProtectedRoute>,
      },
      {
        path: "/admin/customer/:customerId/equipment/types",
        element: <ProtectedRoute><EquipmentTypes /></ProtectedRoute>,
      },
      {
        path: "/admin/customer/:customerId/service",
        element: <ProtectedRoute><AdminService /></ProtectedRoute>,
      },
      {
        path: "/admin/customer/:customerId/service/:serviceId",
        element: <ProtectedRoute><ServiceCertificatePage /></ProtectedRoute>,
      },
      {
        path: "/admin/customer/:customerId/details",
        element: <ProtectedRoute><CompanyDetails /></ProtectedRoute>,
      },
      {
        path: "/admin/customer/:customerId/spot-welder/:equipmentId",
        element: <ProtectedRoute><SpotWelderCertificatePage /></ProtectedRoute>,
      },
      {
        path: "/admin/customer/:customerId/compressor/:equipmentId",
        element: <ProtectedRoute><CompressorCertificatePage /></ProtectedRoute>,
      },
      {
        path: "/admin/customer/:customerId/compressors",
        element: <ProtectedRoute><CompressorListPage /></ProtectedRoute>,
      },
      {
        path: "/admin/customer/:customerId/rivet-tools",
        element: <ProtectedRoute><RivetToolList /></ProtectedRoute>,
      },
      {
        path: "/admin/customer/:customerId/rivet-tool/:equipmentId",
        element: <ProtectedRoute><RivetToolCertificatePage /></ProtectedRoute>,
      },
      {
        path: "/admin/customer/:customerId/spot-welders",
        element: <ProtectedRoute><SpotWelderList /></ProtectedRoute>,
      },
      {
        path: "/admin/customer/:customerId/loler",
        element: <ProtectedRoute><LolerList /></ProtectedRoute>,
      },
      {
        path: "/admin/customer/:customerId/loler/:equipmentId",
        element: <ProtectedRoute><LolerCertificatePage /></ProtectedRoute>,
      },
      {
        path: "/admin/chat",
        element: <ProtectedRoute><ChatPage /></ProtectedRoute>,
      },
      {
        path: "/admin/personnel",
        element: <ProtectedRoute><PersonnelPage /></ProtectedRoute>,
      }
    ],
  },
]);

function ErrorBoundary() {
  return (
    <div className="min-h-screen bg-background flex items-center justify-center p-4">
      <div className="w-full max-w-md">
        <Alert variant="destructive" className="border-2">
          <AlertCircle className="h-5 w-5" />
          <AlertTitle className="text-lg font-semibold">Application Error</AlertTitle>
          <AlertDescription className="mt-2">
            <p className="mb-2">An unexpected error has occurred. Please try:</p>
            <ul className="list-disc list-inside space-y-1">
              <li>Refreshing the page</li>
              <li>Clearing your browser cache</li>
              <li>Logging out and back in</li>
            </ul>
            <button 
              onClick={() => window.location.href = '/login'}
              className="mt-4 w-full bg-destructive/10 text-destructive hover:bg-destructive/20 px-4 py-2 rounded-md transition-colors"
            >
              Return to Login
            </button>
          </AlertDescription>
        </Alert>
      </div>
    </div>
  );
}

createRoot(document.getElementById('root')!).render(
  <QueryClientProvider client={queryClient}>
    <ThemeProvider storageKey="vite-ui-theme">
      <AuthProvider>
        <RouterProvider router={router} />
        <Toaster />
      </AuthProvider>
    </ThemeProvider>
  </QueryClientProvider>
);