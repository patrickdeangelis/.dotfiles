#!/bin/bash

# $1 is the target index passed from tmux
TARGET_INDEX=$1

# 1. Check if the target window index already exists
if tmux list-windows | grep -q "^$TARGET_INDEX:"; then
    # Window exists: Swap the current window with the target
    tmux swap-window -t "$TARGET_INDEX"
else
    # Window doesn't exist: Move current window to that index
    tmux move-window -t "$TARGET_INDEX"
fi

# 2. In both cases, switch focus to that index
tmux select-window -t "$TARGET_INDEX"
