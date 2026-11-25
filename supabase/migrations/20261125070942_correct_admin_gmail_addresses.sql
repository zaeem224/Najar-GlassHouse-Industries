/*
# Correct administrator Gmail addresses

1. Purpose
- Replace the temporary mistyped admin domains with the two confirmed Google addresses:
  maqboolmuzzamil265@gmail.com and xamoxm366@gmail.com.
2. Security changes
- Recreate every catalog and image-storage admin policy with trimmed, lowercase email matching.
- Keep Google-provider verification required.
- Remove anonymous insert, update, and delete grants while preserving public catalog reads.
*/

revoke insert, update, delete on public.categories, public.products from anon;
revoke insert, update, delete on storage.objects from anon;

drop policy if exists "Shopkeeper inserts categories" on public.categories;
create policy "Shopkeeper inserts categories" on public.categories for insert to authenticated
  with check (trim(lower(auth.jwt()->>'email')) = any (array['maqboolmuzzamil265@gmail.com','xamoxm366@gmail.com']) and auth.jwt()->'app_metadata'->>'provider' = 'google');

drop policy if exists "Shopkeeper updates categories" on public.categories;
create policy "Shopkeeper updates categories" on public.categories for update to authenticated
  using (trim(lower(auth.jwt()->>'email')) = any (array['maqboolmuzzamil265@gmail.com','xamoxm366@gmail.com']) and auth.jwt()->'app_metadata'->>'provider' = 'google')
  with check (trim(lower(auth.jwt()->>'email')) = any (array['maqboolmuzzamil265@gmail.com','xamoxm366@gmail.com']) and auth.jwt()->'app_metadata'->>'provider' = 'google');

drop policy if exists "Shopkeeper deletes categories" on public.categories;
create policy "Shopkeeper deletes categories" on public.categories for delete to authenticated
  using (trim(lower(auth.jwt()->>'email')) = any (array['maqboolmuzzamil265@gmail.com','xamoxm366@gmail.com']) and auth.jwt()->'app_metadata'->>'provider' = 'google');

drop policy if exists "Shopkeeper inserts products" on public.products;
create policy "Shopkeeper inserts products" on public.products for insert to authenticated
  with check (trim(lower(auth.jwt()->>'email')) = any (array['maqboolmuzzamil265@gmail.com','xamoxm366@gmail.com']) and auth.jwt()->'app_metadata'->>'provider' = 'google');

drop policy if exists "Shopkeeper updates products" on public.products;
create policy "Shopkeeper updates products" on public.products for update to authenticated
  using (trim(lower(auth.jwt()->>'email')) = any (array['maqboolmuzzamil265@gmail.com','xamoxm366@gmail.com']) and auth.jwt()->'app_metadata'->>'provider' = 'google')
  with check (trim(lower(auth.jwt()->>'email')) = any (array['maqboolmuzzamil265@gmail.com','xamoxm366@gmail.com']) and auth.jwt()->'app_metadata'->>'provider' = 'google');

drop policy if exists "Shopkeeper deletes products" on public.products;
create policy "Shopkeeper deletes products" on public.products for delete to authenticated
  using (trim(lower(auth.jwt()->>'email')) = any (array['maqboolmuzzamil265@gmail.com','xamoxm366@gmail.com']) and auth.jwt()->'app_metadata'->>'provider' = 'google');

drop policy if exists "Shopkeeper can manage product image records" on storage.objects;
create policy "Shopkeeper can manage product image records" on storage.objects for select to authenticated
  using (bucket_id = 'product-images' and trim(lower(auth.jwt()->>'email')) = any (array['maqboolmuzzamil265@gmail.com','xamoxm366@gmail.com']) and auth.jwt()->'app_metadata'->>'provider' = 'google');

drop policy if exists "Shopkeeper uploads product images" on storage.objects;
create policy "Shopkeeper uploads product images" on storage.objects for insert to authenticated
  with check (bucket_id = 'product-images' and trim(lower(auth.jwt()->>'email')) = any (array['maqboolmuzzamil265@gmail.com','xamoxm366@gmail.com']) and auth.jwt()->'app_metadata'->>'provider' = 'google');

drop policy if exists "Shopkeeper removes product images" on storage.objects;
create policy "Shopkeeper removes product images" on storage.objects for delete to authenticated
  using (bucket_id = 'product-images' and trim(lower(auth.jwt()->>'email')) = any (array['maqboolmuzzamil265@gmail.com','xamoxm366@gmail.com']) and auth.jwt()->'app_metadata'->>'provider' = 'google');
