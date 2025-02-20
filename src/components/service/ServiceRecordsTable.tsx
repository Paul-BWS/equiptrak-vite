import { useState } from "react";
import { ServiceRecord } from "@/types/database";
import { ViewServiceModal } from "./ViewServiceModal";
import { useNavigate } from "react-router-dom";
import { supabase } from "@/integrations/supabase/client";
import { useToast } from "@/hooks/use-toast";
import { ServiceMobileCard } from "./components/ServiceMobileCard";
import { ServiceDesktopTable } from "./components/ServiceDesktopTable";
import { DeleteServiceAlert } from "./components/DeleteServiceAlert";
import { getStatus, getStatusColor } from "@/utils/serviceStatus";
import { sendServiceReminder } from "@/utils/serviceEmail";

interface ServiceRecordsTableProps {
  records: ServiceRecord[] | null;
  isLoading: boolean;
  customerId: string;
}

export function ServiceRecordsTable({
  records,
  isLoading,
  customerId,
}: ServiceRecordsTableProps) {
  const [selectedRecordId, setSelectedRecordId] = useState<string | null>(null);
  const [deleteRecordId, setDeleteRecordId] = useState<string | null>(null);
  const navigate = useNavigate();
  const { toast } = useToast();

  const handleDelete = async (recordId: string) => {
    const { error } = await supabase
      .from("service_records")
      .delete()
      .eq("id", recordId);

    if (error) {
      toast({
        title: "Error",
        description: "Failed to delete service record",
        variant: "destructive",
      });
      return;
    }

    toast({
      title: "Success",
      description: "Service record deleted successfully",
    });

    window.location.reload();
  };

  if (isLoading) {
    return <div>Loading...</div>;
  }

  if (!records?.length) {
    return <div>No service records found.</div>;
  }

  return (
    <>
      <div className="space-y-4 md:hidden">
        {records.map((record) => (
          <ServiceMobileCard
            key={record.id}
            record={record}
            onView={setSelectedRecordId}
            onNavigate={(id) => navigate(`/admin/customer/${customerId}/service/${id}/certificate`)}
            onDelete={(id) => setDeleteRecordId(id)}
            getStatus={getStatus}
            getStatusColor={getStatusColor}
          />
        ))}
      </div>

      <ServiceDesktopTable
        records={records}
        onView={setSelectedRecordId}
        onNavigate={(id) => navigate(`/admin/customer/${customerId}/service/${id}/certificate`)}
        onDelete={(id) => setDeleteRecordId(id)}
        onSendReminder={sendServiceReminder}
        getStatus={getStatus}
        getStatusColor={getStatusColor}
      />

      <ViewServiceModal
        open={!!selectedRecordId}
        onOpenChange={() => setSelectedRecordId(null)}
        recordId={selectedRecordId || ''}
      />

      <DeleteServiceAlert
        open={!!deleteRecordId}
        onOpenChange={() => setDeleteRecordId(null)}
        onConfirm={() => {
          if (deleteRecordId) {
            handleDelete(deleteRecordId);
          }
          setDeleteRecordId(null);
        }}
      />
    </>
  );
}