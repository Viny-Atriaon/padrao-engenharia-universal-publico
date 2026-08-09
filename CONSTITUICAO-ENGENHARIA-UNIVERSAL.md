# CONSTITUIÇÃO DE ENGENHARIA — UNIVERSAL
**Versão 3.1 — Definitiva · Documento normativo · Validada em uso real (Filosofia §8 cumprida)**

Como usar — **modo preferido: a Constituição INSTANCIADA.** Gere a versão do SEU projeto (prompt no Kit de Partida §9): só as regras ativadas pelo seu `{{PORTE}}` e perfis, tipicamente 1/3 do tamanho — regra irrelevante no contexto dilui a obediência às relevantes. Este arquivo completo é a FONTE da instanciação e o fallback quando não houver instância. Regras, não explicações — racionais e equivalências de stack no **Handbook**; templates no **Kit de Partida** (`KIT-DE-PARTIDA-UNIVERSAL.md`). Cada regra tem ID estável (`DOMINIO-TEMA-NN`), nunca renumerado; cada item é `[M]` (verificável por máquina) ou `[J]` (julgamento humano).

Vale para QUALQUER porte — de site estático a SaaS multi-tenant: o parâmetro `{{PORTE}}` dosa o rigor (tabela §Perfis), mas o **Protocolo de Contexto** (§CTX) e a **Ordem de Construção** (§ORD) valem sempre, inclusive para o site mais simples.

**Hierarquia de prioridade em qualquer conflito técnico:**
`Estabilidade > Segurança > Correção > Manutenibilidade > Performance > Escalabilidade`

---

## PARÂMETROS DO CONTEXTO

Regra de ouro: parâmetro não preenchido **FALHA ALTO** — vira pendência bloqueante registrada no topo do CLAUDE.md; a IA NÃO DEVE assumir default silencioso.

| Parâmetro | Tipo / Valores | O que ativa |
|---|---|---|
| `{{OWNER}}` | pessoa — decisor final do produto | destinatário das perguntas de produto (SAAS-ADR-01) |
| `{{DECISOR_TECNICO}}` | pessoa — aprova ADR e waiver | governança, exceções |
| `{{ORG}}` | texto — organização dona do código | licença, inventário |
| `{{TAMANHO_TIME}}` | `Solo` \| `2-5` \| `6-15` \| `15+` | perfis condicionais (tabela §Perfis) |
| `{{TIPO_APP}}` | `SPA` \| `SSR` \| `API-only` \| `mobile` \| `CLI` \| `monolito` \| `microserviços` | blocos de frontend, contrato de API |
| `{{PORTE}}` | `site-estático` \| `app-simples` \| `sistema` \| `SaaS` | dosagem de rigor por porte (tabela §Perfis); CTX-* vale para TODOS |
| `{{MULTI_TENANT}}` | `sim` \| `não` | bloco SAAS-TENANT inteiro |
| `{{STACK}}` | mapa: linguagem/framework/ORM/validação/process manager/auth/fila | tabela de equivalências do Handbook |
| `{{MODELO_DEPLOY}}` | `self-hosted` \| `PaaS` \| `containers` \| `serverless` \| `imutável` | HARD-*, DR-RECONSTRUCT-01 |
| `{{EXPOE_LLM}}` | `sim` \| `não` | LLM-TENANT-01, LLM-PII-01, COST-* |
| `{{PROTOCOLO_API}}` | `REST` \| `GraphQL` \| `gRPC` \| `RPC-JSON` | forma do contrato de erro (API-CONTRACT-01) |
| `{{REGULACAO_DADOS}}` | ex.: LGPD, GDPR, HIPAA, nenhuma | PRIV-*, offboarding |
| `{{JURISDICAO_FISCAL}}` | país/UF de faturamento | regras de cobrança e retenção fiscal |
| `{{METODOS_PAGAMENTO}}` | lista, ex.: cartão, boleto, pix, nenhum | bloco SAAS-BILLING |
| `{{IDIOMA_DOMINIO}}` | idioma dos termos de negócio | NOME-IDIOMA-01 |
| `{{IDIOMA_COMMITS}}` | idioma das mensagens de commit | GIT-COMMIT-01 |
| `{{IDIOMA_CODIGO}}` | idioma de identificadores/comentários | NOME-IDIOMA-01 |
| `{{LOCAL_INVENTARIO}}` | caminho/URL do inventário central | DOC-INV-01 |
| `{{CATEGORIA_FORNECEDOR}}` | mapa categoria→fornecedor (gateway de pagamento, e-mail, error tracking, uptime, storage…) | instancia regras que citam categorias |

---

## ORDEM DE PRECEDÊNCIA

1. Instrução explícita do `{{OWNER}}` na sessão atual.
2. ADR aceito no repositório (`docs/adr/`).
3. Esta Constituição.
4. Arquivo de instruções do agente (CLAUDE.md ou equivalente).
5. Handbook (explicativo, nunca normativo).

Conflito entre níveis DEVE ser apontado antes de agir; nunca resolvido em silêncio.

---

## FILOSOFIA

