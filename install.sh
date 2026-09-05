#!/usr/bin/env bash
# SkyFactory 1.3.2 — macOS installer / updater (Modrinth)
# Downloads the latest modpack from this repo's GitHub Release and hands it to Modrinth.
# Re-run any time to UPDATE (it always fetches the latest). macOS: WORKING.
set -euo pipefail

REPO="Ezzybeam/skyfactory-1.3.2-launcher"
PACK_URL="https://github.com/$REPO/releases/latest/download/SkyFactory-1.3.2.mrpack"
DEST="$HOME/Downloads/SkyFactory-1.3.2.mrpack"

if [ -f "$DEST" ]; then
  echo "==> SkyFactory 1.3.2 UPDATER (macOS / Modrinth)"
  echo "==> Existing pack found — fetching the latest version..."
else
  echo "==> SkyFactory 1.3.2 installer (macOS / Modrinth)"
fi
echo "==> Downloading modpack (~56 MB)..."

tmp="$DEST.part"
if ! curl -L --fail --progress-bar -o "$tmp" "$PACK_URL"; then
  echo "!! Download failed. Check your connection and try again."
  echo "   URL: $PACK_URL"
  rm -f "$tmp"
  exit 1
fi
# sanity: a real pack is tens of MB, not an error page
size=$(stat -f%z "$tmp" 2>/dev/null || stat -c%s "$tmp")
if [ "${size:-0}" -lt 1000000 ]; then
  echo "!! Downloaded file is too small (${size} bytes) — likely an error. Aborting."
  rm -f "$tmp"
  exit 1
fi
mv -f "$tmp" "$DEST"
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

TO UPDATE LATER: run this installer again — it always fetches the
newest pack. Then re-import the .mrpack in Modrinth to apply the update.

macOS runs this pack as-is. If it ever crashes with a native error
(SIGSEGV / hs_err_pid), set the instance's Java to an x86_64 Java 8
(Temurin 8) under the instance Options -> Java.
--------------------------------------------------------------------
EOF
