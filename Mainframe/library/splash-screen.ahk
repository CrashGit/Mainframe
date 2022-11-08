SetWinDelay(-1)

letter1 := BouncingText('C', '', 1700)
letter2 := BouncingText('r', letter1, 1400)
letter3 := BouncingText('a', letter2, 1100)
letter4 := BouncingText('s', letter3, 800)
letter5 := BouncingText('h', letter4, 500)

letter1.Initialize()
SetTimer(() => letter2.Initialize(), -300)
SetTimer(() => letter3.Initialize(), -600)
SetTimer(() => letter4.Initialize(), -900)
SetTimer(() => letter5.Initialize(), -1200)


class BouncingText 
{
    __Init() 
    {
        this.count              := 5
        this.acceleration       := 1
        this.deceleration       := unset
        this.starting_position  := unset
        this.final_position     := A_ScreenHeight / 2
        this.bounce_apex        := A_ScreenHeight / 4

        this.gui_height         := unset
        this.guiY               := unset
        this.gui                := Gui('+AlwaysOnTop +ToolWindow -SysMenu -Caption -Border')
        this.gui.BackColor      := '000000'
        this.gui.SetFont('s17 bold', 'Segoe UI')

        this.falling    := ObjBindMethod(this, 'Fall')
        this.bouncing   := ObjBindMethod(this, 'Bounce')
        this.destroy    := ObjBindMethod(this, 'DestroyBouncingText')
        this.coloring   := ObjBindMethod(this, 'colorText')
    }

    __New(_name, _prevGui, _time) 
    {
        this.name := _name
        this.prevGui := _prevGui
        this.destroyTime := _time
    }

    Initialize()
    {
        if this.prevGui = ''
            this.position := 'x' A_ScreenWidth / 2 - 170
        else {
            WinGetPos(&prevX,, &prevWidth,, this.prevGui.gui)
            this.position := 'x' prevx + prevWidth
        }

        this.gui.AddText('Center v' this.name, this.name)
        this.gui.Show(this.position ' y0 AutoSize NoActivate')
        WinSetTransColor('000000', this.gui)

        WinGetPos(,,, &gui_height, this.gui)  ; get height of gui
        this.gui_height := gui_height
        this.starting_position := 0 - this.gui_height
        WinMove(, this.starting_position,,, this.gui) ; move gui just out of view above the monitor

        SetTimer(this.falling, 10)
        SetTimer(this.coloring, 100)
    }

    Fall()
    {
        WinGetPos(, &guiY,,, this.gui)                  ; get position to initialize guiY
        this.guiY := guiY
        WinMove(, this.guiY + this.acceleration,,, this.gui) ; move name 2 pixels down
        WinGetPos(, &guiY,,, this.gui)                  ; update position var again so if statement is easier to understand
        this.guiY := guiY

        if this.guiY >= this.final_position             ; pixels from the top
        {                
            SetTimer(this.falling, 0)
            WinMove(, this.final_position,,, this.gui)  ; move to final position
            this.count -= 1
            if this.count = 0 {
                SetTimer(this.destroy, - this.destroyTime)
                return
            }
            SetTimer(this.bouncing, 10)                 ; start bounce
        }
        else
            this.acceleration += 1
    }

    Bounce()
    {
        this.deceleration := this.acceleration / 2 
        WinGetPos(, &guiY,,, this.gui)
        this.guiY := guiY
        WinMove(, this.guiY - this.deceleration,,, this.gui)
        WinGetPos(, &guiY,,, this.gui)
        this.guiY := guiY
        
        if guiY <= this.bounce_apex {               ; bounce is at or above apex                     
            SetTimer(this.bouncing, 0)                      ; stop bounce
            this.bounce_apex := (this.final_position + this.bounce_apex) / 2   ; halve the bounce height
            this.acceleration := 1
            SetTimer(this.falling, 10)                      ; begin falling again
        }
        else
            this.deceleration -= 0.3
    }

    DestroyBouncingText()
    {
        if IsSet(BouncingText) {
            this.gui.Destroy()
            this.gui := unset
            SetTimer(this.falling, 0)
            SetTimer(this.bouncing, 0)
            SetTimer(this.coloring, 0)
        }
    }

    colorText() 
    {
        static colorIndex := 7

        try this.gui[this.name].SetFont(rgb[CheckColorIndexIsValid(colorIndex+1)])

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
}
