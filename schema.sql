-- ============================================================
-- LANDOR TALENT DIRECTORY — DATABASE SCHEMA
-- Supabase / PostgreSQL
-- Run this in: Supabase Dashboard → SQL Editor → New Query
-- ============================================================

-- Enable UUID generation
create extension if not exists "uuid-ossp";

-- ============================================================
-- TAXONOMY TABLES (admin-managed controlled vocabularies)
-- ============================================================

create table if not exists skills (
  id          uuid primary key default uuid_generate_v4(),
  name        text not null unique,
  created_at  timestamptz default now()
);

create table if not exists software_tools (
  id          uuid primary key default uuid_generate_v4(),
  name        text not null unique,
  created_at  timestamptz default now()
);

create table if not exists interests (
  id          uuid primary key default uuid_generate_v4(),
  name        text not null unique,
  created_at  timestamptz default now()
);

create table if not exists studios (
  id          uuid primary key default uuid_generate_v4(),
  name        text not null unique,   -- e.g. "London", "Paris", "Hamburg"
  timezone    text not null,          -- e.g. "Europe/London"
  created_at  timestamptz default now()
);

-- ============================================================
-- CLIENTS & PROJECTS (admin-managed master lists)
-- ============================================================

create table if not exists clients (
  id          uuid primary key default uuid_generate_v4(),
  name        text not null unique,
  logo_url    text,
  created_at  timestamptz default now(),
  updated_at  timestamptz default now()
);

create table if not exists projects (
  id            uuid primary key default uuid_generate_v4(),
  name          text not null,
  description   text,
  client_id     uuid references clients(id) on delete set null,
  cover_url     text,                -- project thumbnail image
  industry      text,                -- e.g. "Fashion", "Culture", "Finance"
  market        text,                -- e.g. "US, Europe"
  year          int,
  created_at    timestamptz default now(),
  updated_at    timestamptz default now()
);

-- ============================================================
-- TALENTS (core profile table)
-- Region & position come from Ground Control (HR system) — Phase 2 sync
-- ============================================================

create table if not exists talents (
  id                  uuid primary key default uuid_generate_v4(),
  user_id             uuid references auth.users(id) on delete cascade,  -- linked to Supabase Auth

  -- Identity
  full_name           text not null,
  preferred_name      text,
  pronouns            text,                          -- e.g. "she/her", "he/him", "they/them"
  email               text unique not null,
  profile_photo_url   text,

  -- Role & Location (managed by Ground Control in Phase 2 — read-only for talents)
  role_title          text,                          -- e.g. "Senior Designer"
  seniority           text,                          -- e.g. "Junior", "Mid", "Senior", "Director"
  studio_id           uuid references studios(id),
  employment_start    date,                          -- for "X years at Landor"

  -- Reporting
  line_manager_id     uuid references talents(id),
  resource_manager_id uuid references talents(id),

  -- About
  bio                 text,
  portfolio_url       text,
  resume_url          text,

  -- Spoken languages
  languages           text[],                        -- e.g. ["English", "French", "German"]

  -- Career & personal
  objectives          text,                          -- Career goals
  more_about_me       text,                          -- Additional personal context

  -- Access
  access_level        text not null default 'talent' check (access_level in ('talent', 'manager', 'admin')),
  is_active           boolean not null default true,

  -- Timestamps
  created_at          timestamptz default now(),
  updated_at          timestamptz default now()
);

-- ============================================================
-- JUNCTION TABLES (many-to-many relationships)
-- ============================================================

-- Talent ↔ Skills (with proficiency level)
create table if not exists talent_skills (
  talent_id   uuid references talents(id) on delete cascade,
  skill_id    uuid references skills(id) on delete cascade,
  proficiency text check (proficiency in ('novice', 'pro')),
  primary key (talent_id, skill_id)
);

-- Talent ↔ Software tools
create table if not exists talent_software (
  talent_id   uuid references talents(id) on delete cascade,
  software_id uuid references software_tools(id) on delete cascade,
  primary key (talent_id, software_id)
);

-- Talent ↔ Interests / passion points
create table if not exists talent_interests (
  talent_id   uuid references talents(id) on delete cascade,
  interest_id uuid references interests(id) on delete cascade,
  primary key (talent_id, interest_id)
);

-- Talent ↔ Projects (with role on the project)
create table if not exists talent_projects (
  talent_id   uuid references talents(id) on delete cascade,
  project_id  uuid references projects(id) on delete cascade,
  role_on_project text,              -- e.g. "Lead Designer", "Motion Director"
  primary key (talent_id, project_id)
);

-- Talent ↔ Clients (derived from projects, but can also be direct)
create table if not exists talent_clients (
  talent_id   uuid references talents(id) on delete cascade,
  client_id   uuid references clients(id) on delete cascade,
  primary key (talent_id, client_id)
);

-- ============================================================
-- STORAGE BUCKET SETUP (run separately in Storage settings)
-- Bucket name: profile-photos
-- Public read: true
-- Allowed MIME types: image/jpeg, image/png, image/webp
-- Max file size: 400MB (as per brief)
-- ============================================================

-- ============================================================
-- ROW-LEVEL SECURITY (RLS)
-- Access tiers to be fully defined in Phase 1 build (brief §12)
-- Basic policies set here — extend when tiers are confirmed
-- ============================================================

alter table talents         enable row level security;
alter table talent_skills   enable row level security;
alter table talent_software enable row level security;
alter table talent_interests enable row level security;
alter table talent_projects enable row level security;
alter table talent_clients  enable row level security;
alter table projects        enable row level security;
alter table clients         enable row level security;
alter table skills          enable row level security;
alter table software_tools  enable row level security;
alter table interests       enable row level security;
alter table studios         enable row level security;

