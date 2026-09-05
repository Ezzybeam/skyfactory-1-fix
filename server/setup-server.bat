@echo off
REM SkyFactory 1.3.2 dedicated server setup (Windows). Needs Java 8 to RUN.
setlocal
set "DIR=%USERPROFILE%\skyfactory-server"
set "REPO=Ezzybeam/skyfactory-1-fix"
set "HERE=%~dp0"
echo ==^> Setting up SkyFactory server in %DIR%
mkdir "%DIR%" 2>nul
cd /d "%DIR%"

echo ==^> Downloading Forge universal + Minecraft 1.6.4 server jar...
curl -L --fail -o forge-1.6.4-9.11.1.965-universal.jar "https://maven.minecraftforge.net/net/minecraftforge/forge/1.6.4-9.11.1.965/forge-1.6.4-9.11.1.965-universal.jar"
curl -L --fail -o minecraft_server.1.6.4.jar "https://launcher.mojang.com/v1/objects/050f93c1f3fe9e2052398f7bd6aca10c63d64a87/server.jar"

echo ==^> Downloading the modpack + extracting...
curl -L --fail -o pack.mrpack "https://github.com/%REPO%/releases/latest/download/SkyFactory-1.3.2.mrpack"
powershell -NoProfile -Command "Expand-Archive -Force -LiteralPath 'pack.mrpack' -DestinationPath '_unpack'" 2>nul
if not exist mods mkdir mods
if not exist config mkdir config
if not exist scripts mkdir scripts
xcopy /E /I /Y "_unpack\overrides\mods" "mods" >nul 2>&1
xcopy /E /I /Y "_unpack\overrides\config" "config" >nul 2>&1
xcopy /E /I /Y "_unpack\overrides\scripts" "scripts" >nul 2>&1
rmdir /S /Q _unpack 2>nul & del /Q pack.mrpack 2>nul

echo ==^> Removing client-only mods...
for /f "usebackq delims=" %%P in ("%HERE%server-mods-exclude.txt") do (
  echo %%P| findstr /b "#" >nul || del /Q "mods\*%%P*" 2>nul
)

echo ==^> Linking Forge libraries from Modrinth (if present)...
set "LIBSRC=%APPDATA%\ModrinthApp\meta\libraries"
if exist "%LIBSRC%" (
  rmdir libraries 2>nul
  mklink /D libraries "%LIBSRC%" >nul 2>&1 || robocopy "%LIBSRC%" "libraries" /E /NFL /NDL /NJH /NJS >nul
  echo     libraries ready.
) else (
  echo     ^(!^) Modrinth libraries not found - install the client with this repo's launcher first,
  echo         or Forge will try to download libs on first boot ^(some 1.6.4 URLs are dead^).
)

echo ==^> Writing server.properties...
(
echo level-name=skyworld
echo level-type=DEFAULT
echo online-mode=true
echo gamemode=0
echo difficulty=2
echo allow-flight=true
echo spawn-protection=0
echo max-players=10
echo view-distance=6
echo server-port=25565
echo motd=SkyFactory 1.3.2
) > server.properties

echo ==^> Writing run-server.bat...
(
echo @echo off
echo cd /d "%%~dp0"
echo set "J8=java"
echo for /d %%%%D in ("%%ProgramFiles%%\Eclipse Adoptium\jre-8*" "%%ProgramFiles%%\Eclipse Adoptium\jdk-8*" "%%ProgramFiles%%\Java\jre1.8*"^) do if exist "%%%%D\bin\java.exe" set "J8=%%%%D\bin\java.exe"
echo "%%J8%%" -Xms1G -Xmx3G -jar forge-1.6.4-9.11.1.965-universal.jar nogui
echo pause
) > run-server.bat

echo.
echo ============================================================
echo Server ready in %DIR%
echo Start it:  cd /d "%DIR%" ^&^& run-server.bat   (needs JAVA 8)
echo Friends over internet: port-forward TCP 25565 (or use playit.gg). Op yourself: op ^<name^>
echo VOID world generates on first boot (level-name=skyworld). spawn-protection=0 so you can build at spawn.
echo ============================================================
pause
