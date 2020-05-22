set STAND=%1
set PASS=%2
@if not defined STAND set /P STAND=Enter Password([Ctrl]+[C] - break, [Enter] - set stand as "DEV"):
@if not defined STAND set STAND=DEV
@if not defined STAND echo Use %~n0 ^<STAND^> [^<PASS^>] &&exit /b 1
@if not defined PASS set /P PASS=Enter Password([Ctrl]+[C] - break, [Enter] - set password as "%COMPUTERNAME%"):
@if not defined PASS set PASS=%COMPUTERNAME%

cd test
call ..\bin\ExpandAll.cmd DB_PASS=%PASS% STAND=%STAND% Default.ini %STAND%.ini After.ini
cd ..
