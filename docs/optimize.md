# Optimizing SkyFactory 1.3.2 (performance)

The pack ships with **no optimization mods**, so on 1.6.4 you get plain vanilla-ish
performance. Here's how to make it run much smoother. Biggest wins first.

## 1. Memory + JVM args (do this first — free, no mods)

In your launcher, edit the instance → **Java / JVM arguments**.

**Memory:** Min `512M`, Max **`2G`–`3G`**. Do **not** give it more than ~half your
RAM, and more is *not* better for 1.6.4 — huge heaps make GC pauses worse.

**JVM arguments** (G1GC, tuned for old Minecraft):
```
-Xmx3G -Xms512M -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions
-XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50
-XX:G1HeapRegionSize=16M
-Dfml.ignoreInvalidMinecraftCertificates=true -Dfml.ignorePatchDiscrepancies=true
```
(Keep the two `-Dfml...` flags — the pack needs them regardless.)

## 2. OptiFine — the biggest FPS boost

Adds fast render, render-distance control, and a ton of video options.

- Download **OptiFine 1.6.4 HD U** (C2 or D1) from the official site:
  https://optifine.net/downloads  → scroll to **Minecraft 1.6.4**.
  (It's an ad-gated page — click through to get the `.jar`.)
- Drop the `.jar` into the instance's **`mods`** folder
  (Launcher → right-click instance → **Minecraft Folder** → `mods`).
- Launch, then **Options → Video Settings**:
  | Setting | Value |
  |---|---|
  | Render Distance | Short (4) or Tiny (2) |
  | Graphics | Fast |
  | Smooth Lighting | Off |
  | Particles | Minimal |
  | Clouds | Off |
  | Performance / "Smart Animations" | on if present |

## 3. FastCraft — fewer lag spikes, faster load

Speeds up chunk/light/entity handling and cuts world-load time. 1.6.4-compatible.

- **FastCraft 1.21–1.25** (by Player):
  https://www.curseforge.com/minecraft/mc-mods/fastcraft/files → pick a **1.6.4**
  file.
- Drop the `.jar` into the same **`mods`** folder. No config needed.

## Notes / cautions

- **Add one at a time.** This pack has several coremods (OpenModsLib, MobiusCore,
  CodeChickenCore, TConstruct preloader). OptiFine occasionally clashes with a
  movement/render coremod — if the game crashes right after adding OptiFine, remove
  it and keep FastCraft (FastCraft alone is very safe).
- **Windows-on-ARM (UTM VM):** use **x64 Java 8** so LWJGL's x64 natives load; the
  same OptiFine/FastCraft jars work.
- Lower **render distance** is the single biggest FPS lever on 1.6.4 — even without
  OptiFine, set it as low as you can stand.
- These are **drop-in** mods (per-instance), so they don't change the shared pack —
  everyone can tune their own machine.
