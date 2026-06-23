# 02 — Mapa do painel (frontend)

Este arquivo lista **todas as telas do painel** e **todos os campos editáveis**. É a referência para dizer à equipe exatamente onde clicar.

🔗 Painel: https://tcs-ten-topaz.vercel.app

> Nas tabelas, a coluna **"nome interno"** é o nome do campo dentro do banco de dados. A equipe não vê isso na tela — serve só para o assistente correlacionar o que aparece no painel com o que aparece no banco (ao consultar via conector Supabase).

---

## Telas do painel

| Tela | O que faz |
|---|---|
| **Login** | Entrada com conta Google. Só e-mails autorizados acessam. |
| **Lista de clientes** (página inicial) | Mostra todos os clientes: nome, status ativo/inativo, progresso de seções preenchidas (ex: "3/7 seções"), nº de inboxes. Botão **"+ Novo cliente"**. |
| **Novo cliente** | Formulário curto: pede só o **Nome do cliente** e cria o registro. O resto é preenchido na tela de edição. |
| **Editor do cliente** | A tela principal de trabalho. Tem uma **barra lateral** com as seções e o formulário à direita. É aqui que 99% dos ajustes acontecem. |

---

## A tela "Editor do cliente"

Tem uma **barra lateral à esquerda** com **8 seções**. Cada seção tem uma bolinha de status:

- 🔘 **Cinza** = vazio (não preenchido)
- 🟡 **Amarelo** = rascunho (parcialmente preenchido)
- 🟢 **Verde** = completo

Seções marcadas com `*` são **obrigatórias** para conseguir ativar o cliente.

No rodapé da barra lateral fica o botão **"Ativar cliente"** (fica desabilitado se faltar uma seção obrigatória ou uma inbox). Quando o cliente já está ativo, aparece o selo **"Ativo"** e um botão **"Desativar"**.

| Ordem | Seção | Obrigatória? |
|---|---|---|
| 1 | Geral | sim (precisa de ≥1 inbox) |
| 2 | Persona | sim `*` |
| 3 | Tom e Contexto | não |
| 4 | Estratégia de Atendimento | não |
| 5 | Base de Conhecimento | sim `*` |
| 6 | Catálogo | não |
| 7 | Procedimentos | não |
| 8 | Contexto do Negócio | sim `*` |

> Sempre que terminar de editar uma seção, clique em **Salvar**. Logo abaixo do formulário aparece um bloco verde escuro chamado **"Conteúdo renderizado"** — é uma prévia do texto exato que o bot vai receber. Serve pra conferir.

---

## Seção 1 — Geral

Dados básicos do cliente. Não influencia o "jeito de falar" do bot, mas é o que liga o cliente ao WhatsApp.

| Campo (na tela) | Nome interno | Tipo | O que controla |
|---|---|---|---|
| Nome do cliente `*` | `nome` | texto | Nome do cliente exibido no painel. |
| Inboxes vinculadas `*` | `inbox_id_chatwoot` | lista de números | Liga o cliente à(s) caixa(s) de WhatsApp no Chatwoot. É por esse número que o bot sabe qual cliente atender. Precisa de pelo menos 1 para ativar. |

---

## Seção 2 — Persona  `*obrigatória`

Define **quem o bot é** e o **jeito geral de falar**. É a seção mais usada para ajustes de comportamento.

