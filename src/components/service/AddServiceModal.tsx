import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Plus } from "lucide-react";
import { useState } from "react";
import { useTheme } from "@/components/theme-provider";
import { AddServiceForm } from "./add-modal/AddServiceForm";

interface AddServiceModalProps {
  customerId: string;
}

export function AddServiceModal({ customerId }: AddServiceModalProps) {
  const [open, setOpen] = useState(false);
  const { theme } = useTheme();

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <Button 
          className="gap-2"
          style={{ 
            backgroundColor: theme === 'dark' ? '#a6e15a' : '#7b96d4',
            color: theme === 'dark' ? '#1a1a1a' : '#ffffff',
            border: 'none'
          }}
        >
          <Plus className="h-4 w-4" />
          Add Service
        </Button>
      </DialogTrigger>
      <DialogContent 
        className="max-w-4xl max-h-[90vh] overflow-y-auto bg-background"
        aria-describedby="service-form-description"
      >
        <DialogHeader>
          <DialogTitle className="text-xl font-semibold text-foreground">Add Service Record</DialogTitle>
        </DialogHeader>
        <div id="service-form-description" className="sr-only">
          Form to add a new service record with test dates, engineer selection, and equipment details
        </div>
        <AddServiceForm
          customerId={customerId}
          onSuccess={() => setOpen(false)}
          onCancel={() => setOpen(false)}
        />
      </DialogContent>
    </Dialog>
  );
}