# Mainframe

Initially started as this older, but popular gui: https://github.com/plul/Public-AutoHotKey-Scripts

I have updated it to AHK v2 with very heavy modifications, adding a new aesthetic and functionality.

![](https://github.com/CrashGit/Mainframe/blob/main/gui.gif)

If you're not familiar with how this works, the idea is to type commands into a box to perform actions. I find this ideal because it's easier to remember words associated with actions rather than a ton of very specific hotkeys.

The `main().ahk` file is the only thing that needs to be ran.

Default hotkey is `CapsLock + Spacebar`.

Type a question mark (`?`) into the box to see majority of the commands. This will give you an idea of what you can do. Some things will needs to be changed if you wish to actually use them, such as the  directories used or your email address for typing your email. The underscores (`_`) that follow the command represent a space. It should be pretty easy to figure out how to add your own when looking at the commands.ahk file.

One thing to note when adding commands, I coded the command function in a way so that every command doesn't need to destroy the gui. Because of this, there are some things that have to be wrapped in a SetTimer(). A common example of this is trying to send text to the screen. Without the timer, it would send the text to the gui before destroying it instead of the program you want the text to end up. I've included a `SendTextToScreen()` function that can automatically do that, just pass the text as a parameter.

I've also included two other gui files in the commands folder that don't show up with the ? command:

`wrap text.ahk` lets you wrap text with some pre-defined symbols. The text just has to be selected prior to using it.

`phasmo.ahk` is for anyone that plays a lot of Phasmophobia. It has a bunch of buttons that open the wiki page for the item on the button. It includes all ghosts, equipment, and cursed items.

If you don't want these two files, just delete them and remove the #Include line associated with them in `main().ahk`

Hovering the mouse over the titles will also show a tooltip with a brief description.

Not sure if I'll be updating this. Just wanted to put it out there to inspire others.
