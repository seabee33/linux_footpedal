#!/bin/bash

# Stop the system from reading input because no one cares about the output from the foot pedal
xinput disable "PCsensor FootSwitch Keyboard"

# Make sure the right device was found
EVENT_ID=$(ls -l /dev/input/by-id/*PCsensor*event-kbd | awk -F/ '{print $NF}')
echo "Found device at: $EVENT_ID"

if [ -z "$EVENT_ID" ]; then
    echo "Could not find FootSwitch device"
    exit 1
fi

# Read the output from the event log and do key presses when activated
sudo evtest /dev/input/$EVENT_ID | while read line; do
    if [[ "$line" == *"type 1 (EV_KEY), code"* && "$line" == *"value 1"* ]]; then
        if [[ "$line" == *"KEY_A"* ]]; then
            echo "a pressed"
            xdotool key ctrl+shift+r
        elif [[ "$line" == *"KEY_B"* ]]; then
            echo "b pressed"
            xdotool key ctrl+f
        elif [[ "$line" == *"KEY_C"* ]]; then
            echo "c pressed"
            xdotool key ctrl+v
        fi
    fi
done
