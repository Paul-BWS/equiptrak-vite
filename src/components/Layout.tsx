import { Outlet, useLocation } from "react-router-dom";
import { Navigation } from "@/components/Navigation";

export function Layout() {
  const location = useLocation();
  console.log('Layout rendering, pathname:', location.pathname);
  
  return (
    <div className="min-h-screen bg-background">
      <Navigation />
      <main className="container mx-auto py-6 px-4 sm:px-6 lg:px-8">
        <Outlet />
      </main>
    </div>
  );
}