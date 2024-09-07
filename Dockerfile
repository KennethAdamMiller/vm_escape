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
RUN cd bin/debug/native && make

