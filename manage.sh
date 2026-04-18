#!/bin/bash
# Quick management commands for Mailcow
MAILCOW_DIR="/opt/mailcow-dockerized"
cd "$MAILCOW_DIR" 2>/dev/null || { echo "Mailcow not installed. Run setup.sh first."; exit 1; }

case "$1" in
  start)   docker compose up -d ;;
  stop)    docker compose down ;;
  restart) docker compose restart ;;
  update)
    git pull
    docker compose pull
    docker compose up -d
    ;;
  logs)    docker compose logs -f --tail=100 "${2:-postfix-mailcow}" ;;
  status)  docker compose ps ;;
  backup)
    BACKUP_DIR="${2:-/opt/mailcow-backup}"
    mkdir -p "$BACKUP_DIR"
    cp mailcow.conf "$BACKUP_DIR/"
    docker compose exec mysql-mailcow mysqldump -u root --password="$(grep DBPASS mailcow.conf | cut -d= -f2)" mailcow > "$BACKUP_DIR/mailcow-db-$(date +%F).sql"
    echo "Backup saved to $BACKUP_DIR"
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|update|logs [service]|status|backup [dir]}"
    ;;
esac
