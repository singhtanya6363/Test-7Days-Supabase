-- Keepalive table for the Supabase free-plan pause test.
-- One heartbeat row that a scheduled GitHub Action stamps every 12 hours.

create table public.keepalive (
  id integer primary key,
  note text not null default 'heartbeat row for the GitHub Action keepalive',
  created_at timestamptz not null default now(),
  last_ping timestamptz,
  ping_count integer not null default 0,
  last_ping_source text
);

insert into public.keepalive (id) values (1);

alter table public.keepalive enable row level security;

-- Read-only: the public key can read the heartbeat row, nothing else.
create policy "Public can read keepalive"
  on public.keepalive
  for select
  to anon, authenticated
  using (true);

grant select on public.keepalive to anon, authenticated;

-- The only write the public key can make: stamp the time on the heartbeat row.
create or replace function public.keepalive_ping(source text default 'unknown')
returns timestamptz
language sql
security definer
set search_path = ''
as $$
  update public.keepalive
     set last_ping = now(),
         ping_count = ping_count + 1,
         last_ping_source = left(source, 100)
   where id = 1
  returning last_ping;
$$;

revoke all on function public.keepalive_ping(text) from public;
grant execute on function public.keepalive_ping(text) to anon, authenticated;
