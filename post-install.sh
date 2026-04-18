#!/bin/bash
# Run this AFTER setup.sh completes and you've set DNS records.
# Adds domains + mailboxes via Mailcow REST API.

MAILCOW_URL="https://mail.hms.rest"
API_KEY=""   # ← Paste your API key from Mailcow admin UI → API

if [[ -z "$API_KEY" ]]; then
  echo "ERROR: Set API_KEY at the top of this script."
  echo "Get it from: Mailcow UI → Configuration → Access → API → Create API key"
  exit 1
fi

AUTH=(-H "X-API-Key: $API_KEY" -H "Content-Type: application/json")

call() { curl -sf -X "$1" "${AUTH[@]}" "$MAILCOW_URL/api/v1/$2" -d "$3"; echo; }

echo "Adding domain: hms.rest"
call POST add/domain '{"domain":"hms.rest","description":"HMS Rest","aliases":10,"mailboxes":10,"quota":10240,"active":1}'

echo "Adding domain: cloudfy.com"
call POST add/domain '{"domain":"cloudfy.com","description":"Cloudfy","aliases":10,"mailboxes":10,"quota":10240,"active":1}'

echo "Adding mailbox: admin@hms.rest"
call POST add/mailbox '{"local_part":"admin","domain":"hms.rest","name":"Admin HMS","password":"ChangeMe123!","password2":"ChangeMe123!","quota":"1024","active":"1"}'

echo "Adding mailbox: support@hms.rest"
call POST add/mailbox '{"local_part":"support","domain":"hms.rest","name":"Support HMS","password":"ChangeMe123!","password2":"ChangeMe123!","quota":"1024","active":"1"}'

echo "Adding mailbox: admin@cloudfy.com"
call POST add/mailbox '{"local_part":"admin","domain":"cloudfy.com","name":"Admin Cloudfy","password":"ChangeMe123!","password2":"ChangeMe123!","quota":"1024","active":"1"}'

echo "Adding mailbox: support@cloudfy.com"
call POST add/mailbox '{"local_part":"support","domain":"cloudfy.com","name":"Support Cloudfy","password":"ChangeMe123!","password2":"ChangeMe123!","quota":"1024","active":"1"}'

echo ""
echo "Done! Mailboxes created."
echo "⚠  Change passwords immediately in the Mailcow admin UI."
