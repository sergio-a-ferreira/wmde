#!/usr/bin/env bash

#----------------------------------------------------------
# from https://github.com/polybar/polybar/wiki

#----------------------------------------------------------
# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
#polybar-msg cmd quit
# Otherwise you can use the nuclear option:
killall -q polybar

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar_mainbar.log #/tmp/polybar2.log
polybar mainbar 2>&1 | tee -a /tmp/mainbar.log & disown
#polybar bar2 2>&1 | tee -a /tmp/polybar2.log & disown

echo "Bars launched..."

