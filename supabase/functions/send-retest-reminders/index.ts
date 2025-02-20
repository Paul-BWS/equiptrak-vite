import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.3";
import { serve } from "https://deno.land/std@0.190.0/http/server.ts";
import { Resend } from "npm:resend@2.0.0";

const resend = new Resend(Deno.env.get("RESEND_API_KEY"));
const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

const supabase = createClient(supabaseUrl, supabaseServiceKey);

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

const handler = async (req: Request): Promise<Response> => {
  console.log("Running retest reminder check...");
  
  // Handle CORS preflight requests
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    // Check if this is a test request
    const { test } = await req.json().catch(() => ({ test: false }));
    
    if (test) {
      console.log("Sending test email...");
      const testEquipment = [
        {
          name: "Test Welder 1",
          serial_number: "TST-001",
          next_test_date: new Date(Date.now() + (20 * 24 * 60 * 60 * 1000)).toISOString() // 20 days from now
        },
        {
          name: "Test Welder 2",
          serial_number: "TST-002",
          next_test_date: new Date(Date.now() + (25 * 24 * 60 * 60 * 1000)).toISOString() // 25 days from now
        }
      ];

      const equipmentList = testEquipment
        .map(eq => `- ${eq.name} (Serial: ${eq.serial_number}) - Due: ${new Date(eq.next_test_date).toLocaleDateString()}`)
        .join('\n');

      const emailResponse = await resend.emails.send({
        from: "Basic Welding Services <info@basicwelding.co.uk>",
        to: ["paul@basicwelding.co.uk"],
        subject: "TEST - Equipment Retest Reminder",
        html: `
          <h1>Equipment Retest Reminder</h1>
          <p>Dear Basic Welding Services,</p>
          <p>This is a TEST reminder email. The following equipment would be due for retesting in the next 30 days:</p>
          <pre>${equipmentList}</pre>
          <p>Please contact us to schedule your retest.</p>
          <p>Best regards,<br>Basic Welding Services</p>
          <p><small>This is a test email - please ignore.</small></p>
        `,
      });

      console.log("Test email sent:", emailResponse);
      return new Response(
        JSON.stringify({ message: "Test email sent successfully" }),
        {
          status: 200,
          headers: { "Content-Type": "application/json", ...corsHeaders },
        }
      );
    }

    // Get equipment due for retest in 30 days
    const thirtyDaysFromNow = new Date();
    thirtyDaysFromNow.setDate(thirtyDaysFromNow.getDate() + 30);
    
    const { data: dueEquipment, error: equipmentError } = await supabase
      .from("equipment")
      .select(`
        *,
        profiles:customer_id (
          company_name,
          contact_email
        )
      `)
      .eq('status', 'valid')
      .lte('next_test_date', thirtyDaysFromNow.toISOString())
      .gte('next_test_date', new Date().toISOString());

    if (equipmentError) {
      throw equipmentError;
    }

    console.log(`Found ${dueEquipment?.length || 0} equipment items due for retest`);

    // Group equipment by company
    const equipmentByCompany = dueEquipment?.reduce((acc, equipment) => {
      const companyId = equipment.customer_id;
      if (!acc[companyId]) {
        acc[companyId] = {
          companyName: equipment.profiles?.company_name || 'Unknown Company',
          contactEmail: equipment.profiles?.contact_email,
          equipment: []
        };
      }
      acc[companyId].equipment.push(equipment);
      return acc;
    }, {} as Record<string, { companyName: string; contactEmail: string | null; equipment: any[] }>);

    // Send emails for each company
    for (const companyId in equipmentByCompany) {
      const company = equipmentByCompany[companyId];
      if (!company.contactEmail) {
        console.log(`No contact email for company: ${company.companyName}`);
        continue;
      }

      const equipmentList = company.equipment
        .map(eq => `- ${eq.name} (Serial: ${eq.serial_number}) - Due: ${new Date(eq.next_test_date).toLocaleDateString()}`)
        .join('\n');

      const emailResponse = await resend.emails.send({
        from: "Basic Welding Services <info@basicwelding.co.uk>",
        to: [company.contactEmail],
        subject: "Equipment Retest Reminder",
        html: `
          <h1>Equipment Retest Reminder</h1>
          <p>Dear ${company.companyName},</p>
          <p>This is a reminder that the following equipment is due for retesting in the next 30 days:</p>
          <pre>${equipmentList}</pre>
          <p>Please contact us to schedule your retest.</p>
          <p>Best regards,<br>Basic Welding Services</p>
        `,
      });

      console.log(`Sent reminder email to ${company.companyName}:`, emailResponse);
    }

    return new Response(
      JSON.stringify({ message: "Reminder emails sent successfully" }),
      {
        status: 200,
        headers: { "Content-Type": "application/json", ...corsHeaders },
      }
    );
  } catch (error) {
    console.error("Error in send-retest-reminders function:", error);
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
