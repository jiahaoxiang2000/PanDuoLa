.syntax unified
.thumb

.global warp_rs
.section .data
.align 4
.type warp_rs, %object
warp_rs:    .word 0x0, 0x0, 0x0, 0x0
@ rs: .word 0xffff, 0xff00ff, 0xf0f0f0f, 0x33333333
@ rs: .word 0xfffff0cf, 0xfc3ff33f, 0xcccc3ff, 0x3fcc030c
ks:         .word 0xffff, 0xff00ff,

.global warp_bitslicing
.type warp_bitslicing, %function

.text
warp_bitslicing:
    PUSH {r0-r12, r14}

    POP {r0-r12, r14}
    BX lr
