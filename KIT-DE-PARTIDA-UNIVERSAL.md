# KIT DE PARTIDA — UNIVERSAL
**Versão 3.1 · Companheiro executável da Constituição de Engenharia (§CTX e §ORD) · Padrão executável > padrão escrito**

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

### `{{PORTE}}` = app-simples (kit padrão — 30 minutos)
Tudo do site-estático, mais:
6. [ ] `docs/adr/` criado + ADR-001 registrando stack escolhida (template §5)
7. [ ] `docs/CORRECOES.md` vazio com cabeçalho (template §6)
8. [ ] `.env.example` completo + `.env` no `.gitignore` desde o commit 1
9. [ ] Estrutura de diretórios do Nível 0 (`modules/` + `shared/` ou equivalente do framework)

### `{{PORTE}}` = sistema (kit completo — ~2 horas, economiza semanas)
Tudo do app-simples, mais:
10. [ ] Validação de schema instalada e exemplificada em 1 rota
11. [ ] Logger estruturado JSON com `requestId` configurado
12. [ ] Error tracking conectado (categoria em `{{CATEGORIA_FORNECEDOR}}`)
13. [ ] Migrations versionadas inicializadas
14. [ ] Script de deploy nas fases universais (aborta em erro + lock)
15. [ ] Headers de segurança + auth com cookie HttpOnly (SE há login)
16. [ ] Backup automatizado (comprimido + criptografado) + dead man's switch (SE há dados de usuário)
17. [ ] Doc técnica inicializada: `docs/API.md` ou OpenAPI (DOC-API-01) — cresce a cada fase, nunca "no final"
18. [ ] Triagem de dependências ativa: `ignore-scripts` por padrão + regra de quarentena de release (DEP-QUARENTENA-01)

### `{{PORTE}}` = SaaS (kit sistema + camada SaaS)
Tudo do sistema, mais:
19. [ ] Perguntas de produto respondidas pelo `{{OWNER}}` e registradas em ADR (SAAS-ADR-01) — planos? trial? multi-tenant? cobrança? offboarding?
20. [ ] SE multi-tenant: `tenant_id` no schema desde o dia 0 + scoping executável (SAAS-TENANT-02)
21. [ ] Gateway de pagamento como fonte da verdade + webhook idempotente (esqueleto)
22. [ ] SE emite chaves de API / envia webhooks: esqueleto conforme API-KEY-01 / WEBHOOK-OUT-01 (hash da chave, prefixo, assinatura de saída)
23. [ ] Teste de posse com 2 contas no plano de testes

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
antes do fim da sessão (CTX-RESUMO-01).
```

E para **retomar** um projeto existente:

```text
Retome o projeto {{NOME}}. Ritual de início (CTX-RITUAL-01): leia AGENTS.md,
depois ESTADO.md, depois os ADRs que ele referenciar. Em seguida me diga em 3
linhas: onde paramos, o que vem agora, e se há bloqueio. Então execute o próximo
passo do ESTADO.md. Não me pergunte "onde paramos" — o ESTADO.md responde.
```

---

## 8. POR QUE ISTO RESOLVE A AMNÉSIA (o mecanismo, em 6 linhas)

1. **Janela estourou no meio?** O último checkpoint (CTX-CHECKPOINT-01) garante que nada além de minutos se perde — commit + ESTADO.md são o savegame.
2. **Sessão nova não sabe nada?** O ritual de início (CTX-RITUAL-01) reidrata o essencial em ~2 arquivos curtos, não em 200k tokens de histórico.
3. **Decisão sumiu na compactação?** Ela nunca morava no chat — CTX-RESUMO-01 obrigou a gravá-la em ADR/ESTADO no momento em que foi tomada.
4. **Agente quer refazer o que já existe?** CORRECOES.md + ADRs explicam por que o código é como é — o "estranho" documentado não é consertado de volta.
5. **Tarefa grande demais para uma janela?** CTX-FASE-01 proíbe: o plano em FASES.md já nasceu fatiado em blocos de uma sessão.
6. **Dois documentos dizendo coisas diferentes?** CTX-FONTE-01: cada fato tem um único arquivo-dono; o resto referencia.

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

*Fim do Kit de Partida v3.1 — companheiro da Constituição (§CTX/§ORD) e do Handbook (capítulos 21-23).*
