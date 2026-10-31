-- Run this once in Supabase Dashboard → SQL Editor.
create table if not exists public.playlist_drafts (
  id integer primary key check (id = 1),
  songs jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now()
);
create table if not exists public.playlist_public (
  id integer primary key check (id = 1),
  songs jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.playlist_drafts enable row level security;
alter table public.playlist_public enable row level security;
-- Drafts are private: only signed-in admin users can read/write.
drop policy if exists "admin reads drafts" on public.playlist_drafts;
create policy "admin reads drafts" on public.playlist_drafts for select to authenticated using (true);
drop policy if exists "admin writes drafts" on public.playlist_drafts;
create policy "admin writes drafts" on public.playlist_drafts for all to authenticated using (true) with check (true);
-- Published playlist is readable by visitors, writable only by signed-in admin.
drop policy if exists "anyone reads published playlist" on public.playlist_public;
create policy "anyone reads published playlist" on public.playlist_public for select to anon, authenticated using (true);
drop policy if exists "admin writes published playlist" on public.playlist_public;
create policy "admin writes published playlist" on public.playlist_public for all to authenticated using (true) with check (true);
-- Public photo URLs are needed for visitors; uploads/deletes require admin sign-in.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('song-photos','song-photos',true,8388608,array['image/jpeg','image/png','image/webp'])
on conflict (id) do update set public=true, file_size_limit=8388608, allowed_mime_types=array['image/jpeg','image/png','image/webp'];
drop policy if exists "public can view song photos" on storage.objects;
create policy "public can view song photos" on storage.objects for select using (bucket_id = 'song-photos');
drop policy if exists "admin uploads song photos" on storage.objects;
create policy "admin uploads song photos" on storage.objects for insert to authenticated with check (bucket_id = 'song-photos');
drop policy if exists "admin updates song photos" on storage.objects;
create policy "admin updates song photos" on storage.objects for update to authenticated using (bucket_id = 'song-photos') with check (bucket_id = 'song-photos');
drop policy if exists "admin deletes song photos" on storage.objects;
create policy "admin deletes song photos" on storage.objects for delete to authenticated using (bucket_id = 'song-photos');
