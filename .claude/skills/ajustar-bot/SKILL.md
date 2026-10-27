---
name: ajustar-bot
description: Modo "conserto rápido" do bot de um cliente. A pessoa descreve o que não gostou e manda o ID de uma conversa; o assistente lê a conversa e o cadastro no banco (somente leitura) e entrega uma página (artifact) com um bloco por campo do painel, palavra de Ctrl+F copiável, texto pronto com botão "Copiar" e bloco que fica verde ao copiar. Use quando pedirem para analisar conversas de um cliente pelo ID e dizer onde ajustar.
argument-hint: "[nome do cliente]"
---

# /ajustar-bot — análise rápida de conversas por ID

Cliente desta sessão: **$ARGUMENTS** (se vazio, pergunte "Para qual cliente?" antes de tudo).

Todas as regras do `CLAUDE.md` e do `INSTRUCOES-DO-PROJETO.md` continuam valendo — em especial: **banco somente leitura**, nunca inventar dados, nada de frases prontas em campos de tom/estratégia.

## Ao iniciar

1. Ache o cliente em `clientes` (busque com `ilike`, o nome pode estar sem acento). Confirme: ativo, inbox(es), nome do bot, empresa, tom, postura.
2. Responda curto: "Pronto, pode mandar o primeiro ID." Lembre em uma linha que as mudanças são feitas **pelo painel**, não direto no banco.

## A cada ID de conversa recebido

1. **Leia a conversa:** `mensagens_chatwoot` filtrando `chatwoot_conversation_id = <ID>` e `cliente_id`, ordenado por `message_created_at` (inclua `sender_type` e `private` para separar aluno, bot e equipe).
2. **Leia o cadastro atual** dos campos relacionados ao problema (`clientes.briefing`). Nomes internos dos campos: `conhecimento/02-mapa-do-frontend.md`.
3. **Ache a causa:** a regra não existe? Existe mas está escondida/fraca? Falta informação (FAQ/Catálogo/Procedimento)? Há **conflito** com algo já cadastrado? Avise conflitos explicitamente.
4. Se for **estrutural** (ver `conhecimento/04-referencia-tecnica.md`), diga isso e entregue o resumo do chamado em vez de blocos.
5. **Atualize a página** (abaixo) e responda no chat de forma bem curta: causa em 1–2 linhas + lista dos blocos + link.

## A página (artifact)

- Base obrigatória: `.claude/skills/ajustar-bot/modelo-pagina.html` — copie para o scratchpad, **mantenha o `<style>` e o `<script>` sem mudanças** e troque só o conteúdo entre `<header>` e `<footer>`.
- **Uma página por cliente na sessão.** Cada novo ID vira uma nova seção (`<h2>Conversa ID: problema</h2>` + caixa `.case`) **acrescentada** na mesma página, republicada no mesmo arquivo (mesmo link).
- Caixa `.case`: trecho da conversa com as falas problemáticas em `.bad` + `.note` com "Por que aconteceu".
- **Um `<article class="card" data-conversa="ID">` por campo do painel**, numerado em sequência na página toda. Cada card tem:
  - Caminho: `Seção → Campo` (nome que aparece na tela).
  - Etiqueta: `pill add` "Adicionar item" · `pill rep` "Substituir" · `pill opt` "Conferir".
  - `Ctrl+F` com a palavra-chave exata dentro de `<dd><kbd>…</kbd></dd>` — o script adiciona sozinho o botão "Copiar busca". Sempre que for substituir algo, dê o Ctrl+F.
  - Linha "Campo/Onde" dizendo exatamente o que apagar e onde colar (ex.: só a Nuance adicional; o item inteiro; a última frase).
  - Um `.copy` com `<pre id="único">` e botão `data-copy` **por subcampo** (ex.: FAQ = Pergunta e Resposta separadas). IDs únicos na página toda (ex.: `c34613-1`).
- Comportamento já embutido no script (não reescrever): quadrado "Pendente/Copiado" em cada bloco, borda vermelha enquanto pendente, **bloco inteiro verde-escuro ao clicar em Copiar** (com 2+ textos, só depois de copiar todos), desmarcar volta ao vermelho, e marcação salva no navegador.
- Campo de escolha (select): não há texto para colar — o card diz qual opção marcar e lista as opções válidas.
- Dado que não está no banco: deixe `<span class="ph">`/`[colchetes]` e avise na linha "Antes".
- Rodapé: fonte (banco, somente leitura) + IDs das conversas + data.
- Publicar com a ferramenta Artifact (título "Ajustes Bot <Cliente>", ícone `checklist`).
