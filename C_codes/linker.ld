MEMORY
{
    RAM    (rwx) : ORIGIN = 0x00000000, LENGTH = 1024
    TEXT   (rx)  : ORIGIN = 0x00000400, LENGTH = 8188
    RODATA (r)   : ORIGIN = 0x000023FC, LENGTH = 1024
    BSS    (rw)  : ORIGIN = 0x000027FC, LENGTH = 1024
    DATA   (rw)  : ORIGIN = 0x00002BFC, LENGTH = 1024
    MMIO   (rw)  : ORIGIN = 0x00002FFC, LENGTH = 4096
}

ENTRY(main)

SECTIONS
{
    .text :
    {
        . = ALIGN(4);
        *(.text)
        *(.text.*)
    } > TEXT

    .rodata :
    {
        . = ALIGN(4);
        *(.rodata)
        *(.rodata.*)
    } > RODATA

    .bss :
    {
        . = ALIGN(4);
        *(.bss)
        *(.bss.*)
        *(COMMON)
    } > BSS

    .data :
    {
        . = ALIGN(4);
        *(.data)
        *(.data.*)
    } > DATA

    /DISCARD/ :
    {
        *(.comment)
        *(.note*)
        *(.eh_frame)
        *(.riscv.attributes)
    }
}