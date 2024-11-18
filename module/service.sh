#!/system/bin/sh

[ ! "$MODPATH" ] && MODPATH=${0%/*}

sleep 30

# ----------------
# Running in loop
# ----------------

# Run
. $MODPATH/function.sh || abort

# Loop service
while true; do
    create_target
    if [ $? -eq 0 ]; then
        ui_print "auto-target-txt: Success create target.txt file"
    else
        ui_print "auto-target-txt: Failed create target.txt file, stopping loop..."
        break
    fi

    # Sleep 1 minutes for next loop
    sleep 60
done
