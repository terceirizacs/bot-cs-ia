# 03 — O que muda onde

Este é o arquivo central para responder pedidos. Ele traduz **"quero que o bot faça X"** em **"vá em tal tela → tal campo"**.

Todos os ajustes abaixo são feitos no **Editor do cliente** (https://tcs-ten-topaz.vercel.app). Lembre sempre de **clicar em Salvar** ao final.

---

## Configurável x Estrutural — a primeira pergunta

Antes de responder qualquer pedido, decida em qual grupo ele cai:

| | **Configurável** | **Estrutural** |
|---|---|---|
| O que é | Muda o conteúdo de **um cliente** | Muda o **motor** do bot (vale pra todos) |
| Quem faz | A própria equipe, pelo painel | Um desenvolvedor |
| Exemplos | Tom de voz, FAQ, produtos, quando escalar | Formato das mensagens, regras anti-invenção, adicionar capacidade nova |

A maioria esmagadora dos pedidos é **configurável**. A lista de itens estruturais está no fim deste arquivo e detalhada no `04-referencia-tecnica`.

---

## Tabela: jeito de falar e personalidade

| Quero que o bot... | Onde mudar |
|---|---|
| ...fale de um jeito mais **formal / acolhedor / divertido / direto** | Persona → **Tom de voz** (escolher a opção) |
| ...trate o cliente por **"senhor/senhora"** (ou voltar pra "você") | Persona → **Como tratar o lead** |
| ...seja mais **proativo**, ou só **responda quando perguntado** | Persona → **Postura do bot** |
| ...possa (ou não) usar **gírias** | Persona → **Bot pode usar gírias leves** |
| ...mude o **nome** | Persona → **Como o bot deve se chamar** |
| ...se **apresente de outro jeito** ou com outro cargo (ex: "consultora") | Persona → **Frase de apresentação do bot** |
| ...fale **diferente quando o cliente está chateado / empolgado / sumido** | Tom e Contexto → **Tom por momento do lead** (adicionar um item) |
| ...**pare de fazer** algo específico (ex: parar de mandar emoji demais) | Tom e Contexto → **Comportamentos adicionais a evitar** (adicionar uma frase) |
| ...aja diferente **fora do horário comercial** | Tom e Contexto → **Janela de atendimento** + **Tom a adotar fora do horário** |

---

## Tabela: o que o bot sabe e responde

| Quero que o bot... | Onde mudar |
|---|---|
| ...saiba **responder uma pergunta nova** | Base de Conhecimento → **Perguntas frequentes** (adicionar item: pergunta + resposta) |
| ...**corrija uma resposta errada** | Base de Conhecimento → editar a **Resposta** do item de FAQ correspondente |
| ...saiba sobre um **produto / serviço / preço** | Catálogo → **Produtos** (adicionar ou editar o produto) |
| ...fale de uma **promoção** | Catálogo → **Promoções** |
| ...**pare de oferecer** um produto (esgotou / pausou) | Catálogo → o produto → campo **Status** ("esgotado", "pausado" ou "lista de espera") |
| ...explique um **passo a passo** (agendar, cancelar, trocar senha) | Procedimentos → **Procedimentos operacionais** |
| ...mande um **link** (área de membros, comunidade) | Procedimentos → **Links úteis** |
| ...passe um **telefone ou contato** de suporte | Procedimentos → **Contatos de suporte humano** |
| ...conte a **história da empresa** ou sobre o **fundador** | Contexto do Negócio → **História** / **Fundador** |
| ...cite **diferenciais** ou **números** da empresa | Contexto do Negócio → **Diferenciais** / **Números oficiais** |
| ...informe as **redes sociais** | Contexto do Negócio → **Redes sociais oficiais** |

> ⚠️ Se o bot está "inventando" ou errando uma resposta: na maioria das vezes a informação certa **não está cadastrada**. Cadastre-a na Base de Conhecimento (ou Catálogo) — não é um defeito do bot.

> 💡 **O bot já sabe o nome do cliente** (e também e-mail e telefone) automaticamente — esses dados vêm do contato no WhatsApp/Chatwoot, então **não há campo no painel pra preencher isso** e o bot consegue chamar a pessoa pelo nome sozinho. Por privacidade, ele não fica repetindo e-mail/telefone do cliente sem ser pedido. Se o **nome** estiver aparecendo errado, corrija o **contato dentro do Chatwoot** (não é ajuste do painel do bot).

---

## Tabela: quando passar pra um humano

| Quero que o bot... | Onde mudar |
|---|---|
| ...**escale pra um humano** quando o cliente disser/fizer algo (regra geral) | Persona → **Quando o lead deve ser escalado pra humano** |
| ...escale por um motivo **operacional** específico (ex: falha num processo) | Procedimentos → **Quando o bot deve direcionar pra humano** |
| ...escale em uma **fase específica** do funil | Estratégia de Atendimento → a fase → **Sinais de escalação** |
| ...tenha **atenção redobrada** com um sinal de risco | Tom e Contexto → **Sinais de alerta** |

---

## Tabela: estratégia de venda / funil

| Quero que o bot... | Onde mudar |
|---|---|
| ...**ofereça ou não** algo dependendo do momento do cliente | Estratégia de Atendimento → **Fases do funil** (campos "O que oferecer" / "O que NÃO oferecer" da fase) |
| ...tenha um **objetivo diferente** em cada fase do cliente | Estratégia de Atendimento → a fase → **Objetivo do turno** |
| ...siga uma **regra de venda que vale sempre** | Estratégia de Atendimento → **Regras gerais de atendimento** |

---

## Tabela: ligar e desligar

| Quero... | Onde |
|---|---|
| ...**ativar** um cliente (ligar o bot) | Editor do cliente → botão **"Ativar cliente"** (precisa das 3 seções obrigatórias + 1 inbox) |
| ...**desligar o bot** de um cliente | Editor do cliente → botão **"Desativar"** |
| ...criar um **cliente novo** | Lista de clientes → **"+ Novo cliente"** |

---

## O que é ESTRUTURAL (precisa de desenvolvedor)

Se o pedido cair em algum destes casos, **não dá pra fazer pelo painel**. Avise que precisa de um dev e use o `04-referencia-tecnica` para montar o resumo do chamado.

| Pedido | Por que é estrutural |
|---|---|
| Mudar o **tamanho ou formato** das mensagens (os "balões" do WhatsApp) | Faz parte do motor do bot, igual pra todos os clientes. |
| Mudar como o bot **lê áudios ou imagens** | É uma etapa técnica do fluxo. |
| Mudar a **mecânica** de como o bot escala (não os gatilhos, mas o "como") | Lógica central do sistema. |
| Mudar as **regras de não inventar resposta** | Regra de segurança central. |
| **Adicionar uma capacidade nova** ao bot (ex: uma 8ª seção) | Exige criar peças novas no sistema. |
| Mudar a **estrutura do texto** de uma seção para **todos os clientes** | Mexe no "modelo" (template) compartilhado. |
| Mudar o comportamento do **"Supervisor"** (a checagem de qualidade do bot) | Componente central, igual pra todos. |
| Fazer o bot **não repetir** a mesma despedida/mensagem (ex: cliente agradece duas vezes) | Já é **estrutural e automático** desde 06/2026 — ver nota abaixo. |
| O bot está **com erro, fora do ar ou não responde** | É um problema técnico, não de configuração. |

> Mesmo nesses casos, o assistente deve explicar **o que** precisa ser feito em linguagem simples e dar um resumo pro chamado — sem mandar a pessoa embora "no vácuo".

> ✅ **Anti-repetição já é nativo do motor (desde 06/2026).** O bot agora tem, no próprio motor, uma regra que o impede de repetir uma mensagem que ele já enviou na conversa — e um cuidado especial pra quando o cliente **agradece ou se despede uma segunda vez** (aí ele responde algo curtinho e diferente, em vez de repetir a despedida inteira). **A equipe não precisa cadastrar nada por cliente pra isso** — vale automaticamente pra todos. Se alguém pedir "faz o bot não repetir a despedida", a resposta é: *"Isso já está resolvido no próprio bot, não precisa configurar nada."*

---

## Cuidado ao escrever exemplos: não cole frases prontas em "tom" e estratégia

Vale para os campos **Tom por momento do lead** (Tom e Contexto) e para textos de tom/estratégia em geral:

- **Descreva a intenção, não a frase exata.** Ex. certo: *"acolher, tranquilizar e retomar o assunto pendente"*. Ex. errado: *"Oi! Que bom te ver de novo por aqui 😊"*.
- **Por quê:** o bot tende a **recitar literalmente** uma frase pronta que encontra cadastrada — e aí repete a mesma frase, igualzinha, em conversas diferentes. Isso soa robótico. Cadastrar a *orientação* (e não o roteiro) deixa o bot montar a frase do jeito dele, natural, a cada vez.
- **Exceção — FAQ:** na **Base de Conhecimento**, a **Resposta** de cada pergunta é factual e **deve** ser literal e precisa (preço, horário, política). Ali a precisão vem antes da naturalidade. A diferença: FAQ = o fato exato; tom/estratégia = como agir, nunca o texto pronto.
