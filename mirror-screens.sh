#!/bin/bash
# This mirrors the laptop screen to the external output, scaling up-down as necessary
# Useful for coding presentations at conferences, where projectors resolution often doesn't match the laptop built-in panel

xrandr --output eDP1 --auto --output DP2 --auto --same-as eDP1 --scale-from 3840x2160
