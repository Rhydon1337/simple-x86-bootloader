OUTPUT_FORMAT("elf32-i386");
ENTRY(start);
SECTIONS
{
    . = 0x00007E00;
    .text :  ALIGN(4) {
        /* Place the code in second_stage.o before all other code */
        second_stage.o(.text);
	. = ALIGN(4);        
	*(.text);
    }

    /* Place the data after the code */
    .data :  ALIGN(4) {
        *(.data);
        *(.rodata*);
    }

    .bss :   ALIGN(4) {
        __bss_start = .;
        *(COMMON);
        *(.bss)
        . = ALIGN(4);
        __bss_end = .;
    }
    __bss_sizeb = SIZEOF(.bss);

    /* Remove sections that won't be relevant to us */
    /DISCARD/ : {
        *(.eh_frame);
        *(.comment);
    }
}