1. **Toda camada existe por causa de uma dor real.** Nenhuma regra aqui é estética; se parece burocracia, consulte o Handbook antes de ignorar.
2. **Complexidade acompanha a dor.** Nível 3 só entra com dor medida. Antecipar escala é dívida, não prudência.
3. **Anti-destruição: big-bang é proibido.** Reescritas totais, migrações destrutivas de uma vez e "vamos recomeçar do zero" NÃO DEVEM ocorrer sem ADR aprovado pelo `{{DECISOR_TECNICO}}`.
4. **O básico vem de fábrica.** Validação, erros padronizados, migrations, backup e error tracking não são melhoria futura — nascem com o projeto.
5. **Adicionar > substituir.** A mudança segura acrescenta e deprecia; a perigosa remove e reescreve.
6. **A IA não protege se você não pedir.** Assistentes de código otimizam para "funcionar", não para "sobreviver". Esta Constituição é o pedido.
7. **Padrão executável > padrão escrito.** Regra que pode virar lint, teste ou script DEVE virar. `[M]` marca as candidatas.
8. **O padrão não corre na frente da prática.** Nova regra só entra depois de aplicada com sucesso em pelo menos um sistema real.

---

## GLOSSÁRIO DE TERMOS-GATILHO

- **Não-trivial**: mudança que toca dados de outro usuário, OU muda contrato de API público, OU altera fluxo de dinheiro/auth/permissão, OU toca migration/schema.
- **Crítico** (fluxo/rota/cron): participa de autenticação, cobrança, provisionamento, backup ou comunicação com cliente final.
- **Dor medida**: métrica registrada (latência, custo, erro, ticket de suporte) que ultrapassa limiar definido em ADR — nunca "acho que vai precisar".
- **Relevante** (log/alerta): acionável — alguém muda comportamento ao recebê-lo; caso contrário é ruído e DEVE ser removido.
- **Aplicada** (migration): já executada em qualquer ambiente compartilhado (staging/prod).
- **Checkpoint**: commit atômico + `ESTADO.md` atualizado no mesmo momento — a unidade mínima de progresso recuperável.
- **Fase**: bloco de trabalho que cabe numa única sessão de agente e fecha com checkpoint.

---

## PROTOCOLO DE CONTEXTO DO AGENTE CONSTRUTOR (§CTX — antes da primeira linha de código)

O maior risco do desenvolvimento assistido por IA não é código ruim — é **amnésia**: janela de contexto estourada no meio da tarefa, sessão nova que desconhece decisões da anterior, compactação que apaga o combinado. A defesa é estrutural: **a memória do projeto mora no repositório, nunca no chat.** O chat é descartável; o repo é permanente. Estas regras valem para QUALQUER porte, inclusive site simples.

- **CTX-KIT-01 [M]** NENHUM código antes do Kit de Partida completo: `git init` + `CLAUDE.md` + `ESTADO.md` + `docs/FASES.md` + `docs/adr/` + `docs/CORRECOES.md` + `.env.example` (SE há segredos). Templates prontos por porte: `KIT-DE-PARTIDA-UNIVERSAL.md`. Pedido de "só um site rapidinho" não dispensa o kit — dispensa camadas via `{{PORTE}}`, nunca a memória.
- **CTX-ESTADO-01 [M]** `ESTADO.md` é a memória viva do projeto e contém SEMPRE: fase atual, último checkpoint (hash + o que fechou), decisões tomadas na sessão corrente, próximos 3 passos concretos, bloqueios/pendências. Teste de validade: **uma sessão nova, lendo apenas `CLAUDE.md` + `ESTADO.md`, retoma o trabalho sem perguntar "onde paramos?"** — se precisar perguntar, o ESTADO.md reprovou.
- **CTX-FASE-01 [J]** Todo trabalho é quebrado em fases dimensionadas para **caber em uma sessão** (definidas em `docs/FASES.md` antes de começar). Fase que não fechou em uma sessão estava grande demais: dividir e registrar. Proibido "fazer o sistema inteiro" numa sessão só.
- **CTX-CHECKPOINT-01 [M]** Fase fechada = checkpoint (commit + `ESTADO.md`). Proibido acumular mais de uma fase sem checkpoint. Sinal de contexto ficando longo (resumos, compactação, perda de detalhe) → checkpoint IMEDIATO antes de qualquer outra ação.
- **CTX-RITUAL-01 [M]** Ritual de INÍCIO de sessão (nesta ordem, antes de tocar código): ler `CLAUDE.md` → `ESTADO.md` → ADRs recentes → `docs/CORRECOES.md` SE for tocar área já corrigida. Ritual de FIM de sessão: atualizar `ESTADO.md` → commit + push → pendências registradas. Sessão encerrada sem o ritual de fim é regressão de processo.
- **CTX-FONTE-01 [J]** Uma fonte de verdade por tipo de fato: decisão → ADR · correção → `CORRECOES.md` · estado/progresso → `ESTADO.md` · como rodar → `README` · regras do projeto p/ IA → `CLAUDE.md` · plano → `FASES.md`. Duplicar o mesmo fato em dois arquivos é proibido — referencie, não copie (cópia diverge e mente).
- **CTX-ECONOMIA-01 [J]** Economia de janela: referenciar arquivo por caminho em vez de colar conteúdo inteiro; ler somente o trecho necessário de arquivos grandes; `ESTADO.md` tem teto (~150 linhas) — fases concluídas são resumidas em 1 linha cada e o detalhe vai para `docs/HISTORICO.md`.
- **CTX-RESUMO-01 [M]** Toda decisão tomada em conversa (chat) que afeta o código DEVE ser gravada no arquivo-fonte correspondente (ADR/ESTADO/CLAUDE.md) ANTES do fim da sessão — decisão que existe só no chat não existe.

---

## ORDEM DE CONSTRUÇÃO (§ORD — a hierarquia das camadas)

Todo sistema tem uma ordem de dependência entre camadas. Construir fora dela gera as três falhas clássicas: tela bonita sobre modelo de dados errado (retrabalho total), "segurança a gente põe depois" (nunca chega), e infraestrutura de escala antes de existir usuário (over-engineering).

