-- Remove the recovery-code feature and its stored data.
DELETE FROM public.security_activity
WHERE event_type = 'recovery_codes_generated';

DROP FUNCTION IF EXISTS public.save_recovery_code_hashes(TEXT[]);

ALTER TABLE public.account_security_settings
    DROP COLUMN IF EXISTS recovery_code_hashes,
    DROP COLUMN IF EXISTS recovery_codes_generated_at;
