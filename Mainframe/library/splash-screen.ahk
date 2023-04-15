SetWinDelay(-1)

; CHANGE ME
splashScreenText := 'Crash'



SplashScreenGui := Gui('+AlwaysOnTop +ToolWindow -SysMenu -Caption -Border +E0x20')
SplashScreenGui.BackColor := '000000'
SplashScreenGui.SetFont('s17 bold', 'Segoe UI')
SplashScreenGui.AddText(, splashScreenText) ; invisible splash text as a reference to center the animated letters horizontally
SplashScreenGui.Show('xCenter y0 AutoSize NoActivate')
WinSetTransColor('000000', SplashScreenGui)


; very strange issue where if string length is evenly divisible by 7,
; the colors stop changing, so this adds extra blanks to the side
; to fix it while keeping it centered
if Mod(StrLen(splashScreenText), 7) = 0
    splashScreenText := ' ' splashScreenText ' '


; using a timer here to start a new thread because I was getting undefined
; variables if I tried certain commands too soon after restarting the main() script
; because it wasn't finished running so variables wouldn't get assigned fast enough
; if you #Include this script in another script, I recommend keeping this
SetTimer(LoopSplashText, -10)


LoopSplashText() {
    loop parse splashScreenText {
        BouncingText(A_LoopField, A_Index).Initialize()
        Sleep(300)
    }
}


class BouncingText
{
    __Init()
    {
        ; splash text colors
        this.pink   := 'cea84bb'
        this.blue   := 'c87e6fb'
        this.green  := 'c6aeb83'
        this.yellow := 'cebef70'
        this.purple := 'cb696f5'
        this.white  := 'cf0f0f0'
        this.orange := 'cffd975'
        this.rgb    := [pink, blue, green, yellow, purple, white, orange]

        ; variables
        this.acceleration   := 1
        this.deceleration   := unset
        this.count          := StrLen(splashScreenText)
        this.destroyTime    := (this.count*300) + 1000
        this.final_position := A_ScreenHeight / 2
        this.bounce_apex    := A_ScreenHeight / 4


        ; methods
        this.bouncing       := ObjBindMethod(this, 'Bounce')
        this.destroy        := ObjBindMethod(this, 'DestroyBouncingText')
        this.falling        := ObjBindMethod(this, 'Fall')
        this.coloring       := ObjBindMethod(this, 'ColorText')
    }

    __New(_letter, _letterIndex)
    {
        this.splashScreenLetter := _letter
        this.letterIndex        := _letterIndex
    }


    Initialize()
    {
        try {
            if this.letterIndex > 1 {
                SplashScreenGui.AddText('x+0' ' vletter' this.letterIndex, this.splashScreenLetter)
            } else {
                SplashScreenGui.AddText('xp yp vletter' this.letterIndex, this.splashScreenLetter)
            }

            SplashScreenGui.Show('AutoSize NoActivate')

            SetTimer(this.falling, 10)
            SetTimer(this.coloring, 100)
        }
    }


    Fall()
    {
        try {
            SplashScreenGui['letter' this.letterIndex].GetPos(, &guiY)                    ; get position to initialize guiY
            SplashScreenGui['letter' this.letterIndex].Move(, guiY + this.acceleration)   ; move name 2 pixels down
            SplashScreenGui['letter' this.letterIndex].GetPos(, &guiY)                    ; update position var again so if statement is easier to understand

            if guiY >= this.final_position              ; pixels from the top
            {
                SetTimer(this.falling, 0)
                SplashScreenGui['letter' this.letterIndex].Move(, this.final_position)    ; move to final position to make sure all letters will be aligned
                this.count -= 1

                if this.count = 0 {
                    SetTimer(this.destroy, - this.destroyTime)
                    return
                }
                SetTimer(this.bouncing, 10)             ; start bounce
            }
            else
                this.acceleration += 1
        }
    }


    Bounce()
    {
        try {
            this.deceleration := this.acceleration / 2
            SplashScreenGui['letter' this.letterIndex].GetPos(, &guiY)
            SplashScreenGui['letter' this.letterIndex].Move(, guiY - this.deceleration)
            SplashScreenGui['letter' this.letterIndex].GetPos(, &guiY)


            if guiY <= this.bounce_apex {                   ; bounce is at or above apex
                SetTimer(this.bouncing, 0)                  ; stop bounce
                this.bounce_apex := (this.final_position + this.bounce_apex) / 2   ; halve the bounce height
                this.acceleration := 1
                SetTimer(this.falling, 10)                  ; begin falling again
            }
            else
                this.deceleration -= 0.3
        }
    }


    DestroyBouncingText()
    {
        if IsSet(SplashScreenGui) {
            SplashScreenGui.Destroy()
            global SplashScreenGui := unset
            SetTimer(this.falling, 0)
            SetTimer(this.bouncing, 0)
            SetTimer(this.coloring, 0)
            this.bouncing := unset
            this.destroy  := unset
            this.falling  := unset
            this.coloring := unset
        }
    }


    ColorText()
    {
        static colorIndex := this.rgb.Length

        try SplashScreenGui['letter' this.letterIndex].SetFont(this.rgb[CheckColorIndexIsValid(colorIndex+1)])
        catch {
            ; for some reason the timer wouldn't stop without this second stop
            SetTimer(this.coloring, 0)
        }

        CheckColorIndexIsValid(color)
        {
            if color > this.rgb.Length
                colorIndex := 1

            else
                colorIndex++

            return colorIndex
        }
    }
}
