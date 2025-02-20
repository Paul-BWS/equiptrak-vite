import { Button } from "@/components/ui/button";
import { Save, X } from "lucide-react";
import { useTheme } from "@/components/theme-provider";

interface ServiceModalActionsProps {
  isEditing: boolean;
  onSave: () => void;
  onCancel: () => void;
}

export function ServiceModalActions({ isEditing, onSave, onCancel }: ServiceModalActionsProps) {
  const { theme } = useTheme();

  if (!isEditing) return null;

  return (
    <div className="flex justify-end gap-2">
      <Button variant="outline" onClick={onCancel}>
        <X className="h-4 w-4 mr-2" />
        Cancel
      </Button>
      <Button
        onClick={onSave}
        className={`${
          theme === 'dark' 
            ? 'bg-[#a6e15a] text-[#1a1a1a] hover:bg-[#95cc51]' 
            : 'bg-white text-black border border-border hover:bg-gray-50'
        }`}
      >
        <Save className="h-4 w-4 mr-2" />
        Save Changes
      </Button>
    </div>
  );
}