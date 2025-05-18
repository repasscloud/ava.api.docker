#!/bin/bash

set -e

VOLUME_NAME="caddy_data"
BACKUP_FILE="caddy_data.tar.gz"

show_usage() {
  echo "Usage:"
  echo "  $0 backup    # Create backup of volume '${VOLUME_NAME}' into ${BACKUP_FILE}"
  echo "  $0 restore   # Restore '${VOLUME_NAME}' from ${BACKUP_FILE}"
  exit 1
}

case "$1" in
  backup)
    echo "📦 Backing up volume '${VOLUME_NAME}' to '${BACKUP_FILE}'..."
    docker run --rm \
      -v ${VOLUME_NAME}:/volume \
      -v "$(pwd)":/backup \
      alpine \
      tar czf /backup/${BACKUP_FILE} -C /volume .
    echo "✅ Backup complete."
    ;;
  restore)
    if [ ! -f "${BACKUP_FILE}" ]; then
      echo "❌ Backup file '${BACKUP_FILE}' not found in current directory."
      exit 2
    fi
    echo "♻️ Restoring volume '${VOLUME_NAME}' from '${BACKUP_FILE}'..."
    docker run --rm \
      -v ${VOLUME_NAME}:/volume \
      -v "$(pwd)":/backup \
      alpine \
      tar xzf /backup/${BACKUP_FILE} -C /volume
    echo "✅ Restore complete."
    ;;
  *)
    show_usage
    ;;
esac
