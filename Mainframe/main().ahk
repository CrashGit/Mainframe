;-------------------------------------------------------------------------------
; AUTO EXECUTE
;-------------------------------------------------------------------------------
#SingleInstance
#Include library\main() commands library.ahk
#Include library\main() secondary library.ahk
#Include library\custom notification.ahk
; #Include library\custom notification-queue.ahk
#Include library\RGB-Frame.ahk
#Include library\splash-screen.ahk


TraySetIcon('Shell32.dll', 305)


; initialize variables
search_url   := unset
open_with_vscode := 'C:\Users\' A_UserName '\AppData\Local\Programs\Microsoft VS Code\Code.exe '  ; script editing program of choice

; dracula theme color values used in the GUI
pink    := 'cea84bb'
blue    := 'c87e6fb'
green   := 'c6aeb83'
yellow  := 'cebef70'
purple  := 'cb696f5'
white   := 'cf0f0f0'
orange  := 'cffd975'

rgb := [pink, blue, green, yellow, purple, white, orange]   ; dracula theme colors for username
; rgb := ['cff0000', 'cff7f00', 'cffff00', 'c00bc3f', 'c0068ff', 'c7a00e5', 'cd300c9']  ; normal rgb colors for username


#HotIf WinActive('ahk_class AutoHotkeyGUI')
    ^BackSpace::Send('^+{Left}{Backspace}')     ; Control + BackSpace deletes word, normally doesn't work in GUI
#HotIf

;-------------------------------------------------------------------------------
; LAUNCH GUI
;-------------------------------------------------------------------------------
^!r::Reload

CapsLock & Space:: 
{
    Gui_Spawn()
}

Gui_Spawn() ; initial gui
{
    global
    
    if IsSet(MainGui)   ; If the GUI is already open, destroy it
    {
        MainGui_Destroy()
        return
    }

    try lastActiveWindow := WinGetID('A')   ; this line exists because I had a weird issue if script was reloaded, and a different window was clicked, showing then destroying gui activated first window
    
    global MainGui := Gui('+AlwaysOnTop -SysMenu +ToolWindow -Caption -Border')
	MainGui.OnEvent('Escape', MainGui_Destroy)
    MainGui.MarginY := 0
    MainGui.SetFont('s14 bold', 'Segoe UI')
    MainGui.BackColor := '292a35'
    
    MainGui.AddText(green ' Right x25 w16 y12 vsubtitle_1', '<')    ; < and > are size14 font because they seemed disproportionately smaller than the other title text

    MainGui.SetFont('s11')
    main_title := MainGui.AddText(pink ' Center xp+16 yp+3 w170 0x0100 vgui_main_title', 'Hack the Planet') ; 0x0100 necessary for tooltip to show up when hovering over text
    main_title.tooltip := 'We Are Nameless'

    MainGui.AddText(purple ' Left xp+162 w8 yp vsubtitle_2', '/')

    MainGui.SetFont('s14')
    MainGui.AddText(green ' xp+8 w16 yp-3 vsubtitle_3', '>')

    MainGui.SetFont('s10')
    MainGui.AddEdit(yellow ' xm w220 -E0x200 Center Background6772a2 xm-1 ys+40 hp-5 vinput')
    MainGui['input'].OnEvent('Change', (*) => CommandCheck(MainGui['input'].value))
   
    MainGui.SetFont('s8')

    MainGui.AddText('x160   yp+25 h20   vusername_1',   'C')
    MainGui.AddText('xp+7   yp          vusername_2',   'r')
    MainGui.AddText('xp+4   yp          vusername_3',   'a')
    MainGui.AddText('xp+5   yp          vusername_4',   's')
    MainGui.AddText('xp+5   yp          vusername_5',   'h')
    MainGui.AddText('xp+12  yp          vusername_6',   'O')
    MainGui.AddText('xp+8   yp          vusername_7',   'v')
    MainGui.AddText('xp+6   yp          vusername_8',   'e')
    MainGui.AddText('xp+6   yp          vusername_9',   'r')
    MainGui.AddText('xp+4   yp          vusername_10',  'r')
    MainGui.AddText('xp+4   yp          vusername_11',  'i')
    MainGui.AddText('xp+3   yp          vusername_12',  'd')
    MainGui.AddText('xp+7   yp          vusername_13',  'e')
    RGBusernameSetup := (*) => RGBusername('MainGui')
    SetTimer(RGBusernameSetup, 100) ; adjust time to increase or decrease color-changing speed

    MainGui.Show('AutoSize')
    RoundedCorners(15, 'MainGui')

    OnMessage(0x200, TitleToolTip)      ; call this function when moving the mouse over the gui
}  

