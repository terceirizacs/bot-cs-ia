# 04 — Referência técnica

Este arquivo é para o assistente usar em dois momentos:
1. Quando o pedido for **estrutural** — para montar um resumo útil pro chamado ao desenvolvedor.
2. Quando precisar **consultar o banco** (conector Supabase) — para saber onde a informação fica.

A equipe de CS não precisa entender este arquivo. Ele serve para o assistente dar respostas precisas.

---

## Como o sistema é construído (visão técnica)

O CS-IA tem três peças:

1. **Chatwoot** — recebe as mensagens do WhatsApp.
2. **n8n** — o "motor": um workflow único que processa cada mensagem, monta as instruções e gera a resposta. **Um workflow atende todos os clientes.**
3. **Supabase** — o banco de dados onde fica a configuração de cada cliente.

Quando chega uma mensagem, o n8n descobre de qual cliente ela é (pelo número da inbox do Chatwoot), busca a configuração desse cliente no Supabase e responde.

## Como o briefing vira o comportamento do bot

```
Equipe edita uma seção no painel
   → painel salva em clientes.briefing (JSON)
   → painel "renderiza": aplica um modelo (template) e gera um texto
   → texto é salvo em prompts.conteudo
   → n8n lê prompts.conteudo em cada conversa e usa como instrução do bot
```

Pontos importantes:
- A **fonte editável** é `clientes.briefing`. É o que o painel edita.
- O **texto que o bot usa** é `prompts.conteudo` — gerado automaticamente a partir do briefing. **Nunca editar `prompts.conteudo` direto**: ele é sobrescrito no próximo "Salvar".
- O painel transforma o briefing em texto usando "modelos" (templates) guardados na tabela `prompt_templates`.

---

## Tabelas do banco (Supabase) — para consultas via conector

| Tabela | O que guarda | Colunas-chave |
|---|---|---|
| `clientes` | Um registro por cliente | `id` (UUID), `nome`, `ativo` (bool), `briefing` (JSON com as 7 seções) |
| `inboxes` | As caixas de WhatsApp de cada cliente | `cliente_id`, `inbox_id_chatwoot` (número único), `ativo` |
| `prompts` | O texto já renderizado, por seção, por cliente | `cliente_id`, `tipo` (persona, catalogo...), `conteudo`, `ativo` |
| `prompt_templates` | Os modelos que transformam briefing em texto | `secao`, `versao`, `template_texto`, `schema_form`, `ativo` |
| `tipos_prompt` | A lista das 7 seções válidas | `tipo`, `ordem`, `obrigatorio` |
| `usuarios_autorizados` | Quem pode entrar no painel | `email`, `role` |

**Para ver a configuração de um cliente:** consulte `clientes` — a coluna `briefing` (JSON) tem as 7 seções com todos os campos. Os nomes internos dos campos estão no arquivo `02-mapa-do-frontend`.

**Como o n8n acha o cliente certo:** a partir do `inbox_id_chatwoot` da mensagem, ele faz `inboxes → clientes → prompts`. Se o cliente está inativo (`clientes.ativo = false`) ou a inbox está inativa, o bot não responde.

> 🔒 Lembrete: o conector Supabase é **somente leitura**. Só fazer `SELECT`. Nunca `INSERT`/`UPDATE`/`DELETE`/migration. Toda mudança vai pelo painel.

---

## Lista de itens ESTRUTURAIS e o que o dev precisa mexer

Quando um pedido for estrutural, use esta tabela para dizer ao dev (no resumo do chamado) qual arquivo/parte está envolvido.

| Pedido típico | Onde o dev mexe |
|---|---|
| Formato/tamanho das mensagens (balões do WhatsApp) | Code node `04-particiona-mensagem.js` e/ou workflow n8n |
| Regras-base do bot, preâmbulo, regras anti-invenção | `workflow/bot-cs-ia/code-nodes/02-montar-prompt.js` (o `preambuloBase`) |
| Comportamento do "Supervisor" (a checagem de qualidade) | `workflow/bot-cs-ia/code-nodes/02-montar-prompt.js` (`systemMessageSupervisor`) |
| Mecânica de como o bot escala / lê o histórico | `workflow/bot-cs-ia/code-nodes/02-montar-prompt.js` |
| Regra de não-repetição / não repetir despedida | `workflow/bot-cs-ia/code-nodes/02-montar-prompt.js` (`preambuloBase` + heurística `segundaDespedida`). Já implementado em 06/2026 — normalmente não precisa de novo chamado. |
| Esqueleto/regras das 6 ferramentas internas | `workflow/bot-cs-ia/code-nodes/02-montar-prompt.js` |
| Adicionar uma capacidade/seção nova ao bot | `02-montar-prompt.js` + tabela `tipos_prompt` + novo node no n8n |
| Mudar a estrutura do texto de uma seção (vale pra todos os clientes) | `infra/prompt-templates/*.md` + re-render |
| Como o bot lê áudio ou imagem | Workflow n8n (bloco de áudio usa Gemini) |
| Debounce, consolidação de dados | Code nodes `01-combina-conteudo-msg.js`, `03-consolidar-dados.js` |
| Tratamento de erros / bot fora do ar | Workflow `Error CS AI` no n8n |
| Quem pode acessar o painel | Tabela `usuarios_autorizados` (gerenciada via SQL pelo time técnico) |

**Modelo de resumo pro chamado** (o assistente preenche e entrega pra equipe colar):

> **Tipo:** mudança estrutural (não dá pelo painel).
> **O que a equipe quer:** [descrição em linguagem simples]
> **O que provavelmente precisa ser mexido:** [arquivo/parte da tabela acima]
> **Cliente(s) afetado(s):** [um cliente / todos]

---

## Regras invioláveis do sistema (não sugerir contornar)

- Todo prompt mora em `workflow/bot-cs-ia/code-nodes/02-montar-prompt.js`. Editar prompt em outro lugar não tem efeito.
- O preâmbulo estrutural do bot é imutável; a persona do cliente **estende**, nunca substitui.
- O Supervisor é igual pra todos os clientes — não se parametriza por cliente.
- As ferramentas têm regra anti-invenção: se não têm a informação, respondem que não sabem, e o bot escala. Isso é proposital.
- O motor tem **regra anti-repetição** (desde 06/2026): o bot não repete uma mensagem que já enviou na conversa, e responde de forma curta/diferente quando o cliente agradece ou se despede de novo. É estrutural e vale pra todos — não se configura por cliente.
- O bot **enxerga o histórico completo da conversa, incluindo as próprias respostas** (rotuladas `bot:`). Isso é o que permite a regra anti-repetição funcionar. (Antes de 06/2026, o motor escondia as respostas do bot do próprio bot — isso mudou.)
