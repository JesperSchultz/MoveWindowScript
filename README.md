# MoveWindowScript
Small script for moving active windows in X

## Required tools
```
wmcrtl
xdotool
awk
xwininfo
```
## Configuration

The variables in the script can be adjusted to fit monitor setup and resolution
```
horizontal_monitor_count=2
vertical_monitor_count=2
screensize_x=1680
screensize_y=1050
```

## Usage

```
move-window.sh x left
move-window.sh x right
move-window.sh y down
move-window.sh y up
```
