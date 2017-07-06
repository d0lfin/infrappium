#!/bin/bash

/opt/x.sh
sleep 5
nohup /opt/android-sdk/tools/emulator64-x86 -avd Emulator -no-audio -no-boot-anim -no-jni -gpu mesa -qemu -enable-kvm &

exit 0