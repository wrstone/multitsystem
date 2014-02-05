#! /bin/sh
chemindistro="zzzz"
deviceuuid="zzzz"
update-dev
devices="$(list-devices partition)"
for device in $devices; do
if [ "$(/lib/udev/vol_id -u $device)" = "$deviceuuid" ]; then
#Doubler demonter /cdrom a cause du bind
umount /cdrom/$chemindistro 2>/dev/null || true
umount /cdrom 2>/dev/null || true
rm /dev/cdrom 2>/dev/null || true
sleep 1
mount -t vfat -o ro,exec $device /cdrom 2>/dev/null || true
sleep 1
mount --bind /cdrom/$chemindistro /cdrom 2>/dev/null || true
sleep 1
ln -sf $device /dev/cdrom 2>/dev/null || true
log "CD-ROM mount succeeded: device=$device"
mounted=1
db_set cdrom-detect/cdrom_device $device
break
fi
done















