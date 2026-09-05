@echo off
REM SkyFactory 1.3.2 - collect the game crash log (Windows) for sharing.
REM Run this if the game won't launch, then send the file it prints.
setlocal enabledelayedexpansion
set "OUT=%USERPROFILE%\Downloads\skyfactory-crash-log.txt"
set "PROF=%APPDATA%\ModrinthApp\profiles"
set "INSTALL_LOG=%USERPROFILE%\Downloads\skyfactory-install-log.txt"

echo ===== SkyFactory crash-log bundle %date% %time% =====> "%OUT%"
echo Windows: %OS%  %PROCESSOR_ARCHITECTURE%>> "%OUT%"

echo.>> "%OUT%"
echo ----- installer log ----->> "%OUT%"
if exist "%INSTALL_LOG%" (type "%INSTALL_LOG%">> "%OUT%") else (echo ^(none^)>> "%OUT%")

set "NEWEST="
for /f "delims=" %%F in ('dir /b /s /a-d /o-d "%PROF%\*.log" 2^>nul') do (
  if not defined NEWEST set "NEWEST=%%F"
)
echo.>> "%OUT%"
if defined NEWEST (
  echo ----- newest game log: !NEWEST! ----->> "%OUT%"
  type "!NEWEST!">> "%OUT%"
) else (
  echo ----- no game log found under %PROF% ----->> "%OUT%"
  echo ^(launch the instance once so it writes a log, then re-run this^)>> "%OUT%"
)

for /f "delims=" %%C in ('dir /b /s /a-d /o-d "%PROF%\crash-*.txt" 2^>nul') do (
  echo.>> "%OUT%"
  echo ----- crash report: %%C ----->> "%OUT%"
  type "%%C">> "%OUT%"
)
for /f "delims=" %%H in ('dir /b /s /a-d /o-d "%PROF%\hs_err_pid*.log" 2^>nul') do (
  echo.>> "%OUT%"
  echo ----- native crash: %%H ----->> "%OUT%"
  type "%%H">> "%OUT%"
)

echo Wrote: %OUT%
echo Send that file so the launch failure can be diagnosed.
start "" explorer /select,"%OUT%"
pause
