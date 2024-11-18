#!/system/bin/sh

SKIPUNZIP=0

. $MODPATH/function.sh || abort

if [ "$BOOTMODE" != true ]; then
    ui_print "! Please install in Magisk Manager or KernelSU Manager"
    ui_print "! Install from recovery is NOT supported"
    abort
fi

# ----------------
# Module install
# ----------------

ui_print "- Tricky Store dir: $TRICKY_STORE_DIR"
ui_print "- Tee Status: $($TEE_BROKEN && echo "Broken" || echo "Normal")"

# Backup default target.txt
ui_print "- Backup default target.txt file"
backup_default

# Create target.txt
ui_print "- Create target.txt file"
create_target
if [ $? -eq 0 ]; then
    ui_print "- Success installed"
else
    ui_print "! Fail install"
fi
