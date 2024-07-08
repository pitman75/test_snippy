# RISC-V ISA fuzzing simple project

When designing your implementation of the RISC-V ISA, it is essential to perform testing using fuzzing methods. This is necessary because errors can occur where one instruction or a combination of data can affect the subsequent instructions, leading to incorrect operation. In this small project, the [LLVM-snippy](https://github.com/syntacore/snippy) tool from [Syntacore](https://syntacore.com/) is used to generate sequences of random instructions. Thanks a lot for this amazing ISA generator!

The tests are located in the tests directory. Currently, four tests are defined:

 - Linear execution of random instructions
 - Random instructions with loops and branches
 - Random instructions with burst memory load
 - Random instructions with burst memory store

Configuration of sources:
```
 - Flash for program, start address : 0x80000000
 - Flash for program, size          : 0x100000
 - RAM for data, start address      : 0x20000000
 - RAM for data, size               : 0x8000
 - Output byte stream, address      : 0x20100000
```

# Usage

The project provide only phases 3...5

1. Build and install spike emulator
2. Configure path to spike in the *Makefile*
3. Prepare docker image for fuzzing generator by command `make docker`
4. Build and execute random test programs in spike with trace by command `make test`
5. Files *_ram_init.mem and *_rom_init.mem are ready
6. Load and execite prepared *.mem by RISC-V core in simulator, add to testbench trace generation
7. Compare two traces

Enjoy!
