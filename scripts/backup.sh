#!/usr/bin/env bash
set -euo pipefail
# Usage: ./backup.sh
# Requires: sshpass, rclone installed and configured with rclone.conf in cwd

PANEL_URL="${PANEL_URL:-}"
PANEL_API_KEY="${PANEL_API_KEY:-}"
SERVER_ID="${SERVER_ID:-}"
SFTP_HOST="${SFTP_HOST:-}"
SFTP_PORT="${SFTP_PORT:-22}"
SFTP_USER="${SFTP_USER:-}"
SFTP_PASS="${SFTP_PASS:-}"
REMOTE_WORLD_PATH="${REMOTE_WORLD_PATH:-}"
RCLONE_REMOTE_NAME="${RCLONE_REMOTE_NAME:-}"

if [ -z "$PANEL_URL" ] || [ -z "$PANEL_API_KEY" ] || [ -z "$SERVER_ID" ]; then
  echo "Set PANEL_URL, PANEL_API_KEY and SERVER_ID environment variables"
  exit 1
fi

echo "Sending save command..."
curl -s -X POST "$PANEL_URL/api/client/servers/$SERVER_ID/command" \
  -H "Authorization: Bearer $PANEL_API_KEY" \
  -H "Accept: application/vnd.pterodactyl.v1+json" \
  -H "Content-Type: application/json" \
  -d '{"command":"save"}' || true

sleep 6

WORKDIR="$(pwd)/world_backup_$(date +%s)"
mkdir -p "$WORKDIR"

if [ -n "$SFTP_PASS" ]; then
  sshpass -p "$SFTP_PASS" sftp -oBatchMode=no -oStrictHostKeyChecking=no -P ${SFTP_PORT} ${SFTP_USER}@${SFTP_HOST} <<EOF
lcd $WORKDIR
cd $REMOTE_WORLD_PATH
mget *.wld *.wld.bak || true
bye
EOF
else
  echo "SFTP_PRIVATE_KEY not implemented in this wrapper script. Use the GitHub Actions workflow if using secrets."
  exit 1
fi

if [ -n "$RCLONE_REMOTE_NAME" ]; then
  TARGET="${RCLONE_REMOTE_NAME}:terraria-backups/${SERVER_ID}/$(date +%F_%H-%M-%S)"
  rclone --config=rclone.conf copy "$WORKDIR" "$TARGET" --create-empty-src-dirs
  echo "Uploaded to $TARGET"
else
  echo "RCLONE_REMOTE_NAME not set; backup stored locally in $WORKDIR"
fi
