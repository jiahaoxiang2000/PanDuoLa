#include "warp_bitslicing.h"
#include <rtthread.h>
#include <stm32l4xx.h>
#include <stdio.h>

void sbox(uint32_t *r0, uint32_t *r1, uint32_t *r2, uint32_t *r3)
{
    uint32_t T[20] = {0};

    // T_{0} =  X_{0} & X_{1}
    T[0] = *r0 & *r1;
    // T_{1} =  X_{0} & X_{2}
    T[1] = *r0 & *r2;
    // T_{2} =  X_{2} | T_{0}
    T[2] = *r2 | T[0];
    // T_{3} =  X_{0} | X_{3}
    T[3] = *r0 | *r3;
    // T_{4} =  X_{3} | X_{1}
    T[4] = *r3 | *r1;
    // T_{5} =  T_{2} & T_{3}
    T[5] = T[2] & T[3];
    // T_{6} =  T_{2} ^ T_{0}
    T[6] = T[2] ^ T[0];
    // T_{7} =  T_{4} & X_{0}
    T[7] = T[4] & *r0;
    // T_{8} =  X_{1} | T_{7}
    T[8] = *r1 | T[7];
    // T_{9} =  T_{7} ^ X_{1}
    T[9] = T[7] ^ *r1;
    // T_{10} = ~T_{0}
    T[10] = ~T[0];
    // T_{11} =  T_{4} ^ T_{0}
    T[11] = T[4] ^ T[0];
    // T_{12} =  T_{7} & X_{3}
    T[12] = T[7] & *r3;
    // T_{13} =  T_{9} & T_{3}
    T[13] = T[9] & T[3];
    // T_{14} =  T_{6} | T_{13}
    T[14] = T[6] | T[13];
    // T_{15} =  T_{8} & X_{2}
    T[15] = T[8] & *r2;
    // T_{16} = ~T_{5}
    T[16] = ~T[5];
    // T_{17} = ~T_{3}
    T[17] = ~T[3];
    // T_{18} =  T_{11} ^ T_{12}
    T[18] = T[11] ^ T[12];
    // T_{19} =  T_{15} | T_{17}
    T[19] = T[15] | T[17];
    // Y_{0} = T_{16}
    *r0 = T[16];
    // Y_{1} = T_{19}
    *r1 = T[19];
    // Y_{2} = T_{18}
    *r2 = T[18];
    // Y_{3} = T_{14}
    *r3 = T[14];
}

static void warp_bitslicing_cipher(int argc, char *argv[])
{
    uint32_t r0, r1, r2, r3;
    r0 = 0xffff;
    r1 = 0xff00ff;
    r2 = 0xf0f0f0f;
    r3 = 0x33333333;

    uint32_t start, end, elapsed;
    start = SysTick->VAL;

    // Your code Start

    warp_bitslicing();

    // Your code End
    end = SysTick->VAL;
    printf("0 %x\n", warp_rs[0]);
    printf("1 %x\n", warp_rs[1]);
    printf("2 %x\n", warp_rs[2]);
    printf("4 %x\n", warp_rs[3]);
    elapsed = start > end ? (start - end) : (start + (SysTick->LOAD - end));
    rt_kprintf("Execution time: %lu cycles\n", elapsed);
}

MSH_CMD_EXPORT_ALIAS(warp_bitslicing_cipher, warp_b, warp bitslicing);

static void warp_bitslicing_c(int argc, char *argv[])
{
    uint32_t r0, r1, r2, r3;
    uint32_t b = 1;
    uint32_t c = 0;
    r0 = 0xff00ff ;
    r1 = 0xf0f0f0f ;
    r2 = 0x33333333 ;
    r3 = 0x55555555;

    uint32_t start, end, elapsed;
    start = SysTick->VAL;

    // Your code Start

    sbox(&r0, &r1, &r2, &r3);

    // Your code End
    end = SysTick->VAL;
    printf("0 %x\n", r0);
    printf("1 %x\n", r1);
    printf("2 %x\n", r2);
    printf("4 %x\n", r3);
    // printf("r0 %lx\n", r0);
    elapsed = start > end ? (start - end) : (start + (SysTick->LOAD - end));
    // printf("cipher %llx\n", state);
    rt_kprintf("Execution time: %lu cycles\n", elapsed);
}

MSH_CMD_EXPORT_ALIAS(warp_bitslicing_c, c_warp_b, warp bitslicing c version);