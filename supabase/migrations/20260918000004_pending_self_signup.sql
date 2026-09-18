-- Self-signup creates a pending profile. An administrator must activate it.
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_org_id UUID;
    v_role TEXT;
    v_is_active BOOLEAN;
BEGIN
    v_org_id := NULLIF(NEW.raw_user_meta_data ->> 'organization_id', '')::UUID;
    v_role := COALESCE(NULLIF(NEW.raw_user_meta_data ->> 'role', ''), 'cashier');
    v_is_active := COALESCE(NULLIF(NEW.raw_user_meta_data ->> 'is_active', '')::BOOLEAN, false);

    IF v_org_id IS NULL THEN
        RAISE EXCEPTION 'A new user must include organization_id metadata';
    END IF;

    IF v_role NOT IN ('admin', 'manager', 'cashier', 'collector', 'sales', 'reports') THEN
        RAISE EXCEPTION 'Unsupported profile role';
    END IF;

    INSERT INTO public.profiles (id, organization_id, branch_id, full_name, phone, role, is_active)
    VALUES (
        NEW.id,
        v_org_id,
        NULLIF(NEW.raw_user_meta_data ->> 'branch_id', '')::UUID,
        COALESCE(NULLIF(NEW.raw_user_meta_data ->> 'full_name', ''), NEW.email),
        NULLIF(NEW.raw_user_meta_data ->> 'phone', ''),
        v_role,
        v_is_active
    )
    ON CONFLICT (id) DO UPDATE
    SET organization_id = EXCLUDED.organization_id,
        branch_id = EXCLUDED.branch_id,
        full_name = EXCLUDED.full_name,
        phone = EXCLUDED.phone,
        role = EXCLUDED.role,
        is_active = EXCLUDED.is_active;

    RETURN NEW;
END;
$$;

