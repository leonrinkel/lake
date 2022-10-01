.global _start

    .section .text.entry
_start:
    la sp, _stack_end

    la t0, _bss_start
    la t1, _bss_end
.bss_loop:
    beq t0, t1, .bss_loop_end
    sw x0, (t0)
    addi t0, t0, 4
    j .bss_loop
.bss_loop_end:

    jal main

.loop:
    j .loop
