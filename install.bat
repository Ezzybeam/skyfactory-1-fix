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

if exist "%DEST%" (
  echo ==^> SkyFactory 1.3.2 UPDATER (Windows / Modrinth)
  echo ==^> Existing pack found - fetching the latest version...
) else (
  echo ==^> SkyFactory 1.3.2 installer (Windows / Modrinth)
)
echo ==^> Downloading modpack (~56 MB) to your Downloads folder...

where curl >nul 2>&1
if %errorlevel%==0 (
  curl -L --fail -o "%DEST%" "%PACK_URL%"
) else (
  echo     curl not found - using PowerShell...
  powershell -NoProfile -Command "$ProgressPreference='SilentlyContinue';[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;Invoke-WebRequest -Uri '%PACK_URL%' -OutFile '%DEST%'"
)

REM --- verify the download actually landed (>1 MB) ---
if not exist "%DEST%" goto dlfail
for %%A in ("%DEST%") do if %%~zA LSS 1000000 goto dlfail
echo ==^> Saved: %DEST%

echo ==^> Applying launchwrapper fix to Modrinth's libraries...
set "LIBDIR=%APPDATA%\ModrinthApp\meta\libraries\net\minecraft\launchwrapper\1.8"
mkdir "%LIBDIR%" 2>nul
copy /Y "%~dp0windows\launchwrapper-1.8.jar" "%LIBDIR%\launchwrapper-1.8.jar" >nul
if %errorlevel%==0 (echo     patched launchwrapper installed.) else (echo     ^(not yet - re-run windows\FixLaunch.bat after the first import^))

echo ==^> Opening Modrinth App / the modpack file...
start "" "modrinth://" >nul 2>&1
start "" "%DEST%"
if not exist "%APPDATA%\ModrinthApp" (
  echo.
  echo !! Modrinth App may not be installed. Get it: https://modrinth.com/app
  start "" "https://modrinth.com/app"
)

echo.
echo --------------------------------------------------------------------
echo LAST STEPS in Modrinth App:
echo   1. Sign in with your Microsoft/Xbox account.
echo   2. Add Instance -^> "From file" -^> choose:
echo        %DEST%
echo   3. Let it install Minecraft 1.6.4 + Forge + mods.
echo   4. Instance -^> Options -^> Java: add these JVM args:
echo        -Dfml.ignoreInvalidMinecraftCertificates=true -Dfml.ignorePatchDiscrepancies=true
echo   5. If it crashes with ConcurrentModificationException, launch once,
echo        then re-run  windows\FixLaunch.bat , then launch again.
echo   6. Launch.
echo.
echo TO UPDATE LATER: just run this installer again - it grabs the newest
echo   pack. Then re-import the .mrpack in Modrinth (or delete the old
echo   instance and import the new file) to apply the update.
echo.
echo NOTE (Windows is WIP): Modrinth may still crash with
echo   "no lwjgl in java.library.path" -- it does not set the LWJGL native
echo   path for 1.6.4. If so, see docs\windows.md (Prism fallback). Help wanted!
echo --------------------------------------------------------------------
pause
goto end

:dlfail
echo.
echo !! Download FAILED (file missing or too small).
echo    Check your internet connection and try again.
echo    URL: %PACK_URL%
pause

:end
endlocal
