# KIT DE PARTIDA — UNIVERSAL
**Versão 3.6 · Companheiro executável da Constituição de Engenharia (§CTX e §ORD) · Padrão executável > padrão escrito**

Este arquivo transforma o Protocolo de Contexto (regras `CTX-*` da Constituição) em **arquivos prontos para copiar**. Ele existe porque o maior risco de construir com IA não é código ruim — é **amnésia de contexto**: a janela estoura, a sessão seguinte não sabe o que foi decidido, e o agente refaz, desfaz ou contradiz o trabalho anterior. A cura é estrutural: **antes da primeira linha de código, cria-se a memória do projeto no repositório.** O chat é descartável; o repo é permanente.

Regra de ouro (CTX-KIT-01): **nenhum código antes do kit completo** — nem para "um site rapidinho". O porte dosa o rigor das camadas técnicas; a memória é inegociável em qualquer porte.

---

## 0. FASE 0 — VALE CONSTRUIR? (antes do kit, quando o produto é novo)

O kit protege o projeto da amnésia; não protege do projeto errado. Ideia nova de produto, projeto próprio, feature grande ou pivô passa primeiro por aqui. **Não se aplica** a encomenda de cliente com escopo fechado, bug, refatoração ou ajuste em produto que já existe.

1. **Conselho de cinco pareceres independentes**, em paralelo (cinco agentes ou cinco sessões que não leem uns aos outros), todos com o mesmo contexto: quem constrói, tempo e capital disponíveis, produtos já em andamento.
   - A favor 1 — viabilidade técnica: stack, peças prontas, prazo realista do MVP.
   - A favor 2 — oportunidade: tamanho do mercado, custo para conquistar cliente, casos parecidos que deram certo, sinergia com o que já existe.
   - Contra 1 — complexidade escondida: armadilhas técnicas, escopo que não aparece na ideia.
   - Contra 2 — viabilidade comercial: concorrência, custo de aquisição contra receita por cliente, cancelamento.
   - Juiz — nota de 1 a 10 em mercado, métricas, investimento, esforço e custo de oportunidade → **GO**, **NO-GO** ou **GO CONDICIONAL**, sempre com uma alternativa.
2. **Ficha da ideia** — nota de 1 a 5 em sete critérios (total /35): gravidade do problema · tamanho do mercado · disposição a pagar · espaço frente à concorrência · distribuição (como chegam os 100 primeiros clientes) · momento · vantagem de quem constrói. 28 ou mais: construir · 21–27: corrigir o critério mais fraco antes · 14–20: mudar o ângulo · abaixo de 14: recomeçar.
3. **Três testes baratos antes de qualquer código** — cada um com UMA hipótese, os passos exatos, o critério de sucesso em número, prazo de até 2 semanas e custo baixo.

**Saída:** o placar, a ficha e o resultado dos testes viram `docs/adr/000-vale-construir.md` (template §5) quando o kit for criado. O parecer é **entrada, não decisão**: quem decide é o `{{OWNER}}`, inclusive contra o placar — e nenhum conselho revoga decisão já registrada em ADR ou no `ESTADO.md`.

---

## 1. CHECKLIST PRÉ-CONSTRUÇÃO POR PORTE

Execute na ordem. Só depois do último ✅ a primeira feature pode começar. Produto novo passa antes pela Fase 0 (§0).

### `{{PORTE}}` = site-estático (kit mínimo — 10 minutos)
1. [ ] `git init` + primeiro commit
2. [ ] `AGENTS.md` (template §2 — versão curta)
3. [ ] `ESTADO.md` (template §3)
4. [ ] `README.md` (o que é + como rodar/publicar)
5. [ ] `docs/FASES.md` com as fases planejadas (template §4)
6. [ ] `docs/PONTOS-DE-RESTAURACAO.md` com cabeçalho (template §6B) — todo checkpoint vira ponto de restauração
7. [ ] Toda página PÚBLICA com `<title>` e descrição próprios, um único `<h1>` e imagem de prévia de link (`og:image`, ~1200×630) — é ela que aparece quando o link é compartilhado em mensageiro e rede social

