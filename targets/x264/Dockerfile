FROM debian:trixie-slim

WORKDIR /app

RUN apt -y update && apt -y upgrade && apt -y install gcc git nasm python3 gcc-aarch64-linux-gnu gcc-alpha-linux-gnu gcc-arc-linux-gnu gcc-arm-linux-gnueabi gcc-arm-linux-gnueabihf gcc-i686-linux-gnu gcc-hppa64-linux-gnu gcc-hppa-linux-gnu gcc-m68k-linux-gnu gcc-mips-linux-gnu gcc-mips64-linux-gnuabi64 gcc-mips64el-linux-gnuabi64 gcc-mipsel-linux-gnu gcc-mipsisa32r6-linux-gnu gcc-mipsisa32r6el-linux-gnu gcc-mipsisa64r6-linux-gnuabi64 gcc-mipsisa64r6el-linux-gnuabi64 gcc-powerpc-linux-gnu gcc-powerpc64-linux-gnu gcc-powerpc64le-linux-gnu gcc-riscv64-linux-gnu gcc-s390x-linux-gnu gcc-sh4-linux-gnu gcc-sparc64-linux-gnu binutils-aarch64-linux-gnu binutils-alpha-linux-gnu binutils-arc-linux-gnu binutils-arm-linux-gnueabi binutils-arm-linux-gnueabi binutils-hppa-linux-gnu binutils-hppa64-linux-gnu binutils-i686-gnu binutils-i686-linux-gnu binutils-ia64-linux-gnu binutils-loongarch64-linux-gnu binutils-m68k-linux-gnu binutils-mingw-w64 binutils-mips-linux-gnu binutils-mips64-linux-gnuabi64 binutils-mips64el-linux-gnuabi64 binutils-mips64el-linux-gnuabin32 binutils-mipsel-linux-gnu binutils-mipsisa32r6-linux-gnu binutils-mipsisa32r6el-linux-gnu binutils-mipsisa64r6-linux-gnuabi64 binutils-mipsisa64r6-linux-gnuabin32 binutils-mipsisa64r6el-linux-gnuabi64 binutils-mipsisa64r6el-linux-gnuabin32 binutils-powerpc-linux-gnu binutils-powerpc64-linux-gnu binutils-powerpc64le-linux-gnu binutils-riscv64-linux-gnu binutils-s390x-linux-gnu binutils-sh4-linux-gnu binutils-sparc64-linux-gnu binutils-x86-64-linux-gnu binutils-x86-64-linux-gnux32

RUN git clone 'https://code.videolan.org/videolan/x264.git'

# nal_escape_c.c
RUN cat x264/common/bitstream.c | python3 -c 'import sys, re; inp = sys.stdin.buffer.read(); m = re.search(rb"uint8_t \*nal_escape_c\(.*\)(?:.*\n[^}])*.*\n}", inp); print("#include <stdint.h>"); print(); print(m[0].decode("latin1"))' > nal_escape_c.c

# bitstream_x86.o
RUN cd x264 && ./configure
RUN nasm -f elf64 -I./x264/common/x86 -DARCH_X86_64=1 -o bitstream_x86.o x264/common/x86/bitstream-a.asm

# bitstream_aarch64.o
RUN cd x264 && ./configure --host=aarch64-linux-gnu --cross-prefix=aarch64-linux-gnu-
RUN aarch64-linux-gnu-gcc -c x264/common/aarch64/bitstream-a.S -I./x264 -o bitstream_aarch64.o

# bitstream_arm.o
RUN cd x264 && ./configure --host=arm-linux-gnueabi --cross-prefix=arm-linux-gnueabi-
RUN arm-linux-gnueabi-gcc -c x264/common/arm/bitstream-a.S -I./x264 -o bitstream_arm.o

COPY harness.c .
RUN mkdir harnesses
# harness_x86_c
RUN x86_64-linux-gnu-gcc -Wno-implicit-function-declaration -Wno-int-conversion -static -Dnal_escape=nal_escape_c nal_escape_c.c harness.c -o ./harnesses/harness_x86_c

# harness_x86_mmx2
RUN x86_64-linux-gnu-gcc -Wno-implicit-function-declaration -Wno-int-conversion -static -Dnal_escape=x264_nal_escape_mmx2 bitstream_x86.o harness.c -o ./harnesses/harness_x86_mmx2

# harness_x86_sse2
RUN x86_64-linux-gnu-gcc -Wno-implicit-function-declaration -Wno-int-conversion -static -Dnal_escape=x264_nal_escape_sse2 bitstream_x86.o harness.c -o ./harnesses/harness_x86_sse2

# harness_x86_avx2
RUN x86_64-linux-gnu-gcc -Wno-implicit-function-declaration -Wno-int-conversion -static -Dnal_escape=x264_nal_escape_avx2 bitstream_x86.o harness.c -o ./harnesses/harness_x86_avx2

# harness_aarch64_c
RUN aarch64-linux-gnu-gcc -Wno-implicit-function-declaration -Wno-int-conversion -static -Dnal_escape=nal_escape_c nal_escape_c.c harness.c -o ./harnesses/harness_aarch64_c

# harness_aarch64_neon
RUN aarch64-linux-gnu-gcc -Wno-implicit-function-declaration -Wno-int-conversion -static -Dnal_escape=x264_nal_escape_neon bitstream_aarch64.o harness.c -o ./harnesses/harness_aarch64_neon

# harness_ppc64_c
RUN powerpc64-linux-gnu-gcc -Wno-implicit-function-declaration -Wno-int-conversion -static -Dnal_escape=nal_escape_c nal_escape_c.c harness.c -o ./harnesses/harness_ppc64_c

# harness_mips64_c
RUN mips64-linux-gnuabi64-gcc -Wno-implicit-function-declaration -Wno-int-conversion -static -Dnal_escape=nal_escape_c nal_escape_c.c harness.c -o ./harnesses/harness_mips64_c

# harness_arm_c
RUN arm-linux-gnueabi-gcc -Wno-implicit-function-declaration -Wno-int-conversion -static -Dnal_escape=nal_escape_c nal_escape_c.c harness.c -o ./harnesses/harness_arm_c

# harness_arm_neon
RUN arm-linux-gnueabi-gcc -Wno-implicit-function-declaration -Wno-int-conversion -static -Dnal_escape=x264_nal_escape_neon bitstream_arm.o harness.c -o ./harnesses/harness_arm_neon
