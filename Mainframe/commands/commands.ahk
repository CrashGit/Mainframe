; Keep comments to the right of the command as you see now for the tooltip to work properly (typing ? in GUI)
; Write your own AHK commands in this file to be recognized by the GUI. Take inspiration from the samples provided
; Obviously a lot of directories will need to be changed to fit your needs
;---------------------------------------------
;-------------Extend GUI Commands-------------
;---------------------------------------------
; param1 = function call, param2 = gui title, param3 = tooltip text, param4 = url for searches
case 'reload ':		; Reload a script
	Gui_Command('ReloadScript', 'Reload Script', 'Reload a script already running')

case 'run ':		; Run a script
	Gui_Command('RunScript', 'Run Script', 'Run a script from the AHK folder')

case 'quit ':		; Kill a script
	Gui_Command('KillScript', 'Kill Script', 'Exit a running script')

case 'edit ':		; Edit a script
	Gui_Command('EditScript', 'Edit Script', 'Open a script from the AHK folder in VSCode')

case 'new ':		; Create a new ahk script
	Gui_Command('NewFile', 'File Name', 'Create a new file and open it in VSCode')

case 'replace':		; Replace text in selection
	Gui_Command('Replace', 'Text To Replace', 'Replace a string in the highlighted text')

;---------------------------------------------
;--------------------Stuff--------------------
;---------------------------------------------
case 'audio':		; Toggles headphones and soundbar output
	Run('mmsys.cpl')
	WinWaitActive('Sound')				

	InStr(SoundGetName(), 'focusrite') ? ControlSend('{Down 3}', 'SysListView321') : ControlSend('{Down 1}', 'SysListView321')	; if focusrite is enabled, enable soundbar; vice versa
	
	sleep(150)
	ControlClick('Set Default')			; set default
	WinClose('Sound') 					; close sound panel
	
	SetTimer(() => ToolTip(,,, 3), -5000)
	ToolTip(SoundGetName(), A_ScreenWidth - 1, A_ScreenHeight - 1, 3)

    WinMove(A_ScreenWidth - 200,,,, SoundGetName()) ; temp until tooltip placement is fixed

case 'sound':		; Opens audio device menu
	Run('mmsys.cpl')

case 'ethernet':	; Enables/disables Ethernet
	; I don't use this anymore but was useful when my wifi and ethernet were dumb and couldn't decide which wanted to give good speeds
	Run('::{7007ACC7-3202-11D1-AAD2-00805FC1270E}')
	WinWaitActive('Network Connections')

	Send('{Right 2}')	; adjust to how many to the right the ethernet controller is
	Send('{AppsKey}')	; sends right-click context menu
	Sleep(100) 
	Send('{Down}')		; highlights top option in menu (Enable/Disable)
	Sleep(100)
	Send('{Enter}')		; selects highlighted option

	WinClose('Network Connections')

;---------------------------------------------
;---------------Launch Websites---------------
;---------------------------------------------
case 'gmail':		; Open Gmail
	Run('https://mail.google.com/mail/u/0/#inbox')

case 'icloud':		; Open iCloud mail
	Run('https://www.icloud.com/mail/')

case 'amazon':		; Open Amazon
	Run('https://www.amazon.com')

case 'prime':		; Open Amazon Prime Video
	Run('https://www.amazon.com/gp/video/storefront/ref=sv_atv_logo?node=2858778011')

case 'hulu':		; Open Hulu
	Run('https://www.hulu.com/hub/home')

;---------------------------------------------
;--------------------Search-------------------
;---------------------------------------------
; param1 = function call, param2 = gui title, param3 = tooltip text, param4 = url for searches
case 'g ':			; Search Brave
	Gui_Command('Search', 'Brave Search', 'Use Brave Search to search online', 'https://search.brave.com/search?q=REPLACEME&source=web')		

case 'd ': 			; Search Duck Duck Go
	Gui_Command('Search', 'Duck Duck Go', 'Use Duck Duck Go to search online', 'https://duckduckgo.com/?q=REPLACEME&t=h_&ia=web')		

case 'a ':			; Search Brave for AutoHotkey related stuff
	Gui_Command('Search', 'AHK Search', 'Use Brave Search to search posts related to autohotkey', 'https://search.brave.com/search?q=Autohotkey+REPLACEME&source=web')		

case 't ':			; Search Thesaurus for synonyms
	Gui_Command('Search', 'Thesaurus', 'Find synonyms for a word', 'https://www.thesaurus.com/browse/REPLACEME')

case 'y ':			; Search Youtube
	Gui_Command('Search', 'Search YouTube', 'Search YouTube', 'https://www.youtube.com/results?search_query=REPLACEME')

case '/':			; Go to subreddit
	Gui_Command('Search', '/r/', 'Go to a specific subreddit', 'https://www.reddit.com/r/REPLACEME')	

case 'help':		; AHK v2 new help requests, may learn
	Run('https://www.autohotkey.com/boards/viewforum.php?f=82&sid=915b9fff34897ae25982b872de3b093a')

