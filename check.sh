#!/usr/bin/env bash
# Verifica os sites de sites.txt. Um site só é dado como fora do ar depois de 3 tentativas
# seguidas sem resposta 2xx/3xx (evita alarme falso por lentidão passageira).
# Saída: arquivo down.txt com "nome|código|tempo" de cada site fora; resumo no GITHUB_STEP_SUMMARY.
set -uo pipefail

ATTEMPTS=3
WAIT_SECONDS=20
SIMULATE="${SIMULATE_DOWN:-false}"   # teste do alerta: inclui um endereço que nunca responde

: > down.txt
summary="| Site | Resultado | Código | Tempo |\n|---|---|---|---|\n"

sites=$(grep -v '^\s*#' sites.txt | grep '|')
if [ "$SIMULATE" = "true" ]; then
  sites="$sites
Teste de alerta (simulado)|https://10.255.255.1/"
fi

while IFS='|' read -r name url; do
  [ -z "$name" ] && continue
  ok=false
  for i in $(seq 1 "$ATTEMPTS"); do
    result=$(curl -s -o /dev/null -m 20 -L -w '%{http_code} %{time_total}' "$url" || true)
    code=${result%% *}; time=${result##* }
    if [[ "$code" =~ ^[23] ]]; then ok=true; break; fi
    [ "$i" -lt "$ATTEMPTS" ] && sleep "$WAIT_SECONDS"
  done
  code=${code:-000}
  if $ok; then
    summary+="| $name | 🟢 no ar | $code | ${time}s |\n"
  else
    summary+="| $name | 🔴 fora do ar | $code | ${time:-?}s |\n"
    echo "$name|$code|${time:-?}" >> down.txt
  fi
done <<< "$sites"

printf "%b" "$summary" | tee -a "${GITHUB_STEP_SUMMARY:-/dev/null}"
echo "Fora do ar: $(wc -l < down.txt)"
