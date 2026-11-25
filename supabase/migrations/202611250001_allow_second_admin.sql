-- Extend the existing Google-only admin policies to the second authorized account.
-- ALTER POLICY preserves each policy's role and command, and the transaction
-- leaves all policies untouched if any expected policy is missing.
begin;
alter policy "Shopkeeper manages categories" on public.categories
  using (lower(auth.jwt()->>'email') in ('maqboolmuzzamil265@gmail.com', 'xamoxm366@gmail.com') and auth.jwt()->'app_metadata'->>'provider' = 'google')
  with check (lower(auth.jwt()->>'email') in ('maqboolmuzzamil265@gmail.com', 'xamoxm366@gmail.com') and auth.jwt()->'app_metadata'->>'provider' = 'google');
alter policy "Shopkeeper manages products" on public.products
  using (lower(auth.jwt()->>'email') in ('maqboolmuzzamil265@gmail.com', 'xamoxm366@gmail.com') and auth.jwt()->'app_metadata'->>'provider' = 'google')
  with check (lower(auth.jwt()->>'email') in ('maqboolmuzzamil265@gmail.com', 'xamoxm366@gmail.com') and auth.jwt()->'app_metadata'->>'provider' = 'google');
alter policy "Shopkeeper can manage product image records" on storage.objects
  using (bucket_id = 'product-images' and lower(auth.jwt()->>'email') in ('maqboolmuzzamil265@gmail.com', 'xamoxm366@gmail.com') and auth.jwt()->'app_metadata'->>'provider' = 'google');
alter policy "Shopkeeper uploads product images" on storage.objects
  with check (bucket_id = 'product-images' and lower(auth.jwt()->>'email') in ('maqboolmuzzamil265@gmail.com', 'xamoxm366@gmail.com') and auth.jwt()->'app_metadata'->>'provider' = 'google');
alter policy "Shopkeeper removes product images" on storage.objects
  using (bucket_id = 'product-images' and lower(auth.jwt()->>'email') in ('maqboolmuzzamil265@gmail.com', 'xamoxm366@gmail.com') and auth.jwt()->'app_metadata'->>'provider' = 'google');
commit;
