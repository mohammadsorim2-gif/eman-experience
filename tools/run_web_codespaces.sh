#!/usr/bin/env bash
set -euo pipefail

PORT="${1:-3000}"

pkill -f "flutter.*web-server" 2>/dev/null || true
pkill -f "python3 -m http.server ${PORT}" 2>/dev/null || true

python3 tools/activate_instant_drink_factory_hub.py

flutter clean
flutter pub get
flutter analyze --no-fatal-infos --no-fatal-warnings

rm -rf build/web
flutter build web --release --no-wasm-dry-run

if [ ! -f build/web/main.dart.js ]; then
  echo "Build failed: build/web/main.dart.js was not generated." >&2
  exit 1
fi

printf '\nServing Firebase-connected build/web on http://0.0.0.0:%s\n' "$PORT"
exec python3 -m http.server "$PORT" --bind 0.0.0.0 --directory build/web