### `{{PORTE}}` = app-simples (kit padrão — 30 minutos)
Tudo do site-estático, mais:
8. [ ] `docs/adr/` criado + ADR-001 registrando stack escolhida (template §5)
9. [ ] `docs/CORRECOES.md` vazio com cabeçalho (template §6)
10. [ ] `.env.example` completo + `.env` no `.gitignore` desde o commit 1
11. [ ] Estrutura de diretórios do Nível 0 (`modules/` + `shared/` ou equivalente do framework)

### `{{PORTE}}` = sistema (kit completo — ~2 horas, economiza semanas)
Tudo do app-simples, mais:
12. [ ] Validação de schema instalada e exemplificada em 1 rota
13. [ ] Logger estruturado JSON com `requestId` configurado
14. [ ] Error tracking conectado (categoria em `{{CATEGORIA_FORNECEDOR}}`)
15. [ ] Migrations versionadas inicializadas
16. [ ] Script de deploy nas fases universais (aborta em erro + lock)
17. [ ] Headers de segurança + auth com cookie HttpOnly (SE há login)
18. [ ] Backup automatizado (comprimido + criptografado) + dead man's switch (SE há dados de usuário)
19. [ ] Doc técnica inicializada: `docs/API.md` ou OpenAPI (DOC-API-01) — cresce a cada fase, nunca "no final"
20. [ ] Triagem de dependências ativa: `ignore-scripts` por padrão + regra de quarentena de release (DEP-QUARENTENA-01)

21. [ ] Varredura de segurança ligada (Kit §11): revisão de segurança do diff no CI com a ação fixada por hash (SEC-REVIEW-01) e a seção "Varreduras de segurança" no `ESTADO.md` (SEC-SCAN-01)

### `{{PORTE}}` = SaaS (kit sistema + camada SaaS)
Tudo do sistema, mais:
22. [ ] Perguntas de produto respondidas pelo `{{OWNER}}` pelo método de entrevista (§7B) e registradas em ADR (SAAS-ADR-01) — planos? trial? multi-tenant? cobrança? offboarding?
23. [ ] SE multi-tenant: `tenant_id` no schema desde o dia 0 + scoping executável (SAAS-TENANT-02)
24. [ ] Gateway de pagamento como fonte da verdade + webhook idempotente (esqueleto)
25. [ ] SE emite chaves de API / envia webhooks: esqueleto conforme API-KEY-01 / WEBHOOK-OUT-01 (hash da chave, prefixo, assinatura de saída)
26. [ ] Teste de posse com 2 contas no plano de testes

---

## 2. TEMPLATE — `AGENTS.md` (regras do projeto para qualquer agente)

> `AGENTS.md` é o arquivo CANÔNICO (padrão aberto — lido por Codex, Antigravity/Gemini, Cursor e outros). Para ferramentas com nome próprio, crie apontadores de **1 linha** — nunca cópias (CTX-FONTE-01):
> - `CLAUDE.md` contendo apenas: `@AGENTS.md` (Claude Code importa via `@`)
> - `GEMINI.md` contendo apenas: `Siga as instruções de AGENTS.md.`

