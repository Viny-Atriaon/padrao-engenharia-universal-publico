#!/usr/bin/env bash
# ============================================================================
# audit-runtime.sh — Auditoria do AMBIENTE EM EXECUÇÃO (TEST-RUNTIME-01)
# Constituição de Engenharia Universal v3.5
#
# O audit.sh lê o código parado; este script interroga o sistema RODANDO:
# headers reais, arquivos servidos, /health, portas em escuta, backup, IP real
# no log, prontidão e vida do worker. Regra que só existe no código não está
# verificada (GOV-ENFORCE-01, ponto 3: roda diariamente por agendador).
#
# Uso:
#   bash audit-runtime.sh caminho/audit-runtime.conf           # auditoria
#   bash audit-runtime.sh caminho/audit-runtime.conf --abuse   # + regressão de abuso
#
# Configuração: arquivo .conf do PROJETO (variáveis RT_*), ver exemplo em
# KIT-DE-PARTIDA §10. Variável vazia = checagem pulada (⏭️), nunca aprovada.
# Waiver (GOV-ADOPT-01): RT_WAIVERS="REGRA:alvo:AAAA-MM-DD ..." — dentro do
# prazo a falha vira ⚠️ com a data; vencido, volta a ser ❌.
#
# Saída: ✅ conforme · ❌ violação · ⚠️ atenção/waiver · ⏭️ não configurado
# Código de saída: 0 = sem violações · 1 = há violações ❌ · 2 = erro de uso
# Alerta: RT_ALERT_PUSH_URL recebe ?status=up|down&msg=... (monitor do tipo
# push, ex. Uptime Kuma) — o monitor também acusa quando o script NÃO roda.
# ============================================================================

set -u
CONF="${1:-}"
MODE="${2:-}"
[ -f "$CONF" ] || { echo "ERRO: arquivo de configuração não encontrado: $CONF"; exit 2; }
# shellcheck disable=SC1090
. "$CONF"

PASS=0; FAIL=0; WARN=0; SKIP=0; FAILED_IDS=""
TODAY=$(date +%Y-%m-%d)
ok()   { printf "✅ %-18s %s\n" "$1" "$2"; PASS=$((PASS+1)); }
warn() { printf "⚠️  %-18s %s\n" "$1" "$2"; WARN=$((WARN+1)); }
skip() { printf "⏭️  %-18s %s\n" "$1" "não configurado ($2)"; SKIP=$((SKIP+1)); }
bad() {
  # bad REGRA alvo mensagem — consulta waivers antes de reprovar
  local rule="$1" target="$2" msg="$3" w
  for w in ${RT_WAIVERS:-}; do
    local wr="${w%%:*}" rest="${w#*:}"; local wt="${rest%%:*}" wd="${rest##*:}"
    if [ "$wr" = "$rule" ] && { [ "$wt" = "$target" ] || [ "$wt" = "*" ]; }; then
      if [[ "$TODAY" < "$wd" || "$TODAY" == "$wd" ]]; then
        printf "⚠️  %-18s %s [waiver até %s]\n" "$rule" "$msg" "$wd"; WARN=$((WARN+1)); return
      fi
      msg="$msg [waiver VENCIDO em $wd]"
    fi
  done
  printf "❌ %-18s %s\n" "$rule" "$msg"; FAIL=$((FAIL+1)); FAILED_IDS="$FAILED_IDS $rule"
}

hdrs() { curl -s -o /dev/null -D - -m 15 "$1" 2>/dev/null | tr -d '\r'; }
code() { curl -s -o /dev/null -w '%{http_code}' -m "${2:-15}" "$1" 2>/dev/null; }
has_hdr() { printf '%s\n' "$1" | grep -qi "^$2:"; }

echo "============================================================"
echo " AUDITORIA EM EXECUÇÃO — ${RT_PROJECT:-projeto} — $(date '+%Y-%m-%d %H:%M')"
echo "============================================================"

