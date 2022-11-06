case 'phasmo':		; GUI for Phasmophobia Wiki links
	MainGui_Destroy()

;-------------------------------------------------------------------------------
; INITIAL SETUP
;-------------------------------------------------------------------------------
	global PhasmoGui := Gui('+AlwaysOnTop -SysMenu +ToolWindow -Caption -Border')
	PhasmoGui.OnEvent('Escape', Phasmo_Destroy)

	PhasmoGui.BackColor := '292a35'

	PhasmoGui.SetFont('s11 bold', 'Segoe UI')
	PhasmoGui.AddText('x277   y17	  vusername_1',   'C')
	PhasmoGui.AddText('xp+9   yp      vusername_2',   'r')
	PhasmoGui.AddText('xp+6   yp      vusername_3',   'a')
	PhasmoGui.AddText('xp+8   yp      vusername_4',   's')
	PhasmoGui.AddText('xp+7   yp      vusername_5',   'h')
	PhasmoGui.AddText('xp+15  yp      vusername_6',   'O')
	PhasmoGui.AddText('xp+12  yp      vusername_7',   'v')
	PhasmoGui.AddText('xp+8   yp      vusername_8',   'e')
	PhasmoGui.AddText('xp+8   yp      vusername_9',   'r')
	PhasmoGui.AddText('xp+6   yp      vusername_10',  'r')
	PhasmoGui.AddText('xp+6   yp      vusername_11',  'i')
	PhasmoGui.AddText('xp+4   yp      vusername_12',  'd')
	PhasmoGui.AddText('xp+8   yp      vusername_13',  'e')
	RGBusernameSetup := (*) => RGBusername('PhasmoGui')
    SetTimer(RGBusernameSetup, 100)

	PhasmoGui.SetFont('s11')
	phasmoTabNames := PhasmoGui.AddTab3(blue ' x10 y10 w380 h448', ['Ghosts', 'Equipment', 'Cursed Items'])
	phasmoTabNames.OnEvent('Change', Gui_Size)

	PhasmoGui.SetFont('norm')
	PhasmoGui.Show('Center w400 h468')
	RoundedCorners(15)
	ControlFocus(PhasmoGui['username_1'])	; I don't like the look of the selection box around the buttons or tabs so this defaults to not show
	
;-------------------------------------------------------------------------------
; GHOSTS
;-------------------------------------------------------------------------------
	phasmoTabNames.UseTab('Ghosts')

	ghostArray := ['Banshee', 'Demon', 'Deogen', 'Goryo', 'Hantu'
	, 'Jinn', 'Mare', 'Moroi', 'Myling', 'Obake', 'Oni', 'Onryo'
	, 'Phantom', 'Poltergeist', 'Raiju', 'Revenant', 'Shade', 'Spirit'
	, 'Thaye', 'The Mimic', 'The Twins', 'Wraith', 'Yokai', 'Yurei']
	
	CreateAndAlignButtons(ghostArray, 30, 120, 3, 57, 50)
																				
	PhasmoGui.SetFont('s9')
	PhasmoGui.AddText(white ' x0 yp+32 w370 h30 Right', '*Hold control while clicking to keep menu open')

;-------------------------------------------------------------------------------
; EQUIPMENT
;-------------------------------------------------------------------------------	
	PhasmoTabNames.UseTab('Equipment')

	PhasmoGui.SetFont('bold')
	PhasmoGui.AddText(yellow ' x147 y45 w105 h30 vstarterText', 'Starter Equipment')
	PhasmoGui['starterText'].OnEvent('Click', OpenStarterPage)
	
	
	PhasmoGui.SetFont('norm')
	equipmentArray := ['D.O.T.S. Projector', 'EMF Reader', 'Flashlight', 'Ghost Writing Book', 'Spirit Box', 'Photo Camera', 'UV Flashlight', 'Video Camera']

	CreateAndAlignButtons(equipmentArray, 30, 120, 3, 65, 50)

	PhasmoGui.SetFont('s9 bold')
	optionalText := PhasmoGui.AddText(yellow ' x145 yp+50 w110 hp', 'Optional Equipment')
	optionalText.OnEvent('Click', OpenOptionalPage)

	PhasmoGui.SetFont('norm')
	equipmentArray2 := ['Candle', 'Crucifix', 'Glowstick', 'Head Mounted Camera', 'Lighter', 'Motion Sensor', 'Parabolic Microphone', 'Salt', 'Sanity Pills', 'Smudge Sticks', 'Sound Sensor', 'Strong Flashlight', 'Thermometer', 'Tripod']
	
	CreateAndAlignButtons(equipmentArray2, 30, 120, 3, 235, 50)

	PhasmoGui.SetFont('s9')
	PhasmoGui.AddText(white ' x0	yp+32 w370 h30 Right', '*Hold control while clicking to keep menu open')

