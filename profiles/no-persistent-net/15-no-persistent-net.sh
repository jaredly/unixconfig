#!/bin/bash
# Get rid of annoying persistent-net and biosdevname stuff that makes hell
# break loose if you switch ethernet cards between boots (at the cost of
# some minor inconvenience for machines with two ethernet cards).

rm -f /etc/udev/rules.d/*persistent-net*

# Mask the persistent net generator rule.
ln -s /dev/null /etc/udev/rules.d/75-persistent-net-generator.rules

# Note that ifcfg-eth0.old gets in the way.
rm -f /etc/sysconfig/network-scripts/ifcfg-*.old

# Get rid of biosdevname-based net config files that might have slipped in.
rm -f /etc/sysconfig/network-scripts/ifcfg-em*
rm -f /etc/sysconfig/network-scripts/ifcfg-p*

# Remove any HWADDR lines in ifcfg-*
sed -i '/^HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-*

#Fix the cmdline
sed -e '/+=.*biosdevname/d' /etc/default/grub
echo "GRUB_CMDLINE_LINUX+=\"biosdevname=0\"" >> /etc/default/grub

