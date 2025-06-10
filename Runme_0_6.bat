:: Fixed for new YT-DLP Version
<!-- :: Batch section
@echo off

set /P "=Select mode: " < NUL
call :HTA-Input Button result= /V 36 4 15 8 "Video download mode" "Music download mode"
set mode=%result%
set "DirPop="(new-object -COM 'Shell.Application')^.BrowseForFolder(0,'Please choose the dowload location.',0,0).self.path""
for /f "usebackq delims=" %%I in (`powershell %DirPop%`) do set sl=%%I
cd %sl%
If %mode%==1 goto video

set /P "=In what format you want to download: " < NUL
call :HTA-Input RadioButton result= 24 16 46 7 "m4a" "mp3" "aac" "ogg"
if %result%==1 (Set format="m4a") else if %result%==2 (Set format="mp3") else if %result%==3 (Set format="aac") else if %result%==4 (Set format="ogg")
	:here
		set /p url="Url of Video/Playlist: "
		cd %~dp0/exceutables
		yt-dlp.exe -o %sl%/%%(title)s.%%(ext)s --extract-audio --audio-quality 0 --audio-format %format% "%url%"
set /P "=Do you have more to download: " < NUL
call :HTA-Input RadioButton result= 24 16 46 7 "Yes" "No"
echo Option selected = %result%
		if %result%==1 goto here 
		exit /b
	:video
		:here2
		set /p url="Url of Video/Playlist: "
		cd %~dp0/exceutables
		yt-dlp.exe -o %sl%/%%(title)s.%%(ext)s --list-formats "%url%"
set /P "=Select best or worst for the video quality you want to download: " < NUL
call :HTA-Input RadioButton result= 24 16 46 7 "Best availalbe (big file)" "Worst avaialble(small file)"
echo Option selected = %result%
	if %result%==1 (Set qu="best") else (Set qu="worst")
	
			yt-dlp.exe -o %sl%/%%(title)s.%%(ext)s -f "%qu%[ext=mp4]" "%url%"
set /P "=Do you have more to download: " < NUL
call :HTA-Input RadioButton result= 24 16 46 7 "Yes" "No"
echo Option selected = %result%
		if %result%==1 goto here2 
		exit /b

:HTA-Input form result= [/V]  col row width height  option1 option2 ...
setlocal EnableDelayedExpansion
set "form=%1" & shift
set "res=%1" & shift
if /I "%~1" equ "/V" (set "ver=<br>" & shift) else set "ver="
set "pos=%1 %2 %3 %4"
for /L %%i in (1,1,4) do shift
echo %form% > HTML 
set i=0
goto %form%

:Button
   set /A i+=1
   set /P "=<input type="button" onclick="closeHTA(%i%)" value="%~1">%ver% " >> HTML < NUL
   shift
if "%~1" neq "" goto Button
call :GetHTAreply
endlocal & set "%res%=%HTAreply%"
exit /B

:RadioButton
   set "button=%~1"
   if not defined button goto endButton
   set /A i+=1
   set "checked="
   if /I "!button:~0,3!" equ "/C:" (
      set "button=!button:~4,-1!"
      set "checked=checked"
      set "pos=%pos% %i%"
   )
   set /P "=<label><input type="radio" name="RB" onclick="rb=%i%" value="%i%" %checked%>%button%</label>%ver% " >> HTML < NUL
   shift
goto RadioButton

:endButton
set /P "=<br><br><button onclick="closeHTA(rb);">Submit</button>" >> HTML < NUL
call :GetHTAreply
endlocal & set "%res%=%HTAreply%"
exit /B

:GetHTAreply
set "HTAreply="
for /F "delims=" %%a in ('(echo %pos% ^& type HTML ^) ^| mshta.exe "%~F0"') do set "HTAreply=%%a"
del HTML
exit /B
-->

<HTML>
<HEAD>
<HTA:APPLICATION INNERBORDER="no" SYSMENU="no" SCROLL="no" >
   <style type="text/css">
   body {
      color: white;
      background: black;
      font-family: "Comic Sans", monospace;
   }
   </style>
</HEAD>
<BODY>
</BODY>
<SCRIPT language="JavaScript">
var fso     = new ActiveXObject("Scripting.FileSystemObject"),
    stdin   = fso.GetStandardStream(0),
    pos     = stdin.ReadLine().split(" "), rb = pos[4], cb = " ",
    cmdExe  = window.parent,
    winLeft = 300, winTop = 50,
    fontX = 20, fontY = 25;
window.moveTo(winLeft+fontX*pos[0],winTop+fontY*pos[1]);
window.resizeTo(fontX*pos[2],fontY*pos[3]);
document.title = "HTA Input "+stdin.ReadLine();
document.body.innerHTML = stdin.ReadLine();
function checkBox(opt){
   if ( cb.indexOf(" "+opt+" ") >= 0 ) {
      cb = cb.replace(" "+opt+" "," ");
   } else { 
      cb += opt+" ";
   }
}
function closeHTA(reply){
   fso.GetStandardStream(1).WriteLine(reply);
   window.close();
}
</SCRIPT>
</HTML>