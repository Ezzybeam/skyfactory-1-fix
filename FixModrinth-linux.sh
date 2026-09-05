#!/usr/bin/env bash
# SkyFactory 1.3.2 - Modrinth Linux fix (mirror of FixModrinth.bat).
# Supplies the LWJGL/jInput libs + native .so files Modrinth omits for MC 1.6.4,
# and prints the JVM args to add. UNTESTED - please report success/failure.
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
NAT="$HOME/SkyFactory-natives"

# find Modrinth's libraries dir (native install or Flatpak)
CANDS=(
  "$HOME/.local/share/ModrinthApp/meta/libraries"
  "$HOME/.config/ModrinthApp/meta/libraries"
  "$HOME/.var/app/com.modrinth.ModrinthApp/data/ModrinthApp/meta/libraries"
  "$HOME/.var/app/com.modrinth.theseus/data/ModrinthApp/meta/libraries"
)
LIB=""
for c in "${CANDS[@]}"; do [ -d "$c" ] && LIB="$c" && break; done
if [ -z "$LIB" ]; then
  echo "Couldn't find Modrinth's libraries folder. Import the pack + launch once, then"
  echo "pass the path:  ./FixModrinth-linux.sh /path/to/ModrinthApp/meta/libraries"
  [ -n "${1:-}" ] && [ -d "$1" ] && LIB="$1" || exit 1
fi
echo "==> Modrinth libraries: $LIB"

echo "[1/3] Placing LWJGL 2.9.0 + jInput 2.0.5 library jars (+ stubs)..."
cp -R "$HERE/lwjgl-fix/." "$LIB/"

echo "[2/3] Installing native .so files to $NAT"
mkdir -p "$NAT"; cp -f "$HERE/natives-linux/"*.so "$NAT/"

echo "[3/3] Placing patched launchwrapper..."
mkdir -p "$LIB/net/minecraft/launchwrapper/1.8"
cp -f "$HERE/windows/launchwrapper-1.8.jar" "$LIB/net/minecraft/launchwrapper/1.8/launchwrapper-1.8.jar"

cat <<EOF

============================================================
DONE. In Modrinth: edit the SkyFactory instance -> Options/Java -> JVM arguments,
paste this ONE line:

-Dfml.ignoreInvalidMinecraftCertificates=true -Dfml.ignorePatchDiscrepancies=true -Dorg.lwjgl.librarypath=$NAT -Dnet.java.games.input.librarypath=$NAT

Then press Play. Make sure the instance uses JAVA 8.
(If it still fails, run ./collect-log.sh style: send the newest log under
 the instance's logs/ folder.)
============================================================
EOF
