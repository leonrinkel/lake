#!/bin/bash

set -e

riscv64-unknown-elf-gcc \
    -mabi=ilp32 \
    -march=rv32i \
    -nostdlib \
    -ffreestanding \
    -Tlink.ld \
    -o prog.elf \
    prog.c

riscv64-unknown-elf-objcopy \
    -O verilog \
    -S prog.elf \
    prog.v