| Campo (na tela) | Nome interno | Tipo | O que controla |
|---|---|---|---|
| Como o bot deve se chamar? `*` | `nome_bot` | texto | O nome com que o bot se identifica nas conversas. |
| Nome da empresa `*` | `nome_empresa` | texto | Nome da empresa usado nas apresentações. |
| Frase de apresentação do bot (opcional) | `frase_apresentacao` | texto longo | Como o bot se apresenta. Se preenchido, **substitui** o texto padrão "atendente virtual de [empresa]" — permite outro cargo (ex: "sua consultora", "do time de Customer Success"). Se vazio, usa o padrão. Use só pra definir **como o bot se apresenta** — não é lugar de colocar regra de comportamento (ex: "não repita despedida"); isso já é nativo do motor (ver `03`). |
| Segmento do negócio `*` | `segmento` | texto | Ramo de atuação (ex: "estúdio de pilates"). |
| Como tratar o lead? `*` | `tratamento` | escolha | Como o bot se dirige ao cliente. Opções: **você** / **senhor/senhora**. |
| Tom de voz `*` | `tom_voz` | escolha | O tom geral em todas as conversas. Opções: **acolhedor** / **formal** / **divertido** / **direto**. |
| Postura do bot `*` | `postura` | escolha | Quanto o bot toma iniciativa. Opções: **proativo** / **consultivo** / **passivo** (só responde se perguntado). |
| Bot pode usar gírias leves? | `girias_permitidas` | sim/não | Libera linguagem informal e gírias leves. |
| Quando o lead deve ser escalado pra humano? `*` | `escalar_quando` | lista de frases | Os gatilhos que fazem o bot passar a conversa pra um humano. Adicione quantos quiser. |

---

## Seção 3 — Tom e Contexto

Ajustes finos de tom. Tudo aqui é **opcional** — serve pra refinar situações específicas.

| Campo (na tela) | Nome interno | Tipo | O que controla |
|---|---|---|---|
| Tom por momento do lead `*` | `momentos_lead` | lista de itens | Como o bot ajusta o tom em cada situação. Cada item tem: **Situação** (quando), **Tom a adotar** e **Nuance adicional** (opcional). Ex: situação "cliente frustrado" → tom "acolhedor e calmo". ⚠️ Preencha com **orientação de tom** ("acolhedor e calmo"), **nunca com uma frase pronta pra o bot repetir** ("Oi, que bom te ver! 😊") — o bot recita frases literais e fica repetitivo. Ver `03`. |
| Regras específicas sobre quando se apresentar | `regras_apresentacao` | lista de frases | Exceções à regra de só se apresentar na 1ª conversa. |
| Comportamentos adicionais a evitar | `comportamentos_extras_evitar` | lista de frases | Coisas específicas que o bot **não** deve fazer (além das regras gerais do sistema). |
| Sinais de alerta que exigem atenção redobrada | `sinais_alerta` | lista de itens | Situações que mudam o atendimento. Cada item: **Sinal** + **Ação recomendada** (opcional). |
| Janela em que há humano disponível pra handoff | `horario_atendimento` | texto | Horário em que há atendente humano disponível. |
| Tom a adotar fora do horário humano | `tom_fora_horario` | escolha | Como o bot fala fora do horário. Opções: **igual** / **mais breve** / **mais acolhedor** / **mais formal**. |
| Observação adicional pra fora do horário | `mensagem_fora_horario` | texto longo | Instrução extra pro atendimento fora do horário. |

---

## Seção 4 — Estratégia de Atendimento

O "playbook" de vendas: o que o bot deve oferecer dependendo do **momento do cliente no funil**. Opcional.

| Campo (na tela) | Nome interno | Tipo | O que controla |
|---|---|---|---|
| Fases do funil `*` | `fases` | lista de itens | Cada fase do funil (ex: lead frio, cliente ativo). Cada fase tem: **Nome**, **Descrição curta**, **Objetivo do turno**, **Como identificar a fase**, **O que oferecer**, **O que NÃO oferecer**, **Gatilhos de avanço**, **Gatilhos de regressão**, **Sinais de escalação**. |
| Regras gerais de atendimento | `regras_gerais` | lista de frases | Diretrizes que valem em qualquer fase. |

---

## Seção 5 — Base de Conhecimento  `*obrigatória`

As perguntas e respostas que o bot sabe responder.

| Campo (na tela) | Nome interno | Tipo | O que controla |
|---|---|---|---|
| Perguntas frequentes `*` | `faq` | lista de itens | Cada item tem **Pergunta** + **Resposta factual**. O bot responde exatamente o que está aqui. Se a pergunta não estiver na lista, o bot diz que não tem a informação. |

> 💡 Quando o bot "não sabe responder" algo, quase sempre a solução é **adicionar um item de FAQ aqui**.

---

## Seção 6 — Catálogo