; -------------------------------------------------------------------------------
; EXTEND GUI 2ND LAYER
; -------------------------------------------------------------------------------
Gui_Show_Secondary(function, guiTitle, title_tooltip) 
{
    MainGui.SetFont('s14')
    MainGui.AddText(green ' yp+23 Right x25 w16 vsubtitle_4', '<')

    MainGui.SetFont('s11')
    secondary_title := MainGui.AddText(pink ' Center xp+16 yp+3 w170 0x0100 vgui_secondary_title', guiTitle) ; 0x0100 necessary for tooltip to show up when hovering over text
    secondary_title.tooltip := title_tooltip

    MainGui.AddText(purple ' Left xp+162 w18 yp vsubtitle_5', '/')

    MainGui.SetFont('s14')
    MainGui.AddText(green ' xp+8 w16 yp-3 vsubtitle_6', '>')

    MainGui.SetFont('s10')
    MainGui.AddEdit(blue ' xm w220 -E0x200 Center Background6772a2 ys+128 hp-5 vcommand')
    
    global hiddenButton := MainGui.AddButton('x-10 y-10 w1 h1 +default').OnEvent('Click', (*) => SubmitAndDestroy(function, MainGui['command'].value))
    
    MoveUserName(165)           ; adjusts username position when gui extends
    DisableMainGui()            ; disables first section when gui extends

    MainGui.Show('AutoSize')
    RoundedCorners(15, 'MainGui')          ; rounds the corners of the gui    
}

; -------------------------------------------------------------------------------
; EXTEND GUI 3RD LAYER
; -------------------------------------------------------------------------------
Gui_Show_Tertiary(function, guiTitle, title_tooltip) 
{
    MainGui.SetFont('s14')
    MainGui.AddText(green ' yp+199 Right x25 w16', '<')

    MainGui.SetFont('s11')
    tertiary_title := MainGui.AddText(pink ' Center xp+16 yp+3 w170 0x0100 vgui_tertiary_title', guiTitle) ; 0x0100 necessary for tooltip to show up when hovering over text
    tertiary_title.tooltip := title_tooltip

    MainGui.AddText(purple ' Left xp+162 w18 yp', '/')

    MainGui.SetFont('s14')
    MainGui.AddText(green ' xp+8 w16 yp-3', '>')

    MainGui.SetFont('s10')
    MainGui.AddEdit(orange ' xm w220 -E0x200 Center Background6772a2 ys+217 hp-5 vtertiary_field')
    
    MainGui.AddButton('x-10 y-10 w1 h1 +default').OnEvent('Click', (*) => SubmitAndDestroy(function, MainGui['command'].value, MainGui['tertiary_field'].value))
    
    MoveUserName(254)           ; adjusts username position when gui extends
    DisableCommandGui()         ; disables 2nd gui layer

    MainGui.Show('AutoSize')
    RoundedCorners(15, 'MainGui')          ; rounds the corners of the gui

    ControlFocus MainGui['tertiary_field']
}


;-------------------------------------------------------------------------------
; GUI FUNCTIONS
;-------------------------------------------------------------------------------
; The function when the text changes in the initial input field
CommandCheck(input) 
{
    MainGui.Submit(0)
    isCommand := true

    switch input, 'Off'    ; case-sense Off
    {
        #Include commands\commands.ahk
        #Include commands\wrap text.ahk
        #Include commands\phasmo.ahk
        default:
            isCommand := false
    }

    if isCommand
        if !IsSet(hiddenButton) && IsSet(MainGui) && input != ''
            MainGui_Destroy()  
}

Gui_Command(sub, guiTitle, title_tt, url := unset) 
{   
    try global search_url := url    ; used for Search(), passes the url as the parameter                                                       
    Gui_Show_Secondary(sub, guiTitle, title_tt)
}

; prevents extra Submit() and Destroy() calls inside the other functions, aka less code to look at
SubmitAndDestroy(function, secondary_input := '', tertiary_input := '') 
{
    MainGui.Submit()

    if function != 'Replace' && function != 'NewFile'
        MainGui_Destroy()

    %function%(secondary_input, tertiary_input)
}


