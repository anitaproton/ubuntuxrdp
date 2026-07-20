#!/bin/bash

systemctl enable xrdp

systemctl set-default graphical.target

service xrdp start

mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix
tail -f /var/log/xrdp-sesman.log

