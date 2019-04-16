/* 
 * Linker script to generate an ELF file
 * that has to be converted to PS-X EXE.
 */

TARGET("elf32-littlemips")
OUTPUT_ARCH("mips")

ENTRY("_start")

SEARCH_DIR("/usr/local/psxsdk/lib")
STARTUP(start.o)
INPUT(-lpsx -lgcc)

SECTIONS
{
    /* placing my named section at given address: */

    . = 0x80010000;

    __exeData_start = .;
	.exeData : { KEEP(*(.exeData*)) }
	__exeData_end = .;
 
	. = 0x801A0000;

	__text_start = .;
	.text : { *(.text*) }
	__text_end = .;

	__rodata_start = .;
	.rodata : { *(.rodata) }
	__rodata_end = .;

	__data_start = .;
	.data : { *(.data) }
	__data_end = .;
	
	__ctor_list = .;
	.ctors : { *(.ctors) }
	__ctor_end = .;
	
	__dtor_list = .;
	.dtors : { *(.dtors) }
	__dtor_end = .;

	__bss_start = .;
	.bss : { *(.bss) }
	__bss_end = .;

	__scratchpad = 0x1f800000;
}

