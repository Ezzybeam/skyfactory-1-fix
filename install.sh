#!/usr/bin/env bash
# SkyFactory 1.3.2 — macOS installer (Modrinth)
# Downloads the modpack from this repo's GitHub Release and hands it to Modrinth.
# macOS: WORKING.
set -euo pipefail

REPO="Ezzybeam/skyfactory-1.3.2-launcher"
PACK_URL="https://github.com/$REPO/releases/latest/download/SkyFactory-1.3.2.mrpack"
DEST="$HOME/Downloads/SkyFactory-1.3.2.mrpack"

echo "==> SkyFactory 1.3.2 installer (macOS / Modrinth)"
echo "==> Downloading modpack (~56 MB)..."
curl -L --fail --progress-bar -o "$DEST" "$PACK_URL"
echo "==> Saved: $DEST"

if [ -d "/Applications/Modrinth App.app" ]; then
  echo "==> Opening Modrinth App..."
  open -a "Modrinth App" || true
else
  echo "!! Modrinth App not installed. Get it: https://modrinth.com/app"
  open "https://modrinth.com/app" >/dev/null 2>&1 || true
fi

open -R "$DEST" >/dev/null 2>&1 || true   # reveal the .mrpack in Finder

cat <<EOF

--------------------------------------------------------------------
LAST STEP (one click) — in Modrinth App:
  1. Sign in with your Microsoft/Xbox account.
  2. Add Instance  ->  "From file"  ->  choose:
       $DEST
     (or just drag the .mrpack into the Modrinth window)
  3. Let it install Minecraft 1.6.4 + Forge + all mods. Java 8 is
     downloaded automatically.
  4. Press Play.

macOS runs this pack as-is. If it ever crashes with a native error
(SIGSEGV / hs_err_pid), set the instance's Java to an x86_64 Java 8
(Temurin 8) under the instance Options -> Java.
--------------------------------------------------------------------
EOF
