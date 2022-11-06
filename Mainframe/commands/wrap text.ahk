case 'wrap':	; Wrap text in special characters
	MainGui_Destroy()

	global WrapGui := Gui('+AlwaysOnTop -SysMenu +ToolWindow -Caption -Border')
	WrapGui.OnEvent('Escape', WrapGui_Destroy)
	
	WrapGui.BackColor := '292a35'	
	
	WrapGui.SetFont('s11 bold', 'Segoe UI')
	WrapGui.AddGroupBox(blue ' Center x10 y0 w380 h180', 'Wrap Text')

	; ------------------------------------------------------------
	; opening and closing symbols to wrap text in
	; index		  1		2	 3	  4	   5	6    7	   8	 9
	opening := ['{{}', '[', '(', '"', "'", '%', '<', '/* ', '|']
	closing := ['{}}', ']',	')', '"', "'", '%', '>', ' */', '|']

	WrapGui.SetFont('norm')
	WrapGui.AddButton('x30  y30  w100 h30', 	'{    }'	).OnEvent('Click', 	(*) => 	Encase(opening[1], closing[1]))
	WrapGui.AddButton('x150 y30  w100 h30', 	'[    ]'	).OnEvent('Click', 	(*) => 	Encase(opening[2], closing[2]))
	WrapGui.AddButton('x270 y30  w100 h30',		'(    )'	).OnEvent('Click', 	(*) => 	Encase(opening[3], closing[3]))
	WrapGui.AddButton('x30 	y80  w100 h30',		'"    "'	).OnEvent('Click', 	(*) => 	Encase(opening[4], closing[4]))
	WrapGui.AddButton('x150 y80  w100 h30',		"'    '"	).OnEvent('Click', 	(*) => 	Encase(opening[5], closing[5]))
	WrapGui.AddButton('x270 y80  w100 h30',		'%    %'	).OnEvent('Click', 	(*) => 	Encase(opening[6], closing[6]))
	WrapGui.AddButton('x30 	y130 w100 h30',		'<    >'	).OnEvent('Click', 	(*) => 	Encase(opening[7], closing[7]))
	WrapGui.AddButton('x150 y130 w100 h30', 	'/*    */'	).OnEvent('Click', 	(*) => 	Encase(opening[8], closing[8]))
	WrapGui.AddButton('x270 y130 w100 h30', 	'|    |'	).OnEvent('Click', 	(*) =>	Encase(opening[9], closing[9]))

	WrapGui.SetFont('s11 bold')
	WrapGui.AddText('x148   y168	vusername_1',   'C')
	WrapGui.AddText('xp+9   yp      vusername_2',   'r')
	WrapGui.AddText('xp+6   yp      vusername_3',   'a')
	WrapGui.AddText('xp+8   yp      vusername_4',   's')
	WrapGui.AddText('xp+7   yp      vusername_5',   'h')
	WrapGui.AddText('xp+15  yp      vusername_6',   'O')
	WrapGui.AddText('xp+12  yp      vusername_7',   'v')
	WrapGui.AddText('xp+8   yp      vusername_8',   'e')
	WrapGui.AddText('xp+8   yp      vusername_9',   'r')
	WrapGui.AddText('xp+6   yp      vusername_10',  'r')
	WrapGui.AddText('xp+6   yp      vusername_11',  'i')
	WrapGui.AddText('xp+4   yp      vusername_12',  'd')
	WrapGui.AddText('xp+8   yp      vusername_13',  'e')
	global RGBusernameSetup := (*) => RGBusername('WrapGui')
    SetTimer(RGBusernameSetup, 100)

	WrapGui.Show('w400 h190')
	RoundedCorners(15)
	ControlFocus(WrapGui['username_1'])	; I don't like the look of the selection box around the buttons or tabs so this defaults to not show


Encase(opening, closing) 
{
	WrapGui_Destroy()
	A_Clipboard := ''   ; resets clipboard value so ClipWait works properly
	Send('^c')							; copy (ctrl + c)
	ClipWait(3)
	Send(opening A_Clipboard closing)	; send copied value with symbols around it
}

WrapGui_Destroy(*) 
{
	if IsSet(WrapGui) {
		WrapGui.Destroy()
		WrapGui := unset
		SetTimer(RGBusernameSetup, 0)
	}
}