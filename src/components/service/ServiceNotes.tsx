import { Textarea } from "@/components/ui/textarea";

interface ServiceNotesProps {
  notes: string;
  setNotes: (notes: string) => void;
}

export function ServiceNotes({ notes, setNotes }: ServiceNotesProps) {
  return (
    <div className="space-y-4">
      <h2 className="text-lg font-semibold">Notes</h2>
      <Textarea
        value={notes}
        onChange={(e) => setNotes(e.target.value)}
        placeholder="Add any additional notes here..."
        className="min-h-[100px] bg-background"
      />
    </div>
  );
}