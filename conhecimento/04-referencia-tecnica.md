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

## Motor em produção (estado em 04/11/2026)

Dois "agentes" trabalham em cada resposta: o **Agent** escreve a resposta (consultando as 6 ferramentas internas) e o **Supervisor** confere se a resposta pode ir ao cliente ou se a conversa deve passar para uma pessoa. Se não há informação cadastrada, a regra do dono é **abrir handoff** (passar para humano), e o Supervisor é quem garante isso.

- **Modelos (desde 04/11/2026 12:55 UTC; acompanhada 30 min sem critério de reversão):** Agent e Supervisor em `gemini-3.8-flash`; ferramentas e conferência do formato de saída (Parser) em `gemini-3.5-flash-lite`; reservas da OpenAI em `gpt-5.4-mini` (Agent e ferramentas) e `gpt-5.4-nano` (Supervisor). Áudio: `gemini-3.5-flash-lite`, com Whisper da OpenAI como reserva. Custo é estimativa; revisão em dezembro.
- **Saída padrão (desde 03/11/2026):** se o Supervisor devolver uma decisão que o motor não reconhece, o bot não fica mudo: vira nota privada e a conversa é aberta para a equipe.
- **Regras do envio (Code `03-consolidar-dados.js`):** só vira resposta ao cliente o que o Supervisor mandou como resposta, até 1.500 caracteres, sem marcadores internos; link só se estiver no cadastro do cliente ou tiver sido dito na conversa por um humano ou pelo próprio cliente; fora disso vira handoff com o motivo na nota privada.
- **Monitor de modelos (fluxo `Monitor Modelos CS-IA`):** a cada 5 minutos testa `gemini-3.8-flash` e `gpt-5.4-mini` e avisa o time técnico no Discord na segunda falha seguida. Não vigia as ferramentas, o Parser, a reserva do Supervisor nem erros dentro do atendimento.
- **Aviso:** a troca para o 3.8 é recente (04/11/2026); no 1º acompanhamento de 30 min não houve erro nem critério de reversão, mas período curto não prova estabilidade a longo prazo. Prazo externo: em 01/12/2026 o `gemini-2.5-flash` passa a ser redirecionado pelo Google para `gemini-3.5-flash-lite`.

Os fluxos e os códigos de produção estão em `workflow/bot-cs-ia/` do repositório interno do projeto (`Json/` e `code-nodes/`).

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
| Tratamento de erros / bot fora do ar | Workflow `Error CS AI` no n8n (falhas definitivas viram nota privada + conversa aberta); alerta de modelo fora do ar: fluxo `Monitor Modelos CS-IA` |
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
- O bot **conhece os dados cadastrais do contato** (nome, e-mail e telefone) automaticamente, desde 07/2026. Esses dados vêm do próprio contato no Chatwoot/WhatsApp (`body.sender` no `02-montar-prompt.js`) — **não há campo no painel para isso**. Servem, na prática, para o bot **chamar o cliente pelo nome**. Por privacidade, o bot **não repete o e-mail nem o telefone** de volta ao cliente sem ele pedir, e nunca os inventa. Se o **nome** aparecer errado, o ajuste é no **contato dentro do Chatwoot**, não no painel do bot.
