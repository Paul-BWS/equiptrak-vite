import { LoginForm } from "@/components/auth/LoginForm";
import { Wrench, MessageCircle, ExternalLink, Phone, Mail } from "lucide-react";
import { Button } from "@/components/ui/button";
import { useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Textarea } from "@/components/ui/textarea";
import { toast } from "sonner";

// Import workshop background
import workshopBg from "/images/workshop-bg.jpeg";

const Login = () => {
  const [isChatOpen, setIsChatOpen] = useState(false);
  const [faultDescription, setFaultDescription] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleFaultReport = async () => {
    if (!faultDescription.trim()) {
      toast.error("Please provide a fault description");
      return;
    }

    setIsSubmitting(true);
    try {
      const { error } = await supabase
        .from('fault_reports')
        .insert([
          {
            description: faultDescription,
            status: 'new',
            created_at: new Date().toISOString()
          }
        ]);

      if (error) throw error;

      toast.success("Fault report submitted successfully");
      setFaultDescription("");
      setIsChatOpen(false);
    } catch (error: any) {
      console.error('Error submitting fault:', error);
      toast.error("Failed to submit fault report. Please contact us directly.");
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="min-h-screen w-screen flex">
      {/* Left side - Image */}
      <div className="hidden lg:block w-1/2 relative overflow-hidden">
        <div 
          className="absolute inset-0 bg-cover bg-center bg-no-repeat"
          style={{ 
            backgroundImage: `url(${workshopBg})`,
            filter: 'brightness(0.7) contrast(1.1)',
            transform: 'scale(1.1)'
          }}
        />
        <div className="absolute inset-0 bg-gradient-to-r from-black/20 to-transparent pointer-events-none" />
      </div>

      {/* Right side - Login and Content */}
      <div className="w-full lg:w-1/2 min-h-screen bg-[#f5f5f5] p-8 flex flex-col items-center justify-center">
        {/* Main Login Container */}
        <div className="w-full max-w-md p-8 space-y-6 bg-white rounded-2xl shadow-lg mb-6">
          <div className="flex items-center justify-center gap-2">
            <Wrench className="h-8 w-8 text-[#7b96d4]" />
            <h1 className="text-4xl font-bold text-[#7b96d4]">EquipTrak</h1>
            <span className="text-xs text-gray-400 font-bold">v2.0.2</span>
          </div>
          
          <div className="text-center text-red-500 font-bold text-xl bg-yellow-100 p-4 rounded-lg">
            *** NEW DEPLOYMENT TEST - PLEASE IGNORE ***
          </div>
          
          <LoginForm />
        </div>

        {/* Information Cards */}
        <div className="w-full max-w-md grid gap-4 mb-6">
          {/* Website Card */}
          <a 
            href="https://www.basicwelding.co.uk" 
            target="_blank" 
            rel="noopener noreferrer"
            className="p-4 bg-white rounded-lg shadow-md hover:shadow-lg transition-shadow flex items-center justify-between"
          >
            <div className="flex items-center gap-2">
              <ExternalLink className="h-5 w-5 text-[#7b96d4]" />
              <span className="text-gray-700">Need spares or repairs?</span>
            </div>
            <span className="text-[#7b96d4] font-medium">Visit basicwelding.co.uk</span>
          </a>

          {/* Contact Information */}
          <div className="grid grid-cols-2 gap-4">
            <a 
              href="tel:+441484714848" 
              className="p-4 bg-white rounded-lg shadow-md hover:shadow-lg transition-shadow flex items-center gap-2"
            >
              <Phone className="h-5 w-5 text-[#7b96d4]" />
              <span className="text-gray-700">01484 714848</span>
            </a>
            <a 
              href="mailto:service@basicwelding.co.uk" 
              className="p-4 bg-white rounded-lg shadow-md hover:shadow-lg transition-shadow flex items-center gap-2"
            >
              <Mail className="h-5 w-5 text-[#7b96d4]" />
              <span className="text-gray-700">Email Support</span>
            </a>
          </div>
        </div>

        {/* Chat Button */}
        <Dialog open={isChatOpen} onOpenChange={setIsChatOpen}>
          <DialogTrigger asChild>
            <Button 
              className="fixed bottom-4 right-4 bg-[#7b96d4] hover:bg-[#6b86c4] text-white rounded-full p-4 shadow-lg flex items-center gap-2"
            >
              <MessageCircle className="h-5 w-5" />
              <span>Report a Fault</span>
            </Button>
          </DialogTrigger>
          <DialogContent className="sm:max-w-[425px]">
            <DialogHeader>
              <DialogTitle>Report Equipment Fault</DialogTitle>
            </DialogHeader>
            <div className="grid gap-4 py-4">
              <p className="text-gray-500">
                Please describe the fault in detail:
              </p>
              <Textarea
                value={faultDescription}
                onChange={(e) => setFaultDescription(e.target.value)}
                placeholder="Enter fault description..."
                className="min-h-[100px]"
              />
              <div className="flex flex-col gap-4">
                <Button 
                  onClick={handleFaultReport}
                  disabled={isSubmitting}
                >
                  {isSubmitting ? "Submitting..." : "Submit Fault Report"}
                </Button>
                <div className="text-sm text-gray-500">
                  <p className="font-medium mb-2">Or contact us directly:</p>
                  <div className="space-y-2">
                    <a 
                      href="tel:+441484714848" 
                      className="flex items-center gap-2 text-[#7b96d4] hover:underline"
                    >
                      <Phone className="h-4 w-4" />
                      <span>01484 714848</span>
                    </a>
                    <a 
                      href="mailto:service@basicwelding.co.uk" 
                      className="flex items-center gap-2 text-[#7b96d4] hover:underline"
                    >
                      <Mail className="h-4 w-4" />
                      <span>service@basicwelding.co.uk</span>
                    </a>
                  </div>
                </div>
              </div>
            </div>
          </DialogContent>
        </Dialog>
      </div>
    </div>
  );
};

export default Login;