.syntax unified


.global qarmav2_bitslicing
.type qarmav2_bitslicing, %function

qarmav2_bitslicing:
    PUSH {r0-r12, r14}
    MOV r0, r0, ROR #16
    MOV r0, r0, ROR #16
    POP {r0-r12, r14}
    BX lr
