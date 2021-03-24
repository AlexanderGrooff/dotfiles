#!/usr/bin/env python3

# This hooks script syncs task warrior to the configured task server.
# The on-exit event is triggered once, after all processing is complete.

# Make sure hooks are enabled and this hook script is executable. 
# Run `task diag` for diagnostics on the hook.

import sys
import json
import subprocess


try:
    tasks = json.loads(sys.stdin.readline())
except:
    # No input
    pass
  
# Call the `sync` command
# hooks=0 ensures that the sync command doesn't call the on-exit hook
# verbose=nothing sets the verbosity to print nothing at all
subprocess.call(["task", "rc.hooks=0", "rc.verbose=nothing", "sync"])

sys.exit(0)
