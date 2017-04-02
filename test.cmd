@set ini=%1
@if not defined ini set ini=testSettings1.ini
@for /R %%F in ( *.tmpl ) do call src\Expander.cmd %ini% %%F
