MEMORY
{
    IMEM (rx) : ORIGIN = 0x00000000, LENGTH = 256
}

SECTIONS
{
    .text :
    {
        *(.text .text.*)
    } > IMEM
}
