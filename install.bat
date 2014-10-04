@echo off
for /f "tokens=4-5 delims=. " %%i in ('ver') do ^
set VERSION=%%i.%%j
if ["%version%"] == ["[Version.5"] call :DetectXP
if ["%version%"] == ["6.1"] call :DetectArch
if ["%version%"] == ["6.0"] call :DetectArch
call :InstallTC
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo Installation finished!
echo.
echo TurboC has been installed to C:\TC
echo.
if ["%ARCH%"] == ["64-bit"] echo For 64-bit systems, run TC by double-clicking TC_x64.exe :)
if ["%ARCH%"] == [""] echo For 64-bit systems, run TC by double-clicking TC_x64.exe :)
echo.
echo.
pause
exit /b

:DetectXP
for /f "tokens=5-6 delims=. " %%i in ('ver') do ^
set VERSION=%%i.%%j
if ["%version%"] == ["5.1"] set ARCH=32-bit
if ["%version%"] == ["5.2"] set ARCH=64-bit
exit /b

:DetectArch
for /f %%i in ('wmic os get osarchitecture ^| findstr "bit\>"') do ^
set ARCH=%%i
exit /b

:InstallTC
echo Detected windows architecture as %ARCH%
call :InstallTurboC
if ["%ARCH%"] == ["64-bit"] call :Install64bitPatch
if ["%ARCH%"] == [""] call :InstallManual
exit /b

:InstallTurboC
echo.
echo.
echo Installing TurboC...
echo.
xcopy TC C:\TC /evifky
exit /b

:Install64bitPatch
echo.
echo.
echo Installing patch...
echo.
xcopy Patcher\PatcherFiles C:\TC\PatcherFiles /evifhky
copy Patcher\TC_x64.EXE C:\TC\TC_x64.EXE /bvy
xcopy "Patcher\TurboC Patcher" "%appdata%\..\Local\TurboC Patcher" /evifky
exit /b

:InstallManual
echo.
echo.
echo -------------------------------------------------------
echo -  You are running on an unsupported Windows version  -
echo -                                                     -
echo -    Automatically assuming the system is 64-bit.     -
echo - If this is not the case, please terminate this now  -
echo -           by pressing Ctrl + C, then y              -
echo -------------------------------------------------------
pause
call :Install64bitPatch
exit /b
