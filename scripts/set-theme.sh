#!/usr/bin/env bash

# Verify an argument was passed
if [ -z "$1" ]; then
  echo "Error: Please provide an image path."
  echo "Usage: set-theme /path/to/image.png"
  exit 1
fi

IMAGE="$1"

# Verify the file actually exists
if [ ! -f "$IMAGE" ]; then
  echo "Error: File '$IMAGE' not found."
  exit 1
fi

# 1. Feed the Universal Cache for Hyprlock/Fastfetch
cp "$IMAGE" ~/.cache/theme/lock.png
cp "$IMAGE" ~/.cache/theme/wall.png

# 2. Instantly reload the Wayland wallpaper daemon
awww img "$IMAGE" --transition-type wipe

echo "Theme updated to: $IMAGE"
