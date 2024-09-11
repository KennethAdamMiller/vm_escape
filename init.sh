#mkinitramfs, extract ramdisk.img
mkinitramfs -o ramdisk.img
unmkinitramfs ramdisk.img ./extracted

#build everything
docker build . -t vm_escape

#run docker run_vm_escape
docker run --device=/dev/kvm -ti vm_escape ./run_vm_escape.sh
