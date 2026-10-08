# KIT DE PARTIDA — UNIVERSAL
**Versão 3.4 · Companheiro executável da Constituição de Engenharia (§CTX e §ORD) · Padrão executável > padrão escrito**

Este arquivo transforma o Protocolo de Contexto (regras `CTX-*` da Constituição) em **arquivos prontos para copiar**. Ele existe porque o maior risco de construir com IA não é código ruim — é **amnésia de contexto**: a janela estoura, a sessão seguinte não sabe o que foi decidido, e o agente refaz, desfaz ou contradiz o trabalho anterior. A cura é estrutural: **antes da primeira linha de código, cria-se a memória do projeto no repositório.** O chat é descartável; o repo é permanente.

Regra de ouro (CTX-KIT-01): **nenhum código antes do kit completo** — nem para "um site rapidinho". O porte dosa o rigor das camadas técnicas; a memória é inegociável em qualquer porte.

---

## 1. CHECKLIST PRÉ-CONSTRUÇÃO POR PORTE

Execute na ordem. Só depois do último ✅ a primeira feature pode começar.

### `{{PORTE}}` = site-estático (kit mínimo — 10 minutos)
1. [ ] `git init` + primeiro commit
2. [ ] `AGENTS.md` (template §2 — versão curta)
3. [ ] `ESTADO.md` (template §3)
4. [ ] `README.md` (o que é + como rodar/publicar)
5. [ ] `docs/FASES.md` com as fases planejadas (template §4)
6. [ ] `docs/PONTOS-DE-RESTAURACAO.md` com cabeçalho (template §6B) — todo checkpoint vira ponto de restauração

### `{{PORTE}}` = app-simples (kit padrão — 30 minutos)
Tudo do site-estático, mais:
7. [ ] `docs/adr/` criado + ADR-001 registrando stack escolhida (template §5)
8. [ ] `docs/CORRECOES.md` vazio com cabeçalho (template §6)
9. [ ] `.env.example` completo + `.env` no `.gitignore` desde o commit 1
10. [ ] Estrutura de diretórios do Nível 0 (`modules/` + `shared/` ou equivalente do framework)

### `{{PORTE}}` = sistema (kit completo — ~2 horas, economiza semanas)
Tudo do app-simples, mais:
11. [ ] Validação de schema instalada e exemplificada em 1 rota
12. [ ] Logger estruturado JSON com `requestId` configurado
13. [ ] Error tracking conectado (categoria em `{{CATEGORIA_FORNECEDOR}}`)
14. [ ] Migrations versionadas inicializadas
15. [ ] Script de deploy nas fases universais (aborta em erro + lock)
16. [ ] Headers de segurança + auth com cookie HttpOnly (SE há login)
17. [ ] Backup automatizado (comprimido + criptografado) + dead man's switch (SE há dados de usuário)
18. [ ] Doc técnica inicializada: `docs/API.md` ou OpenAPI (DOC-API-01) — cresce a cada fase, nunca "no final"
19. [ ] Triagem de dependências ativa: `ignore-scripts` por padrão + regra de quarentena de release (DEP-QUARENTENA-01)

### `{{PORTE}}` = SaaS (kit sistema + camada SaaS)
Tudo do sistema, mais:
20. [ ] Perguntas de produto respondidas pelo `{{OWNER}}` e registradas em ADR (SAAS-ADR-01) — planos? trial? multi-tenant? cobrança? offboarding?
21. [ ] SE multi-tenant: `tenant_id` no schema desde o dia 0 + scoping executável (SAAS-TENANT-02)
22. [ ] Gateway de pagamento como fonte da verdade + webhook idempotente (esqueleto)
23. [ ] SE emite chaves de API / envia webhooks: esqueleto conforme API-KEY-01 / WEBHOOK-OUT-01 (hash da chave, prefixo, assinatura de saída)
24. [ ] Teste de posse com 2 contas no plano de testes

---

## 2. TEMPLATE — `AGENTS.md` (regras do projeto para qualquer agente)

