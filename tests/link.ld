OUTPUT_ARCH( "riscv" )
ENTRY(_start)

SECTIONS
{
  . = 0x80000000;

  .text.init ALIGN(4): { 
    *(.text.init)
    . = ALIGN(4);
    _start = .;
  }

  .text ALIGN(4): {
    *(.text .text.* .snippy.text .snippy.text.*)
    . = ALIGN(4);
  }

  . = 0x20000000; 

  .rodata ALIGN(4): { 
    *(.rodata .rodata.*) 
    . = ALIGN(4);
  }

  .data ALIGN(4): {
    *(.data .data.* .snippy.data .snippy.data.*)
    . = ALIGN(4);
  }

  .sdata ALIGN(4): {
    *(.sdata .sdata.*)
    . = ALIGN(4);
  }

  .bss ALIGN(4): { 
    *(.bss .bss.*) 
    . = ALIGN(4);
  }

  .sbss ALIGN(4): {
    *(.sbss .sbss.*)
    . = ALIGN(4);
  }

  .data ALIGN(4): {
    *(.snippy.stack .snippy.stack.*)
    . = ALIGN(4);
  }
  . = ALIGN(4);
  _end = .;
  end = _end;
}