- **ORD-SEQ-01 [J]** As camadas nascem em ordem de dependência: **(1) modelo de dados + migrations → (2) fundação de segurança (auth, validação, posse — nasce JUNTO com a primeira rota, nunca "depois") → (3) serviços de domínio (backend) → (4) contrato de API → (5) frontend consumindo o contrato → (6) polimento/UX.** Frontend antes do contrato de API é proibido; contrato antes do modelo de dados é proibido. Exceção única: protótipo de UI explicitamente marcado como DESCARTÁVEL (mock, sem backend), que jamais vira base do código real.
- **ORD-TRANSVERSAL-01 [J]** Segurança, observabilidade e legibilidade NÃO são camadas — são transversais: acompanham toda fase desde o primeiro commit. "Fase de segurança" no fim do projeto é antipadrão.
- **ORD-VERTICAL-01 [J]** A ordem vale DENTRO de cada fatia vertical (CTX-FASE-01): cada fatia percorre dados → serviço → API → tela do SEU fluxo, na ordem, e entrega algo demonstrável. Construir "todo o backend" antes de qualquer tela (camada horizontal completa) é tão proibido quanto começar pela tela.
- **SCALE-READY-01 [M]** **Escalável-pronto por design, escalado por evidência.** Desde o dia 1 (custo ~zero): aplicação stateless (nenhum estado de usuário em memória de processo), sessão/cache externalizáveis, paginação e índices (DB-INDEX-01), jobs idempotentes, nada de filesystem local para dado de usuário, nada de singleton de processo para lock. Resultado obrigatório: **escalar = adicionar instância, nunca reescrever.** A escala CARA (load balancer, réplicas, sharding, filas distribuídas, edge) permanece Nível 3 — só com dor medida.

---

## NÍVEL 0 — PADRONIZAÇÃO (todo repositório nasce assim)

- **ARCH-DIR-01 [J]** Estrutura por módulos de domínio (`modules/` + `shared/`). Módulo A DEVE falar com B apenas pelo service público de B; importar repository/camada interna de outro módulo é proibido.
- **NOME-IDIOMA-01 [M]** Um idioma por dimensão, definido por `{{IDIOMA_DOMINIO}}`, `{{IDIOMA_CODIGO}}`, `{{IDIOMA_COMMITS}}`; nunca misturado dentro do mesmo projeto.
- **API-CONTRACT-01 [M]** Contrato único de API: codes de erro estáveis (string, não frase), formato de erro consistente com `requestId` no envelope, paginação uniforme. SE `{{PROTOCOLO_API}}`=REST ENTÃO envelope padrão como default (equivalente a RFC 9457/JSON:API). SE GraphQL/gRPC ENTÃO usar o mecanismo de erro nativo do protocolo mantendo codes estáveis e requestId.
- **VER-SEMVER-01 [M]** SemVer leve + CHANGELOG mantido; branch principal sempre deployável.
- **DOC-BASE-01 [M]** Documentos obrigatórios: **arquivo de instruções do agente** — `AGENTS.md` é o canônico (padrão aberto lido por múltiplas ferramentas); `CLAUDE.md`, `GEMINI.md` e equivalentes existem apenas como apontadores de 1 linha para ele (importar/referenciar, nunca copiar — CTX-FONTE-01). Ele declara a versão desta Constituição seguida + pendências de auditoria. Mais: `README.md`, `ESTADO.md`, `docs/FASES.md`, `docs/adr/`, `docs/CORRECOES.md` (ver §CTX e Kit de Partida). **Toda menção a "CLAUDE.md" neste padrão significa "o arquivo de instruções do agente".**
- **DOC-ADR-01 [J]** Decisão arquitetural não-trivial vira ADR-lite (contexto → decisão → consequências, ≤1 página) antes do código.
- **DOC-VIVA-01 [J]** Documentação nasce COM a feature, nunca depois: toda fase que cria funcionalidade só fecha o checkpoint com a documentação correspondente atualizada (README, doc técnica do módulo, doc de API). "Documentar tudo no final" é proibido — documento que não acompanha o sistema mente com autoridade. Ao terminar o sistema, a documentação está terminada junto.
- **DOC-API-01 [M]** Todo endpoint exposto é documentado no MESMO checkpoint que o cria: rota, entrada, saída, codes de erro e requisito de auth — em especificação (ex.: OpenAPI) ou `docs/API.md`. Webhooks emitidos documentados com payload, assinatura e política de retry.
- **DOC-INV-01 [M]** Todo sistema registrado no inventário central em `{{LOCAL_INVENTARIO}}` (nome, repo, deploy, fornecedores, responsável).
- **PIPE-SUPPLY-01 [M]** Supply chain travado: scope/registry de pacotes fixado, versões exatas em lockfile, proveniência verificada quando o ecossistema suportar, ações/steps de CI fixados por hash imutável (nunca tag móvel).
- **PIPE-DEPLOY-SCRIPT-01 [M]** Script de deploy robusto: aborta no primeiro erro, trata variável indefinida e falha em pipe como erro, lock contra execução concorrente.

---

## NÍVEL 1 — INEGOCIÁVEL (todo sistema, mesmo protótipo com 1 usuário)