-- All authenticated users can read all talent profiles
create policy "Authenticated users can read talents"
  on talents for select
  using (auth.role() = 'authenticated');

-- Talents can update their own profile
create policy "Talents can update own profile"
  on talents for update
  using (auth.uid() = user_id);

-- Admins can do everything (uses access_level on their own talent record)
create policy "Admins have full access to talents"
  on talents for all
  using (
    exists (
      select 1 from talents t
      where t.user_id = auth.uid() and t.access_level = 'admin'
    )
  );

-- Taxonomy tables: authenticated read, admin write
create policy "Authenticated users can read skills"
  on skills for select using (auth.role() = 'authenticated');

create policy "Authenticated users can read software_tools"
  on software_tools for select using (auth.role() = 'authenticated');

create policy "Authenticated users can read interests"
  on interests for select using (auth.role() = 'authenticated');

create policy "Authenticated users can read studios"
  on studios for select using (auth.role() = 'authenticated');

create policy "Authenticated users can read clients"
  on clients for select using (auth.role() = 'authenticated');

create policy "Authenticated users can read projects"
  on projects for select using (auth.role() = 'authenticated');

-- Junction tables: authenticated read
create policy "Authenticated can read talent_skills"
  on talent_skills for select using (auth.role() = 'authenticated');

create policy "Authenticated can read talent_software"
  on talent_software for select using (auth.role() = 'authenticated');

create policy "Authenticated can read talent_interests"
  on talent_interests for select using (auth.role() = 'authenticated');

create policy "Authenticated can read talent_projects"
  on talent_projects for select using (auth.role() = 'authenticated');

create policy "Authenticated can read talent_clients"
  on talent_clients for select using (auth.role() = 'authenticated');

-- Talents can manage their own junction records
create policy "Talents manage own skills"
  on talent_skills for all
  using (talent_id in (select id from talents where user_id = auth.uid()));

create policy "Talents manage own software"
  on talent_software for all
  using (talent_id in (select id from talents where user_id = auth.uid()));

create policy "Talents manage own interests"
  on talent_interests for all
  using (talent_id in (select id from talents where user_id = auth.uid()));

create policy "Talents manage own projects"
  on talent_projects for all
  using (talent_id in (select id from talents where user_id = auth.uid()));

create policy "Talents manage own clients"
  on talent_clients for all
  using (talent_id in (select id from talents where user_id = auth.uid()));

-- ============================================================
-- SEED DATA — Studios (all Landor offices per the brief)
-- ============================================================

insert into studios (name, timezone) values
  ('London',      'Europe/London'),
  ('Paris',       'Europe/Paris'),
  ('Hamburg',     'Europe/Berlin'),
  ('Sydney',      'Australia/Sydney'),
  ('Milan',       'Europe/Rome'),
  ('Geneva',      'Europe/Zurich'),
  ('Tokyo',       'Asia/Tokyo'),
  ('Los Angeles', 'America/Los_Angeles'),
  ('Mexico City', 'America/Mexico_City'),
  ('New York',    'America/New_York')
on conflict (name) do nothing;

-- ============================================================
-- SEED DATA — Core skillset taxonomy
-- ============================================================

insert into skills (name) values
  ('Art Direction'),
  ('Brand Strategy'),
  ('Branding'),
  ('Copywriting'),
  ('Experience Strategy'),
  ('Illustration'),
  ('Motion Design'),
  ('3D Design'),
  ('UX/UI Design'),
  ('Packaging Design'),
  ('Print Design'),
  ('Photography'),
  ('Video Production'),
  ('Web Design'),
  ('Environmental Design'),
  ('Sound Design'),
  ('Creative Direction')
on conflict (name) do nothing;

-- ============================================================
-- SEED DATA — Software tools taxonomy
-- ============================================================

insert into software_tools (name) values
  ('Adobe Illustrator'),
  ('Adobe Photoshop'),
  ('Adobe After Effects'),
  ('Adobe Premiere Pro'),
  ('Adobe InDesign'),
  ('Figma'),
  ('Sketch'),
  ('Cinema 4D'),
  ('Blender'),
  ('Maya'),
  ('Houdini'),
  ('DaVinci Resolve'),
  ('Procreate'),
  ('Webflow'),
  ('Framer')
on conflict (name) do nothing;

-- ============================================================
-- SEED DATA — Interests / Passion Points
-- ============================================================

insert into interests (name) values
  ('Modern Art'),
  ('Architecture'),
  ('Pottery'),
  ('Automotive'),
  ('Music'),
  ('Fashion'),
  ('Photography'),
  ('Film'),
  ('Gaming'),
  ('Sustainability'),
  ('Typography'),
  ('Street Art'),
  ('Food & Culture'),
  ('Sport'),
  ('Travel')
on conflict (name) do nothing;

-- ============================================================
-- UPDATED_AT trigger (auto-update timestamps on record change)
-- ============================================================

create or replace function update_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger talents_updated_at
  before update on talents
  for each row execute function update_updated_at();

create trigger projects_updated_at
  before update on projects
  for each row execute function update_updated_at();

create trigger clients_updated_at
  before update on clients
  for each row execute function update_updated_at();

-- ============================================================
-- USEFUL INDEXES for filter performance
-- ============================================================

create index if not exists idx_talents_studio      on talents(studio_id);
create index if not exists idx_talents_access_level on talents(access_level);
create index if not exists idx_talents_user_id      on talents(user_id);
create index if not exists idx_projects_client_id   on projects(client_id);
create index if not exists idx_talent_skills_skill  on talent_skills(skill_id);
create index if not exists idx_talent_projects_proj on talent_projects(project_id);
