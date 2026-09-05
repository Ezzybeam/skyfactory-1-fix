@echo off
setlocal enabledelayedexpansion
title SkyFactory - Modrinth Windows fix
echo === SkyFactory 1.3.2 - Modrinth Windows fix ===
echo.
set "LIB=%APPDATA%\ModrinthApp\meta\libraries"
set "NAT=%USERPROFILE%\SkyFactory-natives"

if not exist "%LIB%" (
  echo Modrinth libraries folder not found. Import the pack + try launching once first.
  pause & exit /b 1
)

echo [1/3] Placing LWJGL + jInput 2.9.0/2.0.5 library jars (fixes canonicalize errors)...
robocopy "%~dp0lwjgl-fix" "%LIB%" /E /NFL /NDL /NJH /NJS /R:1 /W:1 >nul

echo [2/3] Installing native DLLs to  %NAT%
mkdir "%NAT%" 2>nul
robocopy "%~dp0natives-windows" "%NAT%" /E /NFL /NDL /NJH /NJS /R:1 /W:1 >nul
REM self-heal: if natives-windows wasn't next to this .bat, download the DLLs from GitHub
if not exist "%NAT%\lwjgl64.dll" (
  echo     natives folder was missing - downloading DLLs from GitHub...
  set "RAW=https://raw.githubusercontent.com/Ezzybeam/skyfactory-1-fix/main/natives-windows"
  for %%D in (lwjgl.dll lwjgl64.dll OpenAL32.dll OpenAL64.dll jinput-dx8.dll jinput-dx8_64.dll jinput-raw.dll jinput-raw_64.dll jinput-wintab.dll) do (
    curl -L --fail -o "%NAT%\%%D" "!RAW!/%%D" 2>nul || powershell -NoProfile -Command "iwr '!RAW!/%%D' -OutFile '%NAT%\%%D'"
  )
)

echo [3/3] Placing patched launchwrapper...
mkdir "%LIB%\net\minecraft\launchwrapper\1.8" 2>nul
copy /Y "%~dp0windows\launchwrapper-1.8.jar" "%LIB%\net\minecraft\launchwrapper\1.8\launchwrapper-1.8.jar" >nul

echo.
echo ============================================================
echo DONE. Now in Modrinth: edit the SkyFactory instance -> Options/Java
echo -> JVM arguments, and PASTE EXACTLY THIS (one line):
echo.
echo -Dfml.ignoreInvalidMinecraftCertificates=true -Dfml.ignorePatchDiscrepancies=true -Dorg.lwjgl.librarypath=%NAT% -Dnet.java.games.input.librarypath=%NAT%
echo.
echo Then press Play.
echo (If it still fails, run windows\CollectLog.bat and send the log.)
echo ============================================================
pause
