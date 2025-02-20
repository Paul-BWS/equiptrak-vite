import { Button } from "@/components/ui/button";
import { useTheme } from "@/components/theme-provider";

interface ServiceFormActionsProps {
  onBack: () => void;
  handleSubmit: () => void;
  isSubmitting: boolean;
}

export function ServiceFormActions({
  onBack,
  handleSubmit,
  isSubmitting,
}: ServiceFormActionsProps) {
  const { theme } = useTheme();
  
  return (
    <div className="flex justify-end gap-4 pt-4 border-t">
      <Button
        variant="outline"
        onClick={onBack}
        className="w-full sm:w-auto"
      >
        Cancel
      </Button>
      <Button
        onClick={handleSubmit}
        disabled={isSubmitting}
        className="w-full sm:w-auto"
        style={{ 
          backgroundColor: theme === 'dark' ? '#a6e15a' : '#7b96d4',
          color: theme === 'dark' ? '#1a1a1a' : '#ffffff',
          border: 'none'
        }}
      >
        Save Service Record
      </Button>
    </div>
  );
}