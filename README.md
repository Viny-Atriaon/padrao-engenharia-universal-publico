# Padrão de Engenharia Universal

Base normativa para construção de qualquer sistema, app, SaaS ou site — por humanos ou agentes de IA (Claude Code, Codex, Antigravity, Cursor, Gemini...) — com qualidade profissional, segurança em camadas e memória de projeto à prova de perda de contexto.

> 📕 **Comece pelo [GUIA-DE-USO.pdf](GUIA-DE-USO.pdf)** — explica todo o fluxo em 7 seções.

## Os artefatos (v3.5.3)

| Arquivo | Papel |
|---|---|
| [CONSTITUICAO-ENGENHARIA-UNIVERSAL.md](CONSTITUICAO-ENGENHARIA-UNIVERSAL.md) | **A norma (v3.5).** ~165 regras com ID estável, marcadas `[M]`/`[J]`, parametrizáveis por porte, stack, time e jurisdição. |
| [HANDBOOK-ENGENHARIA-UNIVERSAL.md](HANDBOOK-ENGENHARIA-UNIVERSAL.md) | **O porquê.** 26 capítulos explicativos — consulta humana; nunca colar inteiro em sessão de IA. |
| [CHANGELOG.md](CHANGELOG.md) | **A evolução.** O que mudou e por que em cada versão, da v2.0 até hoje, mais o quadro **Em preparação** (candidatas e o que destrava cada uma); nenhuma versão é apagada — cada uma fica numa tag (`git show v3.3:ARQUIVO`). |
| [KIT-DE-PARTIDA-UNIVERSAL.md](KIT-DE-PARTIDA-UNIVERSAL.md) | **O executável.** Fase 0 (vale construir?), templates de `AGENTS.md`, `ESTADO.md`, `FASES.md`, ADR, CORRECOES e glossário + prompts de partida, retomada e instanciação, método de entrevista e revisão em duas frentes. |
| [audit.sh](audit.sh) | **O fiscal do código.** Auditoria automática das regras `[M]` verificáveis no repositório: `bash audit.sh /caminho/do/projeto`. Roda no pre-push e no CI. |
| [audit-runtime.sh](audit-runtime.sh) | **O fiscal do sistema rodando** (TEST-RUNTIME-01): headers reais, `/health`, portas em escuta, backup cifrado e recente, IP real no log, worker vivo; `--abuse` inclui a regressão das defesas. Roda diariamente por agendador. Configuração por projeto (Kit §10). |

## Uso em 4 passos

1. Clone ou baixe este repositório (`git clone` ou Code → Download ZIP).
2. Cole o **prompt de partida** (Kit §7) na sessão do seu agente de IA, com o porte do projeto (`site-estático` → `SaaS`).
3. O agente cria os arquivos de memória **antes de qualquer código** e constrói por fases verticais, na ordem dados → segurança → domínio → API → front.
4. No primeiro marco, instale os 4 pontos de aplicação por máquina (Kit §10): `audit.sh` no pre-push e no CI, `audit-runtime.sh` no agendador diário, e o ritual de evidência no `AGENTS.md`.

## Princípios-chave

- **A memória do projeto mora no repositório, nunca no chat** (§CTX).
- **Ordem de construção** com segurança transversal desde o primeiro commit (§ORD).
- **Escalável-pronto por design, escalado por evidência** (SCALE-READY-01).
- **Documentação nasce com a feature**, nunca no final (DOC-VIVA-01).
- **Verificação exige evidência** — "funciona" sem a saída colada não conta (IA-EVIDENCE-01).
- **Quarentena de dependências** — release com menos de ~14 dias não entra (DEP-QUARENTENA-01).
- **Pontos de restauração** — todo checkpoint entra num ledger append-only; o git guarda o conteúdo, o ledger guarda o significado; desfazer é sempre via git, nunca de memória (CTX-RESTORE-01/02/03).
- **Regra escrita não é regra cumprida** — toda regra `[M]` roda por máquina em 4 pontos: pre-push, CI que bloqueia, verificação diária do ambiente em execução e evidência do agente antes de "pronto" (GOV-ENFORCE-01).

## Novidades da v3.5.3

**Varredura de segurança em camadas** (Kit §11): segredos no repositório, dependências, regras estáticas, revisão de segurança do diff, auditoria do código por agentes e ataque ao sistema rodando — cada uma com o seu momento, porque nenhuma ferramenta pega tudo. Inclui o passo a passo para rodar a auditoria por agentes sem riscos e o ciclo do achado ao conserto (teste que falha primeiro, menor conserto, registro em `CORRECOES.md`, a mesma camada de novo). Candidata nova `SEC-AUDIT-01`, já em primeira aplicação.

