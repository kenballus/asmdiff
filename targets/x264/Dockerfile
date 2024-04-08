FROM debian:trixie-slim

WORKDIR /app

RUN apt -y update && apt -y upgrade && apt -y install gcc-13 git nasm python3 gcc-13-aarch64-linux-gnu gcc-13-alpha-linux-gnu gcc-13-arc-linux-gnu gcc-13-arm-linux-gnueabi gcc-13-arm-linux-gnueabihf gcc-13-i686-linux-gnu gcc-13-hppa64-linux-gnu gcc-13-hppa-linux-gnu gcc-13-m68k-linux-gnu gcc-13-mips-linux-gnu gcc-13-mips64-linux-gnuabi64 gcc-13-mips64el-linux-gnuabi64 gcc-13-mipsel-linux-gnu gcc-13-mipsisa32r6-linux-gnu gcc-13-mipsisa32r6el-linux-gnu gcc-13-mipsisa64r6-linux-gnuabi64 gcc-13-mipsisa64r6el-linux-gnuabi64 gcc-13-powerpc-linux-gnu gcc-13-powerpc64-linux-gnu gcc-13-powerpc64le-linux-gnu gcc-13-riscv64-linux-gnu gcc-13-s390x-linux-gnu gcc-13-sh4-linux-gnu gcc-13-sparc64-linux-gnu binutils-aarch64-linux-gnu binutils-alpha-linux-gnu binutils-arc-linux-gnu binutils-arm-linux-gnueabi binutils-arm-linux-gnueabi binutils-hppa-linux-gnu binutils-hppa64-linux-gnu binutils-i686-gnu binutils-i686-linux-gnu binutils-ia64-linux-gnu binutils-loongarch64-linux-gnu binutils-m68k-linux-gnu binutils-mingw-w64 binutils-mips-linux-gnu binutils-mips64-linux-gnuabi64 binutils-mips64el-linux-gnuabi64 binutils-mips64el-linux-gnuabin32 binutils-mipsel-linux-gnu binutils-mipsisa32r6-linux-gnu binutils-mipsisa32r6el-linux-gnu binutils-mipsisa64r6-linux-gnuabi64 binutils-mipsisa64r6-linux-gnuabin32 binutils-mipsisa64r6el-linux-gnuabi64 binutils-mipsisa64r6el-linux-gnuabin32 binutils-powerpc-linux-gnu binutils-powerpc64-linux-gnu binutils-powerpc64le-linux-gnu binutils-riscv64-linux-gnu binutils-s390x-linux-gnu binutils-sh4-linux-gnu binutils-sparc64-linux-gnu binutils-x86-64-linux-gnu binutils-x86-64-linux-gnux32

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 100

RUN git clone 'git clone https://code.videolan.org/videolan/x264.git'

# nal_escape_c.c
RUN cat x264/common/bitstream.c | python3 -c 'import sys, re; inp = sys.stdin.buffer.read(); m = re.search(rb"uint8_t \*nal_escape_c\(.*\)(?:.*\n[^}])*.*\n}", inp); print("#include <stdint.h>"); print(); print(m[0].decode("latin1"))' > nal_escape_c.c

# bitstream_x86.o
RUN nasm -f elf64 -I./x64/common/x86 -DARCH_X86_64=1 -o bitstream_x86.o x264/common/x86/bitstream-a.asm

COPY harness.c .

# harness_x86_c
RUN x86_64-linux-gnu-gcc -Wno-implicit-function-declaration -Wno-int-conversion -static -Dnal_escape=nal_escape_c nal_escape_c.c harness.c -o harness_x86_c

# harness_x86_mmx2
RUN x86_64-linux-gnu-gcc -Wno-implicit-function-declaration -Wno-int-conversion -static -Dnal_escape=x264_nal_escape_mmx2 bitstream.o harness.c -o harness_x86_mmx2

# harness_x86_sse2
RUN x86_64-linux-gnu-gcc -Wno-implicit-function-declaration -Wno-int-conversion -static -Dnal_escape=x264_nal_escape_sse2 bitstream.o harness.c -o harness_x86_sse2

# harness_x86_avx2
RUN x86_64-linux-gnu-gcc -Wno-implicit-function-declaration -Wno-int-conversion -static -Dnal_escape=x264_nal_escape_avx2 bitstream.o harness.c -o harness_x86_avx2


