#!/bin/bash
# Mounts NAS filesystem when correct Wifi network is detected
# Copy to /etc/NetworkManager/dispatcher.d
# This script should be owned by root:root and be executable, and cannot be a symlink
# Use something like this in /etc/fstab:
# //nas.local/rootlink/volume1	/mnt/nas	cifs	noauto,user=*,password=*,uid=*,gid=users,soft,file_mode=0640,dir_mode=0750	0	0

LOGFILE="/var/log/nm-mount.log"

IF=${1}
COMMAND=${2}
HOSTNAME_TO_DETECT=nas.local
MOUNTPOINT=/mnt/nas

export DISPLAY=:0.0
export SU_USER=$(who |grep tty7|awk '{print $1}')

# echo "$(date) $IF $COMMAND" >> $LOGFILE

if [ "$COMMAND" == "up" ]; then
  NAS_IP=`avahi-resolve-host-name $HOSTNAME_TO_DETECT 2>&1`
  if [[ "$NAS_IP" =~ 192.168|fe80:: ]]; then
    echo "$@ $(date) Mounting /mnt/nas..." >> $LOGFILE
    mount $MOUNTPOINT >> $LOGFILE 2>&1
  fi
fi

if [ "$COMMAND" == "down" ]; then
  if mount | fgrep $MOUNTPOINT; then
    echo "$@ $(date) Unmounting $MOUNTPOINT..." >> $LOGFILE
    umount -f $MOUNTPOINT >> $LOGFILE 2>&1
  fi
fi