## Novidades da v3.5.2

Versão de método — nenhuma regra muda. O padrão passa a cobrir o que vem **antes e em volta do código**: a **Fase 0** (conselho de cinco pareceres, ficha da ideia e testes baratos antes de decidir construir), o **método de entrevista** (o agente descobre os fatos sozinho e leva ao dono só as decisões, em rodadas, cada pergunta com a resposta recomendada), a **revisão em duas frentes** para quem trabalha sozinho, o **glossário do domínio**, o **"Fora do escopo"** no plano de fases e uma **retro de uma linha** no fim da sessão. Tudo no Kit e no capítulo 26 do Handbook. Cinco candidatas novas no quadro **Em preparação** do [CHANGELOG.md](CHANGELOG.md) — entre elas `DEP-AGENT-01`: skill, plugin, servidor MCP e hook do agente tratados como dependência.

## Novidades da v3.5

Candidatas promovidas **por evidência, não por intenção**: uma varredura somente leitura em nove sistemas do mesmo ecossistema procurou prova de aplicação das dez lições pendentes. Duas tinham e entraram — `BKP-REMEDIATE-01` (expurgo do legado inseguro só após restore confirmado) e `TEST-CHAOS-01` (falha de dependência externa testada em instância descartável, nunca contra produção). As outras oito seguem no quadro **Em preparação** do [CHANGELOG.md](CHANGELOG.md), com o status encontrado e o que destrava cada uma.

## Novidades da v3.4

Segunda camada da mesma auditoria — o que só apareceu ao reiniciar infraestrutura, medir sob carga e simular ataques contra o próprio sistema. Entram 5 regras (todas já aplicadas em sistema real, como exige `GOV-VERSION-01`): `SEC-CONTROL-LIVE-01` (controle de segurança sem prova de disparo é decoração), `NET-UPSTREAM-01`, `DEP-SERVICE-01` (serviço gerenciado que dorme não é produção), `HARD-CAP-01`, `OPS-RESTART-01` (porta em `Listen` pode aceitar e fechar — só conexão real conta). O **capítulo 25 do Handbook** conta as quinze lições completas e lista as dez candidatas à v3.5. Detalhe em [CHANGELOG.md](CHANGELOG.md).

## Novidades da v3.3

Origem: auditoria de um SaaS multi-tenant em produção que tinha as regras de segurança **escritas** e violava várias sem perceber — porque as marcadas "verificação manual" nunca eram verificadas. Entram 30 regras, entre elas:

- **Execução obrigatória:** GOV-ENFORCE-01 (4 pontos de aplicação), TEST-RUNTIME-01 (auditar o sistema rodando, não só o código), TEST-LOAD-01 (carga com perfil de uso humano), TEST-ABUSE-01 (regressão das defesas de abuso), SCALE-CAP-01 (hardware e teto medido registrados).
- **Segurança:** RATE-LIMIT-02/03 (limites em camadas e IP real comprovado), AUTH-PACE-01 (espera progressiva no login), SEC-WEBHOOK-IN-01, SEC-HEADERS-02, SEC-SANITIZE-01, NET-BIND-01 (só loopback), BKP-VERIFY-01 (backup cifrado verificado todo dia), SAAS-IMPERSONATE-02.
- **Desempenho e operação:** PERF-HOTPATH-01, DB-POOL-01, DB-CURSOR-01, DB-INDEX-02, QUEUE-ONE-01, QUEUE-HYGIENE-01, OBS-WORKER-02, OBS-HEALTH-02, OBS-LOG-02, RES-CACHE-01, PIPE-PARITY-01.
- **Agentes de IA:** IA-ENCODING-01, IA-HOSTSEC-01.

> **Exceção registrada (GOV-AUDIT-01), reduzida na v3.5.1:** 15 das 37 regras `[M]` novas (v3.3–v3.5) já têm checagem automática no `audit.sh` ou no `audit-runtime.sh`. As 22 restantes — a maioria dependente de como cada projeto implementa (pool, cursor, filas, webhooks, cache) — seguem verificadas manualmente no checkpoint até **2026-11-06**. Lista no [CHANGELOG.md](CHANGELOG.md).

## Licença e contribuição

**[CC BY-ND 4.0](LICENSE)** — uso livre (inclusive comercial) com atribuição; instanciar/adaptar para uso interno é permitido; **não** é permitido redistribuir versões modificadas como se fossem o original. Este repositório é somente leitura para o público — sugestões e correções via Issues; mudanças aceitas entram na próxima versão oficial com tag nova (atual: `v3.5.3`).
