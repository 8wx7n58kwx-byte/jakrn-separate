-- Run once in Supabase SQL Editor. Then disable public signups in Auth settings.
-- Create staff accounts via Authentication > Users. All authenticated users can edit.
create table public.jobs(id int primary key check(id between 1 and 10),file_name text,file_path text,file_size bigint,room text check(room in ('ห้องที่ 1','ห้องที่ 2')),status text not null default 'ยังไม่ Present' check(status in ('ยังไม่ Present','Present แล้ว')));
insert into public.jobs(id) select generate_series(1,10);
alter table public.jobs enable row level security;
grant select,update on public.jobs to authenticated;
revoke all on public.jobs from anon;
create policy staff_read on public.jobs for select to authenticated using(true);
create policy staff_update on public.jobs for update to authenticated using(true) with check(true);
insert into storage.buckets(id,name,public) values('presentations','presentations',false);
create policy staff_files_read on storage.objects for select to authenticated using(bucket_id='presentations');
create policy staff_files_insert on storage.objects for insert to authenticated with check(bucket_id='presentations');
create policy staff_files_delete on storage.objects for delete to authenticated using(bucket_id='presentations');
-- Set project file-size limit to suit plan. Free projects cannot exceed 50 MB per file.
