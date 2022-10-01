MEMORY
{
    DMEM (rw ) : ORIGIN = 0x80000000, LENGTH = 1024
    IMEM (rwx) : ORIGIN = 0x00000000, LENGTH = 1024
}

_stack_size = 512;

SECTIONS
{
    .text :
    {
        . = ALIGN(4);
        _text_start = .;
        *(.text.entry)
        *(.text)
        *(.text*)
        . = ALIGN(4);
        _text_end = .;
    } > IMEM

    .srodata :
    {
        . = ALIGN(4);
        _srodata_start = .;
        *(.srodata)
        *(.srodata*)
        . = ALIGN(4);
        _srodata_end = .;
    } > IMEM

    .sdata :
    {
        . = ALIGN(4);
        _sdata_start = .;
        *(.sdata)
        *(.sdata*)
        . = ALIGN(4);
        _sdata_end = .;
    } > IMEM

    .bss :
    {
        . = ALIGN(4);
        _bss_start = .;
        *(.bss)
        *(.bss*)
        . = ALIGN(4);
        _bss_end = .;
    } > DMEM

    .stack :
    {
        . = ALIGN(4);
        _stack_start = .;
        . = . + _stack_size;
        . = ALIGN(4);
        _stack_end = .;
    } > DMEM
}
