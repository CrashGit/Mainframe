;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
; MAIN() FUNCTIONS
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; SEARCH ENGINES
;-------------------------------------------------------------------------------
Search(secondary_input, *)          ; search websites
{
    query_safe := uriEncode(search_url)
    search_final_url := StrReplace(search_url, 'REPLACEME', secondary_input)
    Run(search_final_url)

    uriEncode(str)                  ; unsure if I converted this correctly, seems to be working so far
    {
        if RegExMatch(str, Format("{:x}",'^\w+:/{0,2}'), &pr)
            str := SubStr(str, 1, StrLen(pr))
    
        str := StrReplace(str, '%', '%25')
        loop
            if RegExMatch(str, Format("{:x}",'i)[^\w\.~%/:]'), &char)
               str := StrReplace(str, char, '%' SubStr(Ord(char), 3))
        else 
            break
    
        return(pr str)
    }
}

;-------------------------------------------------------------------------------
; RUN SCRIPTS
;-------------------------------------------------------------------------------
RunScript(secondary_input, *)   ; run a script, if more than one file matching is found, a menu of the options will show
{
    FileMenuGui(false, secondary_input, 'Running Script')
}

;-------------------------------------------------------------------------------
; EDIT SCRIPTS
;-------------------------------------------------------------------------------
EditScript(secondary_input, *)  ; open a script in VSCode, if more than one file matching is found, a menu of the options will show
{
    FileMenuGui(true, secondary_input, 'Editing Script')
}

;-------------------------------------------------------------------------------
; RELOAD SCRIPTS
;-------------------------------------------------------------------------------
ReloadScript(secondary_input, *)    ; reload a given script that is currently running
{
    GetScriptAnd('Run', secondary_input, 600, 'Reloaded Script')
}

;-------------------------------------------------------------------------------
; KILL SCRIPTS
;-------------------------------------------------------------------------------
KillScript(secondary_input, *)  ; exit a running script
{
    GetScriptAnd('WinClose', secondary_input, 150, 'Killed Script')
}

;-------------------------------------------------------------------------------
; CREATE NEW SCRIPT
;-------------------------------------------------------------------------------
NewFile(*)  ; create a new file in the pre-defined folder and open it in VSCode 
{
    Gui_Show_Tertiary('NewFileExtension', 'File Extension', 'Period is automatically added`nLeave blank to default to ahk')
}

NewFileExtension(secondary_input, tertiary_input) 
{
    vscode := 'C:\Users\' A_UserName '\AppData\Local\Programs\Microsoft VS Code\Code.exe '
    fileName := Trim(secondary_input)
    fileExtension := Trim(tertiary_input)
    fileExtension := fileExtension != '' ? fileExtension : 'ahk'    ; leave tertiary_field blank to default to ahk file type
    newFile :=  fileName '.' fileExtension
    
    selectedDirectory := DirSelect('*C:\Users\Crash\Desktop\autohotkey',, 'Select the folder you want the file to be created in')  ; choose directory to create new file
    if selectedDirectory = ''     ; cancels file creation if user cancels folder selection
        return
    
    AddProgressBar('Searching...')

    file_exists := FileExist(selectedDirectory '\' newFile) ; search to make sure file doesn't already exist

    if file_exists {
        result := MsgBox('File already exists. Open in VS Code?', 'Error Creating File', 'YesNo Icon! 0x1000')    ; if file already exists...
        if result = 'Yes' {
            Run(vscode ' ' selectedDirectory '\' newFile)  ; if file already exists, edit it       ; open in VS Code
            return
        }
        else
            return
    }

FileAppend( '       ; FileAppend adds this text to the new file when created
(

)', selectedDirectory '\' newFile)
    
    Sleep(100)
    Run(vscode '"' selectedDirectory '\' newFile '"')
}

;-------------------------------------------------------------------------------
; REPLACE TEXT
;-------------------------------------------------------------------------------
Replace(*)      ; replace string found in the selected text
{
    Gui_Show_Tertiary('Replacement', 'Replacement Text', 'Enter the text you want to replace the string in the previous field')
}

Replacement(secondary_input, tertiary_input)    ; the replacement string
{
    A_Clipboard := ''   ; resets clipboard value so ClipWait works properly
    Send('^c')
    ClipWait(3)
    selection := A_Clipboard
    selection := StrReplace(selection, secondary_input, tertiary_input)
    Send(selection)
}

;-------------------------------------------------------------------------------
; HELP TOOLTIP
;-------------------------------------------------------------------------------
CommandList()   ; displays all the commands you can type and what they do
{
    command_tooltipPlaceholder := ''   ; initialize variable
    loop read, 'commands\commands.ahk'
        if Substr(A_loopReadLine, 1, 1) != ';'                  ; do not display commented lines
            if InStr(A_loopReadLine, 'case')                    ; if 'case' is found in the line
                if InStr(A_loopReadLine, ';')                   ; ensures only case lines with comments are added to the tooltip
                {
                    trimmed := StrSplit(A_loopReadLine, ';')    ; split line into two parts, separating them by the semicolon
                    command := trimmed[1]                       ; everything before semicolon is the command
                    comment := trimmed[2]                       ; everything after semicolon is the comment
                    
                    RegExMatch(command, "'[a-zA-Z0-9/@? ]+'", &command)     ; find command in single quotes, add any symbols in the brackets that you use in your commands, last empty spot represents a space
                    command := StrReplace(command[], "'")                   ; get rid of single quotes
                    command := StrReplace(command, ' ', '__')               ; turn spaces into underscores to represent the spaces
                    comment := '; ' comment                                 ; StrSplit() removes semicolon, this line adds it back in
                    command_tooltipPlaceholder .= command comment '`n'      ; add newline character to end of command and comment
                }

                
    maxTabs := 3    ; arbitrary tab count
    loop parse, command_tooltipPlaceholder, '`n'
    {
        line := A_loopField                         ; temp variable for current line
        commentpos := InStr(line, ';') - 1          ; get character count up until semicolon
        tabs := Ceil(commentpos / 8)                ; 8 is the magic number I guess, equal to 2 tabs
        if tabs > 0                                 ; random blank line keeps getting added to the end for some reason
            tabs := Ceil(maxTabs / tabs)            ; calculate amount of tabs needed

        loop tabs
            line := StrReplace(line, ';', '`t;')    ; replace semicolon with tab and semicolon each loop
        
        if line != ''                               ; for some reason a blank line gets added at the end of tooltipPlaceholder even though it doesn't meet the if conditions, this removes it from final text
            command_tooltip .= line '`n'
    }

    command_tooltip := Sort(command_tooltip)        ; alphabetize

    SetTimer(ToolTip, -8000)                        ; clear tooltip after 8 seconds
    CoordMode('ToolTip')                            ; To make sure the tooltip coordinates is displayed according to the screen and not active window
    ToolTip(command_tooltip, 3, 3)

    WinMove(3, 3,,, command_tooltip)                ; temp until tooltip placement is fixed
}