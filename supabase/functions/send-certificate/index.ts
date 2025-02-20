import { serve } from "https://deno.land/std@0.190.0/http/server.ts";
import { Resend } from "npm:resend@2.0.0";

const resend = new Resend(Deno.env.get("RESEND_API_KEY"));

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

interface EmailRequest {
  to: string;
  certificateNumber: string;
  customerName: string;
  equipmentName: string;
}

const handler = async (req: Request): Promise<Response> => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const { to, certificateNumber, customerName, equipmentName }: EmailRequest = await req.json();

    const emailResponse = await resend.emails.send({
      from: "Basic Welding Services <certificates@basicwelding.co.uk>",
      to: [to],
      subject: `Certificate ${certificateNumber} for ${equipmentName}`,
      html: `
        <h1>Certificate ${certificateNumber}</h1>
        <p>Dear ${customerName},</p>
        <p>Please find attached your certificate for ${equipmentName}.</p>
        <p>Best regards,<br>Basic Welding Services Team</p>
      `,
    });

    return new Response(JSON.stringify(emailResponse), {
      headers: { "Content-Type": "application/json", ...corsHeaders },
    });
  } catch (error) {
    console.error("Error sending email:", error);
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        status: 500,
        headers: { "Content-Type": "application/json", ...corsHeaders },
      }
    );
  }
};

serve(handler);