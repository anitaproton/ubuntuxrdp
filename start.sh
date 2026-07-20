#!/bin/bash


systemctl enable xrdp

systemctl set-default graphical.target

service xrdp start


