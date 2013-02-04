# Base Kickstart Script for WIPING THE HARD DISK

#System language
lang en_US.UTF-8

#System keyboard
keyboard us

#Use HTTP installation media
url --url http://mirrors/releases/18/Fedora/i386/os

#---------------------------------------------------------#
# PRE-INSTALLATION
#---------------------------------------------------------#
%pre --erroronfail
logger Starting preinstall script
echo Starting preinstall script >/dev/tty1

echo "started" >/tmp/wipedisk.log
logger Wiping hard disk

echo >/dev/tty1
echo "Wiping the hard disk (/dev/sda)" >/dev/tty1
echo "Please wait..." >/dev/tty1

dd if=/dev/zero of=/dev/sda bs=64k oflag=direct,dsync >/dev/tty1 2>/dev/tty1

echo "done" >/tmp/wipedisk.log
logger Done wiping hard disk

echo >/dev/tty1
echo Done wiping the hard disk. >/dev/tty1
echo You may now turn off the computer. >/dev/tty1

while true; do
    sleep 60
done
%end