### Arquitetura e código
- **ARCH-SOC-01 [J]** Separação de responsabilidades: rota/controller ≠ regra de negócio ≠ acesso a dados.
- **CODE-VALID-01 [M]** Validação por biblioteca de schema em TODA rota que recebe input (previne mass assignment e prototype pollution); campos não declarados são rejeitados.
- **CODE-ERR-01 [M]** Erros com status HTTP correto, mensagem segura (sem stack/SQL/paths) e `requestId` no envelope.
- **CODE-ENV-01 [M]** `.env` fora do repositório + `.env.example` completo e atualizado.
- **CODE-TYPE-01 [M]** Tipagem estrita quando a linguagem suporta; `any`/equivalente proibido salvo justificativa em comentário.
- **CODE-FAIL-01 [J]** try/catch na camada de dados; falha silenciosa proibida; UI com estados Loading/Empty/Error.

### AppSec base
- **SEC-SQLI-01 [M]** Queries parametrizadas via ORM/camada de acesso; concatenar input em query é proibido.
- **SEC-XSS-01 [M]** Escapar output + CSP ativa.
- **SEC-CSRF-01 [M]** Token anti-CSRF + cookie `SameSite` + verificação de Origin em mutações.
- **SEC-IDOR-01 [M]** Validar POSSE, não só identidade: `WHERE id = ? AND owner = ?` em todo acesso a recurso; preferir UUID a sequencial.
- **SEC-HEADERS-01 [M]** Headers: HSTS, CSP, X-Frame-Options, X-Content-Type-Options, Referrer-Policy. NÃO usar X-XSS-Protection (deprecado).
- **SEC-SSRF-01 [M]** SE o sistema busca URL influenciável por usuário ENTÃO allowlist de esquema+host, rejeitar IP privado/loopback/link-local/metadados de nuvem, e não seguir redirect para rede interna.
- **SEC-PAYLOAD-01 [M]** Teto de tamanho de corpo de requisição + teto rígido de itens por página imposto no servidor.
- **SEC-MEDIA-01 [M]** SE processa mídia ENTÃO validar dimensões e tamanho DESCOMPRIMIDO antes de decodificar.
- **SEC-UPLOAD-01 [M]** SE aceita upload ENTÃO: magic bytes (não extensão), limite de tamanho, nome sanitizado (anti path traversal), armazenado fora do diretório público, executáveis bloqueados; SVG/conteúdo ativo servido de origem isolada + `Content-Disposition: attachment` + sanitizado; parser XML com entidades externas e DTD desabilitados (anti XXE).
- **SEC-REDOS-01 [M]** Regex sem retrocesso exponencial ou executada sob timeout; comprimento do input limitado antes de avaliar.
- **SEC-REDIRECT-01 [M]** SE existe `returnUrl`/`next` ENTÃO allowlist de destino.
- **SEC-CONSTTIME-01 [M]** Comparação constant-time para token, assinatura e API key.
- **SEC-EMAIL-01 [M]** SE o domínio envia e-mail ENTÃO SPF + DKIM + DMARC com política de rejeição.

### Autenticação e sessão
- **AUTH-BUILD-01 [J]** Nunca construir auth do zero; usar solução madura da categoria em `{{CATEGORIA_FORNECEDOR}}` ou do framework.
- **AUTH-STORAGE-01 [M]** Token NUNCA em localStorage; cookie `HttpOnly + Secure + SameSite`.
- **AUTH-HASH-01 [M]** Senha com hash forte da família Argon2/Bcrypt; texto plano, MD5 e SHA1 proibidos.
- **AUTH-RBAC-01 [M]** RBAC desde o dia 1; servidor valida papel E posse em toda rota protegida; endpoints admin isolados.
- **AUTH-EXPIRE-01 [M]** Sessão/token com expiração + invalidação efetiva no logout.
- **AUTH-MFA-01 [M]** MFA/TOTP obrigatório para papéis administrativos.
- **AUTH-TOKEN-01 [M]** SE token stateless ENTÃO: revogável por denylist ou versão-por-usuário (logout, reset de senha e rebaixamento invalidam token vivo); algoritmo esperado fixado (rejeitar `alg: none` e troca assimétrico→simétrico); chave privada protegida; refresh token rotaciona com detecção de reuso.
- **AUTH-FAILCLOSED-01 [M]** Quando store de sessão ou de rate-limit cai, rotas sensíveis falham FECHADAS, nunca abertas.
- **AUTH-SESSION-01 [M]** SE sessão server-side ENTÃO regenerar ID de sessão no login e em elevação de privilégio.
- **AUTH-ENUM-01 [M]** Login e signup não revelam existência de conta: mensagem e timing uniformes.

### APIs expostas e webhooks emitidos
- **API-KEY-01 [M]** SE o sistema emite chaves de API para terceiros ENTÃO: chave exibida UMA única vez na criação; armazenada apenas como hash (nunca plaintext — vazamento de banco não pode virar comprometimento de todos os clientes); prefixo identificável para suporte/log; revogável individualmente; com escopo e rate limit próprios por chave; rotação sem downtime (duas chaves ativas durante a troca).
- **WEBHOOK-OUT-01 [M]** SE o sistema ENVIA webhooks ENTÃO: payload assinado (segredo por destino, verificável pelo receptor); `event_id` único para o receptor deduplicar; retry com backoff exponencial e limite de tentativas; falha persistente registrada e consultável; tudo documentado conforme DOC-API-01.

### Dados e migrations
- **DB-MIG-01 [M]** Schema versionado; migrations versionadas SEMPRE; push direto de schema em produção é proibido.
- **DB-INDEX-01 [M]** Índices em colunas de WHERE/JOIN/FK; consultas N+1 proibidas; paginação obrigatória em toda listagem.
- **DB-STORAGE-01 [M]** Arquivos de usuário em storage dedicado, nunca no filesystem do app.
- **DB-RLS-01 [M]** SE o banco é acessível com chave exposta no cliente ENTÃO RLS em 100% das tabelas é Nível 1.
- **DR-PREMIG-01 [M]** Toda migração precedida de snapshot imediato + lock anti-concorrência + timeout de DDL em tabela grande.

