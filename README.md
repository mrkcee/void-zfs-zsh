# void-zfs-zsh
Set of z shell (ZSH) scripts that I use to help me setup and install Void Linux in a ZFS filesystem. The configuration is very specific to my use case.

These 00 and 01 scripts were based on [eoli3n's void config scripts](https://github.com/eoli3n/void-config).

These require a Void Linux installation disk with the following packages:
 - zsh
 - zfs
 - parted
 - gptfdisk
 - openresolv
 - efibootmgr
 - git

## Numbering
00 - Preparation of disks and partitions, creation of zpools and datasets

01 - Installation of Void Linux and setup of ZFSBootMenu

02 - Installing preferred Void Linux package repository mirror

03/04 - Post-install system packages

05 - Extra packages and configurations

06 - Gaming-related packges

99 - Small utility scripts that are used for recovery and maintenance
