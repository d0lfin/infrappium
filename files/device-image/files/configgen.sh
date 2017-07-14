#!/bin/bash

unauthorized=true

while [[ $unauthorized ]]
do
    sleep 1
    unauthorized=`adb devices | grep unauthorized`
done

# device type
isTablet=`adb shell getprop ro.build.characteristics | grep tablet`

# abi
arm=`adb shell getprop ro.product.cpu.abi | grep arm`

# version
ANDROID_VERSION=`adb shell getprop | grep ro.build.version.release |  sed 's/^.*:.*\[\(.*\)\].*$/\1/g'`

# display size
info=`adb shell dumpsys display | grep -A 20 DisplayDeviceInfo`
width=`echo ${info} | sed 's/^.* \([0-9]\{3,4\}\) x \([0-9]\{3,4\}\).*density \([0-9]\{3\}\),.*$/\1/g'`
height=`echo ${info} | sed 's/^.* \([0-9]\{3,4\}\) x \([0-9]\{3,4\}\).*density \([0-9]\{3\}\),.*$/\2/g'`
density=`echo ${info} | sed 's/^.* \([0-9]\{3,4\}\) x \([0-9]\{3,4\}\).*density \([0-9]\{3\}\),.*$/\3/g'`
let widthDp=${width}/${density}
let heightDp=${height}/${density}
let sumW=${widthDp}*${widthDp}
let sumH=${heightDp}*${heightDp}
let sum=${sumW}+${sumH}

if [[ $softwarebuttons ]]
then
    HARDWAREBUTTONS=false
else
    HARDWAREBUTTONS=true
fi

if [[ $isTablet ]]
then
    DEVICETYPE='Tablet'
else
    DEVICETYPE='Phone'
fi

if [[ $arm ]]
then
    ABI='ARM'
else
    ABI='X86'
fi

if [[ ${sum} -ge 81 ]]
then
    DISPLAYSIZE=10
else
    DISPLAYSIZE=7
fi

# current host
HOST=`hostname`

cat << EndOfMessage
{
    "capabilities": [{
        "browserName": "${DEVICETYPE}",
        "version": "${ANDROID_VERSION}",
        "maxInstances": 1,
        "platform": "ANDROID",
        "abi": "${ABI}",
        "displaySize": ${DISPLAYSIZE},
        "hardwareButtons": ${HARDWAREBUTTONS}
    }],
    "configuration": {
        "proxy": "ru.yandex.qatools.selenium.proxy.WatchdogProxy",
        "cleanUpCycle": 2000,
        "timeout": 90000,
        "maxSession": 1,
        "port": ${PORT},
        "host": "${HOST}",
        "register": true,
        "registerCycle": 5000,
        "hubPort": ${HUB_PORT},
        "hubHost": "localhost"
    }
}
EndOfMessage