### Versionamento
- **GIT-INIT-01 [M]** Git desde o primeiro commit; editar código direto no servidor é proibido.
- **GIT-COMMIT-01 [M]** Commits em `{{IDIOMA_COMMITS}}`, atômicos e bisectáveis.

### Backup e recuperação
- **BKP-DUMP-01 [M]** Dump automático diário, **comprimido e criptografado** (nesta ordem: comprimir → criptografar; ambos OBRIGATÓRIOS), guardado FORA do host de origem; chave custodiada separada do host e do backup (DR-KEY).
- **BKP-RET-01 [M]** Retenção mínima: 7 diários + 4 semanais.
- **BKP-RESTORE-01 [M]** Restore testado ao menos uma vez antes do primeiro usuário real.
- **BKP-DEADMAN-01 [M]** Cron crítico com dead man's switch (alerta quando NÃO roda); verificação de sanidade do dump (tamanho mínimo) ANTES de pingar o healthcheck.

### Observabilidade
- **OBS-TRACK-01 [M]** Error tracking em frontend e backend antes do primeiro usuário.
- **OBS-LOG-01 [M]** Logs estruturados JSON com timestamp, userId, action, requestId; um `requestId` por requisição, propagado.
- **OBS-MASK-01 [M]** Data masking: segredo e PII nunca em log.
- **OBS-HEALTH-01 [M]** `/health` público mínimo (200 + ok); health detalhado (dependências) em rota interna/autenticada.
- **OBS-WORKER-01 [M]** Worker persiste status de erro do job ANTES de relançar exceção.

### Segredos
- **SECRETS-GITIGNORE-01 [M]** `.env` no `.gitignore` desde o commit 1; auditoria de vazamento no histórico.
- **SECRETS-LEAK-01 [M]** Segredo commitado: remover do índice, reescrever histórico com ferramenta atual, e ROTACIONAR a chave exposta — rotação é obrigatória, limpeza de histórico não a substitui.
- **SECRETS-SCOPE-01 [J]** Toda credencial com escopo mínimo necessário.

### Dependências
- **DEP-AUDIT-01 [M]** Audit antes de todo deploy; HIGH/CRITICAL bloqueia, COM válvula de escape: exceção registrada com data + issue, revisada a cada deploy.
- **DEP-HYGIENE-01 [M]** Outdated revisado periodicamente; libs não usadas removidas; devDependencies também auditadas.
- **DEP-QUARENTENA-01 [M]** Dependência nova só entra após triagem anti-supply-chain: nome conferido caractere a caractere no registro oficial (anti-typosquatting); pacote MADURO — amplamente adotado e mantido, nunca framework/lib recém-lançado da moda; **quarentena de release**: versão publicada há menos de ~14 dias não é adotada (mantenedor comprometido e pacote infectado — trojan/ransomware — são descobertos nos primeiros dias), exceção única: patch de segurança, que é o inverso (aplicar rápido); scripts de instalação desabilitados por padrão (`ignore-scripts` ou equivalente) e revisados quando indispensáveis; instalação SOMENTE do registro oficial — nunca de link, tarball ou repositório indicado por tutorial/chat.
- **DEP-MINIMAL-01 [J]** Antes de adicionar dependência, a pergunta obrigatória: precisa mesmo? Função pequena (poucas dezenas de linhas) escreve-se no projeto. Cada dependência é superfície de ataque e custo de manutenção permanentes.

### Legibilidade
- **LEG-COMMENT-01 [J]** Comentar o PORQUÊ, não o quê; JSDoc/docstring em todo service público; nomes autoexplicativos.
- **LEG-DEAD-01 [M]** Código morto comentado é proibido (o git guarda); TODO/FIXME com data + contexto.
- **LEG-CORRECOES-01 [J]** Bug não-trivial documentado em `docs/CORRECOES.md`: sintoma → causa → solução e porquê → alternativas rejeitadas → teste de regressão; referenciado no código corrigido.
- **LEG-HUMANO-01 [J]** Código gerado por IA é indistinguível de código profissional escrito por humano sênior. Régua objetiva — **teste dos 10 minutos**: um dev que nunca viu o projeto entende qualquer módulo em 10 minutos só com código + README. Proibido rastro de geração: comentário de processo ("aqui eu adicionei conforme pedido"), nome genérico (`data2`, `handleStuff`, `utils2`), estrutura que só faz sentido para quem viu o chat. O leitor futuro — humano ou IA — só tem o repositório.

### Infra e runtime
- **HARD-BASE-01 [M]** SE `{{MODELO_DEPLOY}}`=self-hosted ENTÃO: SSH só por chave e root desabilitado; firewall só 22/80/443; banco/cache só em localhost; fail2ban; atualizações de segurança automáticas; process manager nomeado e versionado; logrotate; monitorar expiração de TLS e de domínio; ciclo de vida de DNS — remover registro ao desprovisionar (anti subdomain takeover).
- **COST-API-01 [M]** SE consome API paga ENTÃO: budget/alerta no provedor; kill switch por env var; limite de tentativas + circuit breaker; custo estimado logado por operação.
- **ENV-SEP-01 [M]** Dev nunca aponta para prod; seeds com dados fake; dado real de cliente em ambiente de teste é proibido; migração destrutiva ensaiada em cópia antes.
- **RUN-SHUTDOWN-01 [M]** Tratar sinal de término drenando requisições/jobs em andamento; job interrompido é recuperável (marcado stalled + reprocessado).
- **RUN-QUOTA-01 [M]** SE existem cotas, limites ou operação que só pode ocorrer uma vez sob concorrência ENTÃO check-and-increment atômico (lock ou update condicional); ler-decidir-escrever é proibido.
- **CI-HARDEN-01 [M]** SE há CI/CD ENTÃO: negar execução privilegiada disparada por contribuição externa; token de automação com menor escopo; segredo nunca em log de build; cache isolado e validado.

