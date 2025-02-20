import { Button } from "@/components/ui/button";
import { Plus } from "lucide-react";

interface ServiceInitialViewProps {
  customerId: string;
  onAddNew: () => void;
}

export function ServiceInitialView({ customerId, onAddNew }: ServiceInitialViewProps) {
  return (
    <div className="flex flex-col items-center justify-center space-y-4 p-6">
      <Button onClick={onAddNew} className="gap-2">
        <Plus className="h-4 w-4" />
        Add Service
      </Button>
    </div>
  );
}