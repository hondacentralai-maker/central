import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || 'https://jxmklxobhseupyntyhfq.supabase.co';
const supabaseKey = import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY || 'sb_publishable_E3nWQT6-7RGVGiYcaPuf7w_g9QDSQEl';

export const supabase = createClient(supabaseUrl, supabaseKey);
