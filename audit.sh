#!/usr/bin/env bash
# ============================================================================
# audit.sh — Auditoria do CÓDIGO da Constituição de Engenharia Universal v3.6
# Cumpre GOV-AUDIT-01: verifica mecanicamente as regras [M] automatizáveis.
# O ambiente EM EXECUÇÃO é auditado pelo audit-runtime.sh (TEST-RUNTIME-01).
# Roda no pre-push e no CI (GOV-ENFORCE-01, pontos 1 e 2).
#
# Uso:
#   bash audit.sh /caminho/do/projeto          # auditoria rápida (padrão)
#   bash audit.sh /caminho/do/projeto --deps   # inclui audit de dependências (lento)
#
# Saída: ✅ conforme · ❌ violação · ⚠️ atenção/manual · resumo ao final.
# Código de saída: 0 = sem violações · 1 = há violações ❌
# Waivers (GOV-ADOPT-01): arquivo .audit-waivers na raiz do projeto, uma linha
# por exceção — "REGRA AAAA-MM-DD motivo". Dentro do prazo a violação vira ⚠️;
# vencido, volta a ser ❌. Waiver sem data não é reconhecido.
# ============================================================================

set -u

DIR="${1:-.}"
DEPS="${2:-}"
cd "$DIR" 2>/dev/null || { echo "ERRO: diretório não encontrado: $DIR"; exit 2; }

PASS=0; FAIL=0; WARN=0
ok()   { printf "✅ %-24s %s\n" "$1" "$2"; PASS=$((PASS+1)); }
TODAY=$(date +%Y-%m-%d)
bad()  {
  local until=""
  [ -f .audit-waivers ] && until=$(awk -v r="$1" '$1==r && $2 ~ /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/ {print $2; exit}' .audit-waivers)
  if [ -n "$until" ] && { [[ "$TODAY" < "$until" ]] || [ "$TODAY" = "$until" ]; }; then
    printf "⚠️  %-24s %s [waiver até %s]\n" "$1" "$2" "$until"; WARN=$((WARN+1)); return
  fi
  [ -n "$until" ] && set -- "$1" "$2 [waiver VENCIDO em $until]"
  printf "❌ %-24s %s\n" "$1" "$2"; FAIL=$((FAIL+1))
}
warn() { printf "⚠️  %-24s %s\n" "$1" "$2"; WARN=$((WARN+1)); }

echo "============================================================"
echo " AUDITORIA — Constituição Universal v3.6 — $(basename "$PWD")"
echo "============================================================"

# ---------- GIT-INIT-01: repositório git ----------
# .git pode ser ARQUIVO (worktree, submódulo) — perguntar ao git, não ao sistema de arquivos
GITREPO=""; git rev-parse --is-inside-work-tree >/dev/null 2>&1 && GITREPO=1
in_git() { [ -n "$GITREPO" ]; }
if in_git; then ok "GIT-INIT-01" "repositório git presente"
else bad "GIT-INIT-01" "sem git — 'git init' é o passo 1 do Kit"; fi

# ---------- SECRETS-GITIGNORE-01: .env fora do repo ----------
if in_git; then
  if git ls-files | grep -qE '(^|/)\.env$'; then
    bad "SECRETS-GITIGNORE-01" ".env RASTREADO no git — remediar (SECRETS-LEAK-01) e ROTACIONAR chaves"
  else ok "SECRETS-GITIGNORE-01" ".env não rastreado"; fi
  if git log --all --oneline --full-history -- .env 2>/dev/null | head -1 | grep -q .; then
    bad "SECRETS-LEAK-01" ".env já esteve no HISTÓRICO — chaves comprometidas: rotacionar"
  else ok "SECRETS-LEAK-01" "sem .env no histórico"; fi