> `AGENTS.md` é o arquivo CANÔNICO (padrão aberto — lido por Codex, Antigravity/Gemini, Cursor e outros). Para ferramentas com nome próprio, crie apontadores de **1 linha** — nunca cópias (CTX-FONTE-01):
> - `CLAUDE.md` contendo apenas: `@AGENTS.md` (Claude Code importa via `@`)
> - `GEMINI.md` contendo apenas: `Siga as instruções de AGENTS.md.`

```markdown
# AGENTS.md — {{NOME_DO_PROJETO}}

> Padrão seguido: Constituição de Engenharia Universal **v2.0** · Porte: {{PORTE}} · Auditado em: {{DATA}}
> Pendências de auditoria: (nenhuma | listar IDs de regra + waiver/ADR)

## Ritual obrigatório de início de sessão (CTX-RITUAL-01)
1. Leia este arquivo inteiro.
2. Leia `ESTADO.md` — ele diz onde o trabalho parou e o que vem agora.
3. Leia os ADRs em `docs/adr/` marcados como recentes no ESTADO.md.
4. SE for tocar área já corrigida: leia a entrada correspondente em `docs/CORRECOES.md`.
NUNCA comece a codar sem os passos 1-2. NUNCA pergunte "onde paramos?" — o ESTADO.md responde.

## O projeto
- **O que é:** (1-2 frases)
- **Stack:** (linguagem, framework, banco, deploy — instâncias da {{STACK}})
- **Comandos:** rodar local: `...` · testes: `...` · build: `...` · deploy: `...`

## Regras específicas deste projeto
- (o que NÃO tocar e por quê — referencie ADRs)
- (gotchas conhecidos)
- Idiomas: domínio={{IDIOMA_DOMINIO}} · código={{IDIOMA_CODIGO}} · commits={{IDIOMA_COMMITS}}

## Ritual obrigatório de fim de sessão
1. Atualize `ESTADO.md` (fase, checkpoint, decisões, próximos 3 passos, bloqueios).
2. Commit + push (commits atômicos em {{IDIOMA_COMMITS}}).
3. Decisão tomada no chat → grave no arquivo-fonte (ADR/ESTADO) ANTES de encerrar (CTX-RESUMO-01).
```

---

## 3. TEMPLATE — `ESTADO.md` (a memória viva — teto ~150 linhas)

```markdown
# ESTADO — {{NOME_DO_PROJETO}}
> Atualizado em: {{DATA}} · Fase atual: F{{N}} — {{nome da fase}}
> Teste de validade: uma sessão nova retoma o trabalho lendo SÓ AGENTS.md + este arquivo.

## Último checkpoint
- Commit: `{{hash curto}}` — {{o que fechou}}
- Estado do sistema: (compila? testes verdes? deployado?)

## Decisões desta/última sessão (mover para ADR se forem estruturais)
- {{decisão}} — motivo: {{...}}

## Próximos 3 passos (concretos, executáveis)
1. {{passo}}
2. {{passo}}
3. {{passo}}

## Bloqueios / pendências
- {{o que falta e de quem depende}} (ex: "aguardando {{OWNER}} decidir X")

## Capacidade e hardware (SCALE-CAP-01 — preencher antes do 1º cliente pagante)
- Hardware de produção: {{CPU e núcleos FÍSICOS · RAM · tipo de disco}}
- Último teto medido: {{req/s sustentado (p95 X ms, erro Y%) · req/s de pico · data · versão}} — teste: `{{caminho do script de carga}}`

## Serviços externos (DEP-SERVICE-01)
- {{serviço}} — conta dona: {{e-mail/org}} · plano: {{tier}} · limite que morde: {{ex: pausa após N dias inativo}} · monitor: {{sim/não}}

## Fases concluídas (1 linha cada — detalhe em docs/HISTORICO.md)
- F1 — {{nome}} — commit `{{hash}}` — {{data}}
```

---

## 4. TEMPLATE — `docs/FASES.md` (o plano em blocos que cabem numa sessão)

