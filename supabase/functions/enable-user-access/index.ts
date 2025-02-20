import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

function generatePassword() {
  const adjectives = ['Happy', 'Bright', 'Swift', 'Clever', 'Brave'];
  const nouns = ['Lion', 'Eagle', 'Tiger', 'Dolphin', 'Wolf'];
  const numbers = Math.floor(1000 + Math.random() * 9000);
  const adjective = adjectives[Math.floor(Math.random() * adjectives.length)];
  const noun = nouns[Math.floor(Math.random() * nouns.length)];
  return `${adjective}${noun}${numbers}`;
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Get the authorization header
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) throw new Error('No authorization header')

    // Create Supabase client
    const supabaseClient = createClient(
      req.headers.get('x-supabase-url') ?? '',
      req.headers.get('apikey') ?? '',
      {
        auth: {
          persistSession: false,
        },
        global: {
          headers: { Authorization: authHeader },
        },
      }
    )

    // Get request body
    const { contact_id, email, name } = await req.json()
    
    // Generate a password
    const password = generatePassword()

    // Create the auth user
    const { data: authData, error: authError } = await supabaseClient.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
    })

    if (authError) throw authError

    // Update the contact with user access
    const { error: updateError } = await supabaseClient
      .from('contacts')
      .update({ 
        has_user_access: true,
        user_id: authData.user.id
      })
      .eq('id', contact_id)

    if (updateError) throw updateError

    // Send welcome email with credentials
    // Note: In production, use a proper email service
    console.log('User created with credentials:', {
      email,
      password,
      name
    })

    return new Response(
      JSON.stringify({ 
        message: 'User access enabled successfully',
        email,
        password // In production, send this via email instead
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      }
    )
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 400,
      }
    )
  }
}) 