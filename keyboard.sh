#!/bin/bash
xinput disable "PCsensor FootSwitch Keyboard"

EVENT_ID=$(ls -l /dev/input/by-id/*PCsensor*event-kbd | awk -F/ '{print $NF}')
echo "Found device at: $EVENT_ID"

if [ -z "$EVENT_ID" ]; then
    echo "Could not find FootSwitch device"
    exit 1
fi

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