### Camada SaaS — SE o sistema é SaaS
- **SAAS-ADR-01 [J]** Perguntas de produto (planos, limites, cobrança, offboarding) são respondidas ANTES de codar e viram ADR; a IA pergunta ao `{{OWNER}}`, nunca decide sozinha.
- **SAAS-TENANT-01 [M]** SE `{{MULTI_TENANT}}`=sim ENTÃO: `tenant_id` em toda tabela, decidido em ADR no dia 0; tenant vem da SESSÃO, nunca de payload/URL; posse validada em 2 níveis (tenant + owner); jobs/crons recebem tenant explícito; provisionamento de tenant é atômico.
- **SAAS-TENANT-02 [M]** Tenant scoping EXECUTÁVEL: `tenantId` é parâmetro obrigatório no repository OU extensão da camada de acesso injeta o filtro automaticamente — nunca depende de disciplina.
- **LLM-TENANT-01 [M]** SE `{{EXPOE_LLM}}`=sim E multi-tenant ENTÃO isolamento de tenant também em vector store, embeddings e cache de respostas.
- **SAAS-PLAN-01 [M]** SE há planos ENTÃO limite imposto no servidor com code de erro estável.
- **SAAS-BILLING-01 [M]** SE há cobrança ENTÃO: gateway de pagamento é a fonte da verdade, espelho local mínimo; estado `aguardando_pagamento`; acesso liberado no webhook CONFIRMADO, nunca no clique de retorno; webhook assinado + idempotente + ordenado (só-para-frente); reconciliação diária; dado/registro financeiro nunca deletado.
- **SAAS-OFFBOARD-01 [J]** Offboarding conforme `{{REGULACAO_DADOS}}`: export + exclusão/anonimização com prazo definido em ADR.
- **SAAS-EMAIL-01 [M]** E-mail transacional idempotente (chave por evento — reprocessar não reenvia).
- **SAAS-IMPERSONATE-01 [M]** Impersonation de usuário só com audit log completo (quem, quando, o quê).
- **LLM-PII-01 [M]** SE envia dado a LLM/terceiro ENTÃO minimizar e mascarar o payload de saída; subprocessador registrado com base legal e localidade.

---

## NÍVEL 2 — CLIENTE PAGANTE / PRODUÇÃO

- **PIPE-CICD-01 [M]** CI/CD real: build + testes + audit + deploy automatizado; deploy manual vira exceção documentada.
- **RATE-LIMIT-01 [M]** Rate limiting: login 5 tentativas/15min; atrás de proxy, `trust proxy` configurado para IP real; resposta 429 + headers informativos.
- **TEST-POSSE-01 [M]** Teste de posse com 2 contas (e 2 tenants SE multi-tenant): A não lê nem escreve dado de B.
- **PRIV-REG-01 [J]** `{{REGULACAO_DADOS}}` by design: base legal por dado coletado, consentimento onde exigido, minimização.
- **RUN-IDEMP-01 [M]** Idempotency keys/locks em operações de efeito externo (cobrança, e-mail, provisionamento).
- **RUN-RUNBOOK-01 [J]** Runbook de 1 página executável por terceiro sem contexto: subir, derrubar, restaurar, contatos.
- **OBS-UPTIME-01 [M]** Monitor de uptime externo ao host, com alerta.
- **RUN-INCIDENT-01 [J]** Processo de incidente: severidades SEV1-3 definidas, comunicação ao cliente durante outage, status page, timeline registrada.
- **RUN-ALERTS-01 [J]** Alertas com destino e plantão definidos + política anti-fadiga (alerta ignorado 2x é revisado ou removido).
- **PIPE-3P-01 [J]** Monitorar EOL e mudanças de API de libs/runtime/fornecedores; contingência documentada para SPOF de negócio (ex.: gateway de pagamento).
- **DR-RECONSTRUCT-01 [M]** SE self-hosted ENTÃO capacidade de reconstruir o servidor inteiro: proxy/cert/cron/env/firewall versionados ou snapshot; RTO/RPO definidos em ADR; reconstrução ensaiada ao menos 1x.
- **TEST-FLOW-01 [M]** Testes automatizados dos fluxos críticos (login, cobrança, provisionamento, fluxo principal do produto).
- **TEST-CONTRACT-01 [M]** Testes de contrato de API: shape do envelope, codes de erro e paginação não regridem.
- **TEST-MIGRATION-01 [M]** Migration testada sobre dados representativos (volume e forma reais) antes de prod.
- **TEST-SAAS-01 [M]** SE SaaS ENTÃO testar: webhook duplicado não duplica efeito; signup é atômico; limite de plano resiste a concorrência.
- **TEST-RESTORE-01 [M]** Ensaio recorrente (agendado) de restore de backup E de rollback de deploy.
- **SCALE-DATA-01 [J]** SE crescimento sustentado de dados ENTÃO política de particionamento/arquivamento/expurgo definida antes da dor.
- **SCALE-LOAD-01 [M]** Baseline de carga medido antes de onboarding grande (o número que o sistema aguenta hoje é conhecido).
- **PERF-FRONT-01 [J]** SE SPA/SSR ENTÃO orçamento de performance/UX: bundle, imagens otimizadas, métricas de web vitals acompanhadas.

