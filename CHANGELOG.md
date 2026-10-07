# CHANGELOG — Padrão de Engenharia Universal

Histórico de cada versão: **o que mudou, por que mudou e de onde veio**. Nenhuma versão é apagada — cada uma fica congelada numa tag do git.

**Como ver qualquer versão antiga ou comparar duas:**

```bash
git show v3.3:CONSTITUICAO-ENGENHARIA-UNIVERSAL.md          # a Constituição exatamente como era na v3.3
git diff v3.3 v3.4 -- CONSTITUICAO-ENGENHARIA-UNIVERSAL.md  # o que mudou entre duas versões
git tag --list                                              # todas as versões publicadas
```

Regra de versionamento (`GOV-VERSION-01`): regra nova só entra depois de aplicada com sucesso em ≥1 sistema real; mudança de regra = minor; remoção ou mudança de significado = major; IDs nunca são renumerados nem reutilizados.

---

## Em preparação — candidatas (não publicadas como regra)

Lições observadas que **ainda não têm evidência de aplicação em sistema real** (`GOV-VERSION-01`). Status da última varredura (2026-10-07, nove sistemas do mesmo ecossistema, somente leitura). Cada uma entra na versão seguinte à sua primeira aplicação comprovada.

| Candidata | O que exige | Status na varredura | O que destrava |
|---|---|---|---|
| `OBS-INTEGRATION-01` | credencial/integração de terceiro vencida gera alerta ao usuário e ao operador | ausente em 9/9 (só `log.warn`) | implementar alerta num sistema com integração OAuth |
| `OPS-INVENTORY-01` | inventário de serviços externos: conta dona, plano, limites, renovação | parcial em 1/9 (limites sem dono); pendência explícita em 4 | escrever o inventário e mantê-lo no `ESTADO.md` |
| `ENC-DISK-01` | criptografia de disco verificada no host com segredos/PII | ausente em 9/9; verificado DESLIGADO no host de origem | ligar e registrar a verificação |
| `SECRETS-INVENTORY-01` | paridade `.env` real ↔ `.env.example` ↔ leituras no código; órfãs removidas | parcial em 3/9 (validam obrigatórias no boot; um tem 12 órfãs no example) | script de paridade rodando no CI |
| `API-SURFACE-01` | rota sem consumidor removida ou atrás de flag; flag sem leitor proibida | ausente em 9/9 | inventário rotas × consumidores + remoção |
| `TEST-TENANT-01` | tenant/usuário de teste oficial, sinalizado, fora de métricas, cobrança e e-mails | ausente em 9/9 (um tem demo em produção sem marcação) | campo + filtros |
| `SEC-MIGRATE-01` | modo duplo de controle de segurança com data de remoção | parcial em 1/9 (modo duplo registrado em ADR, sem data — e vivo após o prazo natural) | data no ADR + remoção executada |
| `DB-DRIFT-01` | DDL fora de migration registrado em ledger e reconciliado | ausente em 9/9 | `docs/DRIFT.md` + reconciliação |
| `EDGE-PROTECT-01` | anti-bot, rate limit, TLS mínimo e HSTS na borda, registrados como código/runbook | não verificável em 9/9 (só existe no painel) | exportar a configuração da borda para o repositório |

---

## v3.5 — 2026-10-07 — Candidatas promovidas por evidência: varredura de nove sistemas

**O que mudou**
- Constituição: +2 regras `[M]` — `BKP-REMEDIATE-01` (corrigido um backup ou controle de segurança, o legado inseguro é inventariado e expurgado só após restore confirmado no formato novo) e `TEST-CHAOS-01` (falha de dependência externa testada em instância descartável, com trava anti-produção; cache/banco/worker fora exigem staging).
- Handbook cap. 25 atualizado: as duas lições promovidas, contra-exemplos encontrados na varredura (12 variáveis órfãs; tolerância de token viva após o prazo; demo em produção sem marcação) e a seção "Como as candidatas viram regra".
- Este changelog ganha o quadro **Em preparação** acima, com o status de cada candidata.
- Kit de Partida segue na v3.4 (sem mudança).

**Por que**
Depois da v3.4 ficaram dez lições documentadas sem regra, porque `GOV-VERSION-01` exige aplicação em sistema real. Em vez de esperar, fez-se uma varredura somente leitura em nove sistemas do mesmo ecossistema — construídos por outros agentes — procurando evidência concreta (arquivo e linha, script, tarefa agendada, artefato no disco) de cada candidata. Resultado: duas com prova, sete parciais ou ausentes, uma não verificável de fora. Só as duas entraram.

