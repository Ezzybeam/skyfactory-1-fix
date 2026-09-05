# SkyFactory 1.3.2 — Dedicated Server

Host the OG SkyFactory (Minecraft 1.6.4 + Forge) so friends can join. This builds a
headless server from the **same pack** the launcher uses, with the client-only mods
removed and the void world set up.

## Quick setup

**macOS / Linux:**
```bash
./setup-server.sh            # or:  ./setup-server.sh /path/to/serverdir
cd ~/skyfactory-server && ./run-server.sh
```

**Windows:**
```
setup-server.bat
cd %USERPROFILE%\skyfactory-server && run-server.bat
```

Then connect from the SkyFactory client (installed with this repo's launcher) to
`localhost` (same PC) / your LAN IP / your public IP.

## Requirements

- **Java 8** to run the server (Temurin or Liberica 8). The run script auto-detects
  it; install it if it says it can't find Java 8.
- It downloads: **Forge 1.6.4-9.11.1.965 universal** (Forge maven) + **Minecraft
  1.6.4 server jar** (Mojang, sha1-verified) + the **modpack** (this repo's release).

## What the setup does

1. Grabs Forge universal + the vanilla 1.6.4 server jar.
2. Downloads the pack, extracts `mods/`, `config/`, `scripts/`.
3. Removes the **client-only** mods (see `server-mods-exclude.txt`: NEI plugins,
   HUD mods, InventoryTweaks, LumySkinPatch, WikiLink, + optional OpenEye/Opis/
   MobiusCore). Keeps `mods/1.6.4/` (CodeChickenLib + ForgeMultipart) and all
   coremods as-is.
4. Provides Forge's libraries by **linking Modrinth's** (`meta/libraries`) — so if
   you installed the client with this repo's launcher, the server just works. If
   Modrinth isn't installed, Forge tries to fetch them on first boot (some 1.6.4
   maven URLs are dead, so installing the client first is the easy path).
5. Writes `server.properties` tuned for skyblock (void world, `spawn-protection=0`,
   `allow-flight=true`).

## Key settings (server.properties)

| Setting | Value | Why |
|---|---|---|
| `level-type` | `void` | selects YUNoMakeGoodMap's void generator directly (reliable; `DEFAULT`+override is flaky) |
| `level-name` | `skyworld` | fresh name → the void generates on first boot |
| `spawn-protection` | `0` | the skyblock **is** spawn — players must build/break there |
| `allow-flight` | `true` | avoids "flying is not enabled" kicks in the void |
| `online-mode` | `true` | real accounts; set `false` only for cracked/bots |

> **Void world gotcha:** use `level-type=void` (not `DEFAULT`). The `DEFAULT`+
> `overrideDefault` route is unreliable — it can leave you with normal terrain (a
> world whose `generatorName` is `default`). `level-type=void` makes the world's
> `generatorName=void`, i.e. YUNoMakeGoodMap's real void generator. If you already
> got terrain, delete the world (or change `level-name`) and reboot with `level-type=void`.

## Play with friends over the internet

- **Same house / LAN:** they connect to your LAN IP — nothing else needed.
- **Over the internet:** port-forward **TCP 25565** on your router, or use a tunnel
  (e.g. [playit.gg](https://playit.gg)) if you can't port-forward.
- Op yourself in the server console: `op <yourname>`.

## Console

The server reads commands on stdin. From the same terminal you started it in, type
e.g. `op Ezzybeam`, `stop`. (For a background server, pipe a FIFO/named pipe into it.)

Trouble? Check `logs/` (or the console) — harmless `SEVERE` mod warnings are normal
for 1.6.4; a real failure is a `NoClassDefFoundError` on `net.minecraft.client.*`
(means a client-only mod slipped in — remove it).
