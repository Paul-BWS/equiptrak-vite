import { useState } from "react";
import { addDays, parseISO } from "date-fns";
import { AddServiceHeader } from "./AddServiceHeader";
import { AddServiceEquipment } from "./AddServiceEquipment";
import { AddServiceFooter } from "./AddServiceFooter";
import { useToast } from "@/hooks/use-toast";
import { supabase } from "@/integrations/supabase/client";
import { useQuery } from "@tanstack/react-query";
import { Label } from "@/components/ui/label";
import { Input } from "@/components/ui/input";
import { ServiceEngineerSelect } from "@/components/service/ServiceEngineerSelect";

interface Engineer {
  id: string;
  name: string;
  created_at: string;
  updated_at: string;
}

interface AddServiceFormProps {
  customerId: string;
  onSuccess: () => void;
  onCancel: () => void;
}

export function AddServiceForm({ customerId, onSuccess, onCancel }: AddServiceFormProps) {
  const [testDate, setTestDate] = useState<string>(new Date().toISOString().split('T')[0]);
  const [notes, setNotes] = useState("");
  const [selectedEngineer, setSelectedEngineer] = useState("");
  const [equipmentList, setEquipmentList] = useState<Array<{ name: string; serial: string }>>([
    { name: '', serial: '' }
  ]);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const { toast } = useToast();
  const retestDate = addDays(parseISO(testDate), 364);

  // Fetch engineers
  const { data: engineers = [] } = useQuery<Engineer[]>({
    queryKey: ["engineers"],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('engineers')
        .select('id, name, created_at, updated_at')
        .order('name');

      if (error) {
        console.error("Error fetching engineers:", error);
        return [];
      }

      return data || [];
    }
  });

  const validateForm = () => {
    if (!selectedEngineer || !engineers.find(e => e.id === selectedEngineer)) {
      toast({
        title: "Error",
        description: "Please select an engineer",
        variant: "destructive",
      });
      return false;
    }

    if (!equipmentList[0].name || !equipmentList[0].serial) {
      toast({
        title: "Error",
        description: "Please enter equipment details",
        variant: "destructive",
      });
      return false;
    }

    return true;
  };

  const handleSubmit = async () => {
    try {
      if (!validateForm()) {
        console.log("Form validation failed");
        return;
      }

      setIsSubmitting(true);
      console.log("Starting submission with customer ID:", customerId);
      console.log("Test date:", testDate);
      console.log("Retest date:", retestDate);
      console.log("Selected engineer:", selectedEngineer);
      console.log("Equipment list:", equipmentList);

      const serviceRecord = {
        company_id: customerId,
        engineer_name: engineers.find(e => e.id === selectedEngineer)?.name || '',
        test_date: parseISO(testDate).toISOString(),
        retest_date: retestDate.toISOString(),
        status: 'valid',
        notes: notes || null,
        equipment1_name: equipmentList[0]?.name || null,
        equipment1_serial: equipmentList[0]?.serial || null,
        equipment2_name: equipmentList[1]?.name || null,
        equipment2_serial: equipmentList[1]?.serial || null,
        equipment3_name: equipmentList[2]?.name || null,
        equipment3_serial: equipmentList[2]?.serial || null,
        equipment4_name: equipmentList[3]?.name || null,
        equipment4_serial: equipmentList[3]?.serial || null,
        equipment5_name: equipmentList[4]?.name || null,
        equipment5_serial: equipmentList[4]?.serial || null,
        equipment6_name: equipmentList[5]?.name || null,
        equipment6_serial: equipmentList[5]?.serial || null,
        equipment7_name: equipmentList[6]?.name || null,
        equipment7_serial: equipmentList[6]?.serial || null,
        equipment8_name: equipmentList[7]?.name || null,
        equipment8_serial: equipmentList[7]?.serial || null
      };

      console.log("Submitting service record:", serviceRecord);

      const { error: serviceError } = await supabase
        .from('service_records')
        .insert(serviceRecord);

      if (serviceError) {
        console.error("Error creating service record:", serviceError);
        console.log("Full error details:", JSON.stringify(serviceError, null, 2));
        throw new Error(serviceError.message || "Failed to create service record");
      }

      console.log("Service record created successfully");

      toast({
        title: "Success",
        description: "Service record created successfully",
      });
      
      onSuccess();
    } catch (error: any) {
      console.error("Error in handleSubmit:", error);
      toast({
        title: "Error",
        description: error.message || "Failed to create service record",
        variant: "destructive",
      });
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="space-y-6">
      <div className="p-4 rounded-lg bg-card border border-border/50">
        <div className="space-y-4">
          {/* Test and Retest Dates */}
          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label className="text-[#94a3b8] font-medium">Test Date</Label>
              <Input
                type="date"
                value={testDate}
                onChange={(e) => setTestDate(e.target.value)}
              />
            </div>
            <div className="space-y-2">
              <Label className="text-[#94a3b8] font-medium">Retest Date</Label>
              <Input
                type="date"
                value={retestDate.toISOString().split('T')[0]}
                disabled
              />
            </div>
          </div>

          {/* Engineer Selection */}
          <div className="space-y-2">
            <Label className="text-[#94a3b8] font-medium">Engineer</Label>
            <ServiceEngineerSelect
              selectedEngineer={selectedEngineer}
              setSelectedEngineer={setSelectedEngineer}
              hideLabel
            />
          </div>
        </div>
      </div>
      
      <AddServiceEquipment
        equipmentList={equipmentList}
        setEquipmentList={setEquipmentList}
      />

      <AddServiceFooter
        notes={notes}
        setNotes={setNotes}
        onCancel={onCancel}
        onSubmit={handleSubmit}
        isSubmitting={isSubmitting}
      />
    </div>
  );
}