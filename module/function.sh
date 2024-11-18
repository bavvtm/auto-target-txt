#!/system/bin/sh

# ----------------
# Global Vars
# ----------------

# Folder located for Tricky Store module
# TRICKY_STORE_DIR=

# Path for backup target.txt file while processing
# TARGET_BACKUP=

# Default Tricky Store target.txt backup
# TARGET_BACKUP_DEFAULT=

# Android Security Level status, you can also check it on app "DRM Info"
# Scroll down and check Security Level is L1 (Not broken) or L3 (Broken)
# TEE_BROKEN=

# ----------------
# Functions
# ----------------

set_tricky() {
    [ -d $1 ] || abort "! Unable to detect tricky store dir"
    [ ! -z $TEE_STATUS_FILE ] || export TEE_STATUS_FILE="$1/tee_status"
    [ ! -z $TARGET_FILE ] || export TARGET_FILE="$1/target.txt"
}

create_target() {
    if [ -f $TARGET_FILE ]; then
        [ -f $TARGET_BACKUP ] && su -c rm -rf "$TARGET_BACKUP"
        su -c mv "$TARGET_FILE" "$TARGET_BACKUP"
    fi

    # Making target.txt
    local PACKAGES=$(su -c pm list packages | awk -F: '{print $2}')
    for package in $PACKAGES; do
        # Force use generate certificate if tee is broken
        # @see: https://t.me/TheBreakdowns/143
        if [ "$TEE_BROKEN" = true ]; then
            echo "$package!" >>"$TARGET_FILE"
        else
            echo "$package" >>"$TARGET_FILE"
        fi
    done

    return 0
}

backup_default() {
    if [ -f $TARGET_FILE ]; then
        [ -f $TARGET_BACKUP_DEFAULT ] && su -c rm -rf "$TARGET_BACKUP_DEFAULT"
        su -c cp "$TARGET_FILE" "$TARGET_BACKUP_DEFAULT"
    fi
}

restore_default() {
    if [ -f $TARGET_BACKUP_DEFAULT ]; then
        su -c rm "$TARGET_FILE"
        su -c mv "$TARGET_BACKUP_DEFAULT" "$TARGET_FILE"
    fi
}

# ----------------
# Presets
# ----------------

[ -z $TRICKY_STORE_DIR ] && TRICKY_STORE_DIR="/data/adb/tricky_store"
set_tricky $TRICKY_STORE_DIR

[ -z $TEE_BROKEN ] && [ ! -f $TEE_STATUS_FILE ] && TEE_BROKEN=true
[ -z $TEE_BROKEN ] && [ -f $TEE_STATUS_FILE ] && grep "teeBroken=true" "$TEE_STATUS_FILE" >/dev/null && TEE_BROKEN=true
[ -z $TEE_BROKEN ] && [ -f $TEE_STATUS_FILE ] && grep "teeBroken=false" "$TEE_STATUS_FILE" >/dev/null && TEE_BROKEN=false

[ -z $TARGET_BACKUP ] && TARGET_BACKUP="$TARGET_FILE.bak"
[ -z $TARGET_BACKUP_DEFAULT ] && TARGET_BACKUP_DEFAULT="$MODPATH/target.txt"
