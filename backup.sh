#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f "$SCRIPT_DIR/.env" ]; then
  set -a
  # shellcheck disable=SC1091
  source "$SCRIPT_DIR/.env"
  set +a
fi

: "${BACKUP_SRC:?BACKUP_SRC is not set}"
: "${BACKUP_DEST:?BACKUP_DEST is not set}"

if [ ! -d "$BACKUP_SRC" ]; then
  echo "[$(date '+%F %T')] ERROR: source '$BACKUP_SRC' not found" >&2
  exit 1
fi

DATE="$(date +%F)"
ARCHIVE="$BACKUP_DEST/backup-$DATE.tar.gz"

mkdir -p "$BACKUP_DEST"
/usr/bin/tar -czf "$ARCHIVE" -C "$(dirname "$BACKUP_SRC")" "$(basename "$BACKUP_SRC")"
echo "[$(date '+%F %T')] Backup created: $ARCHIVE ($(du -h "$ARCHIVE" | cut -f1))"

if [ -n "${WEBHOOK_URL:-}" ]; then
  /usr/bin/curl -fsS -m 10 -X POST -H 'Content-Type: application/json' \
    -d "{\"text\":\"Backup OK: $(basename "$ARCHIVE")\"}" "$WEBHOOK_URL" >/dev/null \
    && echo "[$(date '+%F %T')] Webhook sent" \
    || echo "[$(date '+%F %T')] WARN: webhook failed" >&2
fi
