import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Save } from "lucide-react";

interface ServiceFooterProps {
  notes: string;
  setNotes: (notes: string) => void;
  onCancel: () => void;
  onSubmit: () => void;
  isSubmitting: boolean;
}

export function ServiceFooter({
  notes,
  setNotes,
  onCancel,
  onSubmit,
  isSubmitting,
}: ServiceFooterProps) {
  return (
    <div className="flex flex-col space-y-4">
      <div className="w-full space-y-2">
        <Label>Notes</Label>
        <Textarea
          value={notes}
          onChange={(e) => setNotes(e.target.value)}
          className="min-h-[100px]"
        />
      </div>
      <div className="flex w-full gap-2">
        <Button variant="outline" className="w-full" onClick={onCancel}>
          Cancel
        </Button>
        <Button
          className="w-full gap-2"
          onClick={onSubmit}
          disabled={isSubmitting}
        >
          <Save className="h-4 w-4" />
          Save Service Record
        </Button>
      </div>
    </div>
  );
}