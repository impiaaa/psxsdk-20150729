#!/bin/sh

# This shell script will generate the playstation.x linker script, and the psx-gcc and psx-elf2x shell scripts.

# You have to pass the PREFIX of the toolchain as the first argument of this shell script

echo "/* 
 * Linker script to generate an ELF file
 * that has to be converted to PS-X EXE.
 */

TARGET(\"elf32-littlemips\")
OUTPUT_ARCH(\"mips\")

ENTRY(\"_start\")

SEARCH_DIR(\"$1/lib\")
STARTUP(start.o)
INPUT(-lpsx -lgcc)

SECTIONS
{
	. = 0x80010000;

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
" > playstation.x

echo "/* 
 * Linker script to generate an ELF file
 * that has to be converted to PS-X EXE.
 */

TARGET(\"elf32-littlemips\")
OUTPUT_ARCH(\"mips\")

ENTRY(\"_start\")

SEARCH_DIR(\"$1/lib\")
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
" > psxsdkserial.x

echo "#!/bin/sh
mipsel-unknown-elf-gcc -D__PSXSDK__ -fno-strict-overflow -fsigned-char -msoft-float -mno-gpopt -fno-builtin -G0 -I$1/include -T $1/mipsel-unknown-elf/lib/ldscripts/playstation.x \$*"> psx-gcc
chmod +x psx-gcc

echo "#!/bin/sh
mipsel-unknown-elf-g++ -D__PSXSDK__ -fno-strict-overflow -fsigned-char -msoft-float -mno-gpopt -fno-builtin -G0 -I$1/include -T $1/mipsel-unknown-elf/lib/ldscripts/playstation.x -fno-rtti -fno-exceptions -fno-threadsafe-statics -fno-use-cxa-atexit \$*" > psx-g++
chmod +x psx-g++

echo "#!/bin/sh
mipsel-unknown-elf-gcc -D__PSXSDK__ -fno-strict-overflow -fsigned-char -msoft-float -mno-gpopt -fno-builtin -G0 -I$1/include -T $1/mipsel-unknown-elf/lib/ldscripts/psxsdkserial.x \$*"> psxsdkserial-gcc
chmod +x psxsdkserial-gcc