**Origem de cada regra e ressalvas (registradas por honestidade)**
- `BKP-REMEDIATE-01`: sistema em produção do ecossistema; 18 backups legados em claro (locais e remotos) inventariados no ledger de restauração e apagados só depois do roundtrip de restore; rotação passou a aceitar só o formato cifrado; tarefa agendada rodando, 0 artefatos em claro restantes. No sistema de origem da auditoria, a mesma correção ainda está **pendente** (aguarda decisão de expurgo).
- `TEST-CHAOS-01`: sistema de monitoramento do ecossistema, **ainda em construção** (fase 4 de 8, não deployado): a dependência externa é derrubada pelo lado servidor numa instância descartável; trava recusa alvo de produção; 15 testes, 2 execuções verdes registradas. A regra foi escrita no escopo do que foi provado (dependência externa) — o escopo maior (cache, banco, worker) fica explícito como exigência de staging. O decisor técnico aceitou "sistema real em construção com teste executado" como aplicação válida.

**Exceção registrada (`GOV-AUDIT-01`), ainda vigente:** checagens automáticas das regras novas da v3.3 em diante — prazo 2026-11-06.

---

## v3.4 — 2026-10-07 — Lições operacionais: reinício, carga e defesa

**O que mudou**
- Constituição: +5 regras `[M]` — `SEC-CONTROL-LIVE-01` (todo controle de segurança tem prova de disparo), `NET-UPSTREAM-01` (upstream do proxy verificado em cada família de IP + keepalive), `DEP-SERVICE-01` (serviço gerenciado que dorme é proibido em produção), `HARD-CAP-01` (teto de recursos em host compartilhado; sem ferramenta interativa na produção), `OPS-RESTART-01` (checklist pós-reinício com conexão TCP real).
- Handbook: novo **capítulo 25** — as quinze lições da auditoria que originou a v3.3 e a v3.4, com o que aconteceu, o que ensina e onde cada uma foi parar; dez delas ficam como **candidatas à v3.5**.
- Kit de Partida: template de `ESTADO.md` ganha "Capacidade e hardware" e "Serviços externos".
- Este `CHANGELOG.md` passa a existir.

**Por que**
A segunda camada da mesma auditoria: ao reiniciar a infraestrutura, portas "escutavam" mas fechavam a conexão (três sistemas fora com todos os containers "Up"); sob carga, o proxy alternava para um endereço IPv6 morto (rajadas de 502 aos 100 usuários); um detector de anomalia existia havia meses e nunca tinha disparado (montado antes da autenticação); um banco gerenciado em plano gratuito pausou por inatividade e derrubou um site; e o teto de escala era um notebook de 2 núcleos dividindo RAM com o cliente de IA. Cada regra nova é a forma verificável de impedir a repetição.

**Por que só cinco das quinze lições viraram regra**
`GOV-VERSION-01`: regra só entra depois de aplicada em sistema real. As cinco estavam implementadas e verificadas no sistema de origem; as outras dez estão documentadas no cap. 25 do Handbook e entram quando a correção correspondente estiver no ar e medida.

---

## v3.3 — 2026-10-06 — Regra executável e auditoria do sistema em execução

**O que mudou**
- +30 regras. A central é `GOV-ENFORCE-01`: toda regra `[M]` roda por máquina em 4 pontos — hook de pre-push, CI que bloqueia o merge, verificação diária do ambiente em execução com alerta, e evidência colada pelo agente antes de declarar "pronto". Pular um ponto exige waiver com prazo.
- Testes que passam a ser obrigatórios: `TEST-RUNTIME-01` (auditar o sistema rodando, não só o código), `TEST-LOAD-01` (carga com perfil de uso humano), `TEST-ABUSE-01` (regressão das defesas de abuso), `SCALE-CAP-01` (hardware e teto medido registrados).
- Segurança: `RATE-LIMIT-02/03` (limites em camadas; IP real comprovado no log), `AUTH-PACE-01` (espera progressiva no login, e-mail normalizado), `SEC-WEBHOOK-IN-01`, `SEC-HEADERS-02`, `SEC-SANITIZE-01`, `NET-BIND-01`, `BKP-VERIFY-01`, `SAAS-IMPERSONATE-02`, `ENC-FIELD-01`.
- Desempenho e operação: `PERF-HOTPATH-01`, `DB-POOL-01`, `DB-CURSOR-01`, `DB-INDEX-02`, `QUEUE-ONE-01`, `QUEUE-HYGIENE-01`, `OBS-WORKER-02`, `OBS-HEALTH-02`, `OBS-LOG-02`, `RES-CACHE-01`, `PIPE-PARITY-01`, `SCALE-PROC-01`, `CODE-ERR-02`.
- Agentes de IA: `IA-ENCODING-01`, `IA-HOSTSEC-01`.
- Definição de Pronto passa a exigir `audit.sh` verde e, quando a mudança toca infra/auth/limites/desempenho/backup, `audit-runtime.sh` verde com saída colada.