;---------------------------------------------
;---------------Launch Programs---------------
;---------------------------------------------
; Launching Microsoft Store Apps
; paste/type shell:AppsFolder into the Windows Explorer or the Run window (Windows + r)
; right click an app and create shortcut, agree to create it on the desktop

; OPTION 1:
; right click the shortcut link and go to properties, look at the line 'Target type:'
; use Run('shell:AppsFolder\TARGET TYPE') replacing TARGET TYPE with what you found in the previous step
; you can delete this shortcut
; sometimes the Target type gets cut off, if the name is genuinely too long for you to guess what the cut-off part is, use option 2

; OPTION 2:
; create a folder somewhere of your choosing and put the shortcut(s) in there
; rename the shortcut to what makes sense for you (probably just remove the '- Shortcut')
; use Run() with the path to the file

case 'netflix':		; Open Netflix app	
	Run('shell:AppsFolder\4DF9E0F8.Netflix_mcm4njqhnhss8!Netflix.App')
	
case 'note':		; Notepad++
	Run('Notepad++')	

case 'code':		; Run VSCode
	if WinExist('ahk_exe Code.exe')
		WinActivate('ahk_exe Code.exe')
	else
		Run('Code')

;---------------------------------------------
;----------------Type Raw Text----------------
;---------------------------------------------
case 'shrug': 		; ¯\_(ツ)_/¯
	SendTextToScreen('¯\_(ツ)_/¯')

case 'paste': 		; Paste clipboard content without formatting	
	SetTimer(() => SendText(A_ClipBoard), -50)

case '@i': 			; Enter iCloud email address	
	SendTextToScreen('placeholder@icloud.com')

case '@g': 			; Enter gmail email address	
	SendTextToScreen('placeholder@gmail.com')

case 'phone': 		; Enter phone number	
	SendTextToScreen('placeholder')	

;---------------------------------------------
;-----------------Open Folders----------------
;---------------------------------------------
case 'dl': 			; Downloads
	Run('C:\Users\' A_Username '\Downloads')

Case 'video': 		; Videos Folder
	Run('C:\Users\' A_Username '\Videos')

case 'ahk': 		; AHK Folder
	Run(A_ScriptDir '\..\')

case 'main': 		; Open Mainframe script folder / This folder
	Run(A_ScriptDir)

case 'lib': 		; Open library foldera
	Run(A_ScriptDir '\library\')

case 'bin':			; Recycle Bin		
	Run('shell:RecycleBinFolder')

case 'empty': 		; Empty Recycle Bin
	FileRecycleEmpty()	

case 'startup':		; Open startup Folder
	Run(A_Startup)	; useful for quickly finding the folder to drop ahk files in for autostarting on login

case 'backup':		; Backup the Mainframe folder to two other hard drives
	AddProgressBar('Backing Up Files...', true)
	SetTimer(() => DirCopy('C:\Users\' A_Username '\Desktop\autohotkey\Mainframe', 'F:\Setting up Windows\autohotkey\Mainframe', 1), -10)
	SetTimer(() => DirCopy('C:\Users\' A_Username '\Desktop\autohotkey\Mainframe', 'D:\External Backup\Setting up Windows\autohotkey\Mainframe', 1), -10)

;---------------------------------------------
;----------------Miscellaneous----------------
;---------------------------------------------
case ' ':			; Lazy destroy GUI	

case 'sleep':		; Put computer to sleep
	; Int Parameter #1: Pass 1 instead of 0 to hibernate rather than suspend.
	; Int Parameter #2: Pass 1 instead of 0 to suspend immediately rather than asking each application for permission.
	; Int Parameter #3: Pass 1 instead of 0 to disable all wake events.
	AddProgressBar('Putting to Sleep')
	DllCall('PowrProf\SetSuspendState', 'Int', 0, 'Int', 0, 'Int', 0)

case 'reboot': 		; Restart computer
	AddProgressBar('Rebooting...')
	Shutdown(2)

case 'shut down':	; Shut down computer
	AddProgressBar('Shutting Down...')
	Shutdown(8)

case 'connect':		; Connect to TV
	Send('#k')		; Windows 11
	Sleep(1000)
	Send('{Enter}')

case 'disconnect':	; Disconnect from TV
	Send('#k')		; Windows 11
	Sleep(500)		
	Send('{Tab}')
	Send('{Enter}')

case 'refresh':		; Reload this script		
	Reload		

case 'spy':			; Open Window Spy
	Run('C:\Program Files\AutoHotkey\WindowSpy.ahk')

case 'scripts':		; Get list of running scripts
	CoordMode('ToolTip') 	; To make sure the tooltip coordinates is displayed according to the screen and not active window
	scripts := GetRunningScripts()
	scriptToolTip := CreateListFromArray(scripts)
	
	SetTimer(() => ToolTip(,,, 2), -5000)
	ToolTip(scriptToolTip, A_ScreenWidth - 1, A_ScreenHeight - 1, 2)

case '?':			; Tooltip with list of commands		
	MainGui['input'].value := '' ; Clear the input box
	input := ''
	CommandList()
