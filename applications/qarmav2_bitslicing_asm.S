.syntax unified
.thumb

.section .data
.global rs
rs:     .word 0xffff, 0xff00ff, 0xf0f0f0f, 0x33333333
shift:  .byte 0, 12, 24, 12, 20, 8, 20, 0, 6, 22, 14, 6, 26, 18, 10, 26
mask:   .word 0xc0000000, 0x30000000, 0xc000000, 0x3000000, 0xc00000, 0x300000, 0xc0000, 0x30000, 0xc000, 0x3000, 0xc00, 0x300, 0xc0, 0x30, 0xc, 0x3

.global qarmav2_bitslicing
.type qarmav2_bitslicing, %function

@ Define a macro named PPO, which stands for Permutation Primitive Operation.
@ This macro performs a series of operations on the input and output registers, using a temporary register.

@ Arguments:
@ dest_r: The output register. The result of the operations will be stored in this register.
@ src_r: The input register. The operations will be performed on the value in this register.
@ r3: A temporary register used for intermediate calculations.
@ rotate_amount: The number of bits to rotate the value in src_r to the right.
@ mask_value: A value that will be used to mask the result of the rotation.
.macro PPO, dest_r, src_r, r3, rotate_amount, mask_value
    MOV \r3, \src_r, ROR#\rotate_amount
    AND \r3, \r3, #\mask_value
    ORR \dest_r, \dest_r, \r3
.endm

.text
qarmav2_bitslicing:
    PUSH {r0-r12, r14}
    LDR r0, =rs // Load the address of rs into r0
    // permutation r0
    MOV r1, #0x0
    LDR r2, [r0]// Load the first item of rs into r1

    PPO r1, r2, r3, 0, 0xc00030000 @ (0, [0, 7])
    PPO r1, r2, r3, 12, 0x33000000 @ (6, [1, 3])
    PPO r1, r2, r3, 24, 0xc000000
    PPO r1, r2, r3, 20, 0xcc0000 @ (10, [4, 6])
    PPO r1, r2, r3, 8, 0x300000
    PPO r1, r2, r3, 6, 0xc300 @ (3, [8, 11])
    PPO r1, r2, r3, 22, 0x3000
    PPO r1, r2, r3, 14, 0xc00
    PPO r1, r2, r3, 26, 0xc3 @ (13, [12, 15])
    PPO r1, r2, r3, 18, 0x30
    PPO r1, r2, r3, 10, 0xc

    // out r1 to r0
    STR r1, [r0]// Store the value of r1 back into the first item of rs
    @ STR r1, [r0, #4]// Store the value of r1 back into the first item of rs
    POP {r0-r12, r14}
    BX lr
