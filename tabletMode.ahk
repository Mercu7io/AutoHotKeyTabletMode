#Persistent
#SingleInstance Ignore

#Include %A_ScriptDir%\Ini.ahk
#Include %A_ScriptDir%\Settings.ahk

#include Lib\AutoHotInterception.ahk

; Setup AHI, the keyboard handle came from the "monitor" utility script included with AHI
global KEYB := new AutoHotInterception()
KEYB.SubscribeKeyboard(2, true, Func("KeyEvent"))
KEYB.SetState(false)



global locked

global locked := false
global landscapeOr := true


if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"  ; Requires v1.0.92.01+
   ExitApp
}

FileInstall, unlocked.ico, %A_ScriptDir%\unlocked.ico, 0
FileInstall, locked.ico, %A_ScriptDir%\locked.ico, 0

settings := new Settings()


;create the tray icon and do initial setup
initialize()


;end execution here - the rest of the file is functions and callbacks
return

^+k::
	LockKeyboard(true)
return

initialize()
{
	;initialize the tray icon and menu
	Menu, Tray, Icon, %A_ScriptDir%\unlocked.ico
	Menu, Tray, NoStandard
	Menu, Tray, Add, Lock keyboard, ToggleKeyboard
	Menu, Tray, Click, 1
	Menu, Tray, Default, Lock keyboard
	Menu, Tray, Add, Orientation, ToggleOrientation
	Menu, Tray, Add, Exit, Exit

}

;callback for when the keyboard shortcut is pressed
ShortcutTriggered:
    ;check if shortcut is disabled in settings
    if (settings.DisableShortcut())
    {
        return
    }

    ;if we're already locked, stop here
    if (locked)
    {
        return
    }

	;wait for each shortcut key to be released, so they don't get "stuck"
	for index, key in StrSplit(settings.ShortcutHint(), "+")
	{
		KeyWait, %key%
    }

	LockKeyboard(true)
return


;"Lock/Unlock keyboard" menu clicked
ToggleKeyboard()
{
	
	if (locked) {
		LockKeyboard(false)
	} else {
		LockKeyboard(true)
	}
}


ToggleOrientation()
{		
	VarSetCapacity(DEVMODE, 220, 0)
	NumPut(220, DEVMODE, 68, "short")   ; dmSize
	DllCall("EnumDisplaySettingsW", "ptr", 0, "int", -1, "ptr", &DEVMODE)
	width := NumGet(DEVMODE, 172, "uint")
	height := NumGet(DEVMODE, 176, "uint")
	
	if (landscapeOr){
		;MsgBox, to portrait
		NumPut(width, DEVMODE, 176, "int")
		NumPut(height, DEVMODE, 172, "int")
		NumPut(DMDO_90 := 1, DEVMODE, 84, "int")   ; dmDisplayOrientation
		DllCall("ChangeDisplaySettingsW", "ptr", &DEVMODE, "uint", 0)
		landscapeOr := false
	} else { ; rotating to landscape
		;MsgBox, to landscape
		NumPut(width, DEVMODE, 176, "int")
		NumPut(height, DEVMODE, 172, "int")
		NumPut(DMDO_DEFAULT := 0, DEVMODE, 84, "int")   ; dmDisplayOrientation
		DllCall("ChangeDisplaySettingsW", "ptr", &DEVMODE, "uint", 0)
		landscapeOr := true
	}
}




;"Exit" menu clicked
Exit()
{
	ExitApp
}

;Lock or unlock the keyboard
LockKeyboard(lock)
{

	if (lock) {

	    ;change the tray icon to a lock
		Menu, Tray, Icon, %A_ScriptDir%\locked.ico


        ;lock the keyboard
		KEYB.SetState(true)
		locked := true
		
		;turn to tablet mode
		RegWrite, REG_DWORD, HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\PriorityControl, ConvertibleSlateMode, 0

		
		;MOUSE.SetState(true)
		Run, SystemSettingsAdminFlows EnableTouchpad 0


		;also lock the mouse, if configured to do so
		if (settings.LockMouse()) {
		;	Run, SystemSettingsAdminFlows EnableTouchpad 0
		}

	} else {
        ;unlock the keyboard
		KEYB.SetState(false)
		locked := false
		
		;turn to pc mode
		RegWrite, REG_DWORD, HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\PriorityControl, ConvertibleSlateMode, 1

		;MOUSE.SetState(false)
		Run, SystemSettingsAdminFlows EnableTouchpad 1

		
        ;also unlock the mouse, if configured to do so
        if (settings.LockMouse()) {
        ;    Run, SystemSettingsAdminFlows EnableTouchpad 1
        }
		
		;if in portrait move back to landscape
		if(! landscapeOr){
			ToggleOrientation()
		}
		
	    ;change tray icon back to unlocked
		Menu, Tray, Icon, %A_ScriptDir%\unlocked.ico



		if(settings.CloseOnUnlock())
		{
		    ExitApp
		}
	}
}

return
