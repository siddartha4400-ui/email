# Mail Server Setup — hms.rest & cloudfy.com

Mailcow on Docker. Covers both domains with full SMTP/IMAP/webmail/spam filtering.

## Quick Start

### 1. On your VPS (Ubuntu 22.04, min 2GB RAM)

```bash
git clone <this-repo> /opt/email-setup
cd /opt/email-setup
sudo bash setup.sh
```

Takes ~5 min. When done, admin UI is live at `https://mail.hms.rest`.

### 2. Set DNS records

See [dns-records.md](dns-records.md) — add all records for both domains.

### 3. Add domains & mailboxes via API

```bash
# In Mailcow UI: Configuration → API → create key, paste into post-install.sh
sudo bash post-install.sh
```

### 4. Get DKIM keys & add to DNS

Mailcow UI → Configuration → ARC/DKIM keys → copy TXT value → add to DNS.

---

## Manage the server

```bash
bash manage.sh status     # show running containers
bash manage.sh logs       # tail postfix logs
bash manage.sh restart    # restart all services
bash manage.sh update     # pull latest Mailcow & restart
bash manage.sh backup     # dump DB + config
```

---

## Default credentials

| Item         | Value          |
|--------------|----------------|
| Admin UI     | https://mail.hms.rest |
| Username     | admin          |
| Password     | **moohoo** ← change immediately |

---

## Mailboxes created by post-install.sh

| Address              | Default password  |
|----------------------|-------------------|
| admin@hms.rest       | ChangeMe123!      |
| support@hms.rest     | ChangeMe123!      |
| admin@cloudfy.com    | ChangeMe123!      |
| support@cloudfy.com  | ChangeMe123!      |

Change all passwords in the admin UI after setup.

---

## Webmail

After DNS + SSL is set:  
`https://mail.hms.rest` → click "Webmail" (SOGo)

---

## Test deliverability

Send a test email to `check-auth@verifier.port25.com`  
Or use https://www.mail-tester.com — aim for 9+/10.

---

## Files

| File             | Purpose                          |
|------------------|----------------------------------|
| setup.sh         | Full server install (run once)   |
| post-install.sh  | Add domains + mailboxes via API  |
| manage.sh        | Start/stop/update/backup         |
| dns-records.md   | All DNS records for both domains |
