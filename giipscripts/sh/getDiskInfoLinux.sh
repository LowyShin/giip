#!/bin/bash
# Written by Lowy Shin at 20140922
# User Variables ===============================================
at="{{sk}}"
lssn="{{lssn}}"

# Get System Variables =========================================
did=`df -aT | grep '/' | awk '{print $1}'`
vn=`df -aT | grep '/' | awk '{print $7}'`
fs=`df -aT | grep '/' | awk '{print $2}'`
fr=`df -aT | grep '/' | awk '{print $5}'`
ds=`df -aT | grep '/' | awk '{print $3}'`
us=`df -aT | grep '/' | awk '{print $4}'`
fp=`df -aT | grep '/' | awk '{print $6}'`

# Send to API Server =========================================
qs="at=$at&lssn=$lssn&did=$did&ddesc=$vn&vn=$vn&fs=$fs&fr=$fr&ds=$ds&us=$us&fp=$fp"
wget "http://giip.littleworld.net/API/LSvrDiskStatInputLinux02.asp?$qs"

rm -f LSvrDiskStatInputLinux*