---

## NÍVEL 3 — SÓ COM DOR MEDIDA

| Regra | Capacidade | Gatilho de ativação (dor medida) |
|---|---|---|
| SCALE-CACHE-01 [J] | Caching e CDN | latência/custo de origem medidos acima do limiar de ADR |
| SCALE-FLAG-01 [J] | Feature flags | necessidade real de rollout gradual/kill switch de feature |
| SCALE-EVENT-01 [J] | Eventos de domínio | existe o 2º consumidor REAL do evento (não previsto, real) |
| SCALE-LB-01 [J] | Load balancing | 1 instância saturada com tuning já feito |
| SCALE-HA-01 [J] | Réplicas / HA de banco | SLA contratado ou perda medida com indisponibilidade |
| SCALE-WAF-01 [J] | Rate limit avançado / WAF | ataque real ou abuso recorrente registrado |
| SCALE-QUEUE-01 [J] | Filas distribuídas | fila local/in-process estourando métricas |
| SCALE-APM-01 [J] | APM completo | debugging de latência distribuída virou dor recorrente |
| SAAS-PRORATION-01 [J] | Proration de planos | volume real de upgrades/downgrades no meio do ciclo |
| SAAS-DUNNING-01 [J] | Dunning avançado | inadimplência medida acima do limiar de ADR |
| SCALE-1-N-01 [M] | Checklist 1→N instâncias | antes de subir a 2ª instância: eliminar estado em memória, agendamento local único, locks de processo local, sessão pegajosa |
| SCALE-EDGE-01 [J] | Multi-região / edge | latência por geografia medida e relevante ao negócio |

---

## PERFIS CONDICIONAIS

Legenda: ● obrigatório · ◐ simplificado (versão mínima da regra) · ○ dispensado até mudar de perfil.

### Por porte do projeto (`{{PORTE}}`) — dosagem de rigor, nunca dispensa de memória
| Bloco | site-estático | app-simples | sistema | SaaS |
|---|---|---|---|---|
| §CTX (Kit de Partida, ESTADO.md, fases, rituais) | ● (kit mínimo) | ● | ● | ● |
| Nível 0 (padronização, ADR, IDs) | ◐ (CLAUDE+ESTADO+README) | ● | ● | ● |
| AppSec/Auth (Nível 1) | ◐ (HTTPS+headers; sem backend não há rotas) | ● no que existir | ● | ● |
| Backup (BKP-*) | ◐ (repo+deploy reproduzível bastam SE não há dados de usuário) | ● SE há dados | ● | ● |
| Pipeline em fases | ◐ (obter→construir→publicar→verificar) | ◐ | ● | ● |
| Observabilidade | ◐ (uptime externo) | ◐ (+error tracking) | ● | ● |
| Camada SaaS (SAAS-*) | ○ | ○ | ○ | ● |
| Nível 2 completo | ○ | SE cliente pagante | ● SE produção | ● |

### Por tamanho de time (`{{TAMANHO_TIME}}`)
| Bloco | Solo | 2-5 | 6-15 | 15+ |
|---|---|---|---|---|
| Nível 0 + Nível 1 | ● | ● | ● | ● |
| Code review humano em PR | ○ (auto-review com IA) | ◐ (1 aprovador) | ● | ● |
| CI/CD (PIPE-CICD-01) | ◐ (script local robusto) | ● | ● | ● |
| RUN-INCIDENT-01 / plantão | ◐ (só timeline) | ◐ | ● | ● |
| ADR formal com aprovação | ◐ (ADR-lite, auto-aprovado) | ● | ● | ● + comitê |
| Branch protection / trunk rules | ○ | ● | ● | ● |

### Por modelo de deploy (`{{MODELO_DEPLOY}}`)
| Bloco | self-hosted | PaaS | containers | serverless/imutável |
|---|---|---|---|---|
| HARD-BASE-01 | ● | ○ (delegado) | ◐ (host/orquestrador) | ○ |
| DR-RECONSTRUCT-01 | ● | ◐ (config as code) | ● (imagens+manifests) | ◐ |
| BKP-* (dados) | ● | ● | ● | ● |
| RUN-SHUTDOWN-01 | ● | ● | ● | ◐ (timeout da plataforma) |
| PIPE-DEPLOY-SCRIPT-01 | ● | ◐ | ● | ◐ |

---

## PIPELINE EM FASES UNIVERSAIS

Cada fase tem critério de passagem; falhou, não avança.

1. **OBTER** — código e dependências. Instalação determinística: lockfile respeitado, versão de runtime fixada. *Passa se:* instalação reproduzível do zero.
2. **VALIDAR** — lint + tipos + testes. *Passa se:* zero erro de tipo, testes verdes.
3. **CONSTRUIR** — build de produção. *Passa se:* build limpo, artefato gerado.
4. **VARRER** — audit de dependências + varredura de supply chain (PIPE-SUPPLY-01) + scan de segredos. *Passa se:* sem HIGH/CRITICAL não-excepcionado, sem segredo no artefato.
5. **PUBLICAR** — SE há migração de schema ENTÃO executar DR-PREMIG-01 (snapshot imediato ANTES + lock + timeout de DDL) e só então migrar; depois trocar a versão do app. *Passa se:* migração aplicada e app novo no ar.
6. **VERIFICAR** — smoke test dos fluxos críticos no ambiente real. *Passa se:* smoke verde; senão, reverter.
7. **OBSERVAR** — janela de monitoramento pós-deploy (erros, latência, filas). *Passa se:* métricas dentro do baseline.
8. **REVERTER** — plano sempre pronto. **Rollback de código NÃO desfaz migração**: migrations são forward-only; mudanças de schema seguem expand/contract (expandir compatível → migrar código → contrair depois), de modo que o app anterior continue funcionando sobre o schema novo.

