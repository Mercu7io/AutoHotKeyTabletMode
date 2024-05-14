# AutoHotKeyTabletMode
Autohotkey script to switch to tablet mode and lock keyboard and trackpad.
This script is made for AutoHotKey v1.

Based on https://github.com/sophice/ahk-keyboard-locker and https://github.com/evilC/AutoHotInterception

# How it work
The script show a menu in the tray to lock the keyboard and the touchpad.
It also allow to change orientation.
The orientation come back to landscape when the keyboard in unlock.

------

# Setup

## Install the Autohotkey v1

## Install the Intereception driver
Download and install the [Interception Driver](https://github.com/oblitum/Interception/releases)  
Note that you **must** run `install-interception.exe` at an admin command prompt (**Not double-click it**) - once you do so, it will instruct you to execute `install-interception.exe /install` to actually perform the install.  

## Enable the script
Right-click `Unblocker.ps1` in the lib folder and select `Run as Admin`.  
This is because downloaded DLLs are often blocked and will not work.  
Alternatively, this can be done manually in one of two ways:
   1. By right clicking the DLLs, selecting Properties, and checking a "Block" box if it exists.  
   2. Before you open any zip (ie the AutoHotInterception zip or the Interception zip), right click it and select "Unblock".
  


# Device IDs / VIDs PIDs etc

I set by hand the keyboard ID to 2.
You may need to chang it. To do it, find the device ID using the Monitor app.

## Monitor App
This handy tool allows you to check if AHI is working, and also to find the VID/PID or DeviceHandle of your devices.  
You can use the handy "Copy" buttons to copy the VID/PID or DeviceHandle of the device to the clipboard.  
When using the monitor app, **DO NOT** tick all devices at once, as if it crashes, it will lock up all devices.




