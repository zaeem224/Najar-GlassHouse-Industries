import { createServerClient } from '@supabase/ssr';
import { cookies } from 'next/headers';
import { NextResponse } from 'next/server';
export async function GET(request) {
  const url = new URL(request.url);
  const code = url.searchParams.get('code');
  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
  if (code && supabaseUrl && key) {
    const store = await cookies();
    const supabase = createServerClient(supabaseUrl, key, { cookies: { getAll() { return store.getAll(); }, setAll(values) { values.forEach(({ name, value, options }) => store.set(name, value, options)); } } });
    const { error } = await supabase.auth.exchangeCodeForSession(code);
    if (!error) return NextResponse.redirect(new URL('/admin', url.origin));
  }
  return NextResponse.redirect(new URL('/admin?error=signin', url.origin));
}