# ---------- SEC-HEADERS-02: headers por tipo de resposta ----------
if [ -n "${RT_BASE_URL:-}" ]; then
  H=$(hdrs "$RT_BASE_URL/")
  MISSING=""
  for h in Strict-Transport-Security X-Frame-Options X-Content-Type-Options Referrer-Policy; do
    has_hdr "$H" "$h" || MISSING="$MISSING $h"
  done
  [ -z "$MISSING" ] && ok "SEC-HEADERS-02a" "HTML: HSTS, X-Frame-Options, nosniff, Referrer-Policy" \
                    || bad "SEC-HEADERS-02" "html" "HTML sem:$MISSING"
  if [ -n "${RT_API_PROBE:-}" ]; then
    H=$(hdrs "$RT_BASE_URL$RT_API_PROBE")
    { has_hdr "$H" Strict-Transport-Security && has_hdr "$H" X-Content-Type-Options; } \
      && ok "SEC-HEADERS-02b" "API ($RT_API_PROBE): HSTS + nosniff" \
      || bad "SEC-HEADERS-02" "api" "API ($RT_API_PROBE) sem HSTS ou nosniff"
  fi
  if [ -n "${RT_EMBED_PATH:-}" ]; then
    H=$(hdrs "$RT_BASE_URL$RT_EMBED_PATH")
    has_hdr "$H" X-Frame-Options \
      && bad "SEC-HEADERS-02" "embed" "rota embutível ($RT_EMBED_PATH) com X-Frame-Options — iframe do cliente quebra" \
      || ok "SEC-HEADERS-02c" "rota embutível sem X-Frame-Options (proposital)"
  fi
else skip "SEC-HEADERS-02" "RT_BASE_URL"; fi

# ---------- Arquivos sensíveis não servidos ----------
if [ -n "${RT_BASE_URL:-}" ]; then
  LEAK=""
  # Dotfiles: 404 sempre — até o fallback 200 do SPA confunde scanner e monitor
  for p in /.env /.git/config /.git/HEAD; do
    [ "$(code "$RT_BASE_URL$p")" = "200" ] && LEAK="$LEAK $p"
  done
  # Manifestos: reprova só se o CONTEÚDO real sair (o fallback HTML do SPA não vaza)
  for p in /package.json /composer.json /requirements.txt; do
    curl -s -m 10 "$RT_BASE_URL$p" 2>/dev/null | head -c 400 | grep -qE '"(dependencies|devDependencies|require)"|^[a-zA-Z0-9_.-]+==' && LEAK="$LEAK $p"
  done
  [ -z "$LEAK" ] && ok "SEC-DOTFILES" "/.env e /.git com 404; manifestos não servidos" \
                 || bad "SEC-DOTFILES" "http" "exposto:$LEAK"
fi

# ---------- OBS-HEALTH-01: /health público mínimo ----------
if [ -n "${RT_HEALTH_PUBLIC:-}" ]; then
  BODY=$(curl -s -m 15 "$RT_HEALTH_PUBLIC" 2>/dev/null)
  if printf '%s' "$BODY" | grep -qiE '"(pid|memory|heap|stack|version|node)"|errno|ECONN|prisma'; then
    bad "OBS-HEALTH-01" "health" "/health público expõe detalhe interno: $(printf '%s' "$BODY" | head -c 120)"
  elif [ -z "$BODY" ]; then
    bad "OBS-HEALTH-01" "health" "/health público não respondeu"
  else ok "OBS-HEALTH-01" "/health público mínimo ($(printf '%s' "$BODY" | head -c 60))"; fi
else skip "OBS-HEALTH-01" "RT_HEALTH_PUBLIC"; fi

# ---------- OBS-HEALTH-02: probe de prontidão ----------
if [ -n "${RT_HEALTH_READY:-}" ]; then
  c=$(code "$RT_HEALTH_READY" 20)
  [ "$c" = "200" ] && ok "OBS-HEALTH-02" "probe de prontidão 200" \
                   || bad "OBS-HEALTH-02" "ready" "probe de prontidão respondeu '$c'"
else skip "OBS-HEALTH-02" "RT_HEALTH_READY"; fi

# ---------- Bundle: source maps e segredos ----------
if [ -n "${RT_DIST_DIR:-}" ] && [ -d "${RT_DIST_DIR:-}" ]; then
  NMAP=$(find "$RT_DIST_DIR" -name '*.map' 2>/dev/null | wc -l | tr -d ' ')
  NREF=$(grep -rl 'sourceMappingURL' "$RT_DIST_DIR" --include='*.js' 2>/dev/null | wc -l | tr -d ' ')
  [ "$NMAP" = "0" ] && [ "$NREF" = "0" ] && ok "SEC-SOURCEMAP" "sem source maps no build publicado" \
    || bad "SEC-SOURCEMAP" "dist" "$NMAP arquivo(s) .map e $NREF referência(s) sourceMappingURL"
  SEC=$(grep -rlE '(sk_live_[A-Za-z0-9]{10,}|sk-ant-api[0-9]{2}-[A-Za-z0-9_-]{20,}|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{35}|-----BEGIN [A-Z ]*PRIVATE KEY-----)' "$RT_DIST_DIR" 2>/dev/null | head -3)
  [ -z "$SEC" ] && ok "SECRETS-BUNDLE" "nenhum padrão de segredo no build publicado" \
                || bad "SECRETS-BUNDLE" "dist" "padrão de segredo em: $(echo "$SEC" | tr '\n' ' ')"
