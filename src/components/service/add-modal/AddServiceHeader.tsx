import { Engineer } from "@/types/database/engineers";
import { Label } from "@/components/ui/label";
import { Input } from "@/components/ui/input";
import { Select, SelectTrigger, SelectValue, SelectContent, SelectItem } from "@/components/ui/select";
import { format } from "date-fns";

interface AddServiceHeaderProps {
  testDate: string;
  setTestDate: (date: string) => void;
  retestDate: Date;
  selectedEngineer: string;
  setSelectedEngineer: (id: string) => void;
  engineers?: Engineer[];
}

export function AddServiceHeader({
  testDate,
  setTestDate,
  retestDate,
  selectedEngineer,
  setSelectedEngineer,
  engineers,
}: AddServiceHeaderProps) {
  const labelClassName = "text-sm text-muted-foreground";
  const inputClassName = "w-full px-3 py-2 h-10 rounded-md bg-muted text-foreground border border-input focus:outline-none focus:ring-1 focus:ring-ring";

  return (
    <div className="grid grid-cols-4 gap-4">
      <div className="space-y-2">
        <Label>Certificate Number</Label>
        <div className="p-2 bg-muted rounded-md font-mono">
          BWS-{24570 + Math.floor(Math.random() * 100)}
        </div>
      </div>
      <div className="space-y-2">
        <Label>Test Date</Label>
        <Input
          type="date"
          value={testDate}
          onChange={(e) => setTestDate(e.target.value)}
          className="bg-muted"
        />
      </div>
      <div className="space-y-2">
        <Label>Retest Date</Label>
        <Input
          type="date"
          value={format(retestDate, "yyyy-MM-dd")}
          disabled
          className="bg-muted"
        />
      </div>
      <div className="space-y-2">
        <Label>Engineer</Label>
        <Select
          value={selectedEngineer}
          onValueChange={setSelectedEngineer}
        >
          <SelectTrigger className="bg-muted">
            <SelectValue placeholder="Select an engineer" />
          </SelectTrigger>
          <SelectContent>
            {engineers?.map((engineer) => (
              <SelectItem key={engineer.id} value={engineer.id}>
                {engineer.name}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>
    </div>
  );
}