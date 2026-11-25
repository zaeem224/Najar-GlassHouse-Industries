-- Run once in a new Supabase project. Replace the sample products in the admin panel.
create extension if not exists pgcrypto;
create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  name text not null check (length(trim(name)) between 1 and 80),
  created_at timestamptz not null default now()
);
create unique index if not exists categories_name_unique on public.categories (lower(trim(name)));
create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  category_id uuid references public.categories(id) on delete cascade,
  name text not null default '' check (length(name) <= 120),
  description text not null default '' check (length(description) <= 2000),
  price text not null default '' check (length(price) <= 100),
  out_of_stock boolean not null default false,
  images text[] not null check (coalesce(array_length(images, 1), 0) between 1 and 5 and array_position(images, null) is null),
  demo boolean not null default false,
  created_at timestamptz not null default now()
);
create or replace function public.enforce_product_limit() returns trigger language plpgsql set search_path = public as $$
begin
  perform pg_advisory_xact_lock(9217801);
  if (select count(*) from public.products) >= 1000 then
    raise exception 'The catalog can contain up to 1,000 products. Remove a product before adding another.';
  end if;
  return new;
end;
$$;
drop trigger if exists enforce_product_limit on public.products;
create trigger enforce_product_limit before insert on public.products for each row execute function public.enforce_product_limit();

alter table public.categories enable row level security;
alter table public.products enable row level security;
create policy "Anyone can read categories" on public.categories for select to anon, authenticated using (true);
create policy "Anyone can read products" on public.products for select to anon, authenticated using (true);
-- Checking the signed JWT at the database is essential: the browser alone cannot grant access.
create policy "Shopkeeper manages categories" on public.categories for all to authenticated
  using (lower(auth.jwt()->>'email') = any (array['maqboolmuzzamil265@gmail.com','xamoxm366@gmail.com']) and auth.jwt()->'app_metadata'->>'provider' = 'google')
  with check (lower(auth.jwt()->>'email') = any (array['maqboolmuzzamil265@gmail.com','xamoxm366@gmail.com']) and auth.jwt()->'app_metadata'->>'provider' = 'google');
create policy "Shopkeeper manages products" on public.products for all to authenticated
  using (lower(auth.jwt()->>'email') = any (array['maqboolmuzzamil265@gmail.com','xamoxm366@gmail.com']) and auth.jwt()->'app_metadata'->>'provider' = 'google')
  with check (lower(auth.jwt()->>'email') = any (array['maqboolmuzzamil265@gmail.com','xamoxm366@gmail.com']) and auth.jwt()->'app_metadata'->>'provider' = 'google');
insert into storage.buckets (id, name, public, allowed_mime_types) values ('product-images', 'product-images', true, array['image/jpeg', 'image/png', 'image/webp', 'image/gif', 'image/avif']) on conflict (id) do nothing;
create policy "Shopkeeper can manage product image records" on storage.objects for select to authenticated
  using (bucket_id = 'product-images' and lower(auth.jwt()->>'email') = any (array['maqboolmuzzamil265@gmail.com','xamoxm366@gmail.com']) and auth.jwt()->'app_metadata'->>'provider' = 'google');
create policy "Shopkeeper uploads product images" on storage.objects for insert to authenticated
  with check (bucket_id = 'product-images' and lower(auth.jwt()->>'email') = any (array['maqboolmuzzamil265@gmail.com','xamoxm366@gmail.com']) and auth.jwt()->'app_metadata'->>'provider' = 'google');
create policy "Shopkeeper removes product images" on storage.objects for delete to authenticated
  using (bucket_id = 'product-images' and lower(auth.jwt()->>'email') = any (array['maqboolmuzzamil265@gmail.com','xamoxm366@gmail.com']) and auth.jwt()->'app_metadata'->>'provider' = 'google');

insert into public.categories (id, name) values
 ('ec063811-b2f0-4763-a165-63e30c022001', 'Blue'),
 ('ec063811-b2f0-4763-a165-63e30c022002', 'Plain'),
 ('ec063811-b2f0-4763-a165-63e30c022003', '8 mm');
insert into public.products (id, category_id, name, description, images, demo) values
 ('ec063811-b2f0-4763-a165-63e30c023001', 'ec063811-b2f0-4763-a165-63e30c022001', 'Blue glass', 'An example of the glass styles you can find in our collection.', array['/images/glass.jpg'], true),
 ('ec063811-b2f0-4763-a165-63e30c023002', 'ec063811-b2f0-4763-a165-63e30c022002', 'Plain glass', 'A clean and timeless choice for windows and interiors.', array['/images/interior.jpg'], true),
 ('ec063811-b2f0-4763-a165-63e30c023003', 'ec063811-b2f0-4763-a165-63e30c022003', '8 mm glass', 'Explore glass options for your next project.', array['/images/room.jpg'], true),
 ('ec063811-b2f0-4763-a165-63e30c023004', null, 'Designed glass', 'Find a finish that feels right for your space.', array['/images/building.jpg'], true);
