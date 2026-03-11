#!/usr/bin/env bash
swww-daemon &
#swww img /home/felix/wallpapers/current.jpg &
nm-applet --indicator &
blueman-applet &
waybar &
dunst &
hyprctl setcursor rose-pine-hyprcursor 36 &
hyprcursor &
hyprcursor-set rose-pine-hyprcursor &
# Work sepcific stuff
firefox -new-tab -url https://zabbix.muc.boerse-go.de/ -new-tab -url https://outlook.office.com/ -new-tab -url https://stock3.atlassian.net/jira/your-work -new-tab -url https://monkeytype.com/ -new-tab -url https://open.spotify.com/ -new-tab -url http://bgtop.dc1.boerse-go.de/snapshots.php?autoRefresh=60&limit=500 &
teams-for-linux &
kitty --detach btop &
# More stuff for the Mouse cursor, i put this last because it didn't start once and then blocked everything else
xrdb -load ~/.Xresources
