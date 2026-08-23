#!/usr/bin/env bash
# ============================================================================
# audit.sh — Auditoria mínima da Constituição de Engenharia Universal v3.2
# Cumpre GOV-AUDIT-01: verifica mecanicamente as regras [M] automatizáveis.
#
# Uso:
#   bash audit.sh /caminho/do/projeto          # auditoria rápida (padrão)
#   bash audit.sh /caminho/do/projeto --deps   # inclui audit de dependências (lento)
#
# Saída: ✅ conforme · ❌ violação · ⚠️ atenção/manual · resumo ao final.
# Código de saída: 0 = sem violações · 1 = há violações ❌
# ============================================================================

set -u

DIR="${1:-.}"
DEPS="${2:-}"
cd "$DIR" 2>/dev/null || { echo "ERRO: diretório não encontrado: $DIR"; exit 2; }

PASS=0; FAIL=0; WARN=0
ok()   { printf "✅ %-24s %s\n" "$1" "$2"; PASS=$((PASS+1)); }
bad()  { printf "❌ %-24s %s\n" "$1" "$2"; FAIL=$((FAIL+1)); }
warn() { printf "⚠️  %-24s %s\n" "$1" "$2"; WARN=$((WARN+1)); }

echo "============================================================"
echo " AUDITORIA — Constituição Universal v3.2 — $(basename "$PWD")"
echo "============================================================"

# ---------- GIT-INIT-01: repositório git ----------
if [ -d .git ]; then ok "GIT-INIT-01" "repositório git presente"
else bad "GIT-INIT-01" "sem git — 'git init' é o passo 1 do Kit"; fi

# ---------- SECRETS-GITIGNORE-01: .env fora do repo ----------
if [ -d .git ]; then
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
  if grep -qsiE 'constitui[cç][aã]o.*(v[0-9]|universal)|padr[aã]o seguido' AGENTS.md CLAUDE.md 2>/dev/null; then
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
if [ -n "$MIGFOUND" ]; then
  ok "DB-MIG-01" "migrations versionadas ($MIGFOUND)"
else
  if [ -f prisma/schema.prisma ] || [ -f schema.sql ]; then bad "DB-MIG-01" "schema existe mas SEM migrations versionadas (risco de push direto)"
  else warn "DB-MIG-01" "sem banco detectado (ok SE o projeto não tem banco)"; fi
fi

# ---------- Varredura leve de segredos em arquivos rastreados ----------
if [ -d .git ]; then
  HITS=$(git grep -lIE '(sk-[A-Za-z0-9]{20,}|AKIA[0-9A-Z]{16}|-----BEGIN (RSA|EC|OPENSSH) PRIVATE KEY-----|xox[bp]-[0-9])' -- ':!*.md' 2>/dev/null | head -5)
  if [ -n "$HITS" ]; then bad "SECRETS-SCOPE-01" "padrão de segredo em arquivo rastreado: $(echo "$HITS" | tr '\n' ' ')"
  else ok "SECRETS-SCOPE-01" "nenhum padrão óbvio de segredo em arquivos rastreados"; fi
fi

# ---------- LEG-DEAD-01: TODO/FIXME sem data ----------
if [ -d .git ]; then
  NTODO=$(git grep -nE '(TODO|FIXME)' -- '*.ts' '*.tsx' '*.js' '*.jsx' '*.py' '*.go' 2>/dev/null | grep -vcE '20[0-9]{2}' || true)
  if [ "${NTODO:-0}" -gt 0 ]; then warn "LEG-DEAD-01" "$NTODO TODO/FIXME sem data/contexto"
  else ok "LEG-DEAD-01" "TODO/FIXME com data (ou inexistentes)"; fi
fi

# ---------- CODE-TYPE-01: any explícito (TS) ----------
if ls tsconfig.json >/dev/null 2>&1 && [ -d .git ]; then
  NANY=$(git grep -nE ':\s*any\b' -- '*.ts' '*.tsx' 2>/dev/null | grep -vc 'eslint-disable\|@ts-' || true)
  if [ "${NANY:-0}" -gt 0 ]; then warn "CODE-TYPE-01" "$NANY ocorrência(s) de ': any' — revisar/justificar"
  else ok "CODE-TYPE-01" "sem ': any' explícito"; fi
  if grep -qs '"strict" *: *true' tsconfig.json; then ok "CODE-TYPE-01b" "tsconfig strict ativo"
  else bad "CODE-TYPE-01b" "tsconfig SEM strict:true"; fi
fi

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
echo "── Manuais (não automatizáveis aqui): SEC-HEADERS-01 (headers em runtime),"
echo "   TEST-POSSE-01 (2 contas), BKP-* (cron no servidor), OBS-* (error tracking ativo)."

echo "============================================================"
printf " RESULTADO: %d ✅  ·  %d ❌  ·  %d ⚠️\n" "$PASS" "$FAIL" "$WARN"
if [ "$FAIL" -gt 0 ]; then
  echo " ❌ Violações encontradas — registrar como pendências no AGENTS.md (GOV-ADOPT-01)."
  exit 1
else
  echo " ✅ Sem violações [M] detectáveis. Pendências ⚠️ ficam a critério do {{OWNER}}."
  exit 0
fi