```markdown
# AGENTS.md — {{NOME_DO_PROJETO}}

> Padrão seguido: Constituição de Engenharia Universal **v{{VERSAO_PADRAO}}** (a tag do padrão usada neste projeto) · Porte: {{PORTE}} · Auditado em: {{DATA}}
> Pendências de auditoria: (nenhuma | listar IDs de regra + waiver/ADR)

## Ritual obrigatório de início de sessão (CTX-RITUAL-01)
1. Leia este arquivo inteiro.
2. Leia `ESTADO.md` — ele diz onde o trabalho parou e o que vem agora.
3. Leia os ADRs em `docs/adr/` marcados como recentes no ESTADO.md.
4. SE for tocar área já corrigida: leia a entrada correspondente em `docs/CORRECOES.md`.
5. SE for dar nome a entidade, tela, rota ou tabela nova: confira `docs/GLOSSARIO.md` (um termo por conceito).
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
1. SE a sessão fecha uma fase: revisão em duas frentes antes do checkpoint — padrão (Constituição
   instanciada + este arquivo) e fase (critério de pronto em docs/FASES.md), cada uma num agente
   separado que só recebe o diff. Achado se corrige agora, não "depois".
2. Atualize `ESTADO.md` (fase, checkpoint, decisões, próximos 3 passos, bloqueios).
3. Commit + push (commits atômicos em {{IDIOMA_COMMITS}}).
4. Decisão tomada no chat → grave no arquivo-fonte (ADR/ESTADO) ANTES de encerrar (CTX-RESUMO-01).
5. Retro de uma linha: o que atrapalhou o agente nesta sessão? Se for algo que vai se repetir, anote
   em `ESTADO.md` › Bloqueios/pendências com o prefixo `processo:` — o {{OWNER}} decide se vira
   checagem automática, linha neste arquivo ou candidata ao padrão.
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

## Varreduras de segurança (SEC-SCAN-01 — última rodada de cada camada, Kit §11)
| Camada | Instância (versão) | Última rodada | Achados abertos | Próxima obrigatória |
|---|---|---|---|---|
| Revisão do diff (SEC-REVIEW-01) | /security-review + Action Anthropic @{{hash}} | {{AAAA-MM-DD}} | {{0}} | todo PR e fim de fase |
| Auditoria do código (SEC-AUDIT-01) | security-audit Cloudflare @{{commit}}, perfil {{quick/standard}} | {{AAAA-MM-DD}} | {{n — ver docs/CORRECOES.md}} | {{AAAA-MM-DD: trimestral ou gatilho}} |
| Ataque ao sistema (TEST-PENTEST-01) | Strix {{versão}} | {{AAAA-MM-DD}} | {{n}} | {{AAAA-MM-DD}} |

## Fases concluídas (1 linha cada — detalhe em docs/HISTORICO.md)
- F1 — {{nome}} — commit `{{hash}}` — {{data}}
```

---

## 4. TEMPLATE — `docs/FASES.md` (o plano em blocos que cabem numa sessão)

```markdown
# FASES — {{NOME_DO_PROJETO}}
> Regra (CTX-FASE-01): cada fase cabe em UMA sessão de agente e fecha com checkpoint
> (commit + ESTADO.md). Fase que não fechou estava grande — dividir aqui e registrar.
> MVP em uma frase: o usuário consegue {{fazer X}} e obtém {{resultado Y}} em menos de {{Z}} minutos.

| Fase | Entrega verificável | Critério de pronto | Status |
|---|---|---|---|
| F1 | Kit de Partida + scaffolding | checklist §1 completo, commit inicial | ⬜ |
| F2 | Modelo de dados do núcleo + migrations (§ORD passo 1) | schema versionado; migration roda em banco limpo | ⬜ |
| F3 | Fundação de segurança: auth + validação + posse na 1ª rota (§ORD passo 2) | login funciona; teste de posse com 2 contas passa | ⬜ |
| F4 | 1ª fatia vertical do fluxo principal: dados→serviço→API→tela | {{fluxo demonstrável fim-a-fim}} | ⬜ |
| F5+ | {{demais fatias verticais, uma por sessão}} | {{como verificar}} | ⬜ |

## Fora do escopo (decidido NÃO fazer agora)
| Item | Por que não agora | Reavaliar quando |
|---|---|---|
| {{funcionalidade}} | {{não é essencial ao fluxo principal / custo alto / sem demanda medida}} | {{gatilho concreto, ex.: 10 clientes pagantes pedindo}} |

Princípios de fatiamento (§ORD da Constituição):
- Ordem das camadas DENTRO de cada fatia: dados → segurança → serviço → contrato de API → tela.
  Front antes do contrato é proibido; "segurança depois" é proibido (nasce junto, transversal).
- Fatias VERTICAIS (fluxo completo fino) > camadas horizontais (todo o backend, depois todo o front).
- Escalável-pronto desde a F2 (SCALE-READY-01): stateless, paginação, índices, jobs idempotentes —
  escalar tem que significar "adicionar instância", nunca "reescrever".
- Toda fase termina com algo demonstrável ou testável — nunca "50% de X".
- Descoberta no meio da fase que muda o plano → registrar aqui + ESTADO.md antes de continuar.
- Pedido novo no meio do caminho entra em "Fora do escopo" ou numa fase futura — nunca na fase em andamento.
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

## 6C. TEMPLATE — `docs/GLOSSARIO.md` (a língua do domínio — nasce com o 1º termo)

> Um arquivo-dono para os termos de negócio, no espírito do CTX-FONTE-01: o nome que aparece na
> conversa, na tela, na tabela e no código é o mesmo. Não se cria vazio — nasce quando a primeira
> palavra do domínio é definida (na entrevista §7B ou numa decisão) e cresce junto com o sistema.
> Termo ambíguo ("conta" é o cliente ou o usuário?) se resolve aqui, antes de virar nome no código.

```markdown
# GLOSSÁRIO — {{NOME_DO_PROJETO}}
> Um termo por conceito. Mudou o significado? Atualize aqui no mesmo checkpoint e procure os usos no código.

