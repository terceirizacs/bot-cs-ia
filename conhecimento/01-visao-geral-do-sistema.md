# 01 — Visão geral: como o bot CS-IA funciona

Este arquivo explica, sem termos técnicos, como o bot de atendimento funciona — o suficiente pra entender onde as coisas são configuradas.

## O que é o CS-IA

O CS-IA é um **robô de atendimento que conversa com clientes pelo WhatsApp**. Ele responde dúvidas, fala de produtos e preços, explica procedimentos e, quando precisa, **passa a conversa pra uma pessoa de verdade** (isso se chama "escalar" ou "handoff").

## Um robô só, vários clientes

Existe **um único robô** atendendo **vários clientes da TerceirizaCS** ao mesmo tempo (a Andrea Vermont é um deles). O robô é o mesmo pra todos — o que muda de um cliente pra outro é a **configuração**: o nome do bot, o jeito de falar, os produtos, as perguntas e respostas, etc.

Por isso, quando você for ajustar algo, quase sempre vai ajustar **para um cliente específico**.

## Onde fica a configuração

A configuração de cada cliente fica guardada num banco de dados (o **Supabase**). Mas você **não mexe no banco diretamente** — você mexe no **painel**, um site onde o time edita tudo de forma visual:

🔗 **Painel:** https://tcs-ten-topaz.vercel.app

Você entra com sua conta Google (seu e-mail precisa estar autorizado).

## O "briefing": o coração da configuração

Tudo o que define como o bot se comporta para um cliente fica organizado num **briefing**, dividido em **7 seções**:

| Seção | Pra que serve, em uma frase |
|---|---|
| **Persona** | Quem o bot é: nome, jeito de falar, quando passar pra um humano. |
| **Tom e Contexto** | Ajustes finos de tom: como falar quando o cliente está chateado, fora do horário, etc. |
| **Estratégia de Atendimento** | O que o bot deve oferecer dependendo do momento do cliente (o "funil"). |
| **Base de Conhecimento** | As perguntas e respostas (FAQ) que o bot sabe responder. |
| **Catálogo** | Os produtos, serviços, preços e promoções. |
| **Procedimentos** | Os passo a passo (como agendar, como cancelar...) e os contatos/links. |
| **Contexto do Negócio** | A história da empresa, fundador, diferenciais, redes sociais. |

Cada seção é uma aba no painel, dentro da tela de edição do cliente. O detalhe campo a campo está no arquivo **`02-mapa-do-frontend`**.

## O que acontece quando você salva

1. Você edita uma seção no painel e clica em **Salvar**.
2. O painel **transforma** o que você escreveu no "texto de instrução" que o bot entende.
3. A partir daí, **as próximas conversas** do bot já usam a configuração nova.

Ou seja: você não precisa avisar ninguém nem reiniciar nada. Salvou, valeu.

> ⚠️ É por isso que a mudança deve ser feita **pelo painel**, e não direto no banco. O painel faz essa "tradução". Mexer direto no banco pula essa etapa e quebra o bot.

## Por que o bot às vezes "não sabe" responder

O bot foi feito pra **nunca inventar**. Se perguntarem algo que não está cadastrado, ele responde que não tem aquela informação (e pode passar pra um humano). Isso é proposital — é mais seguro do que inventar uma resposta errada.

Então, quando alguém disser "o bot não soube responder X", na maioria das vezes **não é defeito**: é só uma informação que falta cadastrar (geralmente na **Base de Conhecimento** ou no **Catálogo**).

## O que o bot faz com cada mensagem (desde 11/11/2026)

A cada mensagem do aluno, o bot escolhe uma de três coisas:

1. **Responder**, com o que está cadastrado.
2. **Passar para a equipe** (escalar), deixando uma nota privada com o motivo.
3. **Ficar em silêncio**, quando o aluno só agradeceu, se despediu, contou que deu certo ("já consegui") ou mandou uma resposta automática. Se houver qualquer pergunta, pedido ou problema, ele responde ou passa para a equipe.

Antes de ir ao aluno, a resposta passa por uma checagem (o "Supervisor") e por travas automáticas. Resposta em outro idioma, com texto interno do bot ou em que ele se declara IA ou humano **não é enviada**: a conversa vai para a equipe com uma nota.

Desde 13/11/2026, o último ajuste antes do envio evita repetição: o bot não fica chamando o aluno pelo nome em toda resposta, nem repete "é só me chamar" ou "fico à disposição" a cada mensagem (olha as últimas 12 horas da conversa).

## Como o bot se apresenta (desde 12/11/2026)

O bot diz só o **nome e o time** cadastrados na Persona. Ele **nunca** diz que é assistente virtual, IA, robô ou humano, em nenhum cliente. Se o aluno pergunta "estou falando com uma IA?", ele passa para a equipe quando o cadastro do cliente manda; se o cadastro não diz nada, responde "Eu sou [nome], do time [X]" e segue o assunto.

## Datas (desde 12/11/2026)

O bot sabe a data e a hora de Brasília. Ele só diz "hoje", "amanhã" ou o dia da semana de uma aula, live ou prazo quando a data desse evento está cadastrada (ou foi dita na conversa) e bate com o dia de hoje.

## O que NÃO dá pra mudar pelo painel

Algumas coisas são "estruturais" — fazem parte do motor do bot e são iguais para todos os clientes. Exemplos: o tamanho/formato das mensagens, as regras de quando o bot escala, a maneira como ele evita inventar respostas, ou adicionar uma capacidade totalmente nova.

Essas mudanças **precisam de um desenvolvedor**. O arquivo `04-referencia-tecnica` lista o que é estrutural e o que o dev precisa mexer.

## Glossário rápido

- **Lead / cliente final:** a pessoa que conversa com o bot no WhatsApp.
- **Cliente (da TerceirizaCS):** a empresa que contratou o serviço (ex: Andrea Vermont).
- **Inbox:** a "caixa de entrada" de WhatsApp de um cliente. Cada cliente tem uma ou mais.
- **Briefing:** o conjunto de configurações de um cliente (as 7 seções).
- **Escalar / handoff:** quando o bot passa a conversa pra um atendente humano.
- **Persona:** a identidade do bot — nome, tom, jeito de falar.
- **FAQ:** lista de perguntas frequentes e suas respostas.
- **Tool ("ferramenta"):** cada uma das 7 seções funciona como uma "ferramenta" que o bot consulta quando precisa. Se uma seção está vazia, a ferramenta fica desativada e o bot não a usa.
- **Painel / frontend:** o site onde o time edita a configuração (https://tcs-ten-topaz.vercel.app).
