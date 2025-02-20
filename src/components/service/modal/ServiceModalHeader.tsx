import { DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Pencil } from "lucide-react";
import { useTheme } from "@/components/theme-provider";

interface ServiceModalHeaderProps {
  onEdit: () => void;
  isEditing: boolean;
}

export function ServiceModalHeader({ onEdit, isEditing }: ServiceModalHeaderProps) {
  const { theme } = useTheme();
  
  return (
    <DialogHeader>
      <div className="flex justify-between items-center pr-12">
        <DialogTitle className="text-xl font-semibold">Service Record Details</DialogTitle>
        {!isEditing && (
          <Button
            onClick={onEdit}
            variant="outline"
            size="sm"
            style={{ 
              backgroundColor: theme === 'dark' ? '#a6e15a' : '#7b96d4',
              color: theme === 'dark' ? '#1a1a1a' : '#ffffff',
              border: 'none'
            }}
          >
            <Pencil className="h-4 w-4 mr-2" />
            Edit
          </Button>
        )}
      </div>
    </DialogHeader>
  );
}