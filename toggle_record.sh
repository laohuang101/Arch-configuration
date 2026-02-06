#!/bin/bash

# Define where to save and the file name
SAVE_DIR="$HOME/Videos"
mkdir -p "$SAVE_DIR"
FILENAME="recording_$(date +%Y%m%d_%H%M%S).mp4"

# 1. Check if the recorder is ALREADY running
if pgrep -f "gpu-screen-recorder" > /dev/null; then
    # It's running! Stop it.
    # We use -SIGINT so it saves the file properly before closing
    pkill -SIGINT -f "gpu-screen-recorder"
    notify-send -t 2000 "Recording" "Stopped and saved to Videos" -i camera-video
else
    # It's NOT running! Start it.
    notify-send -t 2000 "Recording" "Started..." -i camera-video
    
    # Run in background (&) so the script doesn't hang
    # We use -w screen to bypass portal issues on Niri
    gpu-screen-recorder -w screen -f 60 -a default_output -o "$SAVE_DIR/$FILENAME" &
fi
