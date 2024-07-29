#include "aes.h"
#include <rtthread.h>
#include <stm32l4xx.h>
#include <stdio.h>

static void aes_cipher(int argc, char *argv[])
{
    uint32_t rkeys[88] = {0};
    unsigned char key0[16] = {0};
    unsigned char key1[16] = {0};
    aes128_keyschedule_ffs(rkeys, key0, key1);
    unsigned char ctext0[16] = {0};
    unsigned char ctext1[16] = {0};
    unsigned char ptext0[16] = {0};
    unsigned char ptext1[16] = {0};

    uint32_t start, end, elapsed;
    start = SysTick->VAL;

    // Your code Start
    aes128_encrypt_ffs(ctext0, ctext1,
                       ptext0, ptext1,
                       rkeys);
    // Your code End
    end = SysTick->VAL;

    elapsed = start > end ? (start - end) : (start + (SysTick->LOAD - end));
    // for (size_t i = 0; i < 32; i++)
    // {
    //     if (X[i] != C[i])
    //     {
    //         rt_kprintf("Error at %d\n", i);
    //     }
    // }

    // printf("cipher %llx\n", X);
    rt_kprintf("Execution time: %lu cycles\n", elapsed);
}

MSH_CMD_EXPORT_ALIAS(aes_cipher, aes, aes cipher);