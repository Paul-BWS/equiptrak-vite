import { Button } from "@/components/ui/button";
import { ArrowLeft } from "lucide-react";
import { AddServiceModal } from "./AddServiceModal";

interface ServiceHeaderProps {
  onBack: () => void;
  customerId: string;
}

export function ServiceHeader({ onBack, customerId }: ServiceHeaderProps) {
  return (
    <div className="flex flex-col gap-6">
      <div className="flex items-center justify-between">
        <Button
          variant="outline"
          onClick={onBack}
          className="gap-2"
        >
          <ArrowLeft className="h-4 w-4" />
          Back
        </Button>
        <AddServiceModal customerId={customerId} />
      </div>

      <div>
        <h2 className="text-3xl font-bold tracking-tight">Service List</h2>
        <p className="text-muted-foreground">
          View and manage service records
        </p>
      </div>
    </div>
  );
}