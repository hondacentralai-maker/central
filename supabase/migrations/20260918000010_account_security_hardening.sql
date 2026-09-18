-- Never expose a broad profile UPDATE policy to the browser. Account settings
-- are changed through a narrow function that only accepts identity fields.
DROP POLICY IF EXISTS profiles_owner_update ON public.profiles;

CREATE OR REPLACE FUNCTION public.update_own_profile(p_full_name TEXT, p_phone TEXT)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    IF auth.uid() IS NULL THEN
        RAISE EXCEPTION 'Authentication required';
    END IF;
    IF p_full_name IS NULL OR length(trim(p_full_name)) < 2 OR length(trim(p_full_name)) > 120 THEN
        RAISE EXCEPTION 'Invalid full name';
    END IF;

    UPDATE public.profiles
    SET full_name = trim(p_full_name),
        phone = NULLIF(trim(p_phone), ''),
        updated_at = now()
    WHERE id = auth.uid();
END;
$$;

REVOKE ALL ON FUNCTION public.update_own_profile(TEXT, TEXT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.update_own_profile(TEXT, TEXT) TO authenticated;
