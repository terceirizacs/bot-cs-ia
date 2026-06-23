# Projeto Claude — "CS-IA: Onde ajustar o bot"

Esta pasta tem **tudo o que você precisa para criar um Projeto no Claude.ai** que ajuda o time de Customer Success a descobrir **onde mudar o comportamento do bot de atendimento (CS-IA)**.

> Esta pasta é a **fonte** da documentação. O Projeto no Claude.ai é uma **cópia** dela. Sempre que algo mudar no sistema, atualize aqui e suba de novo (ver "Como manter atualizado", no fim).

---

## Para que serve esse Projeto

O time de CS descreve, com palavras do dia a dia, como quer que o bot se comporte — por exemplo:

> "Quero que o bot fale de um jeito mais acolhedor."
> "O bot precisa saber responder quanto custa o plano anual."
> "Quero que ele encaminhe pra gente sempre que o cliente falar em cancelamento."

E o Projeto responde **exatamente onde mudar isso no painel**: qual tela, qual seção, qual campo — e, quando faz sentido, **já entrega o texto pronto pra colar**.

Quando o ajuste não dá pra fazer pelo painel (é uma mudança "estrutural", que precisa de um desenvolvedor), o Projeto avisa e **explica o que o dev vai precisar mexer**, para você abrir um chamado completo.

---

## O que tem nesta pasta

| Arquivo / pasta | O que é |
|---|---|
| `README.md` | Este guia. |
| `INSTRUCOES-DO-PROJETO.md` | O texto que vai no campo **Instruções** do Projeto. Copiar e colar. |
| `conhecimento/` | Os 5 arquivos que vão na seção **Arquivos** do Projeto. |
| `guia-conectar-supabase-readonly.md` | Passo a passo para conectar o banco de dados em modo **somente leitura**. |

Dentro de `conhecimento/`:

| Arquivo | Conteúdo |
|---|---|
| `01-visao-geral-do-sistema.md` | Como o bot funciona, em linguagem simples. |
| `02-mapa-do-frontend.md` | Todas as telas do painel e todos os campos editáveis. |
| `03-o-que-muda-onde.md` | Tabela "quero que o bot... → vá em...". O coração das respostas. |
| `04-referencia-tecnica.md` | Detalhe técnico (para pedidos estruturais e para o chamado ao dev). |
| `05-exemplos-de-pedidos.md` | Exemplos de pedido da equipe e a resposta ideal do Projeto. |

---

## Como criar o Projeto no Claude.ai (passo a passo)

1. Acesse **claude.ai** → menu lateral → **Projects** → botão **New project** (Novo projeto).

2. Dê um nome. Sugestão: **`CS-IA — Onde ajustar o bot`**.
   Descrição sugerida: *"Ajuda o time de CS a descobrir onde mudar o comportamento do bot de atendimento."*

3. Abra o Projeto. No painel lateral você verá três blocos: **Memória**, **Instruções** e **Arquivos** (a mesma tela que você já viu).

4. **Instruções** → clique no `+`. Abra o arquivo `INSTRUCOES-DO-PROJETO.md` desta pasta, copie **todo** o conteúdo e cole ali. Salve.

5. **Arquivos** → clique no `+` e suba os **5 arquivos** da pasta `conhecimento/`:
   - `01-visao-geral-do-sistema.md`
   - `02-mapa-do-frontend.md`
   - `03-o-que-muda-onde.md`
   - `04-referencia-tecnica.md`
   - `05-exemplos-de-pedidos.md`

6. **Conector Supabase** → siga o `guia-conectar-supabase-readonly.md`.
   ⚠️ **Importante:** o conector precisa ser configurado em modo **somente leitura**. O conector padrão da galeria do Claude dá poder de **alterar e apagar dados** do banco. O guia explica como evitar isso.

7. Pronto. Teste mandando um pedido de exemplo no chat do Projeto (veja `conhecimento/05-exemplos-de-pedidos.md`).

---

## Como usar no dia a dia

Qualquer pessoa do time entra no Projeto e descreve o que quer. Não precisa saber nada de técnico. Quanto mais específico o pedido, melhor a resposta:

- ✅ Bom: *"No cliente Andrea Vermont, quero que o bot trate os clientes por 'senhor/senhora'."*
- ⚠️ Vago: *"Muda o jeito do bot."* (o Projeto vai pedir pra detalhar)

---

## Como manter atualizado

O Projeto **só sabe o que está nos arquivos**. Arquivo desatualizado = resposta errada.

Sempre que o **painel** mudar (campo novo, tela nova, label renomeado) ou o **banco** mudar:

1. Atualize o arquivo correspondente **nesta pasta** (`projetos-claude/bot-cs-ia/`).
2. No Projeto do Claude.ai, na seção **Arquivos**, **apague a versão antiga** do arquivo e **suba a versão nova**.
3. Se a mudança for grande, revise também o `INSTRUCOES-DO-PROJETO.md`.

Responsável por manter: time técnico / Tiago.
