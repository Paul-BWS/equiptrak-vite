import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { ServiceEngineerSelect } from "./ServiceEngineerSelect";
import { format } from "date-fns";
import { ServiceEquipmentList } from "./ServiceEquipmentList";
import { ServiceFormHeader } from "./ServiceFormHeader";
import { ServiceFormActions } from "./ServiceFormActions";

interface ServiceFormProps {
  onBack: () => void;
  customerId: string;
  testDate: Date;
  setTestDate: (date: Date) => void;
  retestDate: Date;
  selectedEngineer: string;
  setSelectedEngineer: (id: string) => void;
  engineers?: Array<{ id: string; name: string }>;
  notes: string;
  setNotes: (notes: string) => void;
  handleSubmit: () => void;
  isSubmitting: boolean;
  equipmentList: Array<{ name: string; serial: string }>;
  setEquipmentList: (list: Array<{ name: string; serial: string }>) => void;
}

export function ServiceForm({
  onBack,
  testDate,
  setTestDate,
  retestDate,
  selectedEngineer,
  setSelectedEngineer,
  engineers,
  notes,
  setNotes,
  handleSubmit,
  isSubmitting,
  equipmentList,
  setEquipmentList,
}: ServiceFormProps) {
  const handleTestDateChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const newDate = new Date(e.target.value);
    if (!isNaN(newDate.getTime())) {
      setTestDate(newDate);
    }
  };

  return (
    <div className="space-y-6">
      <ServiceFormHeader 
        testDate={testDate}
        retestDate={retestDate}
        selectedEngineer={selectedEngineer}
        setSelectedEngineer={setSelectedEngineer}
        engineers={engineers || []}
      />
      
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div className="space-y-4">
          <div className="space-y-2">
            <Label>Test Date</Label>
            <Input
              type="date"
              value={format(testDate, "yyyy-MM-dd")}
              onChange={handleTestDateChange}
            />
          </div>

          <div className="space-y-2">
            <Label>Retest Date</Label>
            <Input
              type="date"
              value={format(retestDate, "yyyy-MM-dd")}
              disabled
            />
          </div>

          <ServiceEngineerSelect
            selectedEngineer={selectedEngineer}
            setSelectedEngineer={setSelectedEngineer}
            engineers={engineers}
          />

          <div className="space-y-2">
            <Label>Notes</Label>
            <Textarea
              value={notes}
              onChange={(e) => setNotes(e.target.value)}
              className="min-h-[100px]"
            />
          </div>
        </div>

        <div className="space-y-4">
          <ServiceEquipmentList
            equipmentList={equipmentList}
            isEditing={false}
            editedData={{}}
            setEditedData={() => {}}
          />
        </div>
      </div>

      <ServiceFormActions
        onBack={onBack}
        handleSubmit={handleSubmit}
        isSubmitting={isSubmitting}
      />
    </div>
  );
}