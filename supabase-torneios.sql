-- Ri Happy Tangará — gerenciamento seguro de torneios
-- Execute no SQL Editor do projeto Supabase ksltubnnppphxqhjycdau.
create table if not exists public.torneios (
  id text primary key,
  nome text not null,
  data text not null,
  horario text not null default '',
  valor text not null default '',
  formato text not null default '',
  status text not null default 'fechado' check (status in ('aberto','fechado')),
  "decklistObrigatoria" boolean not null default false,
  observacao text not null default '',
  premiacao jsonb not null default '[]'::jsonb,
  atualizado_em timestamptz not null default now()
);

create table if not exists public.tournament_admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  criado_em timestamptz not null default now()
);

alter table public.torneios enable row level security;
alter table public.tournament_admins enable row level security;

drop policy if exists "Public can read open tournaments" on public.torneios;
create policy "Public can read open tournaments"
  on public.torneios for select to anon, authenticated
  using (status = 'aberto');

drop policy if exists "Admins can manage tournaments" on public.torneios;
create policy "Admins can manage tournaments"
  on public.torneios for all to authenticated
  using (exists (select 1 from public.tournament_admins a where a.user_id = auth.uid()))
  with check (exists (select 1 from public.tournament_admins a where a.user_id = auth.uid()));

drop policy if exists "Admins can read own admin record" on public.tournament_admins;
create policy "Admins can read own admin record"
  on public.tournament_admins for select to authenticated
  using (user_id = auth.uid());

grant select on public.torneios to anon, authenticated;
grant insert, update, delete on public.torneios to authenticated;
grant select on public.tournament_admins to authenticated;

insert into public.torneios
(id,nome,data,horario,valor,formato,status,"decklistObrigatoria",observacao,premiacao)
values
('reinado-delta-2026-10-24','Pré-Release — Reinado Delta','24/10/2026','13h','R$ 149,99','Limitado','aberto',false,'Pré-Release: o baralho é montado no evento; não é necessário enviar decklist.','[]'::jsonb),
('copa-da-liga-2026-12-05','Copa da Liga','05/12/2026','13h','R$ 50,00','Expandido','aberto',true,'','["Troféus para os 1º colocados da categoria","Playmat para os 1º colocados da categoria","Boosters para o top 5"]'::jsonb)
on conflict (id) do update set
  nome=excluded.nome,data=excluded.data,horario=excluded.horario,valor=excluded.valor,
  formato=excluded.formato,status=excluded.status,
  "decklistObrigatoria"=excluded."decklistObrigatoria",
  observacao=excluded.observacao,premiacao=excluded.premiacao,
  atualizado_em=now();

-- Depois de criar um usuário em Authentication > Users no painel do Supabase,
-- copie o UUID desse usuário e execute a linha abaixo substituindo UUID_DO_ADMIN:
-- insert into public.tournament_admins (user_id) values ('UUID_DO_ADMIN');