| Termo | O que é | Não confundir com | Onde vive no código |
|---|---|---|---|
| {{termo}} | {{definição em 1 frase, na língua do negócio}} | {{termo vizinho e a diferença}} | {{tabela / módulo / rota}} |
```

---

## 7. PROMPT DE PARTIDA (colável — inicia qualquer projeto no padrão)

Cole numa sessão nova de agente para começar um projeto do zero:

```text
Vamos iniciar o projeto {{NOME}} ({{PORTE}}: site-estático|app-simples|sistema|SaaS).
Siga a Constituição de Engenharia Universal v{{VERSAO_PADRAO}} — a tag mais
recente do padrão (colada abaixo / no repositório).

ANTES de qualquer código (CTX-KIT-01):
1. Execute o checklist pré-construção do meu porte (Kit de Partida §1).
2. Crie AGENTS.md, ESTADO.md e docs/FASES.md a partir dos templates do Kit,
   preenchidos para este projeto. O que faltar, tire comigo pelo método de
   entrevista (Kit §7B): fato você descobre sozinho, decisão é minha ({{OWNER}}).
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

## 7B. MÉTODO DE ENTREVISTA (como o agente tira as decisões do `{{OWNER}}`)

Vale para o kit (§1), para as perguntas de produto da camada SaaS (SAAS-ADR-01) e para qualquer fase que comece com decisão em aberto. "Me pergunte o que não souber", sem método, vira uma pergunta solta por vez ou uma lista de trinta de uma vez — as duas cansam e deixam buracos.

- **Mapa de decisões.** Cada decisão abre outras que dependem dela. Trabalhe em rodadas.
- **Rodada = tudo que já dá para perguntar.** Pergunte de uma vez todas as decisões cujos pré-requisitos já estão resolvidos — e só elas. A que depende de outra ainda aberta fica para a rodada seguinte.
- **Toda pergunta vem com a resposta recomendada**, escrita de modo que "sim" aceite a recomendação.
- **Fato é trabalho do agente; decisão é do `{{OWNER}}`.** O que dá para descobrir lendo o repositório, a documentação ou o ambiente, o agente descobre sozinho, sem travar a rodada. Só pergunta o que é escolha.
- **Termina quando não sobra decisão aberta nem suposição silenciosa.** Nada se constrói antes de o `{{OWNER}}` confirmar que o entendimento é o mesmo.
- **Saída:** decisão estrutural → ADR (§5); o resto → `ESTADO.md` (CTX-RESUMO-01); termo de negócio definido → `docs/GLOSSARIO.md` (§6C).

Formato de cada rodada:

```text
Q1 — {{título}}: {{contexto e opções, se houver}}
→ Recomendo: {{resposta}}

Q2 — {{título}}: ...
→ Recomendo: ...
```

## 7C. REVISÃO EM DUAS FRENTES (o code review de quem trabalha sozinho)

