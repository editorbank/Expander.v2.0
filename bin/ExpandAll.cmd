@if not exist "%~dp0Expander.cmd" @echo Error: not found "%~dp0Expander.cmd"! && exit /b 1
@for /R %%F in ( *.tmpl ) do @(echo.|call "%~dp0Expander.cmd" %* %%F)
@if ERRORLEVEL 1 echo ERROR: SEE ERROR IN Expander.log &&exit /b 1
