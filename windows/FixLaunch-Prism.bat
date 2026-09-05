@echo off
echo Applying SkyFactory 1.6.4 launch fix (Prism)...
set "LIBDIR=%APPDATA%\PrismLauncher\libraries\net\minecraft\launchwrapper\1.8"
mkdir "%LIBDIR%" 2>nul
copy /Y "%~dp0launchwrapper-1.8.jar" "%LIBDIR%\launchwrapper-1.8.jar" >nul
if %errorlevel%==0 (echo Done! Patched launchwrapper installed.) else (echo ERROR: launch the instance once first, then re-run this.)
pause
