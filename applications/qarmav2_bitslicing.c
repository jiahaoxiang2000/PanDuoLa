#include "qarmav2.h"
#include <rtthread.h>
#include <stm32l4xx.h>
#include <stdio.h>

#define right_cyclic_shift(c, s) ({         \
    uint32_t result;                        \
    asm("ROR %[result], %[value], %[shift]" \
        : [result] "=r"(result)             \
        : [value] "r"(c), [shift] "I"(s));  \
    result;                                 \
})

static uint8_t tau_shift[16] = {0, 12, 24, 12, 20, 8, 20, 0, 6, 22, 14, 6, 26, 18, 10, 26};
static uint32_t tau_mask[16] = {3221225472, 805306368, 201326592, 50331648, 12582912, 3145728, 786432, 196608, 49152, 12288, 3072, 768, 192, 48, 12, 3};

#define permutation_tau(r0, r1, r2, r3) ({                        \
    for (int i = 0; i < 16; i++)                                  \
    {                                                             \
        r0 |= right_cyclic_shift(r0, tau_shift[i]) & tau_mask[i]; \
        r1 |= right_cyclic_shift(r1, tau_shift[i]) & tau_mask[i]; \
        r2 |= right_cyclic_shift(r2, tau_shift[i]) & tau_mask[i]; \
        r3 |= right_cyclic_shift(r3, tau_shift[i]) & tau_mask[i]; \
    }                                                             \
})

static void qarmav2_bitslicing_cipher(int argc, char *argv[])
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
    qarmav2_bitslicing();

    // Your code End
    end = SysTick->VAL;
    printf("c %x\n", c);
    printf("r0 %lx\n", r0);
    elapsed = start > end ? (start - end) : (start + (SysTick->LOAD - end));
    // printf("cipher %llx\n", state);
    rt_kprintf("Execution time: %lu cycles\n", elapsed);
}

MSH_CMD_EXPORT_ALIAS(qarmav2_bitslicing_cipher, qarmav2_b, qarmav2 bitslicing);