```markdown
# FASES — {{NOME_DO_PROJETO}}
> Regra (CTX-FASE-01): cada fase cabe em UMA sessão de agente e fecha com checkpoint
> (commit + ESTADO.md). Fase que não fechou estava grande — dividir aqui e registrar.

| Fase | Entrega verificável | Critério de pronto | Status |
|---|---|---|---|
| F1 | Kit de Partida + scaffolding | checklist §1 completo, commit inicial | ⬜ |
| F2 | Modelo de dados do núcleo + migrations (§ORD passo 1) | schema versionado; migration roda em banco limpo | ⬜ |
| F3 | Fundação de segurança: auth + validação + posse na 1ª rota (§ORD passo 2) | login funciona; teste de posse com 2 contas passa | ⬜ |
| F4 | 1ª fatia vertical do fluxo principal: dados→serviço→API→tela | {{fluxo demonstrável fim-a-fim}} | ⬜ |
| F5+ | {{demais fatias verticais, uma por sessão}} | {{como verificar}} | ⬜ |

Princípios de fatiamento (§ORD da Constituição):
- Ordem das camadas DENTRO de cada fatia: dados → segurança → serviço → contrato de API → tela.
  Front antes do contrato é proibido; "segurança depois" é proibido (nasce junto, transversal).
- Fatias VERTICAIS (fluxo completo fino) > camadas horizontais (todo o backend, depois todo o front).
- Escalável-pronto desde a F2 (SCALE-READY-01): stateless, paginação, índices, jobs idempotentes —
  escalar tem que significar "adicionar instância", nunca "reescrever".
- Toda fase termina com algo demonstrável ou testável — nunca "50% de X".
- Descoberta no meio da fase que muda o plano → registrar aqui + ESTADO.md antes de continuar.
```

---

## 5. TEMPLATE — `docs/adr/NNN-titulo.md` (decisão estrutural, ≤1 página)

```markdown
# ADR-{{NNN}}: {{título da decisão}}
> Data: {{DATA}} · Status: aceito | substituído por ADR-{{X}} · Decisor: {{DECISOR_TECNICO}}

## Contexto
{{o problema/escolha em 2-4 frases}}

## Decisão
{{o que foi decidido, afirmativo}}

## Alternativas rejeitadas (metade do valor está aqui)
- {{alternativa}} — rejeitada porque {{...}}

## Consequências
- {{o que fica mais fácil}} / {{o que fica mais difícil e foi aceito conscientemente}}
```

---

## 6. TEMPLATE — `docs/CORRECOES.md` (memória anti-"consertar de volta")

```markdown
# CORREÇÕES — {{NOME_DO_PROJETO}}
> Registro de bugs não-triviais (glossário da Constituição). O código corrigido REFERENCIA
> a entrada (`// ver docs/CORRECOES.md#NN`). Sessão futura que achar o código "estranho"
> lê aqui ANTES de "melhorar" — o estranho pode ser a correção.

## #01 — {{DATA}} — {{título do bug}}
- **Sintoma:** {{o que se via}}
- **Causa raiz:** {{o porquê real}}
- **Solução e por quê ESTA:** {{...}}
- **Alternativas rejeitadas:** {{...}} — porque {{...}}
- **Teste de regressão:** {{arquivo/nome do teste}}
```

---

## 6B. TEMPLATE — `docs/PONTOS-DE-RESTAURACAO.md` (a linha do tempo restaurável)

> Ledger **append-only** (CTX-RESTORE-01/02/03). Divisão de papéis: o **git guarda o CONTEÚDO**
> de cada ponto (restauração byte a byte, sem perda); **este arquivo guarda o SIGNIFICADO**
> (o que cada ponto é, o que entrou, mudou e saiu). Custo de tokens ~zero: a entrada nasce
> no momento do checkpoint (informação já em contexto), nunca se relê o arquivo inteiro,
> entrada antiga nunca é reescrita, e código/diff NUNCA é colado aqui (referencie o hash).

```markdown
# PONTOS DE RESTAURAÇÃO — {{NOME_DO_PROJETO}}
> Append-only. Entrada antiga é IMUTÁVEL. Sem código/diff aqui — o commit guarda o conteúdo.
> Visão MACRO: leia só os títulos `## PR-NNN` (a linha do tempo do projeto).
> Visão MICRO: leia o corpo da entrada desejada.
>
> COMO RESTAURAR (sempre via git, com o hash da entrada — nunca de memória):
> - Inspecionar um ponto:            git switch -c inspecao-prNNN <hash>
> - Voltar arquivos específicos:     git restore --source <hash> -- <caminhos>
> - Reverter um ponto ruim:          git revert <hash>
> - Voltar o projeto INTEIRO ao ponto: criar branch de resgate a partir do <hash>
>   (reset --hard só com autorização explícita do {{OWNER}} — IA-DESTRUCT-01)

