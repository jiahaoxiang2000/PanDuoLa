#include "qarmav2.h"
#include <rtthread.h>
#include <stm32l4xx.h>

static uint32_t a;

#define qarmav2()                       \
    {                                   \
        asm volatile("add r0, r0, #1"); \
    }

static void qarma_cipher(int argc, char *argv[])
{

    uint32_t start, end, elapsed;
    qarmav2();
    qarmav2();
    qarmav2();
    qarmav2();
    start = SysTick->VAL;

    // Your code Start
    a += 1;
    // Your code End
    end = SysTick->VAL;

    elapsed = start > end ? (start - end) : (start + (SysTick->LOAD - end));

    rt_kprintf("Execution time: %lu cycles\n", elapsed);
}

MSH_CMD_EXPORT_ALIAS(qarma_cipher, qarma, qarma cipher);