fi
if grep -qsE '(^|/)\.env' .gitignore 2>/dev/null; then ok "CODE-ENV-01a" ".env no .gitignore"
else bad "CODE-ENV-01a" ".env ausente do .gitignore"; fi
if [ -f .env.example ]; then ok "CODE-ENV-01b" ".env.example presente"
else warn "CODE-ENV-01b" "sem .env.example (obrigatório SE o projeto usa segredos)"; fi

# ---------- Kit de Partida / §CTX ----------
if [ -f AGENTS.md ]; then ok "DOC-BASE-01a" "AGENTS.md presente (canônico)"
elif [ -f CLAUDE.md ]; then warn "DOC-BASE-01a" "só CLAUDE.md — migrar p/ AGENTS.md canônico + apontador"
else bad "DOC-BASE-01a" "sem arquivo de instruções do agente (AGENTS.md)"; fi
[ -f ESTADO.md ]          && ok "CTX-ESTADO-01" "ESTADO.md presente"        || bad "CTX-ESTADO-01" "sem ESTADO.md — a memória viva não existe"
[ -f README.md ]          && ok "DOC-BASE-01b" "README.md presente"         || bad "DOC-BASE-01b" "sem README.md"
[ -f docs/FASES.md ]      && ok "CTX-FASE-01" "docs/FASES.md presente"      || warn "CTX-FASE-01" "sem docs/FASES.md — plano de fases não registrado"
[ -d docs/adr ]           && ok "DOC-ADR-01" "docs/adr/ presente"           || warn "DOC-ADR-01" "sem docs/adr/ — decisões sem registro"
[ -f docs/CORRECOES.md ]  && ok "LEG-CORRECOES-01" "docs/CORRECOES.md presente" || warn "LEG-CORRECOES-01" "sem docs/CORRECOES.md"
if [ -f docs/PONTOS-DE-RESTAURACAO.md ]; then
  ok "CTX-RESTORE-01" "docs/PONTOS-DE-RESTAURACAO.md presente"
  # entradas PR-NNN devem referenciar hash de commit — sem hash, o ponto não é restaurável
  NPR=$(grep -cE '^## PR-[0-9]+' docs/PONTOS-DE-RESTAURACAO.md || true)
  if [ "${NPR:-0}" -gt 0 ]; then
    NHASH=$(grep -cE '\*\*Commit:\*\*.*[0-9a-f]{7,40}' docs/PONTOS-DE-RESTAURACAO.md || true)
    if [ "${NHASH:-0}" -ge "$NPR" ]; then ok "CTX-RESTORE-01b" "$NPR ponto(s) de restauração, todos com hash"
    else bad "CTX-RESTORE-01b" "$((NPR-NHASH)) entrada(s) PR sem hash de commit — ponto não restaurável"; fi
  fi
else
  warn "CTX-RESTORE-01" "sem docs/PONTOS-DE-RESTAURACAO.md — checkpoints sem mapa de restauração"
fi
if [ -f AGENTS.md ] || [ -f CLAUDE.md ]; then
  # alternância em vez de [aã]: fora de locale UTF-8 a classe compara 1 byte e "ã" tem 2
  if grep -qsiE 'constitui(c|ç)(a|ã)o.*(v[0-9]|universal)|padr(a|ã)o seguido' AGENTS.md CLAUDE.md 2>/dev/null; then
    ok "DOC-BASE-01c" "versão do padrão declarada"
  else warn "DOC-BASE-01c" "arquivo de instruções não declara a versão do padrão que segue"; fi
fi

# ---------- PIPE-SUPPLY-01: lockfile + runtime fixado + ignore-scripts ----------
LOCKFOUND=""
for lf in package-lock.json pnpm-lock.yaml yarn.lock bun.lockb Gemfile.lock poetry.lock uv.lock go.sum Cargo.lock; do
  [ -f "$lf" ] && LOCKFOUND="$lf" && break
done
if [ -n "$LOCKFOUND" ]; then
  ok "PIPE-SUPPLY-01a" "lockfile presente ($LOCKFOUND)"
