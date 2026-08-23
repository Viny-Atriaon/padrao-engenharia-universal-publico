# Padrão de Engenharia Universal

Base normativa para construção de qualquer sistema, app, SaaS ou site — por humanos ou agentes de IA (Claude Code, Codex, Antigravity, Cursor, Gemini...) — com qualidade profissional, segurança em camadas e memória de projeto à prova de perda de contexto.

> 📕 **Comece pelo [GUIA-DE-USO.pdf](GUIA-DE-USO.pdf)** — explica todo o fluxo em 7 seções.

## Os 4 artefatos (v3.2)

| Arquivo | Papel |
|---|---|
| [CONSTITUICAO-ENGENHARIA-UNIVERSAL.md](CONSTITUICAO-ENGENHARIA-UNIVERSAL.md) | **A norma.** ~145 regras com ID estável, marcadas `[M]`/`[J]`, parametrizáveis por porte, stack, time e jurisdição. |
| [HANDBOOK-ENGENHARIA-UNIVERSAL.md](HANDBOOK-ENGENHARIA-UNIVERSAL.md) | **O porquê.** 23 capítulos explicativos — consulta humana; nunca colar inteiro em sessão de IA. |
| [KIT-DE-PARTIDA-UNIVERSAL.md](KIT-DE-PARTIDA-UNIVERSAL.md) | **O executável.** Templates de `AGENTS.md`, `ESTADO.md`, `FASES.md`, ADR e CORRECOES + prompts de partida, retomada e instanciação. |
| [audit.sh](audit.sh) | **O fiscal.** Auditoria automática das regras `[M]` em qualquer projeto: `bash audit.sh /caminho/do/projeto` |

## Uso em 4 passos

1. Clone ou baixe este repositório (`git clone` ou Code → Download ZIP).
2. Cole o **prompt de partida** (Kit §7) na sessão do seu agente de IA, com o porte do projeto (`site-estático` → `SaaS`).
3. O agente cria os arquivos de memória **antes de qualquer código** e constrói por fases verticais, na ordem dados → segurança → domínio → API → front.
4. Rode o `audit.sh` a cada marco para medir a conformidade.

## Princípios-chave

- **A memória do projeto mora no repositório, nunca no chat** (§CTX).
- **Ordem de construção** com segurança transversal desde o primeiro commit (§ORD).
- **Escalável-pronto por design, escalado por evidência** (SCALE-READY-01).
- **Documentação nasce com a feature**, nunca no final (DOC-VIVA-01).
- **Verificação exige evidência** — "funciona" sem a saída colada não conta (IA-EVIDENCE-01).
- **Quarentena de dependências** — release com menos de ~14 dias não entra (DEP-QUARENTENA-01).
- **Pontos de restauração** — todo checkpoint entra num ledger append-only; o git guarda o conteúdo, o ledger guarda o significado; desfazer é sempre via git, nunca de memória (CTX-RESTORE-01/02/03).

## Licença e contribuição

**[CC BY-ND 4.0](LICENSE)** — uso livre (inclusive comercial) com atribuição; instanciar/adaptar para uso interno é permitido; **não** é permitido redistribuir versões modificadas como se fossem o original. Este repositório é somente leitura para o público — sugestões e correções via Issues; mudanças aceitas entram na próxima versão oficial com tag nova (atual: `v3.2`).
