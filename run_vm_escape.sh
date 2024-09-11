qemu-system-x86_64 -enable-kvm -m 2048 -display vnc=:89 \
        -netdev user,id=t0, -device rtl8139,netdev=t0,id=nic0 \
        -netdev user,id=t1, -device pcnet,netdev=t1,id=nic1 \
	-L ./qemu/pc-bios \
	-nographic \
	-append "console=ttyS0 nokaslr" \
	-initrd /qemu/tmp/tmp/newinitrd \
	-boot c -kernel ./bzImage
