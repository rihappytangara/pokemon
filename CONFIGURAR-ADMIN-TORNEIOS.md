# Configuração do painel de torneios

O painel fica em `admin-torneios.html` e usa Supabase Auth + Row Level Security. O formulário público lê os torneios abertos do banco quando a configuração está completa; enquanto a chave estiver como placeholder, continua usando `torneios.json`.

## 1. Preparar o banco

1. Abra o projeto Supabase `ksltubnnppphxqhjycdau`.
2. Entre em **SQL Editor**.
3. Abra o arquivo `supabase-torneios.sql` deste repositório, copie o conteúdo e execute no SQL Editor.
4. O script cria as tabelas, ativa RLS, define as políticas e cadastra o Pré-Release e a Copa da Liga.

## 2. Configurar a chave pública

1. No painel Supabase, abra **Project Settings → API** (ou **Connect**, conforme a interface).
2. Copie a chave **anon/public** ou **publishable** do projeto.
3. Edite `supabase-config.js` e substitua `COLE_AQUI_SUA_CHAVE_ANON_OU_PUBLISHABLE`.
4. Nunca use a chave `service_role` ou outra chave secreta no navegador.

A URL do projeto já está configurada em `supabase-config.js`.

## 3. Criar o usuário administrador

1. No Supabase, abra **Authentication → Users** e crie o usuário com e-mail e senha.
2. Copie o UUID desse usuário.
3. No **SQL Editor**, execute, substituindo o UUID pelo valor real:

```sql
insert into public.tournament_admins (user_id)
values ('UUID_DO_ADMIN');
```

Não habilite cadastro público de usuários para esse painel. Crie os usuários administrativos manualmente no Supabase.

## 4. Acessar e administrar

Abra https://rihappytangara.github.io/pokemon/admin-torneios.html e entre com o usuário criado. O painel permite cadastrar, editar, excluir, abrir e fechar torneios. Apenas usuários listados em `tournament_admins` podem fazer essas alterações.

O formulário público continua em https://rihappytangara.github.io/pokemon/teste-limitless.html. Depois da configuração, ele passa a exibir automaticamente os torneios marcados como `aberto` no banco.

## Campos importantes

- `decklistObrigatoria`: `true` exige decklist; `false` torna o campo opcional.
- `premiacao`: lista de itens de premiação, um por linha no painel.
- `status`: `aberto` exibe o evento para inscrições; `fechado` o oculta do formulário, mas mantém o cadastro no painel.
