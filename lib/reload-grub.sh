#!/bin/bash

# Note: this needs to get run after symlinks are made.
grub2-mkconfig -o /boot/grub2/grub.cfg
