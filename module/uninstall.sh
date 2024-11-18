#!/system/bin/sh

[ ! "$MODPATH" ] && MODPATH=${0%/*}

# Restore default target.txt
restore_default
