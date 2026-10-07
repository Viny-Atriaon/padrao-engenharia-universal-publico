# Padrão de Engenharia Universal

Base normativa para construção de qualquer sistema, app, SaaS ou site — por humanos ou agentes de IA (Claude Code, Codex, Antigravity, Cursor, Gemini...) — com qualidade profissional, segurança em camadas e memória de projeto à prova de perda de contexto.

> 📕 **Comece pelo [GUIA-DE-USO.pdf](GUIA-DE-USO.pdf)** — explica todo o fluxo em 7 seções.

## Os 4 artefatos (v3.3)

| Arquivo | Papel |
|---|---|
| [CONSTITUICAO-ENGENHARIA-UNIVERSAL.md](CONSTITUICAO-ENGENHARIA-UNIVERSAL.md) | **A norma (v3.3).** ~155 regras com ID estável, marcadas `[M]`/`[J]`, parametrizáveis por porte, stack, time e jurisdição. |
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
- **Regra escrita não é regra cumprida** — toda regra `[M]` roda por máquina em 4 pontos: pre-push, CI que bloqueia, verificação diária do ambiente em execução e evidência do agente antes de "pronto" (GOV-ENFORCE-01).

## Novidades da v3.3

Origem: auditoria de um SaaS multi-tenant em produção que tinha as regras de segurança **escritas** e violava várias sem perceber — porque as marcadas "verificação manual" nunca eram verificadas. Entram 30 regras, entre elas:

- **Execução obrigatória:** GOV-ENFORCE-01 (4 pontos de aplicação), TEST-RUNTIME-01 (auditar o sistema rodando, não só o código), TEST-LOAD-01 (carga com perfil de uso humano), TEST-ABUSE-01 (regressão das defesas de abuso), SCALE-CAP-01 (hardware e teto medido registrados).
- **Segurança:** RATE-LIMIT-02/03 (limites em camadas e IP real comprovado), AUTH-PACE-01 (espera progressiva no login), SEC-WEBHOOK-IN-01, SEC-HEADERS-02, SEC-SANITIZE-01, NET-BIND-01 (só loopback), BKP-VERIFY-01 (backup cifrado verificado todo dia), SAAS-IMPERSONATE-02.
- **Desempenho e operação:** PERF-HOTPATH-01, DB-POOL-01, DB-CURSOR-01, DB-INDEX-02, QUEUE-ONE-01, QUEUE-HYGIENE-01, OBS-WORKER-02, OBS-HEALTH-02, OBS-LOG-02, RES-CACHE-01, PIPE-PARITY-01.
- **Agentes de IA:** IA-ENCODING-01, IA-HOSTSEC-01.

Handbook e Kit de Partida seguem na v3.2 (sem mudança de conteúdo nesta versão).

> **Exceção registrada (GOV-AUDIT-01):** as checagens automáticas das regras `[M]` novas ainda não estão no `audit.sh` (que continua auditando as regras da v3.2) nem no `audit-runtime.sh` previsto em TEST-RUNTIME-01. Prazo: **2026-11-06** — até lá, essas regras são verificadas manualmente no checkpoint.

## Licença e contribuição

**[CC BY-ND 4.0](LICENSE)** — uso livre (inclusive comercial) com atribuição; instanciar/adaptar para uso interno é permitido; **não** é permitido redistribuir versões modificadas como se fossem o original. Este repositório é somente leitura para o público — sugestões e correções via Issues; mudanças aceitas entram na próxima versão oficial com tag nova (atual: `v3.3`).
