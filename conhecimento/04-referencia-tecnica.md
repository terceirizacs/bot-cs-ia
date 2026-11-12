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

## Motor em produção (estado em 12/11/2026)

Dois "agentes" trabalham em cada resposta: o **Agent** escreve a resposta (consultando as 6 ferramentas internas) e o **Supervisor** confere se a resposta pode ir ao cliente ou se a conversa deve passar para uma pessoa. Se não há informação cadastrada, a regra do dono é **abrir handoff** (passar para humano), e o Supervisor é quem garante isso.

- **Modelos (desde 11/11/2026):** Agent, Supervisor e as 6 ferramentas em `claude-haiku-5-5` (Anthropic). Reservas: `gemini-3.8-flash` no Agent e no Supervisor, OpenAI nas ferramentas. A conferência do formato da decisão do Agent usa `gemini-3.5-flash-lite`. Áudio: `gemini-3.5-flash-lite`, com Whisper da OpenAI como reserva (também quando o Gemini devolve a transcrição vazia). Antes de 11/11 as ferramentas usavam `gemini-3.5-flash-lite`; antes de 07/11 o Agent e o Supervisor usavam `gemini-3.8-flash`. Custo é estimativa.
- **Três decisões possíveis (desde 11/11/2026):** a cada mensagem o Agent escolhe **responder**, **escalar** (passar para a equipe, com o motivo) ou **ficar em silêncio**. O raciocínio dele fica separado e nunca vai ao aluno.
- **Silêncio (desde 11/11/2026):** o bot não responde quando todas as mensagens do aluno naquele momento são só agradecimento, despedida curta, confirmação de que deu certo ("já consegui", "deu tudo certo") ou resposta automática de outro negócio. Basta uma mensagem com pergunta, pedido ou problema para ele responder ou escalar. O silêncio não deixa nota nem etiqueta. Silêncio diante de resposta automática real ainda não foi visto em produção.
- **Idioma e texto interno (desde 10 e 11/11/2026):** a resposta ao aluno é sempre em português; resposta em inglês ou espanhol, ou que narra o próprio raciocínio ("o lead agradece…", "pela regra…"), ou que cita as fontes internas (base de conhecimento, persona, ferramenta), não é enviada e vira handoff.
- **Identidade (desde 12/11/2026):** o bot **nunca** se declara assistente ou atendente virtual, IA, robô, bot, automatizado, humano ou não humano, em nenhum cliente. Sobre quem é, diz só o **nome e o time** que estão na apresentação da persona. Se o aluno pergunta se fala com IA, robô ou pessoa: quando o cadastro manda escalar essa pergunta, o bot escala; quando não manda, responde só "Eu sou [nome], do time [X]" e segue o assunto. Se mesmo assim uma resposta sair com o bot se declarando, ela não é enviada e vira handoff com nota. Mencionar uma ferramenta do produto ("a IA do curso") não conta. Em produção desde 12/11; a trava ainda não disparou de verdade.
- **Data de hoje (desde 12/11/2026):** o Agent e o Supervisor recebem a data e a hora de Brasília. O bot só diz "hoje", "amanhã", "ontem" ou o dia da semana de um evento (aula, live, prazo) se a data dele estiver no cadastro ou na conversa e bater com hoje; evento que já passou não é tratado como futuro. Se a resposta errar nisso, o Supervisor manda para a equipe. A referência é a última mensagem da conversa.
- **Balões (desde 12/11/2026):** o bot não quebra mais a mensagem em dois balões depois de abreviações como "Prof.", "Profa.", "Sr.", "Sra.", "Srta." e "Sto." (já não quebrava depois de "Dr." e "Dra."). Testado só fora do WhatsApp; falta ver num envio real.
- **Saída padrão (desde 03/11/2026):** se o Supervisor devolver uma decisão que o motor não reconhece, o bot não fica mudo: vira nota privada e a conversa é aberta para a equipe.
- **Regras do envio (Code `03-consolidar-dados.js`):** só vira resposta ao cliente o que o Supervisor mandou como resposta, até 1.500 caracteres, sem marcadores internos; link só se estiver no cadastro do cliente ou tiver sido dito na conversa por um humano ou pelo próprio cliente; fora disso vira handoff com o motivo na nota privada.
- **Trava de promessa de encaminhar (desde 05/11/2026):** se a resposta promete encaminhar, repassar ou acionar a equipe (ex.: "vou encaminhar", "a equipe vai analisar") sem que o bot tenha feito o handoff, a resposta não é enviada: vira handoff com a nota "O bot prometeu encaminhar o caso sem acionar a equipe. Texto não enviado: ...". Promessas de baixa urgência (como repassar um feedback) entram na regra por decisão do dono. Em produção há pouco tempo; o efeito real ainda não foi medido.
- **Item 4c do Supervisor (desde 05/11/2026):** a checagem aceita também a resposta que só acolhe e pergunta o motivo do reembolso quando as fontes do cliente mandam perguntar o motivo antes de encaminhar. Antes, essa resposta era barrada em todo cliente com essa regra. Medido em testes, sem prova em produção.
- **Monitor de modelos (fluxo `Monitor Modelos CS-IA`):** a cada 5 minutos testa `claude-haiku-5-5` e `gemini-3.8-flash` (a reserva) e avisa o time técnico no Discord na segunda falha seguida. Não vigia as ferramentas, o Parser nem erros dentro do atendimento.
- **Aviso:** as mudanças acima são recentes (de 07 a 12/11/2026) e ainda não há medida de qualidade em volume com conversa real; confirme com o time técnico antes de afirmar que está estável. Prazo externo: em 01/12/2026 o `gemini-2.5-flash` passa a ser redirecionado pelo Google para `gemini-3.5-flash-lite`.

