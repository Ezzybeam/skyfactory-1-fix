# SkyFactory 1.3.2 on Windows 🚧

Status: **work in progress.** The installer sets everything up, but **Modrinth App
on Windows does not set the LWJGL native path for Minecraft 1.6.4**, so the pack can
still crash on launch with:

```
java.lang.UnsatisfiedLinkError: no lwjgl in java.library.path
```

There isn't a clean Modrinth-only fix for that yet — help wanted (see bottom).

## The Modrinth installer (what we have)

1. Download this repo (**Code → Download ZIP**, unzip) or `git clone` it.
2. Double-click **`install.bat`**. It:
   - downloads `SkyFactory-1.3.2.mrpack` from the GitHub Release,
   - copies the **patched launchwrapper** into Modrinth's shared libraries,
   - opens Modrinth App + the pack file.
3. In Modrinth: **Add Instance → From file →** the downloaded
   `%USERPROFILE%\Downloads\SkyFactory-1.3.2.mrpack`.
4. Add these JVM args (Instance → Options → Java):
   ```
   -Dfml.ignoreInvalidMinecraftCertificates=true -Dfml.ignorePatchDiscrepancies=true
   ```
5. If you hit a `ConcurrentModificationException`, launch once (it downloads files),
   then re-run **`windows\FixLaunch.bat`**, then launch again.

If Modrinth still throws `no lwjgl in java.library.path`, that's the open blocker.

## Reliable fallback today: Prism Launcher

Prism sets the native path automatically and is the recommended launcher for old MC.
The full step-by-step (import the same `.mrpack`, run `FixLaunch.bat`, add the FML
flags, optional OptiFine/FastCraft for low-end PCs) is in
[`windows-setup-full.txt`](windows-setup-full.txt). Short version:

1. Install **[Prism Launcher](https://prismlauncher.org/download/)**, sign in, let it
   auto-download **Java 8**.
2. **Add Instance → Import →** the `SkyFactory-1.3.2.mrpack`.
3. Launch once (it may crash — expected), then **Minecraft Folder → run
   `FixLaunch.bat`** (point it at Prism's libs if needed:
   `%APPDATA%\PrismLauncher\libraries\net\minecraft\launchwrapper\1.8`).
4. Add the two FML JVM flags. Launch.

## Help wanted

The goal is a **Modrinth-only** Windows launch with no Prism. If you know how to make
Modrinth App pass `-Djava.library.path` to the extracted LWJGL 2.9.4 natives for
1.6.4 (or a wrapper that does), please open a PR. Include your Modrinth version,
Java version, and the full log.
