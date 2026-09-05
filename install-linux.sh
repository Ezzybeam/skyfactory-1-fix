#!/usr/bin/env bash
# SkyFactory 1.3.2 - Linux installer (Modrinth). UNTESTED - should work; please report.
set -euo pipefail
REPO="Ezzybeam/skyfactory-1-fix"
PACK_URL="https://github.com/$REPO/releases/latest/download/SkyFactory-1.3.2.mrpack"
DEST="$HOME/Downloads/SkyFactory-1.3.2.mrpack"
mkdir -p "$HOME/Downloads"
echo "==> Downloading SkyFactory 1.3.2 (~56 MB)..."
curl -L --fail --progress-bar -o "$DEST" "$PACK_URL"
echo "==> Saved: $DEST"
command -v xdg-open >/dev/null 2>&1 && xdg-open "$DEST" >/dev/null 2>&1 || true
cat <<MSG

Next steps:
  1. Install Modrinth App (https://modrinth.com/app) and sign in.
  2. Add Instance -> From file -> $DEST  (installs MC 1.6.4 + Forge + mods; Java 8 auto)
  3. Run:  ./FixModrinth-linux.sh   (adds the LWJGL/jInput fix + native .so files)
  4. Paste the JVM args it prints into the instance's Java settings; ensure Java 8.
  5. Play.

UNTESTED on Linux - it should work (same fix as Windows, Linux natives). If it
works or fails, please open an issue/PR: https://github.com/$REPO
MSG
