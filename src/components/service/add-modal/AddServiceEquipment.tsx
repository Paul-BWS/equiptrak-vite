import { Button } from "@/components/ui/button";
import { Plus } from "lucide-react";

interface AddServiceEquipmentProps {
  equipmentList: Array<{ name: string; serial: string }>;
  setEquipmentList: (list: Array<{ name: string; serial: string }>) => void;
}

export function AddServiceEquipment({ equipmentList, setEquipmentList }: AddServiceEquipmentProps) {
  const inputClassName = "w-full px-3 py-2 h-10 rounded-md bg-muted text-foreground border border-input focus:outline-none focus:ring-1 focus:ring-ring";

  return (
    <div className="space-y-6">
      <h3 className="text-lg font-semibold">Test Data</h3>
      
      <div className="grid grid-cols-2 gap-4 mb-2">
        <div className="text-sm text-muted-foreground">Equipment Type</div>
        <div className="text-sm text-muted-foreground">Serial Number</div>
      </div>

      {equipmentList.map((equipment, index) => (
        <div key={index} className="grid grid-cols-2 gap-4">
          <input
            type="text"
            value={equipment.name}
            onChange={(e) => {
              const newList = [...equipmentList];
              newList[index].name = e.target.value;
              setEquipmentList(newList);
            }}
            placeholder="Equipment type"
            className={inputClassName}
          />
          <input
            type="text"
            value={equipment.serial}
            onChange={(e) => {
              const newList = [...equipmentList];
              newList[index].serial = e.target.value;
              setEquipmentList(newList);
            }}
            placeholder="Serial number"
            className={inputClassName}
          />
        </div>
      ))}

      {equipmentList.length < 8 && (
        <Button
          type="button"
          variant="outline"
          onClick={() => setEquipmentList([...equipmentList, { name: '', serial: '' }])}
          className="w-full bg-muted text-foreground border border-input hover:bg-accent hover:text-accent-foreground"
        >
          <Plus className="h-4 w-4 mr-2" />
          Add Equipment
        </Button>
      )}
    </div>
  );
}