-- Run after schema.sql in the existing Supabase project. This adds a second
-- Google administrator without changing the shopkeeper's existing policies.
begin;

drop policy if exists "Second admin manages categories" on public.categories;
create policy "Second admin manages categories" on public.categories for all to authenticated
  using (lower(auth.jwt()->>'email') = 'xamoxm366@gmail.com' and auth.jwt()->'app_metadata'->>'provider' = 'google')
  with check (lower(auth.jwt()->>'email') = 'xamoxm366@gmail.com' and auth.jwt()->'app_metadata'->>'provider' = 'google');

drop policy if exists "Second admin manages products" on public.products;
create policy "Second admin manages products" on public.products for all to authenticated
  using (lower(auth.jwt()->>'email') = 'xamoxm366@gmail.com' and auth.jwt()->'app_metadata'->>'provider' = 'google')
  with check (lower(auth.jwt()->>'email') = 'xamoxm366@gmail.com' and auth.jwt()->'app_metadata'->>'provider' = 'google');

drop policy if exists "Second admin can manage product image records" on storage.objects;
create policy "Second admin can manage product image records" on storage.objects for select to authenticated
  using (bucket_id = 'product-images' and lower(auth.jwt()->>'email') = 'xamoxm366@gmail.com' and auth.jwt()->'app_metadata'->>'provider' = 'google');

drop policy if exists "Second admin uploads product images" on storage.objects;
create policy "Second admin uploads product images" on storage.objects for insert to authenticated
  with check (bucket_id = 'product-images' and lower(auth.jwt()->>'email') = 'xamoxm366@gmail.com' and auth.jwt()->'app_metadata'->>'provider' = 'google');

drop policy if exists "Second admin removes product images" on storage.objects;
create policy "Second admin removes product images" on storage.objects for delete to authenticated
  using (bucket_id = 'product-images' and lower(auth.jwt()->>'email') = 'xamoxm366@gmail.com' and auth.jwt()->'app_metadata'->>'provider' = 'google');

commit;
