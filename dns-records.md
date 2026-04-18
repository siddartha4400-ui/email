# DNS Records for hms.rest & cloudfy.com

Set these in your domain registrar / DNS provider (Cloudflare, Namecheap, etc.)

> Replace `YOUR_VPS_IP` with your actual server IP address.

---

## Domain 1 — hms.rest

| Type  | Host            | Value                              | TTL  |
|-------|-----------------|------------------------------------|------|
| A     | mail            | YOUR_VPS_IP                        | 3600 |
| MX    | @               | mail.hms.rest  (priority 10)       | 3600 |
| TXT   | @               | v=spf1 mx a:mail.hms.rest ~all     | 3600 |
| TXT   | dkim._domainkey | (get from Mailcow admin UI)        | 3600 |
| TXT   | _dmarc          | v=DMARC1; p=quarantine; rua=mailto:postmaster@hms.rest | 3600 |

---

## Domain 2 — cloudfy.com

| Type  | Host            | Value                                | TTL  |
|-------|-----------------|--------------------------------------|------|
| A     | mail            | YOUR_VPS_IP                          | 3600 |
| MX    | @               | mail.hms.rest  (priority 10)         | 3600 |
| TXT   | @               | v=spf1 mx a:mail.hms.rest ~all       | 3600 |
| TXT   | dkim._domainkey | (get from Mailcow admin UI)          | 3600 |
| TXT   | _dmarc          | v=DMARC1; p=quarantine; rua=mailto:postmaster@cloudfy.com | 3600 |

---

## PTR / Reverse DNS (IMPORTANT for deliverability)

Set this at your **VPS provider** (not domain registrar):

```
YOUR_VPS_IP → mail.hms.rest
```

- DigitalOcean: Droplet settings → Add reverse DNS
- AWS: Request via support ticket or Elastic IP settings
- Vultr/Hetzner/Linode: Usually in networking settings

---

## How to get DKIM keys from Mailcow

1. Login to https://mail.hms.rest (admin / moohoo)
2. Go to **Configuration → ARC/DKIM keys**
3. Select domain → copy the TXT record value
4. Paste it into your DNS as `dkim._domainkey` TXT record

---

## Verify everything (after DNS propagates ~1-24h)

```bash
# Check MX
dig MX hms.rest

# Check SPF
dig TXT hms.rest

# Check DKIM
dig TXT dkim._domainkey.hms.rest

# Check PTR
dig -x YOUR_VPS_IP

# Full deliverability test
# Send email to: check-auth@verifier.port25.com
# Or use: https://www.mail-tester.com
```
