import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Plus } from "lucide-react";

interface ServiceEquipmentListProps {
  equipmentList: Array<{ name: string; serial: string }>;
  isEditing: boolean;
  editedData: any;
  setEditedData: (data: any) => void;
}

export function ServiceEquipmentList({
  equipmentList,
  isEditing,
  editedData,
  setEditedData
}: ServiceEquipmentListProps) {
  const handleEquipmentChange = (index: number, field: 'name' | 'serial', value: string) => {
    if (!isEditing) return;

    const newData = { ...editedData };
    newData[`equipment${index + 1}_${field}`] = value;
    setEditedData(newData);
  };

  const addEquipment = () => {
    if (equipmentList.length >= 8) return;
    
    const newData = { ...editedData };
    const nextIndex = equipmentList.length + 1;
    newData[`equipment${nextIndex}_name`] = '';
    newData[`equipment${nextIndex}_serial`] = '';
    setEditedData(newData);
  };

  return (
    <div className="space-y-6">
      <h3 className="text-lg font-semibold">Test Data</h3>
      
      <div className="grid grid-cols-2 gap-4 mb-2">
        <div className="text-sm text-muted-foreground">Equipment Type</div>
        <div className="text-sm text-muted-foreground">Serial Number</div>
      </div>

      {equipmentList.map((equipment, index) => (
        <div key={index} className="grid grid-cols-2 gap-4">
          <Input
            value={isEditing ? editedData[`equipment${index + 1}_name`] || '' : equipment.name}
            onChange={(e) => handleEquipmentChange(index, 'name', e.target.value)}
            disabled={!isEditing}
            placeholder="Equipment type"
            className="bg-muted"
          />
          <Input
            value={isEditing ? editedData[`equipment${index + 1}_serial`] || '' : equipment.serial}
            onChange={(e) => handleEquipmentChange(index, 'serial', e.target.value)}
            disabled={!isEditing}
            placeholder="Serial number"
            className="bg-muted"
          />
        </div>
      ))}

      {isEditing && equipmentList.length < 8 && (
        <Button
          type="button"
          variant="outline"
          onClick={addEquipment}
          className="w-full"
        >
          <Plus className="h-4 w-4 mr-2" />
          Add Equipment
        </Button>
      )}
    </div>
  );
}