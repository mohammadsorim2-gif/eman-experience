#!/usr/bin/env bash
set -euo pipefail

PORT="${1:-3000}"

pkill -f "flutter.*web-server" 2>/dev/null || true
pkill -f "python3 -m http.server ${PORT}" 2>/dev/null || true

flutter clean
flutter pub get
flutter analyze --no-fatal-infos
flutter build web --release

printf '\nServing build/web on http://0.0.0.0:%s\n' "$PORT"
exec python3 -m http.server "$PORT" --bind 0.0.0.0 --directory build/web
