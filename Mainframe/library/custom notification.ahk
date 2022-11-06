SetWinDelay(-1)

ShowNotification(title, message, beepTone)
{
    DestroyNotificationIfSet()  ; prevents issues if notification is already up
    SoundBeep(beepTone, 150)    ; play a tone

    global Notify := Gui('+AlwaysOnTop +ToolWindow -SysMenu -Caption -Border')
    Notify.BackColor := '262626'
    Notify.MarginY := 10

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
    RoundedCorners(15)
    
    WinGetPos(,,, &gui_height, Notify)  ; get height of gui
    WinMove(, 0 - gui_height,,, Notify) ; move gui just out of view above the monitor

    WinSetTransparent(0, Notify)
    SetTimer(SlideAndFadeIn, 10)
}

SlideAndFadeIn()
{
    transparency := WinGetTransparent(Notify) + 5
    
    try WinSetTransparent(transparency, Notify)
    catch {
        WinSetTransparent(255, Notify)
    }

    WinGetPos(, &guiY,,, Notify)
    WinMove(, guiY + 2,,, Notify)
    WinGetPos(, &guiY,,, Notify)

    if guiY >= 20 {     ; pixels from the top
        SetTimer(SlideAndFadeIn, 0)
        SetTimer(() => SetTimer(SlideAndFadeOut, 10), -3000)   ; slide out after 3 seconds
    }
}

SlideAndFadeOut()
{
    transparency := WinGetTransparent(Notify) - 5

    try WinSetTransparent(transparency, Notify)
    catch {
        WinSetTransparent(0, Notify)
    }

    WinGetPos(, &guiY,, &gui_height, Notify)
    WinMove(, guiY - 2,,, Notify)
    WinGetPos(, &guiY,,, Notify)

    if guiY <= (0 - gui_height) {   ; gui_height above the screen (off screen)
        SetTimer(SlideAndFadeOut, 0) 
        DestroyNotificationIfSet()
    }
}


DestroyNotificationIfSet()
{
    global
    if IsSet(Notify) {
        Notify.Destroy()
        Notify := unset
        SetTimer(SlideAndFadeIn, 0)
        SetTimer(SlideAndFadeOut, 0)
    }
}