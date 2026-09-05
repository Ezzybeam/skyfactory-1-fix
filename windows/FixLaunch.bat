@echo off
echo Applying SkyFactory 1.6.4 launch fix...
set "LIBDIR=%APPDATA%\ModrinthApp\meta\libraries\net\minecraft\launchwrapper\1.8"
mkdir "%LIBDIR%" 2>nul
copy /Y "%~dp0launchwrapper-1.8.jar" "%LIBDIR%\launchwrapper-1.8.jar" >nul
if %errorlevel%==0 (
    echo Done! Patched launchwrapper installed.
    echo You can now launch SkyFactory normally.
) else (
    echo ERROR: Copy failed. Make sure you imported the modpack first,
    echo        and that launchwrapper-1.8.jar sits in this same folder.
)
pause
