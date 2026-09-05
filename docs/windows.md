# SkyFactory 1.3.2 on Windows ✅ (Modrinth)

Status: **working** — with one fix step. Modrinth App doesn't set up the old
Minecraft 1.6.4 native libraries correctly, so out of the box it fails. The
`FixModrinth.bat` in this repo supplies exactly what Modrinth misses, and then it
runs.

## Steps

1. Download this repo (**Code → Download ZIP**, unzip) or `git clone`.
2. Double-click **`install.bat`** — downloads the pack + opens Modrinth. (Or grab
   `SkyFactory-1.3.2.mrpack` from the [latest release](../../releases/latest).)
3. In Modrinth: **Add Instance → From file →** the `.mrpack`. Let it install
   Minecraft 1.6.4 + Forge + all mods, and try to launch once (it will fail — that's
   expected, it makes Modrinth create its library folders).
4. Run **`FixModrinth.bat`**. It:
   - adds the **LWJGL 2.9.0** + **jInput 2.0.5** library jars Modrinth is missing
     (including stub base jars — those two artifacts are *natives-only* and their
     base `.jar` genuinely 404s on Mojang, which is what Modrinth chokes on);
   - installs the native **DLLs** to `%USERPROFILE%\SkyFactory-natives`;
   - installs the patched launchwrapper.
5. In Modrinth → instance **Options / Java → JVM arguments**, paste the line
   `FixModrinth.bat` prints (with your real path), i.e.:
   ```
   -Dfml.ignoreInvalidMinecraftCertificates=true -Dfml.ignorePatchDiscrepancies=true -Dorg.lwjgl.librarypath=C:\Users\YOU\SkyFactory-natives -Dnet.java.games.input.librarypath=C:\Users\YOU\SkyFactory-natives
   ```
6. **Play.**

## Why this is needed (the root cause)

- MC 1.6.4 uses **LWJGL 2** + **jInput**, which are *natives-only* artifacts:
  `lwjgl-platform-2.9.0.jar` and `jinput-platform-2.0.5.jar` don't exist as base
  jars (only `-natives-windows` classifiers do). Modrinth lists them on the
  classpath anyway → `Could not canonicalize library path ...`. The stub jars
  satisfy that.
- Modrinth also never sets **`java.library.path`** to the extracted native DLLs for
  1.6.4 → `UnsatisfiedLinkError: no lwjgl in java.library.path`. The
  `-Dorg.lwjgl.librarypath` / `-Dnet.java.games.input.librarypath` args point LWJGL
  and jInput straight at the DLLs (LWJGL checks those *before* `java.library.path`).
- macOS doesn't hit any of this because the 1.6.4 manifest uses **LWJGL 2.9.4** for
  macOS (which *has* a base jar and gets its natives extracted correctly).

## Running inside a VM (no GPU)

On a real PC you're done. **In a VM** (e.g. UTM) you'll hit
`org.lwjgl.LWJGLException: Pixel format not accelerated` — the VM has no accelerated
OpenGL. Drop a software-OpenGL `opengl32.dll` + `libgallium_wgl.dll`
([Mesa3D](https://github.com/pal1000/mesa-dist-win), x64) into the instance folder
(or next to `javaw.exe`). It'll render in software — slow, only useful to confirm it
boots. A real GPU makes this unnecessary.

## Still stuck?

Run `windows\CollectLog.bat` and attach `Downloads\skyfactory-crash-log.txt` to an
issue.
