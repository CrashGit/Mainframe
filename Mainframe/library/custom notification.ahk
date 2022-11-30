SetWinDelay(-1)

; colors
pink      := 'cea84bb'
blue      := 'c87e6fb'
green     := 'c6aeb83'
yellow    := 'cebef70'
purple    := 'cb696f5'
white     := 'cf0f0f0'
orange    := 'cffd975'
backcolor := '262626'


fadeOutIsRunning := false   ; used to fix notification loop when the 3 second SetTimer was called after new notification was created


#HotIf IsSet(Notify)
~LButton::      ; hide notification if clicked, in case it gets in the way
{
    if IsSet(Notify) {
        MouseGetPos(,, &Hwnd,, 2)

        if Hwnd = Notify.Hwnd
            Notify.Hide()
    }
}
#HotIf



ShowNotification(title, message, beepTone := 523)
{
    DestroyNotificationIfSet()  ; prevents issues if notification is already up
    SoundBeep(beepTone)         ; play a tone

    global Notify := Gui('+AlwaysOnTop +ToolWindow -SysMenu -Caption -Border')
    Notify.MarginY := 10
    Notify.BackColor := backcolor

    Notify.SetFont('s17 bold', 'Segoe UI')
    Notify.AddText(yellow ' Center x20', '<')

    Notify.SetFont('s14')
    Notify.AddText(blue ' Center xp+60 yp+5 w160', title)
    Notify.AddText(green ' Center xp+190 yp', '/')

    Notify.SetFont('s17')
    Notify.AddText(yellow ' Center xp+20 yp-3', '>')

    Notify.SetFont('s11')
    Notify.AddText(pink ' x20 w288 Center', message)


    Notify.Show('y0 AutoSize NoActivate')

    Notify.GetPos(,, &width, &height)
    WinSetRegion('0-0 w' width ' h' height ' r15-15', Notify)


    Notify.GetPos(,,, &gui_height)  ; get height of gui
    Notify.Move(, 0 - gui_height)   ; move gui just out of view above the monitor

    WinSetTransparent(0, Notify)

    SetTimer(SlideAndFadeIn, 10)
}



SlideAndFadeIn()
{
    try {
        if fadeOutIsRunning {
            SetTimer(SlideAndFadeOut, 0)
            global fadeOutIsRunning := false
        }

        transparency := WinGetTransparent(Notify) + 5

        try WinSetTransparent(transparency, Notify)
        catch {
            WinSetTransparent(255, Notify)
        }


        Notify.GetPos(, &guiY)
        Notify.Move(, guiY + 2)
        Notify.GetPos(, &guiY)


        if guiY >= 20 {     ; pixels from the top
            SetTimer(SlideAndFadeIn, 0)
            SetTimer(() => SetTimer(SlideAndFadeOut, 10), -3000)   ; slide out after 3 seconds
        }
    }
}



SlideAndFadeOut()
{
    try {
        global fadeOutIsRunning := true

        transparency := WinGetTransparent(Notify) - 5

        try WinSetTransparent(transparency, Notify)
        catch {
            WinSetTransparent(0, Notify)
        }


        Notify.GetPos(, &guiY,, &gui_height)
        Notify.Move(, guiY - 2)
        Notify.GetPos(, &guiY)


        if guiY <= (0 - gui_height) {   ; gui_height above the screen (off screen)
            SetTimer(SlideAndFadeOut, 0)
            DestroyNotificationIfSet()
            global fadeOutIsRunning := false
        }
    }
}



DestroyNotificationIfSet()
{
    if IsSet(Notify) {
        SetTimer(SlideAndFadeIn, 0)
        SetTimer(SlideAndFadeOut, 0)

        Notify.Destroy()
        global Notify := unset
    }
}