## PR-001 — {{DATA}} — {{funcionalidade + ação, ex: "Construtor de forms: validação por campo"}}
- **Commit:** `{{hash}}` · **Fase:** F{{N}} · **Tipo:** adicionado | modificado | corrigido | removido
- **Funcionalidades tocadas:** {{lista curta, ex: construtor-form, dashboard}}
- **Adicionado:** {{item a item; "—" se nada}}
- **Modificado:** {{item a item, com o comportamento anterior → novo; "—" se nada}}
- **Removido:** {{item a item + POR QUÊ; "—" se nada}}
- **Estado verificado neste ponto:** {{build/testes/smoke — evidência no commit (IA-EVIDENCE-01)}}
```

---

## 7. PROMPT DE PARTIDA (colável — inicia qualquer projeto no padrão)

Cole numa sessão nova de agente para começar um projeto do zero:

```text
Vamos iniciar o projeto {{NOME}} ({{PORTE}}: site-estático|app-simples|sistema|SaaS).
Siga a Constituição de Engenharia Universal v2.0 (colada abaixo / no repositório).

ANTES de qualquer código (CTX-KIT-01):
1. Execute o checklist pré-construção do meu porte (Kit de Partida §1).
2. Crie AGENTS.md, ESTADO.md e docs/FASES.md a partir dos templates do Kit,
   preenchidos para este projeto — me pergunte o que não souber ({{OWNER}} decide).
3. Proponha o fatiamento em fases verticais em docs/FASES.md e aguarde meu ok.
4. Só então comece a F1, fechando com checkpoint (commit + ESTADO.md).

Regras de sessão: ritual de início e fim SEMPRE (CTX-RITUAL-01); contexto ficando
longo → checkpoint imediato (CTX-CHECKPOINT-01); decisão de chat vira arquivo
antes do fim da sessão (CTX-RESUMO-01); todo checkpoint vira ponto de restauração
em docs/PONTOS-DE-RESTAURACAO.md (CTX-RESTORE-01); ANTES de qualquer operação de
risco, savepoint (commit) primeiro (CTX-RESTORE-02) — desfazer é git, não memória.
```

E para **retomar** um projeto existente:

```text
Retome o projeto {{NOME}}. Ritual de início (CTX-RITUAL-01): leia AGENTS.md,
depois ESTADO.md, depois os ADRs que ele referenciar. Em seguida me diga em 3
linhas: onde paramos, o que vem agora, e se há bloqueio. Então execute o próximo
passo do ESTADO.md. Não me pergunte "onde paramos" — o ESTADO.md responde.
```

---

## 8. POR QUE ISTO RESOLVE A AMNÉSIA (o mecanismo, em 8 linhas)

1. **Janela estourou no meio?** O último checkpoint (CTX-CHECKPOINT-01) garante que nada além de minutos se perde — commit + ESTADO.md são o savegame.
2. **Sessão nova não sabe nada?** O ritual de início (CTX-RITUAL-01) reidrata o essencial em ~2 arquivos curtos, não em 200k tokens de histórico.
3. **Decisão sumiu na compactação?** Ela nunca morava no chat — CTX-RESUMO-01 obrigou a gravá-la em ADR/ESTADO no momento em que foi tomada.
4. **Agente quer refazer o que já existe?** CORRECOES.md + ADRs explicam por que o código é como é — o "estranho" documentado não é consertado de volta.
5. **Tarefa grande demais para uma janela?** CTX-FASE-01 proíbe: o plano em FASES.md já nasceu fatiado em blocos de uma sessão.
6. **Dois documentos dizendo coisas diferentes?** CTX-FONTE-01: cada fato tem um único arquivo-dono; o resto referencia.
7. **IA errou e apagou o que estava certo?** CTX-RESTORE-02: havia savepoint (commit) ANTES da operação de risco — desfazer é `git restore --source <hash>`, não a IA re-digitando de memória. A memória do que ela fez não importa; o git lembra por ela.
8. **"O que tem em cada ponto? O que já foi feito?"** CTX-RESTORE-01/03: o ledger PONTOS-DE-RESTAURACAO.md responde nas duas alturas — títulos `PR-NNN` = visão macro (linha do tempo por funcionalidade); corpo da entrada = visão micro (o que entrou, mudou e saiu, item a item) — sem custo extra, porque cada entrada nasceu junto com o checkpoint.

## 9. PROMPT DE INSTANCIAÇÃO (gera a Constituição do SEU projeto)

A Constituição completa tem ~135 regras — mas um site estático ativa ~1/3 delas, e **regra irrelevante no contexto dilui a obediência às relevantes**. O modo de uso preferido (v3.0) é gerar a versão instanciada uma única vez por projeto e colar ELA nas sessões:

```text
Leia a CONSTITUICAO-ENGENHARIA-UNIVERSAL.md (v3.0) e gere a "Constituição
Instanciada" deste projeto em docs/CONSTITUICAO-INSTANCIADA.md, assim:

