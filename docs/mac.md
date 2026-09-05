# SkyFactory 1.3.2 on macOS ✅

Status: **working** (Apple Silicon and Intel).

## One command

```bash
curl -fsSL https://raw.githubusercontent.com/Ezzybeam/skyfactory-1-fix/main/install.sh | bash
```

This downloads `SkyFactory-1.3.2.mrpack` to `~/Downloads`, opens **Modrinth App**,
and reveals the file in Finder.

## Then, in Modrinth App

1. **Sign in** with your Microsoft/Xbox account.
2. **Add Instance → From file** → pick `~/Downloads/SkyFactory-1.3.2.mrpack`
   (or drag the file into the window).
3. Let it install **Minecraft 1.6.4 + Forge 9.11.1.965 + all mods**. Modrinth
   downloads **Java 8** automatically.
4. **Play.**

That's it — skins work (LumySkinPatch is bundled), and macOS sets the LWJGL native
path correctly, so it launches.

## If it crashes (rare)

- **Native crash / `SIGSEGV` / `hs_err_pid*`:** the natives vs JVM architecture
  mismatched. Set the instance's Java to an **x86_64 Java 8** (install Temurin 8,
  then Instance → Options → Java → point at
  `/Library/Java/JavaVirtualMachines/temurin-8.jdk/Contents/Home/bin/java`). It runs
  fine under Rosetta 2.
- **`CRITICAL TAMPERING ... 0 certificates`** in the log: harmless, ignore. If the
  game quits with no window, add these to the instance's JVM args:
  ```
  -Dfml.ignoreInvalidMinecraftCertificates=true -Dfml.ignorePatchDiscrepancies=true
  ```
- **`Unable to read the jar file ... - ignoring`**: harmless FML warnings; the pack
  still loads.
