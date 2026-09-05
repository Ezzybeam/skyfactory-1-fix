@echo off
REM ============================================================
REM  SkyFactory 1.3.2 - Windows installer (Modrinth)
REM  Downloads the modpack from this repo's GitHub Release,
REM  applies the launchwrapper fix, and opens Modrinth.
REM  Windows: WORK IN PROGRESS (see notes at the end).
REM ============================================================
setlocal
set "REPO=Ezzybeam/skyfactory-1.3.2-launcher"
set "PACK_URL=https://github.com/%REPO%/releases/latest/download/SkyFactory-1.3.2.mrpack"
set "DEST=%USERPROFILE%\Downloads\SkyFactory-1.3.2.mrpack"

echo ==^> SkyFactory 1.3.2 installer (Windows / Modrinth)
echo ==^> Downloading modpack (~56 MB)...
curl -L --fail -o "%DEST%" "%PACK_URL%"
if errorlevel 1 (
  echo curl failed, trying PowerShell...
  powershell -NoProfile -Command "Invoke-WebRequest -Uri '%PACK_URL%' -OutFile '%DEST%'"
)
echo ==^> Saved: %DEST%

echo ==^> Applying launchwrapper fix to Modrinth's libraries...
set "LIBDIR=%APPDATA%\ModrinthApp\meta\libraries\net\minecraft\launchwrapper\1.8"
mkdir "%LIBDIR%" 2>nul
copy /Y "%~dp0windows\launchwrapper-1.8.jar" "%LIBDIR%\launchwrapper-1.8.jar" >nul
if %errorlevel%==0 (echo     patched launchwrapper installed.) else (echo     ^(will re-apply after import - see below^))

echo ==^> Opening Modrinth App / the modpack file...
start "" "modrinth://" >nul 2>&1
start "" "%DEST%"

echo.
echo --------------------------------------------------------------------
echo LAST STEPS in Modrinth App:
echo   1. Sign in with your Microsoft/Xbox account.
echo   2. Add Instance -^> "From file" -^> choose:
echo        %DEST%
echo   3. Let it install Minecraft 1.6.4 + Forge + mods.
echo   4. Instance -^> Options -^> Java: add these JVM args:
echo        -Dfml.ignoreInvalidMinecraftCertificates=true -Dfml.ignorePatchDiscrepancies=true
echo   5. If it crashes with ConcurrentModificationException, re-run
echo        windows\FixLaunch.bat  once (after the first launch).
echo   6. Launch.
echo.
echo NOTE (Windows is WIP): Modrinth may still crash with
echo   "no lwjgl in java.library.path" -- it does not set the LWJGL native
echo   path for 1.6.4. If so, see docs\windows.md. Help wanted!
echo --------------------------------------------------------------------
pause
