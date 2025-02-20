import { ServiceTestInfo } from "../ServiceTestInfo";
import { ServiceEngineerInfo } from "../ServiceEngineerInfo";
import { ServiceEquipmentList } from "../ServiceEquipmentList";
import { Textarea } from "@/components/ui/textarea";

interface ServiceModalContentProps {
  serviceRecord: any;
  isEditing: boolean;
  editedData: any;
  setEditedData: (data: any) => void;
}

export function ServiceModalContent({ 
  serviceRecord, 
  isEditing, 
  editedData, 
  setEditedData 
}: ServiceModalContentProps) {
  const getEquipmentList = () => {
    if (!serviceRecord && !editedData) return [];

    const data = isEditing ? editedData : serviceRecord;
    return [
      { name: data.equipment1_name, serial: data.equipment1_serial },
      { name: data.equipment2_name, serial: data.equipment2_serial },
      { name: data.equipment3_name, serial: data.equipment3_serial },
      { name: data.equipment4_name, serial: data.equipment4_serial },
      { name: data.equipment5_name, serial: data.equipment5_serial },
      { name: data.equipment6_name, serial: data.equipment6_serial },
      { name: data.equipment7_name, serial: data.equipment7_serial },
      { name: data.equipment8_name, serial: data.equipment8_serial },
    ].filter(pair => pair.name && pair.serial);
  };

  return (
    <div className="space-y-8">
      <ServiceTestInfo
        certificateNumber={serviceRecord.certificate_number}
        testDate={new Date(serviceRecord.test_date)}
        retestDate={new Date(isEditing ? editedData.retest_date : serviceRecord.retest_date)}
        status={serviceRecord.status}
        isEditing={isEditing}
        editedData={editedData}
        setEditedData={setEditedData}
      />

      <ServiceEngineerInfo engineerName={serviceRecord.engineers?.name || ''} />

      <ServiceEquipmentList
        equipmentList={getEquipmentList()}
        isEditing={isEditing}
        editedData={editedData}
        setEditedData={setEditedData}
      />

      <div className="space-y-4">
        <h3 className="text-lg font-semibold">Notes</h3>
        <Textarea
          value={isEditing ? editedData.notes : serviceRecord.notes || ''}
          onChange={(e) => setEditedData({ ...editedData, notes: e.target.value })}
          disabled={!isEditing}
          placeholder="Add any notes here..."
          className="min-h-[100px] bg-muted"
        />
      </div>
    </div>
  );
}