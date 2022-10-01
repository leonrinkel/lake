FROM mcr.microsoft.com/vscode/devcontainers/base:bullseye

ARG VERSION=v4.226

RUN \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        git perl python3 make autoconf g++ flex bison ccache \
        libgoogle-perftools-dev numactl perl-doc libfl2 libfl-dev zlib1g \
        zlib1g-dev gdb cmake gcc-riscv64-unknown-elf && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

RUN \
    git clone https://github.com/verilator/verilator && \
    ( \
        cd verilator && \
        git checkout ${VERSION} && \
        autoconf && \
        ./configure && \
        make -j `nproc` && \
        make install \
    ) && \
    rm -rf verilator

ENTRYPOINT [ "verilator" ]
