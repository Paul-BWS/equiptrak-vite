import { Label } from "@/components/ui/label";
import { format } from "date-fns";
import { ServiceEngineerSelect } from "./ServiceEngineerSelect";

interface ServiceFormHeaderProps {
  testDate: Date;
  retestDate: Date;
  selectedEngineer: string;
  setSelectedEngineer: (value: string) => void;
  engineers: Array<{ id: string; name: string }>;
}

export function ServiceFormHeader({
  testDate,
  retestDate,
  selectedEngineer,
  setSelectedEngineer,
  engineers,
}: ServiceFormHeaderProps) {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 bg-muted/50 rounded-lg p-4">
      <div className="space-y-2">
        <Label className="text-sm font-medium">Certificate Number</Label>
        <div className="h-10 px-3 py-2 bg-background rounded-md border text-sm">
          Generated on save
        </div>
      </div>
      
      <div className="space-y-2">
        <Label className="text-sm font-medium">Test Date</Label>
        <div className="h-10 px-3 py-2 bg-background rounded-md border text-sm">
          {format(testDate, 'dd/MM/yyyy')}
        </div>
      </div>
      
      <div className="space-y-2">
        <Label className="text-sm font-medium">Retest Date</Label>
        <div className="h-10 px-3 py-2 bg-background rounded-md border text-sm">
          {format(retestDate, 'dd/MM/yyyy')}
        </div>
      </div>
      
      <div className="space-y-2">
        <Label className="text-sm font-medium">Status</Label>
        <div className="h-10 px-3 py-2 bg-primary text-primary-foreground rounded-md text-sm font-medium">
          Active
        </div>
      </div>

      <div className="col-span-full">
        <ServiceEngineerSelect
          selectedEngineer={selectedEngineer}
          setSelectedEngineer={setSelectedEngineer}
          engineers={engineers}
        />
      </div>
    </div>
  );
}