else
  [ -f package.json ] && bad "PIPE-SUPPLY-01a" "package.json SEM lockfile — instalação não determinística" \
                      || warn "PIPE-SUPPLY-01a" "nenhum lockfile reconhecido (stack não-node? verificar manualmente)"
fi
if [ -f package.json ]; then
  if [ -f .nvmrc ] || grep -qs '"engines"' package.json; then ok "PIPE-SUPPLY-01b" "runtime fixado (engines/.nvmrc)"
  else warn "PIPE-SUPPLY-01b" "runtime não fixado — adicionar engines ou .nvmrc"; fi
  if grep -qs 'ignore-scripts *= *true' .npmrc 2>/dev/null; then ok "DEP-QUARENTENA-01" "ignore-scripts ativo no .npmrc"
  else warn "DEP-QUARENTENA-01" "ignore-scripts não configurado — scripts de instalação rodam livres"; fi
fi

# ---------- DB-MIG-01: migrations versionadas ----------
MIGFOUND=""
for md in prisma/migrations migrations db/migrations database/migrations alembic supabase/migrations; do
  [ -d "$md" ] && MIGFOUND="$md" && break
done
# monorepo: procura também abaixo de apps/, packages/ e services/
[ -z "$MIGFOUND" ] && MIGFOUND=$(find apps packages services -maxdepth 3 -type d \( -path '*/prisma/migrations' -o -path '*/db/migrations' -o -path '*/supabase/migrations' \) 2>/dev/null | head -1)
SCHEMA=$( { ls prisma/schema.prisma schema.sql 2>/dev/null; find apps packages services -maxdepth 3 -name schema.prisma 2>/dev/null; } | head -1)
if [ -n "$MIGFOUND" ]; then
  ok "DB-MIG-01" "migrations versionadas ($MIGFOUND)"
else
  if [ -n "$SCHEMA" ]; then bad "DB-MIG-01" "schema existe mas SEM migrations versionadas (risco de push direto)"
  else warn "DB-MIG-01" "sem banco detectado (ok SE o projeto não tem banco)"; fi
fi

# ---------- Varredura leve de segredos em arquivos rastreados ----------
if in_git; then
  # placeholders (sk-xxxx…, AKIAXXXX…) não contam — só valores com aparência real
  HITS=$(git grep -nIE '(sk-[A-Za-z0-9]{20,}|AKIA[0-9A-Z]{16}|-----BEGIN (RSA|EC|OPENSSH) PRIVATE KEY-----|xox[bp]-[0-9])' -- ':!*.md' 2>/dev/null \
    | grep -vE '(sk-|AKIA)(x{8,}|X{8,}|0{8,})' | cut -d: -f1 | sort -u | head -5)
  if [ -n "$HITS" ]; then bad "SECRETS-SCOPE-01" "padrão de segredo em arquivo rastreado: $(echo "$HITS" | tr '\n' ' ')"
  else ok "SECRETS-SCOPE-01" "nenhum padrão óbvio de segredo em arquivos rastreados"; fi
fi

# ---------- LEG-DEAD-01: TODO/FIXME sem data ----------
if in_git; then
  NTODO=$(git grep -nE '(TODO|FIXME)' -- '*.ts' '*.tsx' '*.js' '*.jsx' '*.py' '*.go' 2>/dev/null | grep -vcE '20[0-9]{2}' || true)
  if [ "${NTODO:-0}" -gt 0 ]; then warn "LEG-DEAD-01" "$NTODO TODO/FIXME sem data/contexto"
  else ok "LEG-DEAD-01" "TODO/FIXME com data (ou inexistentes)"; fi
fi

