import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { toast } from "sonner";

export const TestEmailButton = () => {
  const sendTestEmail = async () => {
    try {
      const { data, error } = await supabase.functions.invoke('send-retest-reminders', {
        body: { test: true }
      });

      if (error) throw error;
      
      toast.success("Test email sent successfully!");
      console.log("Response:", data);
    } catch (error) {
      console.error("Error sending test email:", error);
      toast.error("Failed to send test email");
    }
  };

  return (
    <Button onClick={sendTestEmail}>
      Send Test Email
    </Button>
  );
};