;-------------------------------------------------------------------------------
; RGB USERNAME
;-------------------------------------------------------------------------------
RGBusername(gui) 
{
    static colorIndex   := 7

    try {
        %gui%['username_1' ].SetFont(rgb[ CheckColorIndexIsValid(colorIndex+1) ]) ; C
        %gui%['username_2' ].SetFont(rgb[ CheckColorIndexIsValid(colorIndex+1) ]) ; r
        %gui%['username_3' ].SetFont(rgb[ CheckColorIndexIsValid(colorIndex+1) ]) ; a
        %gui%['username_4' ].SetFont(rgb[ CheckColorIndexIsValid(colorIndex+1) ]) ; s
        %gui%['username_5' ].SetFont(rgb[ CheckColorIndexIsValid(colorIndex+1) ]) ; h

        %gui%['username_6' ].SetFont(rgb[ CheckColorIndexIsValid(colorIndex+1) ]) ; O
        %gui%['username_7' ].SetFont(rgb[ CheckColorIndexIsValid(colorIndex+1) ]) ; v
        %gui%['username_8' ].SetFont(rgb[ CheckColorIndexIsValid(colorIndex+1) ]) ; e
        %gui%['username_9' ].SetFont(rgb[ CheckColorIndexIsValid(colorIndex+1) ]) ; r
        %gui%['username_10'].SetFont(rgb[ CheckColorIndexIsValid(colorIndex+1) ]) ; r
        %gui%['username_11'].SetFont(rgb[ CheckColorIndexIsValid(colorIndex+1) ]) ; i
        %gui%['username_12'].SetFont(rgb[ CheckColorIndexIsValid(colorIndex+1) ]) ; d
        %gui%['username_13'].SetFont(rgb[ CheckColorIndexIsValid(colorIndex+1) ]) ; e
    }

    CheckColorIndexIsValid(color)
    {
        if color > 7 {  
            colorIndex := 1
            color := colorIndex
        } 
        else {
            colorIndex++
        }
        return color
    }
}

MoveUserName(usernamePosition)  ; adjusts username position when gui extends
{
    MainGui['username_1'].Move(, usernamePosition)
    MainGui['username_2'].Move(, usernamePosition)
    MainGui['username_3'].Move(, usernamePosition)
    MainGui['username_4'].Move(, usernamePosition)
    MainGui['username_5'].Move(, usernamePosition)
    MainGui['username_6'].Move(, usernamePosition)
    MainGui['username_7'].Move(, usernamePosition)
    MainGui['username_8'].Move(, usernamePosition)
    MainGui['username_9'].Move(, usernamePosition)
    MainGui['username_10'].Move(, usernamePosition)
    MainGui['username_11'].Move(, usernamePosition)
    MainGui['username_12'].Move(, usernamePosition)
    MainGui['username_13'].Move(, usernamePosition)
}

; changed the color of titles instead of disabling so that tooltips still work on them
DisableMainGui()        ; disables first section when gui extends
{
    MainGui['gui_main_title'].SetFont('c646681')
    MainGui['subtitle_1'].SetFont('c646681')
    MainGui['subtitle_2'].SetFont('c646681')
    MainGui['subtitle_3'].SetFont('c646681')
    MainGui['input'].Enabled := false
}

DisableCommandGui()     ; disables 2nd gui layer
{
    MainGui['gui_secondary_title'].SetFont('c646681')
    MainGui['subtitle_4'].SetFont('c646681')
    MainGui['subtitle_5'].SetFont('c646681')
    MainGui['subtitle_6'].SetFont('c646681')
    MainGui['command'].Enabled := false
}

RoundedCorners(curve, gui)   ; dynamically rounds the corners of the gui, param is the curve radius as an integer
{
    %gui%.GetPos(,, &width, &height)
    width   := 'w' width
    height  := 'h' height
    WinSetRegion('0-0 ' width ' ' height ' r' curve '-' curve, 'ahk_class AutoHotkeyGUI')
}

;-------------------------------------------------------------------------------
; MAINGUI DESTROY
;-------------------------------------------------------------------------------
MainGui_Destroy(*) 
{
    global 
    Tooltip()
    Tooltip(,,, 4)

    if IsSet(MainGui) {
        MainGui.Destroy()
        MainGui := unset
        hiddenButton := unset
        SetTimer(RGBusernameSetup, 0)
        OnMessage(0x200, TitleToolTip, 0)   ; disables tooltip on main gui destroy, fixed phasmo gui error popup when moving mouse over different controls too fast
    }
    try if WinGetClass('A') != 'ahk_class AutoHotkeyGUI' ; msgbox would sometimes lose focus, hoping this fixes it
        try WinActivate(lastActiveWindow)
}
