#!/bin/bash
set -e

# ─────────────────────────────────────────────
# Mailcow Docker Mail Server – Full Setup Script
# Domains: hms.rest, cloudfy.com
# ─────────────────────────────────────────────

MAIL_HOSTNAME="mail.hms.rest"   # Change if needed
MAILCOW_DIR="/opt/mailcow-dockerized"

# ── Colors ──
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
log()  { echo -e "${GREEN}[✔]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[✘]${NC} $1"; exit 1; }

# ── Root check ──
[[ $EUID -ne 0 ]] && err "Run as root: sudo bash setup.sh"

# ── 1. System update ──
log "Updating system..."
apt-get update -qq && apt-get upgrade -y -qq

# ── 2. Install dependencies ──
log "Installing Docker & Docker Compose..."
apt-get install -y -qq curl git docker.io docker-compose

systemctl enable --now docker
log "Docker started."

# ── 3. Set hostname ──
log "Setting hostname to $MAIL_HOSTNAME..."
hostnamectl set-hostname "$MAIL_HOSTNAME"
echo "127.0.0.1 $MAIL_HOSTNAME" >> /etc/hosts

# ── 4. Open firewall ports ──
if command -v ufw &>/dev/null; then
  log "Configuring UFW firewall..."
  ufw allow 22/tcp   # SSH
  ufw allow 25/tcp   # SMTP
  ufw allow 80/tcp   # HTTP (Let's Encrypt)
  ufw allow 443/tcp  # HTTPS
  ufw allow 465/tcp  # SMTPS
  ufw allow 587/tcp  # Submission
  ufw allow 993/tcp  # IMAPS
  ufw allow 995/tcp  # POP3S
  ufw allow 4190/tcp # Sieve
  ufw --force enable
fi

# ── 5. Clone Mailcow ──
if [[ -d "$MAILCOW_DIR" ]]; then
  warn "Mailcow already cloned. Pulling latest..."
  git -C "$MAILCOW_DIR" pull
else
  log "Cloning Mailcow..."
  git clone https://github.com/mailcow/mailcow-dockerized "$MAILCOW_DIR"
fi

cd "$MAILCOW_DIR"

# ── 6. Generate config ──
if [[ -f mailcow.conf ]]; then
  warn "mailcow.conf already exists. Skipping generation."
else
  log "Generating Mailcow config..."
  MAILCOW_HOSTNAME="$MAIL_HOSTNAME" ./generate_config.sh
fi

# ── 7. Pull images & start ──
log "Pulling Docker images (this takes a few minutes)..."
docker compose pull

log "Starting Mailcow..."
docker compose up -d

# ── 8. Wait for health ──
log "Waiting 30s for services to initialize..."
sleep 30

# ── Done ──
echo ""
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo -e "${GREEN}  Mailcow is running!${NC}"
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo ""
echo "  Admin UI : https://$MAIL_HOSTNAME"
echo "  Username : admin"
echo "  Password : moohoo  ← CHANGE THIS IMMEDIATELY"
echo ""
echo "  Next steps:"
echo "  1. Login and change admin password"
echo "  2. Add domains: hms.rest and cloudfy.com"
echo "  3. Create mailboxes"
echo "  4. Set DNS records (see dns-records.md)"
echo "  5. Get DKIM keys from admin UI → Configuration → ARC/DKIM keys"
echo ""