else skip "SEC-SOURCEMAP" "RT_DIST_DIR"; fi

# ---------- NET-BIND-01: portas que só podem escutar no loopback ----------
if [ -n "${RT_LOOPBACK_ONLY_PORTS:-}" ]; then
  if command -v ss >/dev/null 2>&1; then
    LISTEN=$(ss -ltnH 2>/dev/null | awk '{print $4}')
  else
    # Windows: coluna 2 do netstat = endereço LOCAL (a 3 é o remoto, 0.0.0.0:0)
    LISTEN=$(netstat -ano -p TCP 2>/dev/null | awk '$4=="LISTENING"{print $2}'; netstat -ano -p TCPv6 2>/dev/null | awk '$4=="LISTENING"{print $2}')
  fi
  for p in $RT_LOOPBACK_ONLY_PORTS; do
    ADDRS=$(printf '%s\n' "$LISTEN" | grep -E "[:.]${p}\$" | sort -u)
    if [ -z "$ADDRS" ]; then warn "NET-BIND-01" "porta $p não está em escuta (serviço fora do ar?)"; continue; fi
    EXPOSED=$(printf '%s\n' "$ADDRS" | grep -vE '^(127\.|\[::1\]|::1|localhost)' | tr '\n' ' ')
    [ -z "$EXPOSED" ] && ok "NET-BIND-01" "porta $p só no loopback" \
                      || bad "NET-BIND-01" "$p" "porta $p exposta em: $EXPOSED"
  done
else skip "NET-BIND-01" "RT_LOOPBACK_ONLY_PORTS"; fi

# ---------- BKP-VERIFY-01 / BKP-REMEDIATE-01: backup recente, cifrado, sem legado em claro ----------
if [ -n "${RT_BACKUP_DIR:-}" ] && [ -d "${RT_BACKUP_DIR:-}" ]; then
  LAST=$(ls -t "$RT_BACKUP_DIR"/${RT_BACKUP_GLOB:-*} 2>/dev/null | head -1)
  if [ -z "$LAST" ]; then bad "BKP-VERIFY-01" "backup" "nenhum backup em $RT_BACKUP_DIR"
  else
    AGE_H=$(( ( $(date +%s) - $(stat -c %Y "$LAST") ) / 3600 ))
    [ "$AGE_H" -le "${RT_BACKUP_MAX_AGE_H:-26}" ] && ok "BKP-VERIFY-01a" "último backup há ${AGE_H}h ($(basename "$LAST"))" \
      || bad "BKP-VERIFY-01" "backup" "último backup há ${AGE_H}h (máx. ${RT_BACKUP_MAX_AGE_H:-26}h)"
    MAGIC=$(head -c 8 "$LAST" 2>/dev/null | od -An -c | tr -d ' \n')
    if [ "$MAGIC" = "Salted__" ] || ! head -c 2 "$LAST" | od -An -tx1 | grep -q '1f 8b'; then
      # Salted__ = openssl enc; e não pode ser gzip puro (1f 8b) nem texto SQL
      if head -c 200 "$LAST" | grep -qa 'PostgreSQL database dump\|CREATE TABLE'; then
        bad "BKP-VERIFY-01" "backup" "último backup é SQL legível — não está cifrado"
      else ok "BKP-VERIFY-01b" "último backup ilegível sem a chave"; fi
    else bad "BKP-VERIFY-01" "backup" "último backup é gzip puro — não está cifrado"; fi
  fi
  PLAIN=$(find "$RT_BACKUP_DIR" -maxdepth 1 -type f \( -name '*.sql' -o -name '*.sql.gz' -o -name '*.dump' \) 2>/dev/null | wc -l | tr -d ' ')
  [ "$PLAIN" = "0" ] && ok "BKP-REMEDIATE-01" "nenhum dump em claro na pasta de backup" \
                     || bad "BKP-REMEDIATE-01" "legado" "$PLAIN dump(s) em claro ainda na pasta de backup"
else skip "BKP-VERIFY-01" "RT_BACKUP_DIR"; fi