# ---------- CODE-TYPE-01: any explícito (TS) ----------
if ls tsconfig.json >/dev/null 2>&1 && in_git; then
  NANY=$(git grep -nE ':\s*any\b' -- '*.ts' '*.tsx' 2>/dev/null | grep -vc 'eslint-disable\|@ts-' || true)
  if [ "${NANY:-0}" -gt 0 ]; then warn "CODE-TYPE-01" "$NANY ocorrência(s) de ': any' — revisar/justificar"
  else ok "CODE-TYPE-01" "sem ': any' explícito"; fi
  if grep -qs '"strict" *: *true' tsconfig.json; then ok "CODE-TYPE-01b" "tsconfig strict ativo"
  else bad "CODE-TYPE-01b" "tsconfig SEM strict:true"; fi
fi

# ========== Regras v3.3–v3.5 verificáveis no código ==========

# ---------- IA-ENCODING-01: arquivos de texto sem mojibake nem BOM ----------
if in_git; then
  # Uma passada só (xargs): por arquivo custaria minutos no Windows e o pre-push viraria regra pulada.
  # LC_ALL=C compara BYTES — em locale UTF-8 o grep rejeitaria byte solto na classe.
  ENC_FILES=$(git ls-files -z -- '*.ts' '*.tsx' '*.js' '*.jsx' '*.mjs' '*.py' '*.go' '*.json' '*.yml' '*.yaml' '*.sh' '*.ps1' '*.conf' 2>/dev/null \
    | xargs -0 -r env LC_ALL=C grep -lE $'\xc3\x83[\xc2][\xa3\xa7\xa9\xa1\xb3\xaa\xad\xb5]|\xc3\xa2\xe2\x82\xac' 2>/dev/null)
  # BOM UTF-8: só conta se estiver na 1ª linha do arquivo
  BOM_FILES=$(git ls-files -z -- '*.ts' '*.tsx' '*.js' '*.jsx' '*.mjs' '*.py' '*.json' '*.yml' '*.yaml' '*.sh' '*.conf' 2>/dev/null \
    | xargs -0 -r env LC_ALL=C grep -lE $'^\xef\xbb\xbf' 2>/dev/null \
    | while IFS= read -r f; do [ "$(head -c 3 "$f" | od -An -tx1 | tr -d ' ')" = "efbbbf" ] && echo "$f(BOM)"; done)
  ENC_BAD=$(printf '%s\n%s\n' "$ENC_FILES" "$BOM_FILES" | grep -v '^$' | tr '\n' ' ')
  if [ -z "$ENC_BAD" ]; then ok "IA-ENCODING-01" "código sem mojibake e sem BOM"
  else bad "IA-ENCODING-01" "encoding corrompido em:$(echo "$ENC_BAD" | tr ' ' '\n' | head -5 | tr '\n' ' ')"; fi
fi

# ---------- NET-BIND-01 (estático): portas publicadas pelo compose com host IP explícito ----------
COMPOSE=$(ls docker-compose*.yml docker-compose*.yaml compose*.yml compose*.yaml 2>/dev/null)
if [ -n "$COMPOSE" ]; then
  # "- 5432:5432" ou "- '6380:6379'" sem 127.0.0.1 na frente = escuta em todas as interfaces
  OPEN=$(grep -nE '^\s*-\s*["'"'"']?[0-9]{2,5}:[0-9]{2,5}' $COMPOSE 2>/dev/null | grep -v '127\.0\.0\.1' | head -5)
  if [ -z "$OPEN" ]; then ok "NET-BIND-01" "portas do compose presas ao loopback"
  else bad "NET-BIND-01" "porta publicada em todas as interfaces: $(echo "$OPEN" | tr -s ' ' | tr '\n' ';' | head -c 200)"; fi
fi

# ---------- SCALE-CAP-01: capacidade e hardware registrados no ESTADO.md ----------
if [ -f ESTADO.md ]; then
  if grep -qiE 'n[uú]cleos|cores' ESTADO.md && grep -qiE '[0-9]+ ?req/s' ESTADO.md; then
    ok "SCALE-CAP-01" "ESTADO.md registra hardware e teto medido (req/s)"
  else warn "SCALE-CAP-01" "ESTADO.md sem hardware (núcleos) e/ou teto medido em req/s"; fi
