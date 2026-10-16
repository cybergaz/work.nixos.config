#!/usr/bin/env bash
# Writes /etc/xegality/server.env, the secrets xegality-server needs, from Bun's .env on this box,
# so each secret is kept in one place. Root-only (0600): systemd reads it before dropping to the
# service user. Prints key names only, never values. Re-run after changing Bun's .env. From the
# workstation:
#   ssh xegality-vps 'bash -s' < ~/nixos-config/hosts/vps/set-server-secrets.sh
set -euo pipefail
cd ~/xegality-backend
# Inside the clone, so `dotenv` resolves from its node_modules.
parser=$(mktemp -p . --suffix=.ts .server-env.XXXXXX)
trap 'rm -f "$parser"' EXIT
cat >"$parser" <<'TS'
import { parse } from "dotenv";
import { readFileSync } from "node:fs";

const env = parse(readFileSync(".env"));
const required = ["DB_URL", "ACCESS_KEY", "AWS_S3_BUCKET_NAME", "AWS_REGION", "AWS_ACCESS_KEY_ID",
  "AWS_SECRET_ACCESS_KEY", "GEMINI_API_KEY"];
const missing = required.filter((key) => !env[key]);
if (missing.length) {
  console.error(`missing from .env: ${missing.join(", ")}`);
  process.exit(1);
}
const out: Record<string, string> = Object.fromEntries(required.map((key) => [key, env[key]]));
// The server insists on verified TLS to any non-local database; Neon hands out sslmode=require.
const db = new URL(env.DB_URL);
db.searchParams.set("sslmode", "verify-full");
out.DB_URL = db.toString();
// Vision OCR for scans (optional), re-serialised to one line of JSON.
if (env.GOOGLE_CREDENTIALS) {
  try {
    out.GOOGLE_CREDENTIALS = JSON.stringify(JSON.parse(env.GOOGLE_CREDENTIALS));
  } catch {
    console.error("GOOGLE_CREDENTIALS is not valid JSON: skipped, so scans will not be OCRed");
  }
}
// Indian Kanoon (optional): needed by XEGALITY_DATAROOM_PROVIDER=indian_kanoon.
if (env.INDIAN_KANOON_API_KEY) out.INDIAN_KANOON_API_KEY = env.INDIAN_KANOON_API_KEY;
// systemd reads single-quoted values literally.
for (const [key, value] of Object.entries(out)) {
  if (/['\n]/.test(value)) {
    console.error(`${key} contains a quote or a newline: edit /etc/xegality/server.env by hand`);
    process.exit(1);
  }
  console.log(`${key}='${value}'`);
}
TS
env_file=$(bun "$parser")
sudo install -d -m 0755 /etc/xegality
sudo install -m 0600 /dev/null /etc/xegality/server.env
printf '%s\n' "$env_file" | sudo tee /etc/xegality/server.env >/dev/null
echo "saved /etc/xegality/server.env: $(printf '%s\n' "$env_file" | cut -d= -f1 | tr '\n' ' ')"
if systemctl cat xegality-server >/dev/null 2>&1 \
  && [ -x /nix/var/nix/profiles/xegality-server/bin/xegality-server ]; then
  sudo systemctl reset-failed xegality-server 2>/dev/null || true
  sudo systemctl restart xegality-server
  for _ in $(seq 1 20); do curl -sf http://127.0.0.1:4100/livez >/dev/null 2>&1 && break; sleep 1; done
  echo "server: $(systemctl is-active xegality-server)"
  echo "readyz: $(curl -s http://127.0.0.1:4100/readyz)"
fi
