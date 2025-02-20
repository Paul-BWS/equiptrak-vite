-- Drop existing policies
DROP POLICY IF EXISTS "profiles_policy" ON profiles;

-- Create a more permissive policy for profiles
CREATE POLICY "profiles_policy" ON profiles
FOR ALL USING (true)
WITH CHECK (
    -- Admins can do everything
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
    OR
    -- Users can only modify their own profile
    auth.uid() = id
);

-- Create a trigger to automatically create profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
    INSERT INTO public.profiles (id, email, role)
    VALUES (new.id, new.email, 
        CASE 
            WHEN new.email IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk') THEN 'admin'
            ELSE 'customer'
        END
    );
    RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop if exists and recreate trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user(); 