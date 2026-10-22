-- Heat Hero Trainer: tables and access rules for Supabase.
-- Paste this whole file into Supabase > SQL Editor > New query, then press Run.

create table if not exists public.progress (
  user_id uuid primary key references auth.users on delete cascade,
  nick text not null,
  data jsonb not null default '{}',
  updated_at timestamptz not null default now()
);

create table if not exists public.coaches (
  user_id uuid primary key references auth.users on delete cascade
);

create table if not exists public.shared (
  key text primary key,
  data jsonb,
  updated_at timestamptz not null default now()
);

alter table public.progress enable row level security;
alter table public.coaches enable row level security;
alter table public.shared enable row level security;

-- Each student reads and writes only their own progress row.
create policy "student reads own" on public.progress for select using (auth.uid() = user_id);
create policy "student inserts own" on public.progress for insert with check (auth.uid() = user_id);
create policy "student updates own" on public.progress for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Coaches read every student's progress.
create policy "coach reads all" on public.progress for select
  using (exists (select 1 from public.coaches c where c.user_id = auth.uid()));

-- A person can see whether they themselves are a coach.
create policy "see own coach row" on public.coaches for select using (user_id = auth.uid());

-- Shared data (song timings): any signed-in person reads, only coaches write.
create policy "signed in reads shared" on public.shared for select using (auth.role() = 'authenticated');
create policy "coach writes shared" on public.shared for all
  using (exists (select 1 from public.coaches c where c.user_id = auth.uid()))
  with check (exists (select 1 from public.coaches c where c.user_id = auth.uid()));

-- AFTER you create your own coach account (see SETUP.md), run this once,
-- with your coach email in place of the example:
-- insert into public.coaches (user_id) select id from auth.users where email = 'YOUR_COACH_EMAIL';
