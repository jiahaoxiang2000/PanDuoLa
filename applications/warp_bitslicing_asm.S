.syntax unified
.thumb

.global warp_rs
.section .data
.align 4
.type warp_rs, %object
warp_rs:    .word 0xff00ff, 0xf0f0f0f, 0x33333333, 0x55555555
@ rs: .word 0xffff, 0xff00ff, 0xf0f0f0f, 0x33333333
@ rs: .word 0xfffff0cf, 0xfc3ff33f, 0xcccc3ff, 0x3fcc030c
ks:         .word 0xffff, 0xff00ff,
ss:         .space 20*4

.global warp_bitslicing
.type warp_bitslicing, %function

@ the r11 is the pointer to the rs, r12 is the pointer to the ss
.macro SBOX r11, r12, r0, r1, r2, r3, r4, r5
    LDR \r0, [\r11]
    LDR \r1, [\r11, #4]
    LDR \r2, [\r11, #8]
    LDR \r3, [\r11, #12]
    @ T[0] = R0 & R1
    AND \r4, \r0, \r1
    STR \r4, [\r12]
    @ T[1] = R0 & R2
    AND \r4, \r0, \r2
    STR \r4, [\r12, #4]
    @ T[2] = R2 | T[0]
    LDR \r4, [\r12]
    ORR \r4, \r2, \r4
    STR \r4, [\r12, #8]
    @ T[3] = R0 | R3
    ORR \r4, \r0, \r3
    STR \r4, [\r12, #12]
    @ T[4] = R3 | R1
    ORR \r4, \r3, \r1
    STR \r4, [\r12, #16]
    @ T[5] = T[2] & T[3]
    LDR \r4, [\r12, #8]
    LDR \r5, [\r12, #12]
    AND \r4, \r4, \r5
    STR \r4, [\r12, #20]
    @ T[6] = T[2] ^ T[0]
    LDR \r4, [\r12, #8]
    LDR \r5, [\r12]
    EOR \r4, \r4, \r5
    STR \r4, [\r12, #24]
    @ T[7] = T[4] & R0
    LDR \r4, [\r12, #16]
    AND \r4, \r4, \r0
    STR \r4, [\r12, #28]
    @ T[8] = R1 | T[7]
    LDR \r4, [\r12, #28]
    ORR \r4, \r1, \r4
    STR \r4, [\r12, #32]
    @ T[9] = T[7] ^ R1
    LDR \r4, [\r12, #28]
    EOR \r4, \r4, \r1
    STR \r4, [\r12, #36]
    @ T[10] = ~T[0]
    LDR \r4, [\r12]
    MVN \r4, \r4
    STR \r4, [\r12, #40]
    @ T[11] = T[4] ^ T[0]
    LDR \r4, [\r12, #16]
    LDR \r5, [\r12]
    EOR \r4, \r4, \r5
    STR \r4, [\r12, #44]
    @ T[12] = T[7] & R3
    LDR \r4, [\r12, #28]
    AND \r4, \r4, \r3
    STR \r4, [\r12, #48]
    @ T[13] = T[9] & T[3]
    LDR \r4, [\r12, #36]
    LDR \r5, [\r12, #12]
    AND \r4, \r4, \r5
    STR \r4, [\r12, #52]
    @ T[14] = T[6] | T[13]
    LDR \r4, [\r12, #24]
    LDR \r5, [\r12, #52]
    ORR \r4, \r4, \r5
    STR \r4, [\r12, #56]
    @ T[15] = T[8] & R2
    LDR \r4, [\r12, #32]
    AND \r4, \r4, \r2
    STR \r4, [\r12, #60]
    @ T[16] = ~T[5]
    LDR \r4, [\r12, #20]
    MVN \r4, \r4
    STR \r4, [\r12, #64]
    @ T[17] = ~T[3]
    LDR \r4, [\r12, #12]
    MVN \r4, \r4
    STR \r4, [\r12, #68]
    @ T[18] = T[11] ^ T[12]
    LDR \r4, [\r12, #44]
    LDR \r5, [\r12, #48]
    EOR \r4, \r4, \r5
    STR \r4, [\r12, #72]
    @ T[19] = T[15] | T[17]
    LDR \r4, [\r12, #60]
    LDR \r5, [\r12, #68]
    ORR \r4, \r4, \r5
    STR \r4, [\r12, #76]
    @ r0 = T[16]
    LDR \r4, [\r12, #64]
    STR \r4, [\r11]
    @ r1 = T[19]
    LDR \r4, [\r12, #76]
    STR \r4, [\r11, #4]
    @ r2 = T[18]
    LDR \r4, [\r12, #72]
    STR \r4, [\r11, #8]
    @ r3 = T[14]
    LDR \r4, [\r12, #56]
    STR \r4, [\r11, #12]
.endm

.macro PPO, dest_r, src_r, t1, t2, rotate_amount, mask_value
    MOV \t1, \src_r, ROR#\rotate_amount
    LDR \t2, =\mask_value
    AND \t1, \t1, \t2
    ORR \dest_r, \dest_r, \t1
.endm

.macro PPO_PI dest_r, src_r, t1, t2
    MOV \dest_r, #0x0
    @ MOVW \t1, #:lower16:ms
    @ MOVT \t1, #:upper16:ms
    @ LDR \t2, [\t1]
    @ AND \t2, \t2, \src_r
    @ ORR \dest_r, \dest_r, \t2
    PPO \dest_r, \src_r, \t1, \t2, 1, 0x800080 @ (1, [8, 24], '0x800080')
    PPO \dest_r, \src_r, \t1, \t2, 5, 0x2000200 @ (5, [6, 22], '0x2000200')
    PPO \dest_r, \src_r, \t1, \t2, 7, 0x80008 @ (7, [12, 28])
    PPO \dest_r, \src_r, \t1, \t2, 9, 0x1000100 @ (9, [7, 23])
    PPO \dest_r, \src_r, \t1, \t2, 11, 0x20002 @ (11, [14, 30])
    PPO \dest_r, \src_r, \t1, \t2, 13, 0x400040 @ (13, [9, 25])
    PPO \dest_r, \src_r, \t1, \t2, 15, 0x4000400 @ (15, [5, 21])
    PPO \dest_r, \src_r, \t1, \t2, 19, 0x100010 @ (19, [11, 27])
    PPO \dest_r, \src_r, \t1, \t2, 21, 0x80008000 @ (21, [0, 16])
    PPO \dest_r, \src_r, \t1, \t2, 23, 0x8000800 @ (23, [4, 20])
    PPO \dest_r, \src_r, \t1, \t2, 25, 0x30003000 @ (25, [2, 3, 18, 19])
    PPO \dest_r, \src_r, \t1, \t2, 27, 0x240024 @ (27, [10, 13, 26, 29])
    PPO \dest_r, \src_r, \t1, \t2, 29, 0x40004000 @ (29, [1, 17])
    PPO \dest_r, \src_r, \t1, \t2, 31, 0x10001 @ (31, [15, 31])
.endm

.text
warp_bitslicing:
    PUSH {r0-r12, r14}
    MOVW r12, #:lower16:warp_rs
    MOVT r12, #:upper16:warp_rs

    MOVW r11, #:lower16:ks
    MOVT r11, #:upper16:ks

    MOVW r10, #:lower16:ss
    MOVT r10, #:upper16:ss

    SBOX r12, r10, r0, r1, r2, r3, r4, r5

    POP {r0-r12, r14}
    BX lr
