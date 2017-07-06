#!/bin/bash

function run_x_server () {
    nohup X :10 &
    nohup x11vnc -loop -display :10 &
}

function run_emulator () {
    nohup /opt/android-sdk/tools/emulator64-x86 -avd Emulator -no-audio -no-boot-anim -no-jni -gpu mesa -qemu -enable-kvm &
}

function wait_for_emulator () {
    until [[ "$bootanim" =~ "stopped" ]]; do
        bootanim=`adb -e shell getprop init.svc.bootanim 2>&1 &`
        sleep 1
    done
}

run_x_server
sleep 5
run_emulator
wait_for_emulator

exit 0