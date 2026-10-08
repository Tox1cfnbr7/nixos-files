#!/usr/bin/env bash
while true; do
    vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    if [[ $vol == *MUTED* ]]; then
        vol_text="Vol: stumm"
    else
        vol_text="Vol: $(echo "$vol" | awk '{printf "%d%%", $2*100}')"
    fi
    echo "$vol_text | $(date '+%a %d.%m. %H:%M')"
    sleep 2
done
