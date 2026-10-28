# 06 — Padrões de resposta do atendimento humano

Registro de como o time humano respondeu casos em que o bot errou ou escalou, com as instruções da gestão sobre o que o bot pode e não pode dizer. Serve de referência ao orientar ajustes no briefing de cada cliente: **antes de propor uma mudança sobre o tema, leia o caso correspondente aqui.**

Cada caso traz: a conversa, o que o bot fez de errado, o padrão da resposta humana, as instruções da gestão e o que já está cadastrado no banco (conferido na data do registro).

---

## Fabiana Tomé - IBATRI — Tribu Experience: conteúdo exclusivo presencial / gravação

- **Registrado em:** 28/10/2026
- **Conversa de origem:** Pedro, conversa 57385 (inbox de sync 131621), 28/10/2026
- **Status do ajuste:** ⏳ pendente — a gestão vai direcionar o ajuste no briefing

### O que aconteceu

1. Pedro (aluno) respondeu ao convite do encontro: *"Infelizmente, não vou conseguir comparecer no encontro presencial! Moro muito longe."*
2. O bot respondeu: *"Entendi, sem problemas 😊 / Você quer que eu te ajude com alguma informação do encontro (como acesso/como acompanhar o conteúdo) mesmo não podendo ir?"*
3. Pedro perguntou: *"Vai passar on-line?"*
4. O bot não achou a informação (`NAO_TENHO_INFORMACAO`) e escalou para a equipe.

### O que o bot fez de errado

- **Sugeriu que daria para "acompanhar o conteúdo" sem ir ao evento.** Isso abre a expectativa de transmissão ou gravação para quem não vai comprar ingresso — o que não existe.
- **Não respondeu "o evento é online?"**, embora a resposta já esteja cadastrada na FAQ do cliente (ver abaixo). A falha foi de busca/uso da base, não de falta de cadastro.

### Padrão da resposta humana (Equipe CS)

Sequência enviada, em mensagens curtas:

> Não, Pedro.
> Este encontro é exclusivo presencial.
> Até o momento não teremos liberação da gravação para quem não poderá ir.
> Também não teremos ingressos para evento online.
> O Tribu Experience é somente presencial e o conteúdo até o momento será exclusivo para os presentes.
> Ocorrerá a liberação do conteúdo para quem adquirir o VIP após o acontecimento do evento.

Pontos do padrão:

1. **Resposta direta e negativa logo de início** ("Não, Pedro."), sem rodeio.
2. **Evento exclusivamente presencial** — não há transmissão ao vivo.
3. **Não há gravação para quem não vai ao evento.**
4. **Não existe ingresso online.**
5. **O conteúdo é exclusivo para os presentes.**
6. **Única exceção:** quem compra o **ingresso VIP** recebe o replay depois do evento — a gravação está atrelada à compra do VIP, nunca é dada a quem não compra.
7. Uso de "até o momento" — não fecha a porta para mudanças futuras da organização, mas também não promete nada.

### Instruções da gestão (28/10/2026)

- **A IA não pode responder desse jeito** (oferecer "acompanhar o conteúdo" a quem disse que não vai).
- **A IA não pode prometer gravação de conteúdo para aluno que não vai comprar ingresso do Tribu Experience.**
- O ajuste na IA da Fabiana deve garantir a resposta correta sobre o conteúdo exclusivo do Tribu Experience, seguindo o padrão humano acima.

### O que já está cadastrado no banco (conferido em 28/10/2026)

- **FAQ já existente** — pergunta: *"O evento é online? / Consigo assistir de casa? / As palestras ficam gravadas? / Tem replay das palestras?"* — resposta: *"Não, o Tribu Experience é presencial, em São Paulo. Quem compra o ingresso VIP recebe o replay das palestras por 12 meses. O ingresso Classic não inclui o replay."* → **coerente** com o padrão humano; não há conflito.
- **Catálogo:** o ingresso VIP inclui "replay das palestras por 12 meses"; o Classic não.
- **Regra existente "o que NÃO oferecer":** não oferecer nem vender o Tribu Experience por iniciativa própria (só responder se o aluno perguntar; exceção da placa de conquista). Ao ajustar, cuidar para que a menção ao VIP/replay apareça **como resposta à pergunta do aluno**, não como oferta ativa.

### Pontos a decidir no ajuste (quando a gestão direcionar)

- Reforçar a FAQ existente com as frases do aluno que não vai poder ir ("não vou conseguir ir", "moro longe", "vai passar online?", "vai ter transmissão?", "vou receber a gravação?") e com a parte que falta: **sem gravação para quem não vai / não existe ingresso online / conteúdo exclusivo dos presentes**.
- Orientação de comportamento: quando o aluno disser que **não vai ao evento**, acolher e encerrar o assunto — **não** oferecer formas de "acompanhar o conteúdo".
- Confirmar com a gestão se, para quem diz que não vai, o bot deve ou não citar o replay do VIP (o humano citou; a regra de não oferecer o evento por iniciativa própria sugere citar só se o aluno perguntar sobre gravação).
