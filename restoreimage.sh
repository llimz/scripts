#!/bin/bash

while test $# -gt 0; do
        case "$1" in
                -h|--help)
			echo 'usage restoreimage.sh +image_file_name_without_extension'
                        exit 0
                        ;;
                -m)
                        shift
                        if test $# -gt 0; then
                                export MOUNT=$1
                        else
                                echo "no mount dir specified"
                                exit 1
                        fi
                        shift
                        ;;
                --mount*)
                        export MOUNT=`echo $1 | sed -e 's/^[^=]*=//g'`
                        shift
                        ;;
                *)
			export NAME=$1
                        break
                        ;;
        esac
done

if [ $(dpkg-query -W -f='${Status}' sshfs 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  apt-get install sshfs;
fi

echo 'Restore image name '$NAME

#mount the backup folder
mount -a
sshfs -o noatime,noexec,allow_other root@192.168.0.7:/mnt/HD/HD_a2/Backup/ $MOUNT
#if [ $? -ne 0 ]; then exit $?; fi 
sleep 5

#make the diskimage
gunzip -c $MOUNT/$NAME.img.gz | dd of=/dev/sda2 bs=1M
#dd if=/dev/mmcblk0p2 bs=1M | gzip -c > $MOUNT/$NAME.img.gz
sleep 10

#unmount the backup folder
#fusermount -u $MOUNT
