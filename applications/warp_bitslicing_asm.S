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