# ---------- RATE-LIMIT-03: IP real chega ao log ----------
if [ -n "${RT_ACCESS_LOG:-}" ] && [ -f "${RT_ACCESS_LOG:-}" ]; then
  IPS=$(tail -n 3000 "$RT_ACCESS_LOG" | grep -oE "${RT_ACCESS_LOG_IP_REGEX:-\"ip\":\"[^\"]*\"}" | sed -E 's/.*"([^"]*)"$/\1/; s/^::ffff://')
  TOTAL=$(printf '%s\n' "$IPS" | grep -c . || true)
  if [ "${TOTAL:-0}" -lt 20 ]; then warn "RATE-LIMIT-03" "poucas requisições no log ($TOTAL) para concluir"
  else
    # Público = fora de privado, loopback e faixas de documentação (usadas por testes)
    PUBLIC=$(printf '%s\n' "$IPS" | grep -vcE '^(10\.|127\.|172\.(1[6-9]|2[0-9]|3[01])\.|192\.168\.|192\.0\.2\.|198\.51\.100\.|203\.0\.113\.|::1|fd|fe80)' || true)
    TOP=$(printf '%s\n' "$IPS" | sort | uniq -c | sort -rn | head -1 | awk '{print $1" × "$2}')
    if [ "${PUBLIC:-0}" -gt 0 ]; then ok "RATE-LIMIT-03" "$PUBLIC de $TOTAL requisições com IP público no log (mais frequente: $TOP)"
    else bad "RATE-LIMIT-03" "log" "nenhum IP público em $TOTAL requisições — o proxy não repassa o IP real? (mais frequente: $TOP)"; fi
  fi
else skip "RATE-LIMIT-03" "RT_ACCESS_LOG"; fi

# ---------- OBS-WORKER-02: worker com sinal de vida ----------
if [ -n "${RT_WORKER_HEARTBEAT_FILE:-}" ]; then
  if [ -f "$RT_WORKER_HEARTBEAT_FILE" ]; then
    SIL=$(( ( $(date +%s) - $(stat -c %Y "$RT_WORKER_HEARTBEAT_FILE") ) / 60 ))
    [ "$SIL" -le "${RT_WORKER_MAX_SILENCE_MIN:-30}" ] && ok "OBS-WORKER-02" "worker deu sinal há ${SIL} min" \
      || bad "OBS-WORKER-02" "worker" "worker sem sinal há ${SIL} min (máx. ${RT_WORKER_MAX_SILENCE_MIN:-30})"
  else bad "OBS-WORKER-02" "worker" "arquivo de sinal do worker não existe: $RT_WORKER_HEARTBEAT_FILE"; fi
else skip "OBS-WORKER-02" "RT_WORKER_HEARTBEAT_FILE"; fi

# ---------- TEST-ABUSE-01 (opcional, --abuse) ----------
if [ "$MODE" = "--abuse" ]; then
  if [ -n "${RT_ABUSE_CMD:-}" ]; then
    echo "── rodando regressão de abuso…"
    if OUT=$(bash -c "$RT_ABUSE_CMD" 2>&1); then ok "TEST-ABUSE-01" "todas as defesas seguraram"
    else bad "TEST-ABUSE-01" "abuse" "defesa falhou: $(printf '%s' "$OUT" | grep -E 'FALHOU' | head -3 | tr '\n' ' ')"; fi
  else skip "TEST-ABUSE-01" "RT_ABUSE_CMD"; fi
fi

echo "============================================================"
printf " RESULTADO: %d ✅  ·  %d ❌  ·  %d ⚠️  ·  %d ⏭️\n" "$PASS" "$FAIL" "$WARN" "$SKIP"

# ---------- Alerta (monitor push: também acusa quando o script não roda) ----------
if [ -n "${RT_ALERT_PUSH_URL:-}" ]; then
  if [ "$FAIL" -gt 0 ]; then ST=down; MSG="falhas:${FAILED_IDS}"; else ST=up; MSG="ok ${PASS}/${WARN}w"; fi
  curl -s -m 10 -G "$RT_ALERT_PUSH_URL" --data-urlencode "status=$ST" --data-urlencode "msg=$MSG" >/dev/null 2>&1 \
    || echo " ⚠️ alerta push não entregue"
fi

if [ "$FAIL" -gt 0 ]; then echo " ❌ Violações:$FAILED_IDS"; exit 1; fi
echo " ✅ Sem violações no ambiente em execução."
exit 0
