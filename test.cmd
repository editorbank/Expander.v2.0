@echo off
set ini=%1
if not defined ini set ini=test\Settings1.ini
for /R %%F in ( *.tmpl ) do (
  echo %%F ...
  call src\Expander.cmd %ini% %%F
)