;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
; SUPPORTING FUNCTIONS
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; SHOW MENU AND OPEN/EDIT FILE
;-------------------------------------------------------------------------------
FileMenuGui(toBeEdited, secondary_input, notificationTitle) 
{
    open_with_vscode := 'C:\Users\' A_UserName '\AppData\Local\Programs\Microsoft VS Code\Code.exe '
    runScript := ''
    check_if_toBeEdited := toBeEdited ? open_with_vscode : runScript
    characters := '\\[0-9A-Za-z-_\{\}\[\]\(\)\. ]+'  ; possible characters in path/file name
    filePathsArray := []    ; stores the paths of files found
    longestName := 0    ; everything related to this is an attempt to center the menu to the screen

    CoordMode('Menu')
    FileMenu := Menu()
    FileMenu.SetColor('6772a2')

    loop files, A_ScriptDir '\..\*' secondary_input '*.*', 'R' ; looks for any file containing the inputted text  ; found an issue where .ahk_l files slipped by >:(
    {
        RegExMatch(A_LoopFileFullPath, characters characters '\..*$', &fileName)   ; store filename and previous folder as string
        if fileName.Len > longestName
            longestName := fileName.Len
        filePathsArray.Push(A_LoopFileFullPath)                                    ; add file path to array
        FileMenu.Insert(, fileName[], (filename, filePos, submenu) => RunOrEditMenuFile(filename, filePos, submenu))
        FileMenu.SetIcon(fileName[], 'shell32.dll', 270, 0)
        FileMenu.Add()
        continue   
    }
        try FileMenu.Delete(((filePathsArray.Length * 2)) '&') ; removes extra separator at the end
        

        if filePathsArray.Length = 1 {      ; if only one match found, run/edit it
            Run(check_if_toBeEdited '"' filePathsArray[1] '"')
            RunOrEdit_Notification(filePathsArray[1])
        }
        else {
            AddProgressBar('Gathering Files')
            FileMenu.Show((A_ScreenWidth / 2) - ((longestName * 2) + 100), (A_ScreenHeight / 2) - (23 * filePathsArray.Length)) ; can't get proper width :( 23 is half the height of a menu item, use Window Spy to guesstimate
        }
        

        RunOrEditMenuFile(filename, filePos, submenu) 
        {
            Run(check_if_toBeEdited '"' filePathsArray[Ceil(filePos / 2)] '"')
            RunOrEdit_Notification(filename)
        }

        RunOrEdit_Notification(filename) 
        {
            filename := RegExReplace(filename, '^.+\\|\.+$')
            ShowNotification(notificationTitle, filename, 500)
        }
}

;-------------------------------------------------------------------------------
; RELOAD OR KILL SCRIPT
;-------------------------------------------------------------------------------
GetScriptAnd(reload_or_kill_script, input, soundFrequency, notificationTitle) 
{
    DetectHiddenWindows('On')
    list := WinGetList('ahk_class AutoHotkey')  ; creates a list of all running ahk scripts

    for index, id in list
    {
        title := WinGetTitle('ahk_id ' id)      ; get title of each id during the loop
        if InStr(title, input)
        {
            %reload_or_kill_script%(title)
            title := RegExReplace(title, ' - AutoHotkey v[\- .0-9a-z]+$')   ; trims end of file name
            title := RegExReplace(title, '^.+\\|\.+$')                      ; converts the path name to just the name of the file
            
            ShowNotification(notificationTitle, title, soundFrequency)
            break
        }
    }
}

;-------------------------------------------------------------------------------
; GET A LIST OF SCRIPTS CURRENTLY RUNNING
;-------------------------------------------------------------------------------
GetRunningScripts() 
{
    DetectHiddenWindows('On')
    scripts := []
    list := WinGetList('ahk_class AutoHotkey')

    for index, id in list
    {
        title := WinGetTitle('ahk_id ' id)
        scripts.Push(RegExReplace(title, ' - AutoHotkey v[\- .0-9a-z]+$'))  ; stores all ahk scripts running in scripts array
        scripts[index] := RegExReplace(scripts[index], '^.+\\|\.+$')        ; converts the path name to just the name of the file
        scripts[index] := Format('{:L}', scripts[index])                    ; converts name to all lowercase
    }

    return scripts
}

;-------------------------------------------------------------------------------
; CREATE A LIST FROM AN ARRAY USEFUL FOR THINGS SUCH AS A TOOLTIP
;-------------------------------------------------------------------------------
CreateListFromArray(array) 
{
    for index, value in array 
    {
        if (index = array.Length)
            tooltip .= value
        else
            tooltip .= value '`n'
    }
    return tooltip
}

;-------------------------------------------------------------------------------
; SAME AS SEND() BUT WITH A DELAY
;-------------------------------------------------------------------------------
SendTextToScreen(text)     ; this sets a delay to sending text so the gui can be destroyed first, per the function SubmitAndDestroy()
{    
    SetTimer(() => Send(text), -50)
}

;-------------------------------------------------------------------------------
; ADD A PROGRESSBAR TO SIMULATE PROGRESS
;-------------------------------------------------------------------------------
AddProgressBar(text, use_timer := false) 
{
    if use_timer    ; timer version allows the progress bar to show up along-side whatever you're doing
        SetTimer(ShowProgressBar, -10)
    else
        ShowProgressBar()

    ShowProgressBar() 
    {
        ProgressGui := Gui('+AlwaysOnTop -SysMenu +ToolWindow -Caption -Border')
        ProgressGui.BackColor := '181a1b'
        ProgressGui.AddText('cFFFFFF', text)
        ProgressGui.AddProgress('C6772a2 Background292a35 Smooth vprogress')
        ProgressGui.Show()

        while ProgressGui['progress'].value < 100
        {
            ProgressGui['progress'].value += 4
            Sleep(10)
        }
        ProgressGui.Destroy()
        ProgressGui := unset
    }
}

;-------------------------------------------------------------------------------
; SHOWS A TOOLTIP WHEN HOVERING OVER TITLES IN THE GUI
;-------------------------------------------------------------------------------
TitleToolTip(wParam, lParam, msg, Hwnd)
{   
    try WinGetPos(&xGui, &yGui, &guiWidth, &guiHeight, MainGui) ; get position and dimensions of gui
    static PrevHwnd := 0

    if (Hwnd != PrevHwnd) 
    {
        currControl := GuiCtrlFromHwnd(Hwnd)
        
        if currControl {
            if !currControl.HasProp("tooltip")
                return

            SetTimer(DisplayTitleToolTip, -10)
        } 
        else 
            ToolTip(,,, 4)  ; clear tooltip when moving off gui title

        PrevHwnd := Hwnd
    }

    DisplayTitleToolTip()   ; without the timer to this function, the tooltip would stay up if you moved too fast past the title
    {
        ToolTip(currControl.tooltip, -5000, -5000, 4)  ; shows tooltip of the title description
        WinGetPos(,, &ttWidth,, currControl.tooltip)   ; get width of tooltip
        WinMove(xGui + ((guiWidth - ttWidth) / 2), (yGui + guiHeight) - 1,,, currControl.tooltip) ; move tooltip to bottom center of gui
    }
}