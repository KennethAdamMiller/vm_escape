FROM ubuntu:18.04
RUN apt-get update && apt-get install git -y
RUN git clone https://github.com/qemu/qemu.git
WORKDIR qemu
RUN git checkout bd80b59 
RUN DEBIAN_FRONTEND=noninteractive apt-get install python gcc bison flex make libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev ninja-build -y 
RUN mkdir -p bin/debug/native && \
	cd bin/debug/native && \
	../../../configure --target-list=x86_64-softmmu --enable-debug \
        --disable-werror
RUN cd bin/debug/native && make && make install
RUN DEBIAN_FRONTEND=noninteractive apt-get install cpio initramfs-tools-core -y
# (mkinitramfs -o initrd || true) && \
RUN mkdir -p /qemu/tmp/tmp/extracted/ 
COPY extracted /qemu/tmp/tmp/extracted
#unmkinitramfs initrd ./extracted  &&  \
RUN cd /qemu/tmp/tmp    && \
    cd extracted   && \
    cd early  &&  \
    find . -print0 | cpio --null --create --format=newc > /qemu/tmp/tmp/newinitrd   && \
    cd ../early2   && \
    find kernel -print0 | cpio --null --create --format=newc >> /qemu/tmp/tmp/newinitrd

COPY run_vm_escape.sh ./
RUN apt-get install wget -y
RUN wget https://storage.googleapis.com/kvmctf/latest.tar.gz
RUN tar xzf latest.tar.gz
RUN cp kvmctf-6.1.74/bzImage/bzImage ./ && mkdir /vm-escape
COPY ./vm-escape.c ./Makefile /vm-escape
RUN make -C /vm-escape/ && cp /vm-escape/vm-escape /qemu/tmp/tmp/extracted/main/bin
RUN cd /qemu/tmp/tmp/extracted/main   && \
    find . | cpio --create --format=newc | xz --format=lzma >> /qemu/tmp/tmp/newinitrd

