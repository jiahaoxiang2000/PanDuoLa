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
.macro PPO, dest_r, src_r, t1, t2, rotate_amount, mask_value
    MOV \t1, \src_r, ROR#\rotate_amount
    LDR \t2, =\mask_value
    AND \t1, \t1, \t2
    ORR \dest_r, \dest_r, \t1
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
.macro PPO_TUA dest_r, src_r, t1, t2
    MOV \dest_r, #0x0
    LDR \t1, =0xc00030000
    AND \dest_r, \src_r, \t1 @ (0, [0, 7])
    PPO \dest_r, \src_r, \t1, \t2, 12, 0x33000000 @ (6, [1, 3])
    PPO \dest_r, \src_r, \t1, \t2, 24, 0xc000000 @ (12, [2])
    PPO \dest_r, \src_r, \t1, \t2, 20, 0xcc0000 @ (10, [4, 6])
    PPO \dest_r, \src_r, \t1, \t2, 8, 0x300000 @ (4, [5])
    PPO \dest_r, \src_r, \t1, \t2, 6, 0xc300  @ (3, [8, 11])
    PPO \dest_r, \src_r, \t1, \t2, 22, 0x3000 @ (11, [9])
    PPO \dest_r, \src_r, \t1, \t2, 14, 0xc00  @ (7, [10])
    PPO \dest_r, \src_r, \t1, \t2, 26, 0xc3 @ (13, [12, 15])
    PPO \dest_r, \src_r, \t1, \t2, 18, 0x30 @  (9, [13])
    PPO \dest_r, \src_r, \t1, \t2, 10, 0xc  @  (5, [14])
.endm

.macro PPO_TUA_INV dest_r, src_r, t1, t2
    MOV \dest_r, #0x0
    LDR \t1, =0xc0030000
    AND \dest_r, \src_r, \t1 @ (0, [0, 7])
    PPO \dest_r, \src_r, \t1, \t2, 6, 0xc000003 @ (3, [2, 15])
    PPO \dest_r, \src_r, \t1, \t2, 8, 0xc0000 @ (4, [6])
    PPO \dest_r, \src_r, \t1, \t2, 10, 0xc @ (5, [14])
    PPO \dest_r, \src_r, \t1, \t2, 12, 0xcc0 @ (6, [10, 12])
    PPO \dest_r, \src_r, \t1, \t2, 14, 0xc00000 @ (7, [4])
    PPO \dest_r, \src_r, \t1, \t2, 18, 0x3000000 @ (9, [3])
    PPO \dest_r, \src_r, \t1, \t2, 20, 0x330 @ (10, [11, 13])
    PPO \dest_r, \src_r, \t1, \t2, 22, 0x3000 @ (11, [9])
    PPO \dest_r, \src_r, \t1, \t2, 24, 0x30000000 @ (12, [1])
    PPO \dest_r, \src_r, \t1, \t2, 26, 0x30c000 @ (13, [5, 8])
.endm

.macro PPO_TUA_F dest_r, src_r, t1, t2
    MOV \dest_r, #0x0
    PPO \dest_r, \src_r, \t1, \t2, 2, 0x3000 @ (2, [9])
    PPO \dest_r, \src_r, \t1, \t2, 4, 0xc30030 @ (4, [4, 7, 13])
    PPO \dest_r, \src_r, \t1, \t2, 8, 0xc000000 @ (8, [2])
    PPO \dest_r, \src_r, \t1, \t2, 14, 0x30000300 @ (14, [1, 11])
    PPO \dest_r, \src_r, \t1, \t2, 16, 0xc003 @ (16, [8, 15])
    PPO \dest_r, \src_r, \t1, \t2, 18, 0xc00c0 @ (18, [6, 12])
    PPO \dest_r, \src_r, \t1, \t2, 24, 0x300000 @ (24, [5])
    PPO \dest_r, \src_r, \t1, \t2, 26, 0x3000000 @ (26, [3])
    PPO \dest_r, \src_r, \t1, \t2, 28, 0xc00 @ (28, [10])
    PPO \dest_r, \src_r, \t1, \t2, 30, 0xc000000c @ (30, [0, 14])
.endm

.macro PPO_TUA_F_INV dest_r, src_r, t1, t2
    MOV \dest_r, #0x0
    PPO \dest_r, \src_r, \t1, \t2, 2, 0x30000003 @ (2, [1, 15])
    PPO \dest_r, \src_r, \t1, \t2, 4, 0xc0 @ (4, [12])
    PPO \dest_r, \src_r, \t1, \t2, 6, 0xc0000 @ (6, [6])
    PPO \dest_r, \src_r, \t1, \t2, 8, 0x3000 @ (8, [9])
    PPO \dest_r, \src_r, \t1, \t2, 14, 0x3000030 @ (14, [3, 13])
    PPO \dest_r, \src_r, \t1, \t2, 16, 0xc0030000 @ (16, [0, 7])
    PPO \dest_r, \src_r, \t1, \t2, 18, 0xc00c00 @ (18, [4, 10])
    PPO \dest_r, \src_r, \t1, \t2, 24, 0xc @ (24, [14])
    PPO \dest_r, \src_r, \t1, \t2, 28, 0xc300300 @ (28, [2, 5, 11])
    PPO \dest_r, \src_r, \t1, \t2, 30, 0xc000 @ (30, [8])
.endm

.macro PERMUTATION base_r, t1, t2, t3, t4, PPO
    LDR \t2, [\base_r]// Load the first item of rs into r1
    \PPO \t1, \t2, \t3, \t4
    STR \t1, [\base_r]// Store the value of r1 back into the first item of rs

    LDR \t2, [\base_r, #4]// Load the second item of rs into r1
    \PPO \t1, \t2, \t3, \t4
    STR \t1, [\base_r, #4]// Store the value of r1 back into the second item of rs

    LDR \t2, [\base_r, #8]// Load the third item of rs into r1
    \PPO \t1, \t2, \t3, \t4
    STR \t1, [\base_r, #8]// Store the value of r1 back into the third item of rs

    LDR \t2, [\base_r, #12]// Load the fourth item of rs into r1
    \PPO \t1, \t2, \t3, \t4
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
    PERMUTATION r11, r0, r1, r2, r3, PPO_TUA_F_INV
    @ STR r1, [r0, #4]// Store the value of r1 back into the first item of rs
    POP {r0-r12, r14}
    BX lr
