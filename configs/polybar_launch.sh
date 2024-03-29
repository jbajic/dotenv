#!/usr/bin/env bash

name=main
pkill polybar
if type "xrandr"; then
  for monitor in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=${monitor} polybar --config=~/.config/polybar/config.ini --reload ${name}&
  done
else
  polybar --reload ${name} &
fi
