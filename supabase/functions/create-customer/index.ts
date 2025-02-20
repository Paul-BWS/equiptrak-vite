// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts"

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

console.log("Hello from Functions!")

serve(async (req) => {
  console.log('Request received:', req.method);
  
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Get the JWT token from the request headers
    const authHeader = req.headers.get('Authorization')
    console.log('Auth header present:', !!authHeader);
    
    if (!authHeader) {
      throw new Error('No authorization header')
    }

    // Create Supabase client
    const supabaseClient = createClient(
      req.headers.get('x-supabase-url') ?? '',
      req.headers.get('apikey') ?? '',
      {
        auth: {
          persistSession: false,
        },
        global: {
          headers: {
            Authorization: authHeader,
          },
        },
      }
    )

    // Log request body for debugging
    const body = await req.json()
    console.log('Request body received:', {
      hasUserData: !!body.user_data,
      hasProfileData: !!body.profile_data,
      email: body.user_data?.email,
      companyName: body.user_data?.company_name,
      role: body.user_data?.role
    });

    const { user_data, profile_data } = body

    // Validate required fields
    if (!user_data?.email || !user_data?.password || !user_data?.company_name || !user_data?.role) {
      throw new Error('Missing required user data fields')
    }

    if (!profile_data?.email || !profile_data?.company_name || !profile_data?.role) {
      throw new Error('Missing required profile data fields')
    }

    console.log('Calling create_customer RPC...')
    // Call the database function to create customer
    const { data, error } = await supabaseClient.rpc('create_customer', {
      user_data,
      profile_data,
    })

    if (error) {
      console.error('RPC Error:', error)
      throw error
    }

    console.log('Customer created successfully')
    return new Response(
      JSON.stringify({ message: 'Customer created successfully' }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      }
    )
  } catch (error) {
    console.error('Error in create-customer function:', error)
    return new Response(
      JSON.stringify({ 
        error: error.message,
        details: error.toString()
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 400,
      }
    )
  }
})

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/create-customer' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
