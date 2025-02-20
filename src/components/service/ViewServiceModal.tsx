import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { useServiceRecordQuery } from "@/hooks/service/useServiceRecordQuery";
import { ScrollArea } from "@/components/ui/scroll-area";
import { ViewServiceForm } from "./view-modal/ViewServiceForm";

interface ViewServiceModalProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  recordId: string;
}

export function ViewServiceModal({ open, onOpenChange, recordId }: ViewServiceModalProps) {
  const { data: serviceRecord, isLoading, refetch } = useServiceRecordQuery(recordId);

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-4xl max-h-[90vh]">
        <DialogHeader>
          <DialogTitle>Service Record Details</DialogTitle>
        </DialogHeader>
        
        {isLoading ? (
          <div>Loading records...</div>
        ) : serviceRecord ? (
          <ScrollArea className="h-[calc(90vh-8rem)] pr-4">
            <ViewServiceForm 
              serviceRecord={serviceRecord}
              recordId={recordId}
              onSuccess={() => {
                refetch();
                onOpenChange(false);
              }}
              onCancel={() => onOpenChange(false)}
            />
          </ScrollArea>
        ) : (
          <div>No service records found.</div>
        )}
      </DialogContent>
    </Dialog>
  );
}