X86_CC := x86_64-linux-gnu-gcc
X86_AS := nasm
X86_ASFLAGS := -Irepo/common/x86/ -DARCH_X86_64=1 -f elf64

.PHONY: clean all

all: harness_x86_c harness_x86_mmx2 harness_x86_sse2 harness_x86_avx2


repo:
	git clone https://code.videolan.org/videolan/x264.git
	mv x264 repo

bitstream.o: repo
	$(X86_AS) $(X86_ASFLAGS) -o $@ repo/common/x86/bitstream-a.asm

harness_x86_sse2: harness.c bitstream.o
	$(X86_CC) -static -Dnal_escape=x264_nal_escape_sse2 $^ -o $@

harness_x86_avx2: harness.c bitstream.o
	$(X86_CC) -static -Dnal_escape=x264_nal_escape_avx2 $^ -o $@

harness_x86_mmx2: harness.c bitstream.o
	$(X86_CC) -static -Dnal_escape=x264_nal_escape_mmx2 $^ -o $@

harness_x86_c: harness.c nal_escape_c.c
	$(X86_CC) -static -Dnal_escape=nal_escape_c $^ -o $@

# Extract the C implementation of nal_escape
nal_escape_c.c: repo
	cat repo/common/bitstream.c | python3 -c 'import sys, re; inp = sys.stdin.buffer.read(); m = re.search(rb"uint8_t \*nal_escape_c\(.*\)(?:.*\n[^}])*.*\n}", inp); print("#include <stdint.h>"); print(); print(m[0].decode("latin1"))' > $@

clean:
	rm -f *.o harness_x86_c harness_x86_avx2 harness_x86_mmx2 harness_x86_sse2 nal_escape_c.c

distclean: clean
	rm -rf repo
