#!/bin/bash
# Decrypt sops-encrypted files in ~/.bash.d after external repo is cloned/updated

set -euo pipefail

BASHD="$HOME/.bash.d"

if [ ! -d "$BASHD" ]; then
    exit 0
fi

cd "$BASHD"

for enc_file in *.enc; do
    [ -f "$enc_file" ] || continue
    plaintext="${enc_file%.enc}"
    if sops -d "$enc_file" > "$plaintext" 2>/dev/null; then
        echo "Decrypted: $enc_file -> $plaintext"
    else
        echo "Failed to decrypt: $enc_file" >&2
    fi
done
