#!/usr/bin/env bash
set -euo pipefail

echo "=== Halo — Install ==="
echo ""

# Install Ruby dependencies
echo "[1/4] Installing gem dependencies..."
cd "$(dirname "$0")"
bundle install --quiet

# ── Rotate / initialise RAILS_MASTER_KEY ─────────────────────────
# Every fresh install gets a unique master key.  The key is written
# to .env so it survives restarts.  Credentials are re-encrypted
# with this key so the app can always decrypt its secret_key_base.
echo "[2/4] Configuring secrets..."
if [ ! -f .env ]; then
  touch .env
fi

if ! grep -q '^RAILS_MASTER_KEY=' .env 2>/dev/null; then
  NEW_KEY=$(ruby -e "require 'securerandom'; puts SecureRandom.hex(16)")
  echo "RAILS_MASTER_KEY=${NEW_KEY}" >> .env
  echo "  → Generated RAILS_MASTER_KEY and saved to .env"
else
  echo "  → RAILS_MASTER_KEY already configured"
fi

# Export the key so the rails commands below can use it
set -a; source .env; set +a

# Re-encrypt credentials with the current master key.
# We always recreate from scratch — this is a demo app, the only
# secret inside is secret_key_base which is safe to regenerate.
rm -f config/credentials.yml.enc

SECRET=$(ruby -e "require 'securerandom'; puts SecureRandom.hex(64)")
TMP_YML=$(mktemp /tmp/cred-XXXXXX.yml)
printf 'secret_key_base: %s\n' "$SECRET" > "$TMP_YML"

TMP_EDITOR=$(mktemp /tmp/cred-editor-XXXXXX.sh)
printf '#!/bin/bash\ncp %s "$1"\n' "$TMP_YML" > "$TMP_EDITOR"
chmod +x "$TMP_EDITOR"

EDITOR="$TMP_EDITOR" ruby bin/rails credentials:edit 2>/dev/null
rm -f "$TMP_YML" "$TMP_EDITOR"
echo "  → Credentials encrypted with current RAILS_MASTER_KEY"

# Prepare database (create + migrate, idempotent)
echo "[3/4] Setting up database..."
ruby bin/rails db:prepare

# Seed demo data (idempotent)
echo "[4/4] Seeding demo data..."
ruby bin/rails db:seed

echo ""
echo "=== Install complete ==="
echo ""
echo "Start the server with:"
echo "  bundle exec rails server -b 0.0.0.0 -p 3000"
echo ""
echo "Then open http://localhost:3000 in your browser."
