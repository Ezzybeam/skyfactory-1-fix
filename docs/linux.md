# SkyFactory 1.3.2 on Linux ❓

Status: **untested.** No one has confirmed it yet — this is a best-guess based on how
macOS works. **If you get it running, please open a PR** with your distro, launcher,
and Java version.

## Expected route (Modrinth or Prism)

Linux launchers ship the LWJGL 2.9.4 **Linux natives** (`.so`), so — like macOS — it
should "just work" once the pack is imported.

1. Install a launcher:
   - **Modrinth App** — https://modrinth.com/app  (Flatpak/AppImage), or
   - **Prism Launcher** — https://prismlauncher.org/download/ (recommended for old MC).
2. Install **Java 8** (`temurin-8-jdk` / `openjdk-8-jre`), or let the launcher fetch it.
3. Download the pack:
   ```bash
   curl -L -o ~/Downloads/SkyFactory-1.3.2.mrpack \
     https://github.com/Ezzybeam/skyfactory-1.3.2-launcher/releases/latest/download/SkyFactory-1.3.2.mrpack
   ```
4. Import it (**Add Instance → From file / Import**).
5. Add the JVM args:
   ```
   -Dfml.ignoreInvalidMinecraftCertificates=true -Dfml.ignorePatchDiscrepancies=true
   ```
6. Launch.

## Likely gotchas

- **`no lwjgl in java.library.path`** — the same Modrinth 1.6.4 bug as Windows might
  appear. If so, use Prism (it sets the native path), or run the equivalent of
  `FixLaunch.bat` against `~/.local/share/PrismLauncher/libraries/net/minecraft/launchwrapper/1.8`.
- Make sure the launcher is using **Java 8**, not a newer JDK — old Forge won't load
  on 17/21.

An `install.sh` for Linux would be welcome once the manual path is confirmed.
