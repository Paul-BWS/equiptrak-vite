import { useState } from "react";
import { Button } from "@/components/ui/button";

interface AddServiceFooterProps {
  notes: string;
  setNotes: (notes: string) => void;
  onCancel: () => void;
  onSubmit: () => Promise<void>;
  isSubmitting: boolean;
}

export function AddServiceFooter({
  notes,
  setNotes,
  onCancel,
  onSubmit,
  isSubmitting,
}: AddServiceFooterProps) {
  return (
    <div className="space-y-4">
      <div className="space-y-4">
        <h3 className="text-lg font-semibold">Notes</h3>
        <textarea
          value={notes}
          onChange={(e) => setNotes(e.target.value)}
          placeholder="Add any notes here..."
          className="w-full min-h-[100px] px-3 py-2 rounded-md bg-muted text-foreground border border-input focus:outline-none focus:ring-1 focus:ring-ring"
          rows={4}
        />
      </div>

      <div className="flex justify-end gap-4 pt-4 border-t border-border">
        <Button
          variant="outline"
          onClick={onCancel}
          className="bg-muted text-foreground border border-input hover:bg-accent hover:text-accent-foreground"
        >
          Cancel
        </Button>
        <Button
          onClick={onSubmit}
          disabled={isSubmitting}
          className="bg-primary text-primary-foreground hover:bg-primary/90"
        >
          Save Service Record
        </Button>
      </div>
    </div>
  );
}