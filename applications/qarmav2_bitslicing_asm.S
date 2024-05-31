.syntax unified
.thumb

.global ts
.global rs
.section .data
rs: .word 0xffff, 0xff00ff, 0xf0f0f0f, 0x33333333
.align 4
ts: .space 20*4

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
    LDR \t2, [\base_r]// Load the first item of rs into r1
    PPO_TUA \t1, \t2, \t3
    STR \t1, [\base_r]// Store the value of r1 back into the first item of rs

    LDR \t2, [\base_r, #4]// Load the second item of rs into r1
    PPO_TUA \t1, \t2, \t3
    STR \t1, [\base_r, #4]// Store the value of r1 back into the second item of rs

    LDR \t2, [\base_r, #8]// Load the third item of rs into r1
    PPO_TUA \t1, \t2, \t3
    STR \t1, [\base_r, #8]// Store the value of r1 back into the third item of rs

    LDR \t2, [\base_r, #12]// Load the fourth item of rs into r1
    PPO_TUA \t1, \t2, \t3
    STR \t1, [\base_r, #12]// Store the value of r1 back into the fourth item of rs
.endm

.macro DIFFUSION_MATRIX base_r, r1, r2, r3, r4, r5, r6, r7, r8, r9
    LDR \r1, [\base_r]
    LDR \r2, [\base_r, #4]
    LDR \r3, [\base_r, #8]
    LDR \r4, [\base_r, #12]
    MOV \r5, \r2, ROR#24
    EOR \r5, \r5, \r3, ROR#16
    EOR \r5, \r5, \r4, ROR#8
    MOV \r6, \r3, ROR#24
    EOR \r6, \r6, \r4, ROR#16
    EOR \r6, \r6, \r1, ROR#8
    MOV \r7, \r4, ROR#24
    EOR \r7, \r7, \r1, ROR#16
    EOR \r7, \r7, \r2, ROR#8
    MOV \r8, \r1, ROR#24
    EOR \r8, \r8, \r2, ROR#16
    EOR \r8, \r8, \r3, ROR#8
    STR \r5, [\base_r]
    STR \r6, [\base_r, #4]
    STR \r7, [\base_r, #8]
    STR \r8, [\base_r, #12]
.endm

@ the r11 is the pointer to the rs, r12 is the pointer to the ts
.macro SBOX r11, r12, r0, r1, r2, r3, r4, r5
    LDR \r0, [\r11]
    LDR \r1, [\r11, #4]
    LDR \r2, [\r11, #8]
    LDR \r3, [\r11, #12]
    @ T[0] = R2 ^ R3
    EOR \r4, \r2, \r3
    STR \r4, [\r12]
    @ T[1] = T[0] ^ 0xFFFF_FFFF
    MVN \r4, \r4
    STR \r4, [\r12, #4]
    @ T[2] = T[1] | R0
    ORRS \r4, \r4, \r0
    STR \r4, [\r12, #8]
    @ T[3] = T[2] ^ R3
    EOR \r4, \r4, \r3
    STR \r4, [\r12, #12]
    @ T[4] = T[3] | R1
    ORRS \r4, \r4, \r1
    STR \r4, [\r12, #16]
    @ T[5] = R0 ^ T[4]
    EOR \r4, \r0, \r4
    STR \r4, [\r12, #20]
    @ T[6] = R1 ^ T[0]
    LDR \r4, [\r12]
    EOR \r4, \r1, \r4
    STR \r4, [\r12, #24]
    @ T[7] = T[1] ^ T[3]
    LDR \r4, [\r12, #4]
    LDR \r5, [\r12, #12]
    EOR \r4, \r4, \r5
    STR \r4, [\r12, #28]
    @ T[8] = R2 | T[7]
    ORRS \r4, \r2, \r4
    STR \r4, [\r12, #32]
    @ T[9] = T[8] ^ T[3]
    LDR \r4, [\r12, #32]
    LDR \r5, [\r12, #12]
    EOR \r4, \r4, \r5
    STR \r4, [\r12, #36]
    @ T[10] = T[6] | T[8]
    LDR \r4, [\r12, #24]
    LDR \r5, [\r12, #32]
    ORRS \r4, \r4, \r5
    STR \r4, [\r12, #40]
    @ T[11] = T[10] | R1
    LDR \r4, [\r12, #40]
    ORRS \r4, \r4, \r1
    STR \r4, [\r12, #44]
    @ T[12] = T[11] & T[9]
    LDR \r4, [\r12, #44]
    LDR \r5, [\r12, #36]
    AND \r4, \r4, \r5
    STR \r4, [\r12, #48]
    @ T[13] = R1 ^ T[10]
    LDR \r4, [\r12, #40]
    EOR \r4, \r1, \r4
    STR \r4, [\r12, #52]
    @ T[14] = T[1] ^ T[0]
    LDR \r4, [\r12, #4]
    LDR \r5, [\r12]
    EOR \r4, \r4, \r5
    STR \r4, [\r12, #56]
    @ T[15] = T[0] ^ T[5]
    LDR \r4, [\r12]
    LDR \r5, [\r12, #20]
    EOR \r4, \r4, \r5
    STR \r4, [\r12, #60]
    @ T[16] = T[13] & T[15]
    LDR \r4, [\r12, #52]
    LDR \r5, [\r12, #60]
    AND \r4, \r4, \r5
    STR \r4, [\r12, #64]
    @ T[17] = R3 & T[15]
    LDR \r4, [\r12, #60]
    AND \r4, \r3, \r4
    STR \r4, [\r12, #68]
    @ T[18] = T[16] ^ T[8]
    LDR \r4, [\r12, #64]
    LDR \r5, [\r12, #32]
    EOR \r4, \r4, \r5
    STR \r4, [\r12, #72]
    @ T[19] = T[13] | T[17]
    LDR \r4, [\r12, #52]
    LDR \r5, [\r12, #68]
    ORR \r4, \r4, \r5
    STR \r4, [\r12, #76]
    @ r0 = T[12]
    LDR \r4, [\r12, #48]
    STR \r4, [\r11]
    @ r1 = T[5]
    LDR \r4, [\r12, #20]
    STR \r4, [\r11, #4]
    @ r2 = T[18]
    LDR \r4, [\r12, #72]
    STR \r4, [\r11, #8]
    @ r3 = T[19]
    LDR \r4, [\r12, #76]
    STR \r4, [\r11, #12]
.endm

.macro SBOX_INV r11, r12, r0, r1, r2, r3, r4, r5
    LDR \r0, [\r11]
    LDR \r1, [\r11, #4]
    LDR \r2, [\r11, #8]
    LDR \r3, [\r11, #12]
    @ T[0] = R2 & R1
    AND \r4, \r2, \r1
    STR \r4, [\r12]
    @ T[1] = R0 ^ R1
    EOR \r4, \r0, \r1
    STR \r4, [\r12, #4]
    @ T[2] = R2 | R0
    ORRS \r4, \r2, \r0
    STR \r4, [\r12, #8]
    @ T[3] = R0 ^ T[0]
    LDR \r4, [\r12]
    EOR \r4, \r0, \r4
    STR \r4, [\r12, #12]
    @ T[4] = R1 | R2
    ORRS \r4, \r1, \r2
    STR \r4, [\r12, #16]
    @ T[5] = R3 & T[3]
    LDR \r4, [\r12, #12]
    AND \r4, \r3, \r4
    STR \r4, [\r12, #20]
    @ T[6] = R1 ^ 0xFFFF_FFFF
    MVN \r4, \r1
    STR \r4, [\r12, #24]
    @ T[7] = T[5] | R1
    LDR \r4, [\r12, #20]
    ORRS \r4, \r4, \r1
    STR \r4, [\r12, #28]
    @ T[8] = T[1] | R3
    LDR \r4, [\r12, #4]
    ORRS \r4, \r4, \r3
    STR \r4, [\r12, #32]
    @ T[9] = R3 | R2
    ORRS \r4, \r3, \r2
    STR \r4, [\r12, #36]
    @ T[10] = T[9] & T[4]
    LDR \r4, [\r12, #36]
    LDR \r5, [\r12, #16]
    AND \r4, \r4, \r5
    STR \r4, [\r12, #40]
    @ T[11] = T[6] ^ T[7]
    LDR \r4, [\r12, #24]
    LDR \r5, [\r12, #28]
    EOR \r4, \r4, \r5
    STR \r4, [\r12, #44]
    @ T[12] = T[4] ^ T[8]
    LDR \r4, [\r12, #16]
    LDR \r5, [\r12, #32]
    EOR \r4, \r4, \r5
    STR \r4, [\r12, #48]
    @ T[13] = T[2] ^ T[5]
    LDR \r4, [\r12, #8]
    LDR \r5, [\r12, #20]
    EOR \r4, \r4, \r5
    STR \r4, [\r12, #52]
    @ T[14] = T[12] | R0
    LDR \r4, [\r12, #48]
    ORRS \r4, \r4, \r0
    STR \r4, [\r12, #56]
    @ T[15] = T[14] & T[9]
    LDR \r4, [\r12, #56]
    LDR \r5, [\r12, #36]
    AND \r4, \r4, \r5
    STR \r4, [\r12, #60]
    @ T[16] = T[11] ^ T[0]
    LDR \r4, [\r12, #44]
    LDR \r5, [\r12]
    EOR \r4, \r4, \r5
    STR \r4, [\r12, #64]
    @ T[17] = T[10] & T[8]
    LDR \r4, [\r12, #40]
    LDR \r5, [\r12, #32]
    AND \r4, \r4, \r5
    STR \r4, [\r12, #68]
    @ T[18] = T[6] | T[17]
    LDR \r4, [\r12, #24]
    LDR \r5, [\r12, #68]
    ORRS \r4, \r4, \r5
    STR \r4, [\r12, #72]
    @ T[19] = T[16] & T[18]
    LDR \r4, [\r12, #64]
    LDR \r5, [\r12, #72]
    AND \r4, \r4, \r5
    STR \r4, [\r12, #76]
    @ r0 = T[19]
    LDR \r4, [\r12, #76]
    STR \r4, [\r11]
    @ r1 = T[13]
    LDR \r4, [\r12, #52]
    STR \r4, [\r11, #4]
    @ r2 = T[15]
    LDR \r4, [\r12, #60]
    STR \r4, [\r11, #8]
    @ r3 = T[17]
    LDR \r4, [\r12, #68]
    STR \r4, [\r11, #12]
.endm

.text
qarmav2_bitslicing:
    PUSH {r0-r12, r14}
    LDR r11, =rs // r0 for the state value
    LDR r12, =ts // r1 for the temp value on the sbox computation
    // permutation rs
    SBOX_INV r11, r12, r0, r1, r2, r3, r4, r5
    @ STR r1, [r0, #4]// Store the value of r1 back into the first item of rs
    POP {r0-r12, r14}
    BX lr