;-------------------------------------------------------------------------------
; CURSED ITEMS
;-------------------------------------------------------------------------------
	PhasmoTabNames.UseTab('Cursed Items')

	cursedItemArray := ['Bone Evidence', 'Haunted Mirror', 'Music Box', 'Ouija Board', 'Summoning Circle', 'Tarot Cards', 'Voodoo Doll']
	
	CreateAndAlignButtons(cursedItemArray, 30, 120, 3, 57, 50)

	PhasmoGui.SetFont('s9')
	PhasmoGui.AddText(white ' x0	yp+32 w370 h30 Right', '*Hold control while clicking to keep menu open')

;-------------------------------------------------------------------------------
; INSERT GUI BUTTON
;-------------------------------------------------------------------------------
	CreateAndAlignButtons(array, width, widthOffset, columns, height, heightOffset) 
	{	
		columnCount := columns	; copy of columns var to manipulate without interfering with other code
		
		for index, item in array
		{
			if StrLen(item) < 13	; this if/else automates the font size
				PhasmoGui.SetFont('s11')
			else
				PhasmoGui.SetFont('s9')
			
			; determine x position of button
			if Mod(index, columns) = 1 || index = 1	; if first (top) button in column, set xPos to xwidth
				xPos := 'x' width
			else									; if not first (top) button in column, set xPos to xp+widthOffset
				xPos := 'xp+' widthOffset
			
			; determine y position of button
			if index <= columns						; if first row, set yPos to yheight
				yPos := 'y' height
			else if index <= columnCount			; if in the same row as previous button, set yPos to yp (previous y value)
				yPos := 'yp'
			else {									; if index exceeds amount of buttons allowed in row, start new row and set yPos to yp+heightOffset
				yPos := 'yp+' . heightOffset
				columnCount += columns				; add column count, each iteration it's essentially checking what row it's on
			}
			
			phasmoButton := PhasmoGui.AddButton(xPos ' ' yPos ' w100 h30', item)
			phasmoButton.buttonName := item
			phasmoButton.OnEvent('Click', (phasmoButton, *) => WikiPage(phasmoButton.buttonName))
		}
	}

;-------------------------------------------------------------------------------
; OPEN WIKI PAGE
;-------------------------------------------------------------------------------
	OpenStarterPage(*) 
	{ 
		WikiPage('Equipment#:~:text=Onsite`%20equipment-,Starter`%20equipment,-Starter`%20Equipment`%20is')
	}
	
	OpenOptionalPage(*) 
	{
		WikiPage('Equipment#:~:text=Projector`%20evidence.-,Optional`%20equipment,-This`%20equipment`%20must')
	}
	
	WikiPage(page) 
	{
		if GetKeyState('Control', 'P') = 0  				; if control is not held when button is clicked, destroy gui
			Phasmo_Destroy()

		Run('https://Phasmophobia.fandom.com/wiki/' page) 	; open wiki for Phasmo to page relevant to the button clicked
	}

;-------------------------------------------------------------------------------
; CHANGE WINDOWS SIZE PER TAB
;-------------------------------------------------------------------------------
	Gui_Size(*)		; changes size of window, I didn't like looking at a wall of nothing when there were few buttons on some tabs
	{
		switch phasmoTabNames.Text
		{
			case 'Ghosts':
				phasmoTabNames.Move(,,, 448)
				PhasmoGui.Show('Center h468')
			case 'Equipment':
				phasmoTabNames.Move(,,, 476)
				PhasmoGui.Show('Center h496')
			case 'Cursed Items':
				phasmoTabNames.Move(,,, 198)
				PhasmoGui.Show('Center h218')
		}
		RoundedCorners(15)
		ControlFocus(PhasmoGui['username_1'])	; I don't like the look of the selection box around the buttons or tabs so this defaults to not show 
	}

;-------------------------------------------------------------------------------
; DESTROY GUI
;-------------------------------------------------------------------------------
	Phasmo_Destroy(*) 
	{
		if IsSet(PhasmoGui) {
			PhasmoGui.Destroy()
			PhasmoGui := unset
			SetTimer(RGBusernameSetup, 0)
		}
	}