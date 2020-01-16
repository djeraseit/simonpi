#!/bin/bash

QEMUISRUNNING=

# QEMU Vars
export QEMU_AUDIO_DRV=none

checkQemu() {
    if [ -n "$(pidof "$QEMUARM")" ] \
    || [ -n "$(pidof "$QEMUARM64")" ]; then
        QEMUISRUNNING=1
    else
        QEMUISRUNNING=0
    fi
}

killQemu() {
    checkRoot
    
    if [ $QEMUISRUNNING = "1" ]; then
        echo -e "[$PASS] Killing QEMU instances ..."
        if [ -n "$(pidof "$QEMUARM")" ]; then
            for i in $(pidof "$QEMUARM"); do
                sudo -E kill -15 "$i"
            done
        else
            for i in $(pidof "$QEMUARM64"); do
                sudo -E kill -15 "$i"
            done
        fi
    else
        echo -e "[$WARN] QEMU is not running ..."
    fi
}