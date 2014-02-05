serialnumber=""
for serial in $(sudo lsusb -v 2>/dev/null | grep -i serial | awk '{print $3}')
do
if [ "$(grep "${serial}" /tmp/multisystem/multisystem-selection-serial-usb)" ]; then
serialnumber="${serial}"
break
fi
done
echo "serialnumber:$serialnumber"
if [ "${serialnumber}" ]; then
sed -i "s%XXXXXXXXXXXXXXXX%${serialnumber}%" "$(cat /tmp/multisystem/multisystem-mountpoint-usb)/multisystem.bat"
fi

