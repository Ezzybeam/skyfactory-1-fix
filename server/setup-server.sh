#!/usr/bin/env bash
# SkyFactory 1.3.2 dedicated server setup (macOS / Linux).
# Builds a headless Forge 1.6.4 server from the same pack the launcher uses.
# Needs Java 8 to RUN (the script tells you if it's missing).
set -euo pipefail

REPO="Ezzybeam/skyfactory-1-fix"
DIR="${1:-$HOME/skyfactory-server}"
PACK_URL="https://github.com/$REPO/releases/latest/download/SkyFactory-1.3.2.mrpack"
FORGE_URL="https://maven.minecraftforge.net/net/minecraftforge/forge/1.6.4-9.11.1.965/forge-1.6.4-9.11.1.965-universal.jar"
# vanilla 1.6.4 server jar (Mojang, sha1 050f93c1f3fe9e2052398f7bd6aca10c63d64a87)
MCSERVER_URL="https://launcher.mojang.com/v1/objects/050f93c1f3fe9e2052398f7bd6aca10c63d64a87/server.jar"
HERE="$(cd "$(dirname "$0")" && pwd)"

echo "==> Setting up SkyFactory server in: $DIR"
mkdir -p "$DIR"; cd "$DIR"

echo "==> Downloading Forge universal + Minecraft 1.6.4 server jar..."
curl -L --fail -o forge-1.6.4-9.11.1.965-universal.jar "$FORGE_URL"
curl -L --fail -o minecraft_server.1.6.4.jar "$MCSERVER_URL"

echo "==> Downloading the modpack + extracting mods/config/scripts..."
curl -L --fail -o pack.mrpack "$PACK_URL"
rm -rf _unpack && mkdir _unpack
unzip -q pack.mrpack -d _unpack
mkdir -p mods config scripts
[ -d _unpack/overrides/mods ]    && cp -R _unpack/overrides/mods/.    mods/    2>/dev/null || true
[ -d _unpack/overrides/config ]  && cp -R _unpack/overrides/config/.  config/  2>/dev/null || true
[ -d _unpack/overrides/scripts ] && cp -R _unpack/overrides/scripts/. scripts/ 2>/dev/null || true
rm -rf _unpack pack.mrpack

echo "==> Removing client-only mods (server-safe subset)..."
while IFS= read -r pat; do
  [ -z "$pat" ] && continue; case "$pat" in \#*) continue;; esac
  find mods -maxdepth 1 -iname "*$pat*" -print -delete 2>/dev/null || true
done < "$HERE/server-mods-exclude.txt"

echo "==> Providing Forge libraries..."
# The Forge universal jar resolves its deps against ./libraries. If you installed
# the CLIENT with this repo's launcher, Modrinth already has them — reuse them.
LIBSRC=""
for c in "$HOME/Library/Application Support/ModrinthApp/meta/libraries" \
         "$HOME/.local/share/ModrinthApp/meta/libraries" \
         "$HOME/.var/app/com.modrinth.ModrinthApp/data/ModrinthApp/meta/libraries"; do
  [ -d "$c" ] && LIBSRC="$c" && break
done
if [ -n "$LIBSRC" ]; then
  ln -sfn "$LIBSRC" libraries
  echo "    linked libraries -> $LIBSRC"
else
  echo "    (!) Modrinth libraries not found. Forge will try to download them on first"
  echo "        run; some 1.6.4 maven URLs are dead. Easiest fix: install the client"
  echo "        once with this repo's launcher, then re-run this."
fi

echo "==> Writing server.properties (void skyblock, build-anywhere)..."
cat > server.properties <<PROP
level-name=skyworld
level-type=void
online-mode=true
gamemode=0
difficulty=2
allow-flight=true
spawn-protection=0
max-players=10
view-distance=6
server-port=25565
motd=SkyFactory 1.3.2
PROP

echo "==> Writing run script..."
cat > run-server.sh <<'RUN'
#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
# find a Java 8
J8=""
if command -v /usr/libexec/java_home >/dev/null 2>&1; then J8="$(/usr/libexec/java_home -v 1.8 2>/dev/null)/bin/java" || true; fi
[ -x "$J8" ] || for c in /Library/Java/JavaVirtualMachines/*8*/Contents/Home/bin/java /usr/lib/jvm/*8*/bin/java; do [ -x "$c" ] && J8="$c" && break; done
[ -x "$J8" ] || J8="java"
echo "Using Java: $J8"; "$J8" -version 2>&1 | head -1
"$J8" -Xms1G -Xmx3G -jar forge-1.6.4-9.11.1.965-universal.jar nogui
RUN
chmod +x run-server.sh

cat <<EOF

============================================================
SkyFactory server ready in: $DIR
Start it:   cd "$DIR" && ./run-server.sh
Needs JAVA 8 (Temurin/Liberica 8). 1.6.4 has no eula.txt step.

NOTES
 - VOID WORLD: YUNoMakeGoodMap makes the world a void skyblock, but ONLY for a
   FRESH world. level-name=skyworld is new, so first boot generates the void. If you
   ever get normal terrain, change level-name (or delete the world) and reboot.
 - spawn-protection=0 so players can build/break at spawn (the skyblock IS spawn).
 - online-mode=true = real Minecraft accounts only. Set false only for cracked/bots.
 - To let friends join over the internet, port-forward TCP 25565 (or use a tunnel
   like playit.gg). LAN just works.
 - Keep mods/1.6.4/ and the config/ + scripts/ folders as-is.
============================================================
EOF
