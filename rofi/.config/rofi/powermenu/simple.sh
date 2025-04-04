#!/bin/sh

# Power menu script using tofi

CHOSEN=$(printf "Lock\nSuspend\nReboot\nShutdown\nLog Out" | rofi -dmenu -i -them-str '@import "/home/amirali/.config/rofi/powermenu/powermenu-style.rasi"')

case "$CHOSEN" in
	"Lock") hyprlock ;;
	"Suspend") systemctl suspend ; hyprlock;;
	"Reboot") reboot ;;
	"Shutdown") poweroff ;;
	"Log Out") hyprctl dispatch exit ;;
	*) exit 1 ;;
esac