Os fluxos e os códigos de produção ficam na pasta interna do projeto (`workflow/bot-cs-ia/`), fora deste repositório público; peça ao time técnico.

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
| Formato/tamanho das mensagens (balões do WhatsApp), inclusive onde o balão quebra | Code node `04-particiona-mensagem.js` e/ou workflow n8n |
| Regra de como o bot fala de si (nunca se declarar virtual, IA, robô ou humano) e travas do envio (idioma, texto interno, autodeclaração, silêncio) | `02-montar-prompt.js` (regras do Agent e do Supervisor) e `03-consolidar-dados.js` (travas) — igual para todos os clientes |
| Data de hoje, "amanhã" e dia da semana de eventos | `02-montar-prompt.js` |
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
- O bot nunca se declara virtual, IA, robô, humano ou não humano (desde 12/11/2026). É estrutural e vale para todos os clientes; o que se configura por cliente é o nome e o time da apresentação (Persona) e se a pergunta "é IA?" deve ser escalada.
- O motor tem **regra anti-repetição** (desde 06/2026): o bot não repete uma mensagem que já enviou na conversa, e responde de forma curta/diferente quando o cliente agradece ou se despede de novo. É estrutural e vale pra todos — não se configura por cliente.
- O bot **enxerga o histórico completo da conversa, incluindo as próprias respostas** (rotuladas `bot:`). Isso é o que permite a regra anti-repetição funcionar. (Antes de 06/2026, o motor escondia as respostas do bot do próprio bot — isso mudou.)
- O bot **conhece os dados cadastrais do contato** (nome, e-mail e telefone) automaticamente, desde 07/2026. Esses dados vêm do próprio contato no Chatwoot/WhatsApp (`body.sender` no `02-montar-prompt.js`) — **não há campo no painel para isso**. Servem, na prática, para o bot **chamar o cliente pelo nome**. Por privacidade, o bot **não repete o e-mail nem o telefone** de volta ao cliente sem ele pedir, e nunca os inventa. Se o **nome** aparecer errado, o ajuste é no **contato dentro do Chatwoot**, não no painel do bot.