Produtos, serviços, preços e promoções. Opcional — fica ativa quando há pelo menos 1 produto.

| Campo (na tela) | Nome interno | Tipo | O que controla |
|---|---|---|---|
| Produtos / programas / serviços `*` | `produtos` | lista de itens | Cada produto tem: **Nome**, **Status** (ativo / esgotado / pausado / lista de espera), **Descrição curta**, **Para quem**, **Preços** (rótulo + valor + condição), **Formato**, **Duração**, **Diferenciais**, **O que inclui**, **O que NÃO inclui**, **Info geral**. |
| Promoções vigentes | `promocoes` | lista de itens | Cada promoção: **Nome**, **Descrição**, **Válido até** (data), **Código/cupom**. |
| Bônus gerais | `bonus_gerais` | lista de frases | Bônus que valem pra mais de um produto. |
| Observações gerais sobre o catálogo | `observacoes_gerais` | lista de frases | Ex: "preços válidos em janeiro/2026". |

> 💡 Para o bot **parar de oferecer** um produto, mude o **Status** dele para "esgotado", "pausado" ou "lista de espera" — não precisa apagar.

---

## Seção 7 — Procedimentos

Passo a passo de processos, links e contatos. Opcional — fica ativa quando há pelo menos 1 procedimento.

| Campo (na tela) | Nome interno | Tipo | O que controla |
|---|---|---|---|
| Procedimentos operacionais `*` | `procedimentos` | lista de itens | Cada procedimento: **Nome** (ex: "agendar uma aula"), **Passos** (lista numerada, a ordem importa), **Pré-requisitos/exceções**. |
| Links úteis | `links_uteis` | lista de itens | Cada link: **Rótulo**, **URL**, **Descrição**. |
| Contatos de suporte humano | `contatos_suporte` | lista de itens | Cada contato: **Canal** (whatsapp/telefone/email/presencial/outro), **Valor** (número/e-mail/endereço), **Quando usar**, **Horário**. |
| Quando o bot deve direcionar pra humano | `quando_escalar_humano` | lista de frases | Gatilhos de escalação específicos de situações operacionais. |

---

## Seção 8 — Contexto do Negócio  `*obrigatória`

A identidade institucional da empresa — o que o bot diz quando perguntam sobre a empresa.

| Campo (na tela) | Nome interno | Tipo | O que controla |
|---|---|---|---|
| Nome da empresa `*` | `nome_empresa` | texto | Nome usado no texto "sobre a empresa". |
| O que a empresa faz? `*` | `descricao_empresa` | texto longo | Descrição em 1-2 frases. |
| História ou origem | `historia` | texto longo | História da empresa (só aparece se preenchido). |
| Nome do fundador ou responsável | `fundador_nome` | texto | Nome do fundador (só aparece se preenchido). |
| Descrição breve do fundador | `fundador_descricao` | texto | Credenciais/papel do fundador. |
| Descrição da equipe | `equipe` | texto longo | Sobre a equipe (só aparece se preenchido). |
| Quem a empresa atende? `*` | `publico_alvo` | texto longo | Público-alvo da empresa. |
| Como a empresa se posiciona no mercado? `*` | `posicionamento` | texto longo | Diferenciação competitiva. |
| Diferenciais competitivos | `diferenciais` | lista de frases | Diferenciais da empresa como um todo. |
| Valores / filosofia | `valores` | lista de frases | Princípios que guiam a empresa. |
| Números oficiais | `numeros_oficiais` | lista de itens | Cada número: **Rótulo**, **Valor**, **Quando foi atualizado**. O bot só cita quando perguntado. |
| Redes sociais oficiais | `redes_sociais` | lista de itens | Cada rede: **Plataforma** + **Handle ou URL**. |

---

## Como ativar / desativar um cliente

- **Ativar:** preencha as seções obrigatórias (Persona, Base de Conhecimento, Contexto do Negócio) e vincule pelo menos 1 inbox. Depois clique em **"Ativar cliente"** no rodapé da barra lateral.
- **Desativar (desligar o bot do cliente):** clique em **"Desativar"**. Com o cliente inativo, o bot para de responder as mensagens daquele cliente.