fi

# ---------- TEST-LOAD-01 / TEST-ABUSE-01 / TEST-RUNTIME-01: testes versionados ----------
if in_git; then
  LOADT=$(git ls-files | grep -iE '(load|carga|stress).*(test|teste)|loadtest' | head -1)
  # exige caminho de TESTE — o arquivo da própria defesa (ex.: abuseGuard.ts) não conta
  ABUSET=$(git ls-files | grep -iE 'abuse|abuso' | grep -iE '(test|teste|spec|regress|resilien)' | grep -iE '\.(js|ts|py|sh|go)$' | head -1)
  RTCONF=$(git ls-files | grep -E 'audit-runtime\.conf$' | head -1)
  [ -n "$LOADT" ]  && ok "TEST-LOAD-01" "teste de carga versionado ($LOADT)"     || warn "TEST-LOAD-01" "nenhum teste de carga versionado no repositório"
  [ -n "$ABUSET" ] && ok "TEST-ABUSE-01" "regressão de abuso versionada ($ABUSET)" || warn "TEST-ABUSE-01" "nenhuma regressão de defesa contra abuso versionada"
  [ -n "$RTCONF" ] && ok "TEST-RUNTIME-01" "auditoria do ambiente configurada ($RTCONF)" || warn "TEST-RUNTIME-01" "sem audit-runtime.conf — o sistema rodando não é auditado"
fi

