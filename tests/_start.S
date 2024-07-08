.section .bss
.global stack
.align 4
stack:
    .skip 1024

.section .text
.global _start
_start:
    # Save and set trap handler address
    la x1, _trap_handler
    csrrw x31, mtvec, x1
    # Init stack pointer
    la sp, stack + 1024
    li gp, 0x20000000
    li ra, 0x80000000
    add tp, x0, x0
    add t0, x0, x0
    add t1, x0, x0
    add t2, x0, x0
    add s0, x0, x0
    add s1, x0, x0
    add a0, x0, x0
    add a1, x0, x0
    add a2, x0, x0
    add a3, x0, x0
    add a4, x0, x0
    add a5, x0, x0
    add a6, x0, x0
    add a7, x0, x0
    add s2, x0, x0
    add s3, x0, x0
    add s4, x0, x0
    add s5, x0, x0
    add s6, x0, x0
    add s7, x0, x0
    add s8, x0, x0
    add s9, x0, x0
    add s10, x0, x0
    add s11, x0, x0
    add t3, x0, x0
    add t4, x0, x0
    add t5, x0, x0
    add t6, x0, x0
    call SnippyFunction
_test_fini:
    j _test_fini

    # force alignment
    .balign 64
    # Exception handler
_trap_handler:
    # increment return address
    csrr    x30, mepc
    addi    x30, x30, 4
    csrw    mepc, x30

    # Store MCAUSE
    csrr    x30, mcause
    #sw      x30, 0(x1)

    # return
    #mret
_trap_exit:
    j _trap_exit

