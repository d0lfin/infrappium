#!/bin/bash

unauthorized=true

while [[ $unauthorized ]]
do
    sleep 1
    unauthorized=`adb devices | grep unauthorized`
done

# device type
isTablet=`adb shell getprop ro.build.characteristics | grep tablet`

# version
ANDROID_VERSION=`adb shell getprop | grep ro.build.version.release |  sed 's/^.*:.*\[\(.*\)\].*$/\1/g'`

# current host
HOST=`hostname`

if [[ $isTablet ]]
then
    DEVICETYPE='Tablet'
else
    DEVICETYPE='Phone'
fi

cat << EndOfMessage
{
    "capabilities": [{
        "browserName": "${DEVICETYPE}",
        "version": "${ANDROID_VERSION}",
        "maxInstances": 1,
        "platform": "ANDROID"
    }],
    "configuration": {
        "proxy": "ru.yandex.qatools.selenium.proxy.WatchdogProxy",
        "cleanUpCycle": 2000,
        "timeout": 90000,
        "url": "http://${HOST}:${PORT}/wd/hub",
        "maxSession": 1,
        "port": ${PORT},
        "host": "${HOST}",
        "register": true,
        "registerCycle": 5000,
        "hubPort": ${HUB_PORT},
        "hubHost": "${HUB}"
    }
}
EndOfMessage