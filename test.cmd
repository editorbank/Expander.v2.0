set STAND=%1
set PASS=%2
@if not defined STAND set /P STAND=Enter Password([Ctrl]+[C] - break, [Enter] - set stand as "DEV"):
@if not defined STAND set STAND=DEV
@if not defined STAND echo Use %~n0 ^<STAND^> [^<PASS^>] &&exit /b 1
@if not defined PASS set /P PASS=Enter Password([Ctrl]+[C] - break, [Enter] - set password as "%COMPUTERNAME%"):
@if not defined PASS set PASS=%COMPUTERNAME%
@if not exist target md target
@set inis=test\Default.ini test\%STAND%.ini test\After.ini
@for /R %%F in ( *.tmpl ) do @(
  echo Templayting %%F ...
  echo.|call bin\Expander.cmd DB_PASS=%PASS% STAND=%STAND% %inis% %%F
  if ERRORLEVEL 1 echo ERROR: SEE ERROR IN .\Expander.log &&exit /b 1
)