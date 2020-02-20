#!/usr/bin/env bash

function fix_pa {
    PA_CMD=/usr/bin/pulseaudio

    # Check if pulseaudio is running
    if $PA_CMD --check; then
        # Kill the running instance
        $PA_CMD -k
    fi

    # Restart daemon
    $PA_CMD -D
}
fix_pa
fix_pa
