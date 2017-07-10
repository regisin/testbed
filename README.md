# testbed

## Shrink .img files

Source https://softwarebakery.com/shrinking-images-on-linux

First we will enable loopback if it wasn't already enabled:

sudo modprobe loop

Now we can request a new (free) loopback device:

$ sudo losetup -f

This will return the path to a free loopback device. In this example this is /dev/loop0.

Next we create a device of the image:

$ sudo losetup /dev/loop0 myimage.img
Now we have a device /dev/loop0 that represents myimage.img. We want to access the partitions that are on the image, so we need to ask the kernel to load those too:

$ sudo partprobe /dev/loop0
