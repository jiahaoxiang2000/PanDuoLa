#include "warp_bitslicing.h"
#include <rtthread.h>
#include <stm32l4xx.h>
#include <stdio.h>

static void warp_bitslicing_cipher(int argc, char *argv[])
{
    uint32_t r0, r1, r2, r3;
    uint32_t b = 1;
    uint32_t c = 0;
    r0 = 0xffff;
    r1 = 0xff00ff;
    r2 = 0xf0f0f0f;
    r3 = 0x33333333;

    uint32_t start, end, elapsed;
    start = SysTick->VAL;

    // Your code Start

    // permutation_tau(r0, r1, r2, r3);
    warp_bitslicing();

    // Your code End
    end = SysTick->VAL;
    printf("0 %x\n", warp_rs[0]);
    printf("1 %x\n", warp_rs[1]);
    printf("2 %x\n", warp_rs[2]);
    printf("4 %x\n", warp_rs[3]);
    // printf("r0 %lx\n", r0);
    elapsed = start > end ? (start - end) : (start + (SysTick->LOAD - end));
    // printf("cipher %llx\n", state);
    rt_kprintf("Execution time: %lu cycles\n", elapsed);
}

MSH_CMD_EXPORT_ALIAS(warp_bitslicing_cipher, warp_b, warp bitslicing);