Parâmetros: {{PORTE}}={{...}} · {{TAMANHO_TIME}}={{...}} · {{TIPO_APP}}={{...}} ·
{{MULTI_TENANT}}={{...}} · {{MODELO_DEPLOY}}={{...}} · {{EXPOE_LLM}}={{...}} ·
{{STACK}}={{...}} · demais parâmetros: {{...}}

Regras de geração:
1. Inclua SOMENTE as regras ativadas pelos meus parâmetros e perfis (tabelas §Perfis);
   regra condicional cuja condição é falsa fica FORA (liste só os IDs excluídos no rodapé).
2. Mantenha os IDs originais intactos (rastreabilidade com o doc-fonte).
3. Mantenha na íntegra: §CTX, §ORD, Desenvolvimento Assistido por IA, Definição de
   Pronto e Ordem de Precedência — esses nunca são cortados.
4. Substitua os placeholders {{...}} pelos meus valores reais.
5. Cabeçalho: "Instanciada da Constituição Universal v3.0 em {{DATA}} — regenerar
   se os parâmetros mudarem".
```

---

## 10. APLICAÇÃO POR MÁQUINA — os 4 pontos da GOV-ENFORCE-01 (instalar no 1º marco)

Regra escrita que ninguém roda não existe. Copie `audit.sh` e `audit-runtime.sh` deste repositório para `scripts/` do projeto (cópia versionada: o CI não enxerga este repositório) e instale os quatro pontos. Atualizar o padrão = copiar os dois scripts de novo.

**Ponto 1 — `.githooks/pre-push`** (versionado; ative em cada clone com `git config core.hooksPath .githooks`):

```bash
#!/usr/bin/env bash
set -u
cd "$(git rev-parse --show-toplevel)" || exit 1
echo "── pre-push: auditoria do código"
bash scripts/audit.sh . > /tmp/pre-push-audit.txt 2>&1 || {
  grep -E '^❌' /tmp/pre-push-audit.txt
  echo "push bloqueado: corrija, ou registre waiver com prazo em .audit-waivers"; exit 1; }
echo "── pre-push: testes"
[ -d node_modules ] || { echo "push bloqueado: dependências não instaladas (os testes não puderam rodar)"; exit 1; }
{{COMANDO_DE_TESTE}} > /tmp/pre-push-tests.txt 2>&1 || { tail -25 /tmp/pre-push-tests.txt; echo "push bloqueado: testes falhando"; exit 1; }
```

**Ponto 2 — job de CI que bloqueia** (GitHub Actions; equivalente em outro CI):

```yaml
  constituicao:
    name: Constituição — auditoria do código e testes (bloqueia)
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Auditoria do código
        run: bash scripts/audit.sh .
      # + instalar dependências e rodar {{COMANDO_DE_TESTE}}
