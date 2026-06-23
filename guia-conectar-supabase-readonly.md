# Guia — Conectar o Supabase ao Projeto em modo SOMENTE LEITURA

O Projeto precisa **ler** o banco de dados para mostrar como cada cliente está configurado. Mas ele **nunca** deve poder alterar ou apagar dados.

Este guia mostra como conectar o Supabase de um jeito que **garante isso**.

> Este passo é técnico — recomendado que seja feito pelo Tiago ou pelo time técnico, não pela equipe de CS.

---

## ⚠️ O problema do conector padrão

Na galeria de conectores do Claude (categoria "Anthropic e Parceiros") existe um conector **Supabase** pronto. **Não use esse.**

Esse conector da galeria vem com **32 ferramentas, incluindo escrita total** — `execute_sql` (roda qualquer comando SQL), `apply_migration`, `delete_branch` e outras. Ele pede permissão **"Read & write"** e **não tem botão para limitar a leitura**. Ou seja: conectado assim, o Claude *poderia* apagar ou alterar dados do banco.

A solução é adicionar o Supabase como **"conector personalizado"**, com uma URL que ativa o modo somente leitura.

---

## ✅ A solução: conector personalizado com `read_only`

O Supabase oferece o mesmo serviço por um endereço que aceita um parâmetro `read_only=true`. Com ele ligado:

- Todas as ferramentas de escrita (`apply_migration`, `create_branch`, etc.) **somem**.
- A ferramenta `execute_sql` continua, mas roda tudo por um usuário do banco que **só consegue ler** — qualquer tentativa de `INSERT`/`UPDATE`/`DELETE` falha no próprio banco.

---

## Passo 1 — O código do projeto Supabase ("Project Ref")

O projeto Supabase do CS-IA tem este código:

```
poxeqbzrweovaixamoqj
```

Esse código **não é secreto** — é o subdomínio público da API do Supabase. Se um dia precisar reconferir, ele aparece no painel do Supabase em **Settings → General → Reference ID**.

---

## Passo 2 — Adicionar o conector personalizado no Claude.ai

1. No Claude.ai, abra **Configurações → Conectores** (em inglês: *Customize → Connectors*).
   - Em contas **Team/Enterprise**, isso é feito pelo **Owner** em *Organization settings → Connectors*.
2. Clique no botão **"+"** ao lado de "Conectores" e escolha **"Adicionar conector personalizado"**.
3. No modal **"Adicionar conector personalizado"**, preencha:
   - **Nome:** `Supabase CS-IA (somente leitura)`
   - **URL do servidor MCP remoto:**
     ```
     https://mcp.supabase.com/mcp?read_only=true&project_ref=poxeqbzrweovaixamoqj&features=database,docs
     ```
   - **Configurações avançadas** (ID do Cliente OAuth / Client Secret OAuth): **deixe em branco**. O Supabase registra o cliente OAuth automaticamente.
4. Clique em **"Adicionar"**.
5. O Claude vai abrir uma janela de login do Supabase (**OAuth**) — autorize com a conta que tem acesso ao projeto CS-IA.

**O que cada parte da URL faz:**

| Parte | Para que serve |
|---|---|
| `read_only=true` | Liga o modo somente leitura. Remove as ferramentas de escrita. |
| `project_ref=<...>` | Trava o conector em um único projeto Supabase. |
| `features=database,docs` | Limita as ferramentas a "banco de dados" e "documentação". Remove edge functions, storage, branching e gestão de projeto — coisas que o Projeto não precisa. |

---

## Passo 3 — Ajustar as permissões de ferramentas (importante!)

Depois de conectar, abra o conector **"Supabase CS-IA (somente leitura)"**. Em **"Permissões de ferramentas"** as ferramentas aparecem em dois grupos:

- **Ferramentas somente leitura** (≈5): `Execute SQL`, `List tables`, `List extensions`, `List migrations`, `Search docs`.
- **Ferramentas de gravação/exclusão** (1): `Apply migration`.

**Sinal de que o modo leitura pegou:** o `Execute SQL` deve estar no grupo **"somente leitura"**. Se ele estiver em "gravação/exclusão", o `read_only=true` falhou — remova o conector e refaça conferindo a URL.

**Ação obrigatória — bloquear a ferramenta de escrita.** A `Apply migration` ainda aparece na lista (no modo leitura ela falharia se usada, mas vale blindar). Cada ferramenta tem 3 ícones à direita:

| Ícone | Significado |
|---|---|
| ✓ círculo com check | Permitir automaticamente |
| ✋ mão | Requer aprovação (pergunta antes de usar) |
| ⊘ círculo cortado | Bloquear / desativar |

Na linha **`Apply migration`**, clique no **⊘ (círculo cortado)** para **bloquear**.

**Para as 5 ferramentas de leitura:** deixe em **✓ Permitir** (mais prático — são consultas inofensivas) ou em **✋ Requer aprovação** (você confirma cada consulta). Recomendado: **Permitir**.

**Teste rápido no chat do Projeto:** peça *"liste as tabelas do banco"* (deve funcionar) e *"aplique uma migration de teste"* (deve ser bloqueado).

---

## Camadas de segurança (resumo)

A configuração protege o banco em **quatro camadas**:

1. **URL com `read_only=true`** — o Supabase roda toda consulta por um usuário de banco só-leitura; qualquer escrita falha no próprio banco.
2. **`features=database,docs`** — reduz o conjunto de ferramentas só ao necessário (banco + documentação).
3. **Bloqueio da `Apply migration`** na tela de permissões do conector (Passo 3).
4. **Instruções do Projeto** — o texto em `INSTRUCOES-DO-PROJETO.md` proíbe o Claude de tentar qualquer alteração no banco.

---

## Plano B (se o conector personalizado não funcionar)

A Anthropic não documenta formalmente que os parâmetros da URL (`?read_only=true...`) são sempre preservados no conector personalizado. Na prática funciona (é o que o próprio Supabase orienta), mas se na verificação do Passo 3 as ferramentas de escrita aparecerem, faça assim:

**Opção B — proteção no próprio banco.** Um desenvolvedor cria um usuário do banco que só consegue ler, rodando este SQL no Supabase (SQL Editor):

```sql
CREATE ROLE claude_readonly WITH LOGIN PASSWORD 'defina-uma-senha-forte';
GRANT pg_read_all_data TO claude_readonly;
```

Esse usuário garante, no nível do banco, que nada pode ser alterado — mesmo que a camada do conector falhe. Use a connection string desse usuário em integrações que aceitem conexão direta.

> Observação técnica: o conector remoto do Supabase faz login via OAuth (na conta Supabase), e não por connection string. Por isso, no fluxo do Claude.ai, a proteção principal e suficiente é o `read_only=true` na URL — a Opção B é a rede de segurança para cenários de conexão direta.

**Em qualquer cenário**, as Instruções do Projeto continuam proibindo o Claude de tentar escrever — essa camada vale sempre.

---

## Checklist final

- [ ] Conector adicionado como **personalizado** (não o da galeria)
- [ ] URL com `read_only=true` e `project_ref=poxeqbzrweovaixamoqj`
- [ ] Login OAuth concluído (todas as permissões eram "Read")
- [ ] `Execute SQL` aparece no grupo "somente leitura"
- [ ] `Apply migration` **bloqueada** (ícone ⊘)
- [ ] Teste no chat: "listar tabelas" funciona, "aplicar migration" é bloqueado
- [ ] Conector da galeria padrão **não** está sendo usado