No perfil Solo, o review humano vira "auto-review com IA" (§Perfis da Constituição). Para não ser o mesmo agente relendo o próprio trabalho com o mesmo contexto, a revisão roda em **dois agentes separados que só recebem o diff**: quem implementou está sob pressão de contexto; quem revisa chega limpo e enxerga o que passou. Roda no fim de cada fase, antes do checkpoint.

```text
Revise o diff entre {{hash do último checkpoint}} e HEAD em duas frentes, cada uma
num agente separado que recebe só o diff e o documento da sua frente:
1. PADRÃO — o diff obedece à docs/CONSTITUICAO-INSTANCIADA.md e ao AGENTS.md?
   Aponte o ID da regra em cada violação.
2. FASE — o diff entrega o critério de pronto da fase em docs/FASES.md, nem mais
   nem menos? Aponte o que falta e o que entrou sem ter sido pedido.
Junte os achados por gravidade e me mostre antes de corrigir.
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

A Constituição completa tem ~165 regras — mas um site estático ativa ~1/3 delas, e **regra irrelevante no contexto dilui a obediência às relevantes**. O modo de uso preferido (desde a v3.0) é gerar a versão instanciada uma única vez por projeto e colar ELA nas sessões:

```text
Leia a CONSTITUICAO-ENGENHARIA-UNIVERSAL.md (v{{VERSAO_PADRAO}}) e gere a "Constituição
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
5. Cabeçalho: "Instanciada da Constituição Universal v{{VERSAO_PADRAO}} em {{DATA}} —
   regenerar se os parâmetros mudarem ou se sair versão nova do padrão".
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

## 11. VARREDURA DE SEGURANÇA EM CAMADAS — a dinâmica (SEC-SCAN-01, SEC-REVIEW-01, SEC-AUDIT-01, TEST-PENTEST-01)

Nenhuma ferramenta pega tudo: cada camada enxerga um tipo de falha que as outras não veem. O `audit.sh` confere se a proteção **existe**; as camadas abaixo procuram se ela **funciona**. A dinâmica tem três partes: **quando roda o quê** (gatilhos), **que falha cada camada pega** (por que juntas cobrem) e **como cada ferramenta roda sem riscos**. As instâncias padrão podem ser trocadas por equivalentes (Handbook, tabela de equivalências); a camada e o gatilho, não.

### 11.1 Quando roda o quê

| Gatilho | O que roda | Instância padrão | Efeito do achado |
|---|---|---|---|
| Todo commit (pre-push) | auditoria do código do padrão + segredos | `audit.sh`, gitleaks | bloqueia o push |
| Todo PR e todo fim de fase | revisão de segurança do diff (SEC-REVIEW-01) + regras estáticas + dependências | `/security-review` (fim de fase) e Action `anthropics/claude-code-security-review` (PR) da Anthropic; Semgrep ou CodeQL; npm audit ou osv-scanner | HIGH/CRITICAL bloqueia o merge |
| Mudança sensível: autenticação, permissão, isolamento entre clientes, pagamento, upload, borda ou infraestrutura | auditoria por agentes **com escopo na área** (SEC-AUDIT-01, perfil quick); SE tocou borda, infraestrutura ou autenticação: ataque ao sistema com escopo (TEST-PENTEST-01) | skill `security-audit` da Cloudflare; Strix | confirmado bloqueia o deploy |
| Antes do 1º cliente pagante (portão) | auditoria completa (perfil standard) + ataque completo + `audit-runtime.sh --abuse` | Cloudflare; Strix; `audit-runtime.sh` | sem as três rodadas limpas, não há cliente |
| Versão grande | auditoria com escopo no diff entre versões + ataque contra a versão nova em instância local | Cloudflare (quick, escopo `vA..vB`); Strix | confirmado bloqueia a publicação |
| Todo dia | sistema rodando + dependências com falha nova | `audit-runtime.sh`; osv-scanner agendado | alerta |
| Trimestral, mesmo sem mudança | auditoria completa a partir da rodada anterior (as rodadas se somam) + ataque completo + revisão das exceções vencendo | Cloudflare (standard, ledger anterior); Strix | HIGH bloqueia o próximo deploy |
| Depois de incidente ou de achado HIGH | a camada que achou, de novo, mais a vizinha: achado do diff → auditoria com escopo na área; achado da auditoria → ataque focado; achado do ataque → auditoria da área | as mesmas | fecha pelo ciclo (11.4) |

