#!/bin/bash

# Get the Windows username and convert to WSL path
WINDOWS_USER=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')
WINDOWS_USER_DIR="/mnt/c/Users/$WINDOWS_USER"


# Get the current directory where your script is running
CURRENT_DIR="$PWD"

# The string to find and replace (you can pass this as an argument)
SEARCH_STRING="WINDOWS_BACKGROUND_IMAGE_PATH"

# The Windows-style path where bg.png symlink will be
# Convert /mnt/c/Users/username to C:\Users\username
WINDOWS_STYLE_PATH="C:\\\\Users\\\\$WINDOWS_USER\\\\bg.png"

# Create symlink for settings.json
# Searching for Windows Terminal settings location
TERMINAL_DIR=$(find "$WINDOWS_USER_DIR/AppData/Local/Packages" -maxdepth 1 -type d -name "Microsoft.WindowsTerminal_*" | head -n 1)
TERMINAL_SETTINGS_PATH="$TERMINAL_DIR/LocalState/settings.json"

# Check if we found the terminal directory
if [ -z "$TERMINAL_DIR" ]; then
    echo "Error: Could not find Windows Terminal directory"
    exit 1
fi

# Replace the placeholder in settings.json with the Windows path
sed -i "s|$SEARCH_STRING|$WINDOWS_STYLE_PATH|g" "$CURRENT_DIR/settings.json"

# Create symlink for bg.png in user directory
ln -sf "$CURRENT_DIR/bg.png" "$WINDOWS_USER_DIR/bg.png"

# Create the symlink for settings.json
ln -sf "$CURRENT_DIR/settings.json" "$TERMINAL_SETTINGS_PATH"


echo "Setup complete!"
