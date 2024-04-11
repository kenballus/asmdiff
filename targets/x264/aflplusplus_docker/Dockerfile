FROM debian:trixie-slim

WORKDIR /app

RUN apt -y update && apt -y upgrade && apt -y install curl make lld-17 clang-17 git ninja-build pkg-config libglib2.0-dev python3-setuptools gcc-13 g++-13 gcc-13-plugin-dev

RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-17 100 \
 && update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-17 100 \
 && update-alternatives --install /usr/bin/ld.lld ld.lld /usr/bin/ld.lld-17 100 \
 && update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-17 100 \
 && update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100 \
 && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 100 \
 && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-13 100

ARG AFL_VERSION=4.10c
RUN curl -L "https://github.com/AFLplusplus/AFLplusplus/archive/refs/tags/v$AFL_VERSION.tar.gz" > afl.tgz && tar xf afl.tgz && rm afl.tgz
RUN mv "AFLplusplus-$AFL_VERSION" AFLplusplus && cd AFLplusplus && make -j$(nproc)

ARG CPU_TARGET
RUN cd AFLplusplus/qemu_mode && ./build_qemu_support.sh

RUN cd AFLplusplus && make install

ARG TARGET
COPY $TARGET . 

CMD sleep infinity