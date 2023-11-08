#!/usr/bin/env bash

# Set up environment to run the Python project
if [ ! -d .venv ]; then
    python3 -m venv .venv
    source .venv/bin/activate
    pip install -r requirements.txt
fi
