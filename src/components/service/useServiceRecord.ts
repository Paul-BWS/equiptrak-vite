import { useState } from "react";
import { addDays } from "date-fns";
import { useEngineerQuery } from "@/hooks/service/useEngineerQuery";
import { useServiceMutation } from "@/hooks/service/useServiceMutation";
import { supabase } from "@/integrations/supabase/client";

export function useServiceRecord(customerId?: string, onSuccess?: () => void) {
  const [testDate, setTestDate] = useState<Date>(new Date());
  const [notes, setNotes] = useState("");
  const [selectedEngineer, setSelectedEngineer] = useState("");
  const [status, setStatus] = useState<"valid" | "upcoming" | "expired">("valid");
  const [isAdding, setIsAdding] = useState(false);
  const [equipmentList, setEquipmentList] = useState<Array<{ name: string; serial: string }>>([
    { name: '', serial: '' }
  ]);

  const { data: engineers, isLoading: engineersLoading } = useEngineerQuery();
  const createServiceRecord = useServiceMutation(onSuccess);

  const retestDate = addDays(testDate, 364);

  const handleSubmit = async () => {
    try {
      // First create the equipment record
      console.log("Creating equipment for customer:", customerId);
      const { data: equipmentData, error: equipmentError } = await supabase
        .from('equipment')
        .insert({
          name: equipmentList[0].name,
          serial_number: equipmentList[0].serial,
          customer_id: customerId,
          last_test_date: testDate.toISOString(),
          next_test_date: retestDate.toISOString(),
          status: status
        })
        .select()
        .single();

      if (equipmentError) {
        console.error("Error creating equipment:", equipmentError);
        throw equipmentError;
      }

      console.log("Created equipment:", equipmentData);

      const serviceData = {
        customerId,
        selectedEngineer,
        testDate,
        retestDate,
        status,
        notes,
        equipment_id: equipmentData.id,
        equipment1_name: equipmentList[0]?.name || '',
        equipment1_serial: equipmentList[0]?.serial || '',
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
        equipment8_serial: equipmentList[7]?.serial || null,
      };

      await createServiceRecord.mutateAsync(serviceData);
    } catch (error) {
      console.error("Error in handleSubmit:", error);
      throw error;
    }
  };

  return {
    testDate,
    setTestDate,
    notes,
    setNotes,
    selectedEngineer,
    setSelectedEngineer,
    status,
    setStatus,
    isAdding,
    setIsAdding,
    engineers,
    engineersLoading,
    retestDate,
    handleSubmit,
    createServiceRecord,
    equipmentList,
    setEquipmentList
  };
}