```

**Ponto 3 — `scripts/audit-runtime.conf` + agendador diário** (cron/Scheduled Task rodando `bash scripts/audit-runtime.sh scripts/audit-runtime.conf`; semanal com `--abuse`). Variável vazia = checagem pulada, nunca aprovada:

```bash
RT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RT_PROJECT="{{NOME_DO_PROJETO}}"
RT_BASE_URL="http://127.0.0.1:{{PORTA_DO_PROXY}}"     # sempre local, nunca o domínio público
RT_API_PROBE="/api/v1/me"                             # rota da API que responde sem login (401)
RT_EMBED_PATH=""                                      # rota que PODE ser embutida em iframe, se houver
RT_HEALTH_PUBLIC="http://127.0.0.1:{{PORTA_DO_PROXY}}/health"
RT_HEALTH_READY="http://127.0.0.1:{{PORTA_DA_API}}/health/ready"
RT_DIST_DIR="$RT_ROOT/{{PASTA_DO_BUILD_PUBLICADO}}"
RT_LOOPBACK_ONLY_PORTS="{{API}} {{BANCO}} {{CACHE}} {{PROXY}}"
RT_BACKUP_DIR="{{PASTA_DOS_BACKUPS}}"; RT_BACKUP_GLOB="{{prefixo}}-*"; RT_BACKUP_MAX_AGE_H=26
RT_ACCESS_LOG="{{LOG_COM_IP_POR_REQUISICAO}}"
RT_WORKER_HEARTBEAT_FILE="{{ARQUIVO_QUE_O_WORKER_TOCA}}"; RT_WORKER_MAX_SILENCE_MIN=30
RT_ABUSE_CMD="{{COMANDO_DA_REGRESSAO_DE_ABUSO}}"      # TEST-ABUSE-01 (só com --abuse)
RT_ALERT_PUSH_URL=""                                  # monitor do tipo push (acusa também quando NÃO roda)
RT_WAIVERS=""                                         # "REGRA:alvo:AAAA-MM-DD ..." (GOV-ADOPT-01)
```

**Ponto 4 — no `AGENTS.md`, seção obrigatória:**

```markdown
## Regras aplicadas por máquina (GOV-ENFORCE-01)
Antes de declarar qualquer entrega pronta, rode e COLE a saída de `bash scripts/audit.sh .`.
SE tocou infra, autenticação, limites, desempenho ou backup: também
`bash scripts/audit-runtime.sh scripts/audit-runtime.conf`. SE tocou desempenho ou limites:
também os testes de carga e de abuso, com o resultado registrado no ESTADO.md (SCALE-CAP-01).
Exceção só por waiver com data (`.audit-waivers` ou `RT_WAIVERS`); vencido, reprova sozinho.
```

**Prove que os pontos disparam** (SEC-CONTROL-LIVE-01): uma vez, empurre para um repositório local descartável um commit com violação proposital (ex.: arquivo com `Ã£`) e confirme o bloqueio pelo motivo certo; rode o `audit-runtime.sh` com um `.conf` sabotado (porta exposta, backup em claro) e confirme o ❌.

---

*Fim do Kit de Partida v3.4 — companheiro da Constituição (§CTX/§ORD) e do Handbook (capítulos 21-25). v3.2: template §6B (PONTOS-DE-RESTAURACAO.md) e savepoint pré-risco no prompt de partida. v3.4: `ESTADO.md` ganha "Capacidade e hardware" (SCALE-CAP-01) e "Serviços externos" (DEP-SERVICE-01) — o número que o sistema aguenta e quem é dono de cada dependência passam a morar na memória viva. v3.5.1: §10 — templates dos 4 pontos de aplicação por máquina (pre-push, CI, `audit-runtime.conf` + agendador, seção do `AGENTS.md`) e o roteiro para provar que cada ponto dispara.*
