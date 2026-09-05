# SkyFactory 1 — Fix, Launcher & Server

Get the classic **SkyFactory 1** (SkyFactory 1.3.2, Minecraft **1.6.4** + Forge)
running on a modern machine. It's an old pack and today's launchers mishandle its
**LWJGL native libraries**, so it usually crashes on startup. This repo gives you a
**one-command installer** plus the fix files.

> **Been fighting to get SkyFactory 1 to launch and nothing works?** You're in the
> right place. If you've seen any of these, this repo fixes them:
> - `java.lang.UnsatisfiedLinkError: no lwjgl in java.library.path`
> - `Could not canonicalize library path ... lwjgl-platform-2.9.0.jar` (or `jinput-platform-2.0.5.jar`)
> - `org.lwjgl.LWJGLException: Pixel format not accelerated`
> - `CRITICAL TAMPERING WITH MINECRAFT ... 0 certificates`
> - the game just closes / no window ever opens
>
> It works on **macOS** and **Windows** (Modrinth), with a **Linux** fix too.

| Platform | Status | Installer |
|----------|--------|-----------|
| **macOS** | ✅ Working | `install.sh` |
| **Windows** | ✅ Working (needs `FixModrinth.bat`) | `install.bat` + `FixModrinth.bat` |
| **Linux** | ❓ Untested — should work | `install-linux.sh` + `FixModrinth-linux.sh` |

Uses **Modrinth App** as the launcher. Everything downloads from this repo — no
external drives or accounts needed beyond your Minecraft/Microsoft login.

---

## Quick start

### macOS ✅
```bash
curl -fsSL https://raw.githubusercontent.com/Ezzybeam/skyfactory-1-fix/main/install.sh | bash
```
Then in Modrinth: **Add Instance → From file →** the downloaded
`~/Downloads/SkyFactory-1.3.2.mrpack` → **Play**. (Full steps:
[`docs/mac.md`](docs/mac.md).)

### Windows ✅
Download this repo (green **Code → Download ZIP**, or `git clone`), double-click
**`install.bat`**, then run **`FixModrinth.bat`** and paste the JVM args it prints —
full steps in [`docs/windows.md`](docs/windows.md). (Works on a real GPU; a VM needs
software OpenGL.)

### Linux ❓
**Untested, but should work** — the repo ships the Linux version of the Windows fix
(same stubs, Linux `.so` natives). `./install-linux.sh` then `./FixModrinth-linux.sh`
— see [`docs/linux.md`](docs/linux.md). Please report back if you try it!

### Performance ⚡
The pack has no optimization mods. For a big FPS boost (OptiFine + FastCraft) and
tuned JVM/GC args, see [`docs/optimize.md`](docs/optimize.md).

### Host a server 🖥️
Want to play with friends? Set up a dedicated server (Forge 1.6.4, void world, built
from the same pack) with `server/setup-server.sh` (Mac/Linux) or
`server/setup-server.bat` (Windows) — see [`server/`](server/).

### Updating 🔄
Both installers pull from the **latest** release, so **just run the installer again**
to update — it re-downloads the newest pack and re-applies the fix. Then re-import
the `.mrpack` in Modrinth to apply it to your instance.

---

## What's the actual problem?

SkyFactory 1.3.2 runs on **Minecraft 1.6.4 / LWJGL 2**, which needs **native**
libraries (`.dylib` / `.dll` / `.so`). The game only starts if the launcher extracts
them and points the JVM at them with `-Djava.library.path=...`.

- **macOS:** Modrinth handles this fine → the pack runs. ✅
- **Windows:** Modrinth App does **not** set `java.library.path` for 1.6.4, so the
  client dies instantly with:
  ```
  java.lang.UnsatisfiedLinkError: no lwjgl in java.library.path
  ```
  Fixed by `FixModrinth.bat` (supplies the missing LWJGL/jInput files + native
  DLLs). See [`docs/windows.md`](docs/windows.md).

You'll also always see this on 1.6.4 — it is **harmless, ignore it**:
```
CRITICAL TAMPERING WITH MINECRAFT ... there were 0 certificates
```
The bundled JVM flags silence its effect:
`-Dfml.ignoreInvalidMinecraftCertificates=true -Dfml.ignorePatchDiscrepancies=true`

## What's in this repo

```
install.sh              macOS installer/updater (downloads pack -> opens Modrinth)
install.bat             Windows installer/updater (downloads pack + fix -> opens Modrinth)
collect-log.sh          macOS: bundle the game crash log for sharing
windows/CollectLog.bat  Windows: bundle the game crash log for sharing
FixModrinth.bat         Windows: installs the missing LWJGL/jInput libs + native DLLs
lwjgl-fix/ natives-windows/  the missing 1.6.4 libraries + DLLs used by FixModrinth
windows/FixLaunch.bat   copies the patched launchwrapper into Modrinth's libraries
windows/launchwrapper-1.8.jar   patched launchwrapper (fixes a startup crash)
docs/mac.md             macOS guide
docs/windows.md         Windows guide (working fix)
docs/linux.md           Linux notes (untested)
docs/windows-setup-full.txt   the detailed original setup notes
```

## If it doesn't work (logs)

The installers write their own run to `~/Downloads/skyfactory-install-log.txt`. To
capture the actual **game** crash log for troubleshooting, run the collector:

- **macOS:** `./collect-log.sh`
- **Windows:** double-click `windows/CollectLog.bat`

Either writes `Downloads/skyfactory-crash-log.txt` (newest game log + any crash
reports + native `hs_err` dumps). Attach that file to an issue.
The modpack itself (`SkyFactory-1.3.2.mrpack`, ~56 MB) ships as a **GitHub Release**
asset; the installers download it automatically.

## Credits & license

- **SkyFactory** modpack by **Bacon_Donut**; 1.3 update help from **Wyld**.
- All mods © their respective authors — this repo does not claim or relicense them.
- Skins on 1.6.4 are fixed by **LumySkinPatch** (bundled in the pack).
- Installer scripts + guide: free to use and adapt.

> This project only redistributes a community launch fix and a convenience installer.
> If you are a mod author and want your work handled differently, open an issue.