# ---------- GOV-ENFORCE-01: os pontos de execução existem ----------
if in_git; then
  # O hook precisa estar VERSIONADO (vale para todo clone) e, fora do CI, ATIVADO neste clone
  VHOOK=$(git ls-files .githooks/pre-push .husky/pre-push 2>/dev/null | head -1)
  if [ -n "$VHOOK" ] && grep -q 'audit' "$VHOOK" 2>/dev/null; then
    ok "GOV-ENFORCE-01a" "pre-push versionado roda a auditoria ($VHOOK)"
    if [ -z "${CI:-}" ]; then
      HP=$(git config core.hooksPath 2>/dev/null || true)
      [ "$HP" = "$(dirname "$VHOOK")" ] || warn "GOV-ENFORCE-01a" "hook versionado mas NÃO ativado neste clone: git config core.hooksPath $(dirname "$VHOOK")"
    fi
  else bad "GOV-ENFORCE-01a" "sem pre-push versionado rodando a auditoria (.githooks/pre-push + git config core.hooksPath .githooks)"; fi
  if ls .github/workflows/*.yml .github/workflows/*.yaml .gitlab-ci.yml 2>/dev/null | head -1 | grep -q .; then
    if grep -qs 'audit\.sh' .github/workflows/*.y*ml .gitlab-ci.yml 2>/dev/null; then ok "GOV-ENFORCE-01b" "CI roda o audit.sh"
    else bad "GOV-ENFORCE-01b" "CI existe mas não roda o audit.sh"; fi
  else warn "GOV-ENFORCE-01b" "sem CI — ponto 2 da GOV-ENFORCE-01 ausente"; fi
fi

# ========== v3.6: varredura de segurança em camadas (Kit §11) ==========

# epoch de uma data AAAA-MM-DD (GNU date ou BSD date)
epoch() { date -d "$1" +%s 2>/dev/null || date -j -f %Y-%m-%d "$1" +%s 2>/dev/null; }

# ---------- SEC-SCAN-01: o ESTADO.md registra a última rodada de cada camada ----------
if [ -f ESTADO.md ]; then
  if grep -qiE '^## +Varreduras de seguran(ç|c)a' ESTADO.md; then ok "SEC-SCAN-01" "ESTADO.md registra as varreduras de segurança"
  else bad "SEC-SCAN-01" "ESTADO.md sem a seção \"Varreduras de segurança\" (Kit §3 e §11)"; fi
fi

# ---------- SEC-REVIEW-01: revisão de segurança do diff no CI, ação fixada por hash ----------
WFS=$(ls .github/workflows/*.yml .github/workflows/*.yaml 2>/dev/null)
if [ -n "$WFS" ]; then
  if grep -qsE 'claude-code-security-review@[0-9a-f]{40}' $WFS; then ok "SEC-REVIEW-01" "CI roda a revisão de segurança do diff, ação fixada por hash"
  elif grep -qsE 'claude-code-security-review@' $WFS; then bad "SEC-REVIEW-01" "revisão de segurança no CI com tag móvel — fixe a ação por hash (PIPE-SUPPLY-01)"
  elif grep -qsiE 'security-review' $WFS; then ok "SEC-REVIEW-01" "CI roda uma revisão de segurança do diff (instância equivalente)"
  else bad "SEC-REVIEW-01" "CI não roda revisão de segurança do diff (Kit §11)"; fi
else
  warn "SEC-REVIEW-01" "sem CI — rode /security-review no fim de cada fase e registre no ESTADO.md"
fi

# ---------- SEC-AUDIT-01 / TEST-PENTEST-01: rodada registrada há no máximo 92 dias ----------
# Primeira data de cada linha do ESTADO.md que cita a regra = "última rodada" (template do Kit §3).
for RULE in SEC-AUDIT-01 TEST-PENTEST-01; do
  last=""
  if [ -f ESTADO.md ]; then
    last=$(grep -h "$RULE" ESTADO.md | while IFS= read -r l; do printf '%s\n' "$l" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1; done | sort | tail -1)
  fi
  if [ -z "$last" ]; then
    warn "$RULE" "nenhuma rodada registrada no ESTADO.md (obrigatória antes do 1º cliente pagante)"
  else
    now_s=$(epoch "$TODAY"); last_s=$(epoch "$last")
    if [ -n "$now_s" ] && [ -n "$last_s" ]; then
      age=$(( (now_s - last_s) / 86400 ))
      if [ "$age" -le 92 ]; then ok "$RULE" "última rodada em $last ($age dias)"
      else bad "$RULE" "última rodada em $last — passou de 92 dias (cadência trimestral, Kit §11)"; fi
    else warn "$RULE" "última rodada em $last (não foi possível calcular a idade)"; fi
  fi
done

# ---------- DEP-AUDIT-01 (opcional, --deps) ----------
if [ "$DEPS" = "--deps" ] && [ -f package.json ]; then
  echo "── rodando npm audit (pode demorar)…"
  AUD=$(npm audit --audit-level=high 2>&1 | tail -3)
  if echo "$AUD" | grep -qiE 'high|critical'; then bad "DEP-AUDIT-01" "vulnerabilidades HIGH/CRITICAL: $AUD"
  else ok "DEP-AUDIT-01" "sem HIGH/CRITICAL"; fi
else
  warn "DEP-AUDIT-01" "não executado (rode com --deps para incluir)"
fi

# ---------- Itens que exigem verificação manual/em runtime ----------
echo "── No ambiente em execução (audit-runtime.sh): headers, /health, portas, backup cifrado,"
echo "   IP real no log, worker vivo. Manuais: TEST-POSSE-01 (2 contas), OBS-TRACK-01."

echo "============================================================"
printf " RESULTADO: %d ✅  ·  %d ❌  ·  %d ⚠️\n" "$PASS" "$FAIL" "$WARN"
if [ "$FAIL" -gt 0 ]; then
  echo " ❌ Violações encontradas — registrar como pendências no AGENTS.md (GOV-ADOPT-01)."
  exit 1
else
  echo " ✅ Sem violações [M] detectáveis. Pendências ⚠️ ficam a critério do {{OWNER}}."
  exit 0
fi
