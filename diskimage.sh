#!/bin/sh

if [ $(dpkg-query -W -f='${Status}' sshfs 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  apt-get install sshfs;
fi

MOUNT=/mnt/Backup

mount -a
sshfs -o noatime,noexec,allow_other root@192.168.0.7:/mnt/HD/HD_a2/Backup/ $MOUNT
sleep 5

#pv -tpreb /dev/mmcblk0p2 | dd bs=1M | gzip -c > $MOUNT/rasprdc.img.gz
dd if=/dev/mmcblk0p2 bs=1M | gzip -c > $MOUNT/rasprdc.img.gz

fusermount -u $MOUNT