**Por que**
Auditoria de um SaaS multi-tenant em produção que **tinha as regras de segurança escritas e violava várias sem perceber**: backup subindo em claro para a nuvem (regra desde a v3.1), worker parado três dias sem alerta, rate limit virando balde único da plataforma por falta de IP real (o sistema caía com 20 usuários), `/health` detalhado público. Todas marcadas "verificação manual" — e verificação manual nunca acontecia. A v3.3 muda a natureza da regra: escrita não basta, tem que rodar.

**Exceção registrada (`GOV-AUDIT-01`)**
As checagens automáticas das regras novas ainda não estão no `audit.sh` nem existe o `audit-runtime.sh`. Prazo: **2026-11-06**. Até lá, verificação manual no checkpoint — a mesma fraqueza que a versão combate, assumida com data.

---

## v3.2 — 2026-08-23 — Pontos de restauração: reversibilidade sem memória

**O que mudou:** `CTX-RESTORE-01/02/03` — ledger append-only `docs/PONTOS-DE-RESTAURACAO.md` + savepoint antes de qualquer mudança de risco; o git guarda o conteúdo, o ledger guarda o significado; "desfazer" nunca depende da memória do chat. Handbook cap. 24; Kit §6B. Licença atualizada; URL do repositório removida do texto.

**Por que:** incidente real — um agente apagou código correto e não conseguiu reverter porque o registro do que havia feito morava só na janela de contexto (`GOV-POSTMORTEM-01`).

---

## v3.1 — 2026-08-09 — Documentação viva, APIs expostas e quarentena de dependências

**O que mudou:** `DOC-VIVA-01`/`DOC-API-01` (a documentação nasce com a feature, nunca no final); `API-KEY-01`/`WEBHOOK-OUT-01` (chaves de API emitidas e webhooks enviados); backup **comprimido e criptografado** (`BKP-DUMP-01`); `DEP-QUARENTENA-01`/`DEP-MINIMAL-01` (release com menos de ~14 dias não entra; pergunta obrigatória antes de adicionar dependência). Handbook cap. 23. Primeira publicação com guia de uso e licença CC BY-ND.

**Por que:** documentação escrita "depois" nunca era escrita; ataques à cadeia de suprimentos de pacotes descobertos nos primeiros dias após a publicação.

---

## v3.0 — Validada em uso real

**O que mudou:** `§ORD` (ordem de construção: dados → segurança → domínio → API → front, segurança transversal desde o primeiro commit), `SCALE-READY-01` (escalável-pronto por design, escalado por evidência), `LEG-HUMANO-01` (código gerado por IA indistinguível do de um sênior — teste dos 10 minutos), `IA-EVIDENCE-01` (alegação sem evidência = não verificado), e a **instanciação** da Constituição como modo preferido. Handbook cap. 22.

**Por que:** primeira versão validada construindo um sistema real do zero com o padrão.

---

## v2.0 — Protocolo de contexto e Kit de Partida

**O que mudou:** `§CTX` (a memória do projeto mora no repositório, nunca no chat: `AGENTS.md`, `ESTADO.md`, `FASES.md`, ADR, CORRECOES), parâmetro `{{PORTE}}` (dosagem de rigor por tamanho do projeto) e o Kit de Partida com templates e prompts. Handbook cap. 21.

**Por que:** o maior risco de construir com IA não era código ruim — era amnésia de contexto entre sessões.

---

*O histórico público do repositório antes da v3.2 foi condensado; as tags `v3.1` e `v3.2` apontam para as versões publicadas. A partir da v3.3 cada versão é um commit próprio, com mensagem explicando o porquê.*
