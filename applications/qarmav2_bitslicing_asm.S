.syntax unified
.thumb

.section .data
.global rs
rs:     .word 0xffff, 0xff00ff, 0xf0f0f0f, 0x33333333
shift:  .byte 0, 12, 24, 12, 20, 8, 20, 0, 6, 22, 14, 6, 26, 18, 10, 26
mask:   .word 0xc0000000, 0x30000000, 0xc000000, 0x3000000, 0xc00000, 0x300000, 0xc0000, 0x30000, 0xc000, 0x3000, 0xc00, 0x300, 0xc0, 0x30, 0xc, 0x3

.global qarmav2_bitslicing
.type qarmav2_bitslicing, %function

.text
qarmav2_bitslicing:
    PUSH {r0-r12, r14}
    LDR r0, =rs // Load the address of rs into r0
    // permutation r0
    MOV r1, #0x0
    LDR r2, [r0]// Load the first item of rs into r1
    // permutation one
    @ MOV r3, r2, ROR#0
    @ AND r3, r3, #0xc0000000
    @ ORR r1, r1, r3
    // permutation two
    MOV r3, r2, ROR#12
    AND r3, r3, #0x30000000
    ORR r1, r1, r3
    // permutation three
    MOV r3, r2, ROR#24
    AND r3, r3, #0xc000000
    ORR r1, r1, r3
    // permutation four
    MOV r3, r2, ROR#12
    AND r3, r3, #0x3000000
    ORR r1, r1, r3
    // permutation five
    MOV r3, r2, ROR#20
    AND r3, r3, #0xc00000
    ORR r1, r1, r3
    // permutation six
    MOV r3, r2, ROR#8
    AND r3, r3, #0x300000
    ORR r1, r1, r3
    // permutation seven
    MOV r3, r2, ROR#20
    AND r3, r3, #0xc0000
    ORR r1, r1, r3
    // permutation eight
    @ MOV r3, r2, ROR#0
    @ AND r3, r3, #0x30000
    @ ORR r1, r1, r3
    // permutation nine
    MOV r3, r2, ROR#6
    AND r3, r3, #0xc000
    ORR r1, r1, r3
    // permutation ten
    MOV r3, r2, ROR#22
    AND r3, r3, #0x3000
    ORR r1, r1, r3
    // permutation eleven
    MOV r3, r2, ROR#14
    AND r3, r3, #0xc00
    ORR r1, r1, r3
    // permutation twelve
    MOV r3, r2, ROR#6
    AND r3, r3, #0x300
    ORR r1, r1, r3
    // permutation thirteen
    MOV r3, r2, ROR#26
    AND r3, r3, #0xc0
    ORR r1, r1, r3
    // permutation fourteen
    MOV r3, r2, ROR#18
    AND r3, r3, #0x30
    ORR r1, r1, r3
    // permutation fifteen
    MOV r3, r2, ROR#10
    AND r3, r3, #0xc
    ORR r1, r1, r3
    // permutation sixteen
    MOV r3, r2, ROR#26
    AND r3, r3, #0x3
    ORR r1, r1, r3
    // out r1 to r0
    STR r1, [r0]// Store the value of r1 back into the first item of rs
    @ STR r1, [r0, #4]// Store the value of r1 back into the first item of rs
    POP {r0-r12, r14}
    BX lr
