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

        this.gui                := Gui('+AlwaysOnTop +ToolWindow -SysMenu -Caption -Border ')
        this.gui.BackColor      := '000000'
        this.gui.SetFont('s17 bold', 'Segoe UI')

        this.falling    := ObjBindMethod(this, 'Fall')
        this.bouncing   := ObjBindMethod(this, 'Bounce')
        this.destroy    := ObjBindMethod(this, 'DestroyBouncingText')
        this.coloring   := ObjBindMethod(this, 'colorText')
    }

    __New(_letter, _prevGui, _time) 
    {
        this.letter := _letter
        this.prevGui := _prevGui
        this.destroyTime := _time
    }

    Initialize()
    {
        if this.prevGui = ''
            this.position := 'x' A_ScreenWidth / 2 - 170
        else {
            this.prevGui.gui.GetPos(&prevX,, &prevWidth)
            this.position := 'x' prevx + prevWidth
        }

        WinSetExStyle('+0x20', this.gui)
        this.gui.AddText('Center v' this.letter, this.letter)
        this.gui.Show(this.position ' y0 AutoSize NoActivate')
        WinSetTransColor('000000', this.gui)

        this.gui.GetPos(,,, &gui_height)                ; get height of gui           
        this.starting_position := 0 - gui_height        ; set starting position just out of view
        this.gui.Move(, this.starting_position)         ; move gui just out of view above the monitor

        SetTimer(this.falling, 10)
        SetTimer(this.coloring, 100)
    }

    Fall()
    {
        this.gui.GetPos(, &guiY) ; get position to initialize guiY
        this.gui.Move(, guiY + this.acceleration) ; move name 2 pixels down
        this.gui.GetPos(, &guiY) ; update position var again so if statement is easier to understand

        if guiY >= this.final_position                  ; pixels from the top
        {                
            SetTimer(this.falling, 0)
            this.gui.Move(, this.final_position)    ;move to final position
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
        this.gui.GetPos(, &guiY)
        this.gui.Move(, guiY - this.deceleration)
        this.gui.GetPos(, &guiY)

        
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

        try this.gui[this.letter].SetFont(rgb[CheckColorIndexIsValid(colorIndex+1)])

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