As baratas rodam sempre; as caras rodam em marcos. Uma camada alimenta a outra: o diff que toca autenticação dispara a auditoria com escopo, e a auditoria que acha falha de isolamento dispara o ataque focado naquela rota.

### 11.2 Que falha cada camada pega

| Tipo de falha | Quem pega primeiro | Quem confirma |
|---|---|---|
| Segredo commitado | gitleaks no commit | `audit-runtime.sh` (segredo no bundle) |
| Dependência com falha conhecida | npm audit / osv-scanner (PR e diário) | — |
| Padrão perigoso no código (injeção, `eval`, regex lenta) | Semgrep / CodeQL no PR | revisão do diff |
| Falha nova trazida pela mudança | revisão do diff da Anthropic (PR e fim de fase) | auditoria com escopo |
| Lógica, posse, isolamento entre clientes, escalada de permissão | auditoria por agentes da Cloudflare | teste do projeto (o "precisa validar" vira teste) |
| Configuração, cabeçalho, cookie, proxy, borda | Strix contra o sistema rodando | `audit-runtime.sh` |
| Abuso e limites | regressão de abuso (TEST-ABUSE-01) | Strix |
| O que ninguém previu | rodada trimestral (as rodadas se somam) | incidente → post-mortem → regra (GOV-POSTMORTEM-01) |

Nenhuma combinação garante pegar qualquer falha: regra de negócio que só o dono conhece e falha de dia zero em dependência escapam. O que a dinâmica garante é que **cada tipo conhecido de falha tem uma camada responsável e uma data**, e que o que escapou volta como regra.

### 11.3 Como cada ferramenta roda sem riscos

Ferramenta de varredura é ferramental do agente (candidata DEP-AGENT-01): lida antes de instalar, origem oficial, versão fixada, instalada no projeto — e você sabe para onde ela manda o código.

**Revisão do diff — Anthropic (SEC-REVIEW-01).** No fim de cada fase, rode `/security-review` no Claude Code. No CI, um job por PR com a ação **fixada por hash** (PIPE-SUPPLY-01; o README dela usa `@main`):

```yaml
  revisao-de-seguranca:
    if: github.event.pull_request.head.repo.full_name == github.repository   # só PR do próprio repositório
    runs-on: ubuntu-latest
    permissions: { contents: read, pull-requests: write }
    steps:
      - uses: actions/checkout@{{hash}}
        with: { ref: "${{ github.event.pull_request.head.sha }}", fetch-depth: 2 }
      - uses: anthropics/claude-code-security-review@0c6a49f1fa56a1d472575da86a94dbc1edb78eda   # 2026-02-11
        with:
          claude-api-key: ${{ secrets.CLAUDE_API_KEY }}
          comment-pr: true
          exclude-directories: node_modules,dist,.next
```

A ação não é blindada contra injeção de prompt: em repositório com contribuição externa, ligue "Require approval for all external contributors" e nunca rode em PR de fork. A chave da API fica em secret do CI, com escopo e orçamento próprios (COST-API-01).

**Auditoria do código por agentes — Cloudflare (SEC-AUDIT-01).**

```text
1. Instale fixando a versão, só no projeto e fora do git:
   clone https://github.com/cloudflare/security-audit-skill numa pasta temporária,
   confira o commit (última revisão lida: c1c8a8c), copie skills/security-audit para
   .claude/skills/security-audit/ do projeto e acrescente essa pasta ao .git/info/exclude.
2. Peça: "Rode uma auditoria de segurança, perfil {{quick|standard}}, escopo {{áreas, ex.:
   autenticação e isolamento de dados | diff vA..vB | tudo}}, orçamento de {{N}} agentes,
   saída fora do repositório. Use a rodada anterior se existir. Não execute código do
   projeto fora de sandbox, nunca abra o .env e não toque no sistema publicado."
3. Leia REPORT.md e NEEDS-VALIDATION.md na pasta de saída e registre a rodada no ESTADO.md.
```

