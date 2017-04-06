# How to Classroom in a Box

### Copy files from the CentOS iso after mounting it.

1. Insert a USB key and erase with Disk Utility with the following settings  
    * Name: CIAB
    * Format: MS-DOS
    * Scheme: GUID Partition Map
1. Download the latest "Everything" iso from  
     [centos.org](https://www.centos.org/download/)
1. Attach the CD but don't mount  
    `hdiutil attach -nomount Centos-7.iso`
1. Make a directory to mount the CD  
    `mkdir files`
1. Mount the partition returned by hdiutil to the new directory  
    `mount_cd9660 /dev/disk3 files`
1. Copy all of the files from ./files to the USB drive:  
    `cp -R ./files/* /Volumes/CIAB`

### Copy files from this directory.

1. clone this directory somewhere:  
    `git clone git@github.com:puppetlabs/education-builds.git`
1. cd to the `classroom_in_a_box` directory  
    `cd education_builds/classroom_in_a_box`
1. Copy the `ks` folder to the USB drive:  
    `cp -R ./ks /Volumes/CIAB`
1. Copy the grub.cfg to the USB drive:  
    `cp EFI/BOOT/grub.cfg /Volumes/CIAB/EFI/BOOT/grub.cfg`
1. Eject the disk and use it to boot the NUC.
