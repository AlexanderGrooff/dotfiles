ATTEMPTS=5
CURR_ATTEMPT=0

while [ $CURR_ATTEMPT -lt $ATTEMPTS ]; do
    if [[ $(xrandr | grep -E "^ .*\+" | grep -v "\*") ]] ; then
        echo "Found broken monitor config, attempting to fix..."
        autorandr horizontal
    else
        echo "Monitor config is OK."
        break
    fi
    CURR_ATTEMPT=$((CURR_ATTEMPT+1))
done

if [ $CURR_ATTEMPT -eq $ATTEMPTS ]; then
    echo "Failed to fix monitor config, giving up."
fi
