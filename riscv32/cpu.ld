/* The bootloader will look at this image and start execution at the symbol
   designated as the entry point. */
ENTRY(_start)
/*OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
OUTPUT_ARCH(arm)
*/

SECTIONS
{
    . = 0;
    /* link the multiboot struct here */
    .text : { *(.text) }
    .rodata : { *(.rodata) }
    .data : { *(.data) }
    _start_bss = . ;
    .bss  : { *(.bss)  }
    _end_bss = ADDR(.bss) + SIZEOF(.bss) ;
    
    . = ALIGN(16);

    .stack : { *(.stack) }
    _end_kernel = .;
}
