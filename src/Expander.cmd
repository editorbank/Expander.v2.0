rem /* Expander v2.0 *\
::CMD //----------\\""=\*\\*//*/=""//----------
@echo off
title %~n0
if "%~1"=="" goto :help
set __log__="%~dpn0.log"
set __dbg__=off
echo.>>%__log__%
echo ---- %DATE% %TIME% Start with parameters: %* >>%__log__%

cscript //E:JScript //NOLOGO "%~dpnx0" %* 1>>%__log__% 2>>&1
if not "%errorlevel%"=="0" goto :err

:end
echo ---- %DATE% %TIME% Complete Successfully>>%__log__%
echo.>>%__log__%
goto :eof

:err
echo ---- %DATE% %TIME% Complete With Errors!!! Level="%errorlevel%".>>%__log__%
echo.>>%__log__%
if not "%errorlevel%"=="0" Echo Error!!! Level="%errorlevel%". See %__log__% & goto :help
goto :eof

:help
  echo.Create files by template (.tmpl) and expand from environments variables and variables from initialization files (.ini). 
  echo.(c)14.07.2014 Zakharov-EYu. 
  echo.
  echo.Use: 
  echo.  %~n0 [/d[ebug]] ^<file1.ini^> ^<file2.tmpl^> [...]
  pause
exit /B 1
::JScript //----------\\""=\*/=""//----------

var Expander_Error="";

var _Expander_Debug = false;
var _Expander_Debug_inicounter = 0;
var _Expander_Debug_expcounter = 0;
var _Expander_Debug_file = "";
var _Expander_Debug_lineNo = 0;
var _Expander_Shell = new ActiveXObject("WScript.Shell");
var _Expander_FSO = new ActiveXObject("Scripting.FileSystemObject");
var _Expander_Vars = {};

_Expander_reIni = /[.]ini$/i;
_Expander_reTemplate = /[.]tmpl$/i;
_Expander_reDebug = /^\/d(e|eb|ebu|ebug)?$/i;


Expander_Debug_Position=function(){
  return "\""+_Expander_Debug_file+"\"#"+_Expander_Debug_lineNo+": ";
}

Expander_ErrorSet=function(message){
  Expander_Error+=(Expander_Error?"\n":"")+Expander_Debug_Position()+message;
}


_Expander_Exp1=function(name){
  ++_Expander_Debug_expcounter;
  if(name=="%%") return "%";
  var value=_Expander_Shell.ExpandEnvironmentStrings(name);
  if(value==name){
    value="";
    if(typeof(_Expander_Vars[name])=="undefined") Expander_ErrorSet("No defined variable "+name+"!!! Set empty value.");
  }
  return value;
}

_Expander_reVariabe=/[%]([_a-z][_a-z0-9]+)[%]/ig; // Length of variabes names must have 2 characters or more.
Expander_ExpandString=function(value){
  return value.replace(_Expander_reVariabe,_Expander_Exp1);
}

Expander_AddValue=function(name,value){
  ++_Expander_Debug_inicounter;
  _Expander_Vars["%"+name+"%"]=value;
  value=_Expander_Shell.ExpandEnvironmentStrings(value);
  if(_Expander_Debug) WScript.Echo(Expander_Debug_Position()+_Expander_Debug_inicounter+". "+name+" = \""+value+"\"");
  _Expander_Shell.Environment("Process")(name)=(value);
}

Expander_IniLoad=function(filename){
  //Expander_Error="";
  _Expander_Debug_file = filename;
  _Expander_Debug_lineNo = 0;
  var isComment=/^\s*$|^\s*[;#]/;
  var isParameter=/^\s*([_a-z][_a-z0-9]*)\s*[=]\s*(([^"';#\s]+)|"([^"]*)"|'([^']*)')/i;
  if(!_Expander_FSO.FileExists(filename)) return false;
  var f = _Expander_FSO.OpenTextFile(filename,1,false,0);
  if(!f) return false;
  var line;
  while (!f.AtEndOfStream){
    line = f.ReadLine();++_Expander_Debug_lineNo;
    if(isComment.test(line))continue;
    var m=line.match(isParameter);
    if(!m) {Expander_ErrorSet("Error parsing!!!"); continue;}
    //if(_Expander_Debug) WScript.Echo("["+m[1]+"] = ["+m[3]+m[4]+m[5]+"]");
    Expander_AddValue(m[1],Expander_ExpandString(m[3]+m[4]+m[5]));
  }
  f.Close();
  return Expander_Error=="";
};

Expander_ExpandFileTo=function(filename,tofile){
  //Expander_Error="";
  _Expander_Debug_file = filename;
  _Expander_Debug_lineNo = 0;
  var isComment=/^\s*$|^\s*[;#]/;
  var isParameter=/^\s*([_a-z][_a-z0-9]*)\s*[=]\s*(([^"';#\s]+)|"([^"]*)"|'([^']*)')/i;
  if(!_Expander_FSO.FileExists(filename)) return false;
  var fi = _Expander_FSO.OpenTextFile(filename,1,false,0);//1-ForReading,no create,0-Opens the file as ASCII.
  var fo = _Expander_FSO.OpenTextFile(tofile,2,true,0);//2-ForWriting,create,0-Opens the file as ASCII.
  if(!fi){ return false;}
  if(!fo){fi.Close(); return false;}
  var line;
  while (!fi.AtEndOfStream){
    ++_Expander_Debug_lineNo;
    line=fi.ReadLine();
    var dbg=_Expander_Debug && _Expander_reVariabe.test(line);
    if(dbg) WScript.Echo(Expander_Debug_Position()+"\n"+line);
    line=Expander_ExpandString(line);
    if(dbg) WScript.Echo(line+"\n");
    fo.WriteLine(line);
  }
  fi.Close();
  fo.Close();
  return Expander_Error=="";
};

Expander_ExpandFile=function(filename,tofile){
  var tofile=filename.replace(_Expander_reTemplate,"");
  if(tofile==filename||tofile=="") tofile=filename+".expanded";
  return Expander_ExpandFileTo(filename,tofile);
}

try{
for (i = 0; i < WScript.Arguments.length; i++){
   var filename=WScript.Arguments(i);
   if(_Expander_reIni.test(filename)){
     _Expander_Debug_inicounter=0;
     WScript.Echo("Load ini:  "+filename+" ...");
     Expander_IniLoad(filename);
     WScript.Echo("Loaded: "+_Expander_Debug_inicounter+" variables.");
   }else if(_Expander_reTemplate.test(filename)){
     WScript.Echo("Expand template: "+filename+" ...");
     _Expander_Debug_expcounter=0;
     Expander_ExpandFile(filename);
     WScript.Echo("Expanded: "+_Expander_Debug_expcounter+" destinations.");
   }else if(_Expander_reDebug.test(filename)){
     WScript.Echo("Debug:ON.");
     _Expander_Debug = true;
   }else{
     WScript.Echo("Skeeped \""+filename+"\". Unknown type of file or argument.");
   }
}
}catch(error){Expander_ErrorSet("Error "+error.number+" - "+error.description+"!!!");}
if(Expander_Error) WScript.StdErr.Write("Expander_Error:\n"+Expander_Error+"\n");
WScript.Quit(Expander_Error?1:0);
