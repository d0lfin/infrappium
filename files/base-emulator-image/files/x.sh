#!/bin/bash

nohup X :10 &
nohup x11vnc -loop -display :10 &

exit 0