---

## DESENVOLVIMENTO ASSISTIDO POR IA

**NUNCA, sem autorização explícita do `{{OWNER}}` na sessão:**
- **IA-DEL-01 [M]** Apagar código sem antes buscar usos (grep/referências) e apresentar o resultado.
- **IA-MIG-01 [M]** Alterar migration já aplicada — criar nova migration, sempre.
- **IA-REWRITE-01 [J]** Reescrever módulo inteiro quando o pedido era um ajuste.
- **IA-GUARD-01 [M]** Remover validação, rate limit, checagem de posse ou qualquer proteção existente.
- **IA-OBSOLETE-01 [J]** Presumir que código "parece não usado" está obsoleto.
- **IA-DESTRUCT-01 [M]** Executar comando destrutivo (drop, delete em massa, force push, rm recursivo) sem confirmação textual explícita.

**SEMPRE:**
- **IA-ADD-01 [J]** Preferir adicionar e depreciar a substituir e remover.
- **IA-CONTEXT-01 [M]** Cumprir o ritual CTX-RITUAL-01 (CLAUDE.md → ESTADO.md → ADRs → CORRECOES.md) antes de mudança não-trivial.
- **IA-FORMAT-01 [J]** Mudança estrutural proposta no formato obrigatório: **o que muda → por que → o que pode quebrar → como reverter**; aguardar aprovação antes de executar.
- **IA-EVIDENCE-01 [M]** Toda alegação de verificação ("testei", "funciona", "build passou", "deploy ok") acompanha a EVIDÊNCIA: saída do comando, do teste ou da requisição. Alegação sem evidência = não verificado, por definição — reportar sucesso presumido é a falha nº 1 de agente e é tratada como regressão de processo.

---

## DEFINIÇÃO DE PRONTO

Uma mudança está PRONTA quando:
- [M] Tipos e lint sem erro; testes existentes verdes; teste novo cobre o comportamento novo (SE não-trivial).
- [M] Validação de input presente em toda rota nova; posse verificada em todo acesso a recurso novo.
- [M] Migration versionada (SE toca schema) e reversível por expand/contract.
- [M] Sem segredo, PII ou log de debug no diff.
- [J] Erros tratados com estados de UI (SE frontend) e codes estáveis (SE API).
- [J] docs/CORRECOES.md atualizado (SE correção de bug não-trivial); ADR criado (SE decisão arquitetural).
- [J] CHANGELOG/commit descrevendo o PORQUÊ em `{{IDIOMA_COMMITS}}`.
- [M] Verificações alegadas acompanhadas de evidência (IA-EVIDENCE-01); código passa a régua LEG-HUMANO-01.
- [J] Documentação da entrega atualizada no mesmo checkpoint (DOC-VIVA-01; DOC-API-01 SE criou/alterou endpoint).

---

## GOVERNANÇA

- **GOV-POSTMORTEM-01 [J]** Incidente SEV1/SEV2 gera post-mortem lite (≤1 página, sem culpados): linha do tempo → causa → ação preventiva com dono e data. Ação preventiva que gera regra nova entra pelo gatilho de versão.
- **GOV-VERSION-01 [J]** Gatilho de versão da Constituição: nova regra só entra após aplicada com sucesso em ≥1 sistema real (Filosofia §8) e aprovada pelo `{{DECISOR_TECNICO}}`. Mudança de regra = minor; remoção ou mudança de significado = major. IDs nunca são renumerados nem reutilizados; regra removida mantém o ID marcado como `REVOGADA`.
- **GOV-SIZE-01 [M]** Teto de tamanho deste documento: ~430 linhas. Estourou: mover conteúdo explicativo para o Handbook antes de adicionar regra.
- **GOV-AUDIT-01 [M]** Script de auditoria mínima (checa itens [M] automatizáveis: headers, .env, lockfile, migrations, audit de deps) é PRÉ-REQUISITO do gatilho de versão — não backlog: regra [M] nova só entra acompanhada do check correspondente ou de exceção registrada.
- **GOV-ADOPT-01 [J]** Adoção em sistema existente: rodar auditoria → registrar lacunas como pendências no CLAUDE.md → priorizar Nível 1 → waivers temporários via ADR com prazo e dono, aprovados pelo `{{DECISOR_TECNICO}}`. Waiver sem prazo é inválido.
- **GOV-LICENSE-01 [M]** Este documento pertence a `{{ORG}}`; uso interno e derivação permitidos com manutenção dos IDs para rastreabilidade.

---
*Fim da Constituição v3.1 — Definitiva. Racionais e equivalências: Handbook. Templates e prompts (partida, retomada, instanciação): `KIT-DE-PARTIDA-UNIVERSAL.md`. Histórico: v2.0 = §CTX (anti-amnésia) + `{{PORTE}}` + Kit; v3.0 (validada em uso real) = §ORD, SCALE-READY-01, LEG-HUMANO-01, IA-EVIDENCE-01, instanciação como modo preferido; v3.1 = documentação viva (DOC-VIVA-01/DOC-API-01 — a doc nasce com a feature), APIs expostas e webhooks emitidos (API-KEY-01/WEBHOOK-OUT-01), backup comprimido+criptografado e quarentena anti-supply-chain de dependências (DEP-QUARENTENA-01/DEP-MINIMAL-01).*
