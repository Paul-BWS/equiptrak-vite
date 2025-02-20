import { Toaster } from "@/components/ui/toaster";
import { MapsProvider } from "@/contexts/MapsContext";
import { ErrorBoundary } from "@/components/ErrorBoundary";

export function App() {
  return (
    <ErrorBoundary>
      <MapsProvider>
        <Toaster />
      </MapsProvider>
    </ErrorBoundary>
  );
}

export default App;