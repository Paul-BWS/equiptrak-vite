import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { AddCustomerForm } from "./AddCustomerForm";
import { CustomerFormValues } from "./customers/types";

interface CustomerDialogsProps {
  isAddOpen: boolean;
  setIsAddOpen: (open: boolean) => void;
  onSuccess: () => void;
  initialData?: CustomerFormValues;
  isEditing?: boolean;
}

export function CustomerDialogs({
  isAddOpen,
  setIsAddOpen,
  onSuccess,
  initialData,
  isEditing = false,
}: CustomerDialogsProps) {
  const handleSuccess = () => {
    onSuccess();
    setIsAddOpen(false);
  };

  const handleOpenChange = (open: boolean) => {
    if (!open) {
      setTimeout(() => {
        setIsAddOpen(false);
      }, 100);
    }
  };

  const dialogDescription = isEditing 
    ? "Update the customer's information below."
    : "Enter the customer's information below.";

  return (
    <Dialog open={isAddOpen} onOpenChange={handleOpenChange}>
      <DialogContent 
        className="sm:max-w-[600px]"
        aria-describedby="dialog-description"
      >
        <DialogHeader>
          <DialogTitle>{isEditing ? "Edit Customer" : "Add Customer"}</DialogTitle>
          <DialogDescription id="dialog-description">
            {dialogDescription}
          </DialogDescription>
        </DialogHeader>
        <AddCustomerForm
          key={isAddOpen ? 'open' : 'closed'}
          onSuccess={handleSuccess}
          initialData={initialData}
          isEditing={isEditing}
          onClose={() => setIsAddOpen(false)}
        />
      </DialogContent>
    </Dialog>
  );
} 