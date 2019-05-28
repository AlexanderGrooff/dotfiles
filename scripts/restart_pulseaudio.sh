#!/usr/bin/env bash

PA_CMD=/usr/bin/pulseaudio

# Check if pulseaudio is running
if $PA_CMD --check; then
    # Kill the running instance
    $PA_CMD -k
fi

# Restart daemon
$PA_CMD -D
