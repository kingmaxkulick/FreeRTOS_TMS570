MEMORY {
    /* TMS570LS12xx Specific Memory Map */
    FLASH0 (RX) : ORIGIN = 0x00000000, LENGTH = 0x00100000  /* 1MB Flash */
    RAM0   (RWX): ORIGIN = 0x08000000, LENGTH = 0x00040000  /* 256KB RAM */
}

SECTIONS {
    .intvecs : {} > FLASH0
    .text    : {} > FLASH0
    .const   : {} > FLASH0
    .cinit   : {} > FLASH0
    .pinit   : {} > FLASH0
    .data    : {} > RAM0
    .bss     : {} > RAM0
    .sysmem  : {} > RAM0
    .stack   : {} > RAM0 (HIGH)
}

/* Entry Point */
--entry_point=_c_int00