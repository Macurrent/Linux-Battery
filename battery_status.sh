#!/bin/bash

while true; do
    export DISPLAY=:0.0
    battery_level=$(acpi -b | grep -P -o '[0-9]+(?=%)')

    if on_ac_power; then
        if [ $battery_level -le 15 ]; then
            killall -CONT vlc ## Resume paused vlc when AC adapter is unpluged
        fi

        if [ $battery_level -ge 90 ]; then
            notify-send "Battery charging above 90%. Please unplug your AC adapter!" "Charging: ${battery_level}% "
            killall -STOP vlc
            gnome-screensaver-command -l ## lock the screen if you don't unplug AC adapter after 20 seconds
            sleep 20
        fi

    else

        if [ $battery_level -ge 90 ]; then
            killall -CONT vlc ## Resume paused vlc when AC adapter is unpluged
        fi

        if [ $battery_level -le 15 ]; then
            notify-send "Battery is lower than 15%. Need for charging! Please plug your AC adapter." "Charging: ${battery_level}%"
            killall -STOP vlc
            gnome-screensaver-command -l ## lock the screen if you don't plug AC adapter after 20 seconds
            sleep 20
        fi
    fi

    if [ $battery_level -le 10 ]; then

        if ! on_ac_power; then
            notify-send "Your laptop is going to shutdown after 10 aeconds. Please plug in your charger"
            sleep 10
            systemctl hibernate
        fi

    fi

done
