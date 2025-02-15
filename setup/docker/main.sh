#!/usr/bin/env bash
set -euo pipefail

url="${EXPORTER_REDIS_URL:-redis://localhost:6379/0}"
prefix="${EXPORTER_PREFIX:-bull}"
metric_prefix="${EXPORTER_STAT_PREFIX:-bull_queue_}"
queues="${EXPORTER_QUEUES:-}"
EXPORTER_AUTODISCOVER="${EXPORTER_AUTODISCOVER:-}"
REDIS_TLS_CA_FILE="${REDIS_TLS_CA_FILE:-}"

flags=(
  --url "$url"
  --prefix "$prefix"
  --metric-prefix "$metric_prefix"
)

if [[ "$EXPORTER_AUTODISCOVER" != 0 && "$EXPORTER_AUTODISCOVER" != 'false' ]] ; then
  flags+=(-a)
fi

if [[ -n ${REDIS_TLS_CA_FILE+x}  && "$REDIS_TLS_CA_FILE" != '' ]];  then 
  echo "REDIS_TLS_CA_FILE is set to '$REDIS_TLS_CA_FILE'"; 
  flags+=(--redisTlsCa="$REDIS_TLS_CA_FILE")
fi


# shellcheck disable=2206
flags+=($queues)

exec node dist/src/index.js "${flags[@]}"
