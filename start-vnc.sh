#!/bin/bash

# Start VNC server
vncserver :1 -geometry 1280x720 -depth 24

# Start XFCE
startxfce4 &
wait
