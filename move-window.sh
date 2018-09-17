#!/bin/bash

# monitor configuration
horizontal_monitor_count=2
vertical_monitor_count=2
screensize_x=1680
screensize_y=1050

# get positions and sizes
currentpos_x=$(xwininfo -id `xdotool getwindowfocus` | awk '/(Absolute upper-left X:  )/ { print $4 }')
currentpos_y=$(xwininfo -id `xdotool getwindowfocus` | awk '/(Absolute upper-left Y:  )/ { print $4 }')
decorations_x=$(xwininfo -id `xdotool getwindowfocus` | awk '/(Relative upper-left X:  )/ { print $4 }')
decorations_y=$(xwininfo -id `xdotool getwindowfocus` | awk '/(Relative upper-left Y:  )/ { print $4 }')
currentsize_x=$(xwininfo -id `xdotool getwindowfocus` | awk '/(Width: )/ { print $2 }')
currentsize_y=$(xwininfo -id `xdotool getwindowfocus` | awk '/(Height: )/ { print $2 }')

#adjust for decorations
currentpos_x=$(($currentpos_x-$decorations_x))
currentpos_y=$(($currentpos_y-$decorations_y))

function set_window_position {
    xdotool windowmove `xdotool getwindowfocus` $1 $2
}

function set_window_unmaximized {
    wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz
}

function set_window_maximized {
    wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
}

function move_window_x {
    if [ $1 -ge 0 ] && [ $1 -le $(($screensize_x*$horizontal_monitor_count)) ]; then
        set_window_unmaximized
        set_window_position $1 $currentpos_y
        if [ $currentsize_x -eq $screensize_x ]; then
            set_window_maximized
        fi
    fi
}

function move_window_y {
    if [ $1 -ge 0 ] && [ $1 -le $(($screensize_y*$vertical_monitor_count)) ]; then
        set_window_unmaximized
        set_window_position $currentpos_x $1
        if [ $currentsize_y -eq $(($screensize_y-$decorations_y)) ]; then
            set_window_maximized
        fi
    fi
}

function usage_print () {
    echo 'move-window.sh x [left|right] - move active window left or right'
    echo 'move-window.sh y [up|down] - move active window up or down'
}

function move_window () {
    if [ $1 = "x" ]; then
        if [ $2 = "left" ]; then
            move_window_x $(($currentpos_x-$screensize_x))
        elif [ $2 = "right" ]; then
            move_window_x $(($currentpos_x+$screensize_x))
        else
            usage_print
        fi
    elif [ $1 = "y" ]; then
        if [ $2 = "up" ]; then
            move_window_y $(($currentpos_y-$screensize_y))
        elif [ $2 = "down" ]; then
            move_window_y $(($currentpos_y+$screensize_y))
        else
            usage_print
        fi
    else
        usage_print
    fi
}

if [ -n "$1" ] && [ -n "$2" ]; then
    move_window $1 $2
else
    usage_print
fi