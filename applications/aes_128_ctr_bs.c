#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <rtthread.h>
#include <stm32l4xx.h>
#include <stdio.h>

typedef struct param
{
    uint32_t ctr;
    uint8_t nonce[12];
    uint8_t rk[2 * 11 * 16];
} param;

extern void AES_128_keyschedule(const uint8_t *, uint8_t *);
extern void AES_128_encrypt_ctr(param const *, const uint8_t *, uint8_t *, uint32_t);
#define AES_128_decrypt_ctr AES_128_encrypt_ctr

static void aes_bs(int argc, char *argv[])
{

    const uint32_t LEN = 256;
    const uint32_t LEN_ROUNDED = ((LEN + 31) / 32) * 32;

    uint8_t key[16];
    uint8_t in[LEN];
    uint8_t out[LEN_ROUNDED];

    unsigned int i, j;
    char buffer[36];
    param p;
    p.ctr = 0;
    for (j = 0; j < 12; ++j)
    {
        p.nonce[j] = 0;
    }
    for (j = 0; j < 16; ++j)
    {
        key[j] = 0;
    }
    for (j = 0; j < LEN; ++j)
    {
        in[j] = 0;
    }

    AES_128_keyschedule(key, p.rk);
    uint32_t start, end, elapsed;
    start = SysTick->VAL;
    AES_128_encrypt_ctr(&p, in, out, LEN);
    // Your code End
    end = SysTick->VAL;

    elapsed = start > end ? (start - end) : (start + (SysTick->LOAD - end));
    // printf("cipher %llx\n", X);
    rt_kprintf("Execution time: %lu cycles\n", elapsed);
}

MSH_CMD_EXPORT_ALIAS(aes_bs, aes_bs, aes cipher);