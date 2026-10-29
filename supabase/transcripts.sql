create table public.transcripts (
    id uuid primary key default gen_random_uuid(),
    user_id uuid not null references auth.users (id) on delete cascade,
    title text not null,
    source_language text not null,
    target_language text not null,
    source_text text not null,
    target_text text not null,
    duration_seconds integer not null default 0 check (duration_seconds >= 0),
    created_at timestamptz not null default now()
);

alter table public.transcripts enable row level security;

revoke all on table public.transcripts from anon, authenticated;
grant usage on schema public to authenticated;
grant select, insert on table public.transcripts to authenticated;

create policy "Users can read their own transcripts"
    on public.transcripts
    for select
    to authenticated
    using ((select auth.uid()) = user_id);

create policy "Users can insert their own transcripts"
    on public.transcripts
    for insert
    to authenticated
    with check ((select auth.uid()) = user_id);
