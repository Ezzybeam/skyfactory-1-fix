# SkyFactory 1.3.2 on Linux ❓ (untested — should work)

Status: **untested, but it should work.** Linux hits the *same* Modrinth 1.6.4 bugs
as Windows (the natives-only base jars 404 for every OS, and Modrinth doesn't set the
native path), and this repo now ships the Linux version of the fix — same approach,
Linux `.so` natives. Nobody's confirmed it on a real Linux box yet, so **please
report** if you try it.

## Steps (Modrinth)

1. Get the repo: `git clone https://github.com/Ezzybeam/skyfactory-1.3.2-launcher`
   (or Download ZIP).
2. Download the pack + open Modrinth:
   ```bash
   ./install-linux.sh
   ```
3. Install/open **Modrinth App** (https://modrinth.com/app), sign in, and
   **Add Instance → From file →** `~/Downloads/SkyFactory-1.3.2.mrpack`.
   Let it install MC 1.6.4 + Forge + mods (Java 8 auto-downloaded). Launch once so
   Modrinth creates its library folders (it'll fail — expected).
4. Apply the fix:
   ```bash
   ./FixModrinth-linux.sh
   ```
   It places the LWJGL 2.9.0 + jInput 2.0.5 jars (with stub base jars), installs the
   native `.so` files to `~/SkyFactory-natives`, and the patched launchwrapper. If it
   can't find Modrinth's libraries folder, pass it:
   `./FixModrinth-linux.sh /path/to/ModrinthApp/meta/libraries`
5. In Modrinth → instance **Options / Java → JVM arguments**, paste what the script
   prints:
   ```
   -Dfml.ignoreInvalidMinecraftCertificates=true -Dfml.ignorePatchDiscrepancies=true -Dorg.lwjgl.librarypath=$HOME/SkyFactory-natives -Dnet.java.games.input.librarypath=$HOME/SkyFactory-natives
   ```
   Make sure the instance uses **Java 8**.
6. **Play.**

## Why it should work

Same root cause as Windows: the 2.9.0 `lwjgl-platform` / `jinput-platform` base jars
don't exist (natives-only), and Modrinth won't set `java.library.path`. The stub
jars + `-Dorg.lwjgl.librarypath` / `-Dnet.java.games.input.librarypath` fix both.
Linux has real OpenGL (native driver or Mesa), so unlike a GPU-less VM you should
**not** hit "Pixel format not accelerated."

## Likely gotchas

- Flatpak Modrinth sandboxes its files under `~/.var/app/...` — the fix script
  probes common paths; if it misses, pass the libraries path explicitly (step 4).
- Ensure **Java 8** (not 17/21) — old Forge won't load otherwise.
- If it still fails, grab the newest log under the instance's `logs/` folder and open
  an issue.