Sem sandbox do sistema operacional (rede cortada, ambiente vazio, escrita só em pasta temporária, limite de CPU e memória), ela não executa o código do projeto e marca como "precisa validar" o que dependeria de execução, já com o teste que resolveria. No Windows, os validadores dela recusam ler arquivos (exigem proteção de leitura que só Linux e macOS têm): rode a auditoria no WSL2/Linux, ou chame as funções exportadas dos validadores com leitura simples, já que os arquivos validados são escritos pelo próprio coordenador.

**Ataque ao sistema rodando — Strix (TEST-PENTEST-01).**

```text
1. Docker ligado. Instale pelo registro oficial, em versão com mais de 14 dias
   (DEP-QUARENTENA-01): uv tool install strix-agent==1.7.0   (ou pipx)
2. Modelo sob contrato de tratamento de dados — nunca o padrão do guia que manda o código
   para terceiro sem contrato: STRIX_LLM="anthropic/{{modelo}}" e LLM_API_KEY no ambiente
   da sessão (PowerShell: $env:STRIX_LLM=...; Git Bash: export STRIX_LLM=...).
3. Alvo: um clone SEM .env e uma instância local descartável com dados fictícios
   (strix --target ./clone-sem-segredos e/ou a URL local dessa instância).
   Nunca a URL de produção, nunca um túnel público.
4. Achados no relatório do Strix → registre no ESTADO.md e feche pelo ciclo (11.4).
```

### 11.4 Do achado ao conserto — a ferramenta acha, quem corrige é o ciclo

1. Para cada achado confirmado ou "precisa validar", escreva primeiro o teste que reproduz a falha e veja ele falhar.
2. Aplique o menor conserto recomendado, no último ponto de decisão confiável. Para aplicar os achados de uma revisão do diff, o `/code-review --fix` do Claude Code ajuda — revise o que ele mudou antes do commit.
3. Teste verde, entrada em `docs/CORRECOES.md` (sintoma → causa → conserto → teste) e ponto de restauração.
4. Rode de novo a camada que achou a falha, para confirmar que fechou e que o conserto não abriu outra; atualize a linha da camada em "Varreduras de segurança" no `ESTADO.md`.

---

*Fim do Kit de Partida v3.6 — companheiro da Constituição (§CTX/§ORD) e do Handbook (capítulos 21-26). v3.2: template §6B (PONTOS-DE-RESTAURACAO.md) e savepoint pré-risco no prompt de partida. v3.4: `ESTADO.md` ganha "Capacidade e hardware" (SCALE-CAP-01) e "Serviços externos" (DEP-SERVICE-01) — o número que o sistema aguenta e quem é dono de cada dependência passam a morar na memória viva. v3.5.1: §10 — templates dos 4 pontos de aplicação por máquina (pre-push, CI, `audit-runtime.conf` + agendador, seção do `AGENTS.md`) e o roteiro para provar que cada ponto dispara. v3.5.2: §0 Fase 0 (vale construir?), §6C glossário do domínio, §7B método de entrevista, §7C revisão em duas frentes, "Fora do escopo" e MVP em uma frase no `FASES.md`, retro de uma linha no fim da sessão, prévia de link no checklist do site e a versão do padrão como `{{VERSAO_PADRAO}}` nos prompts — nada disso é regra nova; é método para cumprir as que já existem. v3.5.3: §11 varredura de segurança em camadas (segredos, dependências, regras estáticas, revisão do diff, auditoria do código por agentes, ataque ao sistema rodando), o passo a passo para rodar a auditoria por agentes sem riscos e o ciclo do achado ao conserto. v3.6: §11 vira a dinâmica das regras SEC-SCAN-01, SEC-REVIEW-01, SEC-AUDIT-01 e TEST-PENTEST-01 — quando roda o quê (gatilhos), que falha cada camada pega e como rodar a revisão da Anthropic, a auditoria da Cloudflare e o Strix sem riscos; `ESTADO.md` ganha "Varreduras de segurança"; checklist do porte sistema ganha o item 21 (SaaS renumerado 22–26).*
