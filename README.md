# testbed

## Shrink .img files

Source https://softwarebakery.com/shrinking-images-on-linux

First we will enable loopback if it wasn't already enabled:

  sudo modprobe loop

Now we can request a new (free) loopback device:

  sudo losetup -f

This will return the path to a free loopback device. In this example this is /dev/loop0.

Next we create a device of the image:

  sudo losetup /dev/loop0 myimage.img

Now we have a device /dev/loop0 that represents myimage.img. We want to access the partitions that are on the image, so we need to ask the kernel to load those too:

  sudo partprobe /dev/loop0

Now we resize using gparted (if needed, install it first: sudo apt-get install -y gparted)

  sudo gparted /dev/loop0

1) Select the partition to shrink
2) Click Resize/Move
3) In the new window, drag the arrow to the desired place, the shaded yellow is the used part, you shouldn't go lower than that.
4) Click the Resize/Move button and wait, it may take some time
5) Apply changes (the check button at the top toolbar)
6) Close gparted

  sudo losetup -d /dev/loop0
  
  fdisk -l myimage.img
  
Sample outpuut:

  Disk /home/pregis/ns3test.img: 29.8 GiB, 32010928128 bytes, 62521344 sectors
  Units: sectors of 1 * 512 = 512 bytes
  Sector size (logical/physical): 512 bytes / 512 bytes
  I/O size (minimum/optimal): 512 bytes / 512 bytes
  Disklabel type: dos
  Disk identifier: 0xd565adf9
  
  Device                    Boot Start     End Sectors  Size Id Type
  /home/pregis/ns3test.img1       8192   92159   83968   41M  c W95 FAT32 (LBA)
  /home/pregis/ns3test.img2      92160 7733247 7641088  3.7G 83 Linux

We see 2 partitions there, use the highest 'End' number, and unit size (7733247 and 512 in the example) in the following step:

  truncate --size=$[(7733247+1)*512] myimage.img
