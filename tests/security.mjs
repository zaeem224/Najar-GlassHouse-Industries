import { PGlite } from '@electric-sql/pglite';
import { readFileSync } from 'node:fs';
import assert from 'node:assert/strict';

const schema = readFileSync(new URL('../supabase/schema.sql', import.meta.url), 'utf8').replace('create extension if not exists pgcrypto;', '');
const migration = readFileSync(new URL('../supabase/migrations/202611250001_allow_second_admin.sql', import.meta.url), 'utf8');
const expanded = "lower(auth.jwt()->>'email') in ('maqboolmuzzamil265@gmail.com', 'xamoxm366@gmail.com')";
const original = "lower(auth.jwt()->>'email') = 'maqboolmuzzamil265@gmail.com'";
assert.equal(schema.split(expanded).length - 1, 7, 'All original admin policy checks must cover both accounts');

for (const existing of [false, true]) {
  const db = new PGlite();
  await db.exec(`create role anon; create role authenticated; create schema auth; create schema storage;
  create function auth.jwt() returns jsonb language sql stable as $$select coalesce(nullif(current_setting('request.jwt.claims',true),''),'{}')::jsonb$$;
  create table storage.buckets (id text primary key,name text,public boolean,allowed_mime_types text[]);
  create table storage.objects (id uuid primary key default gen_random_uuid(), bucket_id text);
  alter table storage.objects enable row level security;
  grant usage on schema public, auth, storage to anon, authenticated;
  grant execute on function auth.jwt() to anon, authenticated;
  grant all on storage.objects to authenticated;`);
  // The existing-project fixture restores the single-account policy expressions
  // from the pre-change schema before applying the migration.
  await db.exec(existing ? schema.replaceAll(expanded, original) : schema);
  if (existing) await db.exec(migration);
  await db.exec('grant select on public.products, public.categories to anon, authenticated; grant insert, update, delete on public.products, public.categories to authenticated;');
  const claims = (email, provider='google') => JSON.stringify({email,app_metadata:{provider}}).replaceAll("'", "''");
  async function signed(email,provider='google') { await db.exec(`reset role; set role authenticated; select set_config('request.jwt.claims','${claims(email,provider)}',false);`); }
  async function rejects(query) { let failed=false; try { await db.exec(query); } catch { failed=true; } assert.ok(failed, 'Expected rejection: '+query); }
  await db.exec('set role anon;');
  assert.equal((await db.query('select count(*)::int as count from public.products')).rows[0].count, 4);
  await rejects("insert into public.categories(name) values ('No')");
  for (const [email, provider] of [['not-the-owner@example.com', 'google'], ['maqboolmuzzamil265@gmail.com', 'email'], ['xamoxm366@gmail.com', 'email']]) {
    await signed(email, provider);
    await rejects("insert into public.categories(name) values ('No')");
    await rejects("insert into storage.objects(bucket_id) values ('product-images')");
    assert.equal((await db.query("update public.products set name='Not allowed' returning id")).rows.length, 0);
  }
  for (const email of ['maqboolmuzzamil265@gmail.com', 'XAMOXM366@gmail.com']) {
    await signed(email);
    await db.exec("insert into public.categories(name) values ('Test'); insert into storage.objects(bucket_id) values ('product-images'); delete from storage.objects where bucket_id='product-images';");
    assert.equal((await db.query('select count(*)::int as count from storage.objects')).rows[0].count, 0);
    await rejects("insert into storage.objects(bucket_id) values ('other-bucket')");
    await db.exec("insert into public.products(category_id, images) select id, array['/test.jpg'] from public.categories where name='Test'; update public.products set name='Updated' where category_id = (select id from public.categories where name='Test'); delete from public.categories where name='Test';");
    assert.equal((await db.query('select count(*)::int as count from public.products')).rows[0].count, 4);
  }
  await rejects("insert into public.products(images) values (array[]::text[])");
  await rejects("insert into public.products(images) values (array['1','2','3','4','5','6'])");
  await db.exec("insert into public.products(images) select array['/test.jpg'] from generate_series(1,996);");
  assert.equal((await db.query('select count(*)::int as count from public.products')).rows[0].count, 1000);
  await rejects("insert into public.products(images) values (array['/test.jpg'])");
  await db.close();
}
console.log('PASS: fresh schema and migration; both Google admins; outsiders and non-Google denied; storage and catalog limits');
