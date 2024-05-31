.syntax unified
.thumb

.section .data
.global rs
rs:     .word 0xffff, 0xff00ff, 0xf0f0f0f, 0x33333333


.global qarmav2_bitslicing
.type qarmav2_bitslicing, %function


.macro PPO, dest_r, src_r, r3, rotate_amount, mask_value
    MOV \r3, \src_r, ROR#\rotate_amount
    AND \r3, \r3, #\mask_value
    ORR \dest_r, \dest_r, \r3
.endm

/**
 * Macro: PPO_TUA
 * the tua = [0, 11, 6, 13, 10, 1, 12, 7, 5, 14, 3, 8, 15, 4, 9, 2] permutaion on the PPO.
 *
 * Parameters:
 * dest_r - The destination register. The results of the operations are stored in this register.
 * src_r - The source register. This register is used as one of the operands for the operations.
 * temp_r - A temporary register used for intermediate computations.
 *
 */
.macro PPO_TUA dest_r, src_r, temp_r
    MOV \dest_r, #0x0
    AND \dest_r, \src_r, #0xc00030000
    PPO \dest_r, \src_r, \temp_r, 12, 0x33000000
    PPO \dest_r, \src_r, \temp_r, 24, 0xc000000
    PPO \dest_r, \src_r, \temp_r, 20, 0xcc0000
    PPO \dest_r, \src_r, \temp_r, 8, 0x300000
    PPO \dest_r, \src_r, \temp_r, 6, 0xc300
    PPO \dest_r, \src_r, \temp_r, 22, 0x3000
    PPO \dest_r, \src_r, \temp_r, 14, 0xc00
    PPO \dest_r, \src_r, \temp_r, 26, 0xc3
    PPO \dest_r, \src_r, \temp_r, 18, 0x30
    PPO \dest_r, \src_r, \temp_r, 10, 0xc
.endm

.macro PERMUTATION_TUA base_r, t1, t2, t3
    LDR \t2, [\base_r] // Load the first item of rs into r1
    PPO_TUA \t1, \t2, \t3
    STR \t1, [\base_r] // Store the value of r1 back into the first item of rs

    LDR \t2, [\base_r, #4] // Load the second item of rs into r1
    PPO_TUA \t1, \t2, \t3
    STR \t1, [\base_r, #4] // Store the value of r1 back into the second item of rs

    LDR \t2, [\base_r, #8] // Load the third item of rs into r1
    PPO_TUA \t1, \t2, \t3
    STR \t1, [\base_r, #8] // Store the value of r1 back into the third item of rs

    LDR \t2, [\base_r, #12] // Load the fourth item of rs into r1
    PPO_TUA \t1, \t2, \t3
    STR \t1, [\base_r, #12] // Store the value of r1 back into the fourth item of rs
.endm

.text
qarmav2_bitslicing:
    PUSH {r0-r12, r14}
    LDR r0, =rs // Load the address of rs into r0
    // permutation rs
    PERMUTATION_TUA r0, r1, r2, r3
   
    @ STR r1, [r0, #4]// Store the value of r1 back into the first item of rs
    POP {r0-r12, r14}
    BX lr
