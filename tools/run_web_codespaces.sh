#!/usr/bin/env bash
set -euo pipefail

PORT="${1:-3000}"

pkill -f "flutter.*web-server" 2>/dev/null || true
pkill -f "python3 -m http.server ${PORT}" 2>/dev/null || true

python3 tools/activate_instant_drink_factory_hub.py

flutter clean
flutter pub get
flutter analyze --no-fatal-infos

required_vars=(
  FIREBASE_API_KEY
  FIREBASE_APP_ID
  FIREBASE_PROJECT_ID
  FIREBASE_MESSAGING_SENDER_ID
  FIREBASE_AUTH_DOMAIN
  FIREBASE_STORAGE_BUCKET
)

missing=()
for name in "${required_vars[@]}"; do
  if [ -z "${!name:-}" ]; then
    missing+=("$name")
  fi
done

if [ "${#missing[@]}" -gt 0 ]; then
  printf 'Missing Firebase environment variables:\n' >&2
  printf '  %s\n' "${missing[@]}" >&2
  printf 'Add them as Codespaces secrets or export them before running this script.\n' >&2
  exit 1
fi

DART_DEFINES=(
  "--dart-define=FIREBASE_API_KEY=${FIREBASE_API_KEY}"
  "--dart-define=FIREBASE_APP_ID=${FIREBASE_APP_ID}"
  "--dart-define=FIREBASE_PROJECT_ID=${FIREBASE_PROJECT_ID}"
  "--dart-define=FIREBASE_MESSAGING_SENDER_ID=${FIREBASE_MESSAGING_SENDER_ID}"
  "--dart-define=FIREBASE_AUTH_DOMAIN=${FIREBASE_AUTH_DOMAIN}"
  "--dart-define=FIREBASE_STORAGE_BUCKET=${FIREBASE_STORAGE_BUCKET}"
)

if [ -n "${FIREBASE_MEASUREMENT_ID:-}" ]; then
  DART_DEFINES+=("--dart-define=FIREBASE_MEASUREMENT_ID=${FIREBASE_MEASUREMENT_ID}")
fi

rm -rf build/web
flutter build web --release --no-wasm-dry-run "${DART_DEFINES[@]}"

if [ ! -f build/web/main.dart.js ]; then
  echo "Build failed: build/web/main.dart.js was not generated." >&2
  exit 1
fi

printf '\nServing authenticated build/web on http://0.0.0.0:%s\n' "$PORT"
exec python3 -m http.server "$PORT" --bind 0.0.0.0 --directory build/web
