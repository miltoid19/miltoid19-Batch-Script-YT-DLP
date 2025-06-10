<!--
@echo on
set /p mode="Insert v for video mode or any other letter for music mode: "
set "DirPop="(new-object -COM 'Shell.Application')^.BrowseForFolder(0,'Please choose the dowload location.',0,0).self.path""
for /f "usebackq delims=" %%I in (`powershell %DirPop%`) do set sl=%%I
If %mode%==v goto video
set /p format=" In what format you want to download aac, flv, m4a, mp3, wav, ogg, webm: "
	:here
		set /p url="Url of Video/Playlist: "
		cd %~dp0/exceutables
		yt-dlp.exe -o %sl%/%%(title)s.%%(ext)s --extract-audio --audio-quality 0 --audio-format %format% "%url%"
		set /p an="Insert y if you have more videos or any input to close: "
		if %an%==y goto here 
		exit /b
	:video
		:here2
		set /p url="Url of Video/Playlist: "
		cd %~dp0/exceutables
		yt-dlp.exe -o %sl%/%%(title)s.%%(ext)s --list-formats "%url%"
			set /p exten=" In what extention you want to download from the list (recomended mp4): "
			set /p format="Insert -->best<-- or -->worst<-- for the video quality you want to download: "
			youtube-dl -o %sl%/%%(title)s.%%(ext)s -f "%format%[ext=%exten%]" "%url%"
		set /p an="Insert y if you have more videos or any other input to close: "
		if %an%==y goto here2 
		exit /b
-->


 
