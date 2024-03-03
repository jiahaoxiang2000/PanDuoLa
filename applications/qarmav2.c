#include "qarmav2.h"
#include <rtthread.h>
#include <stm32l4xx.h>
#include <stdio.h>

static uint32_t a;

static uint8_t tau_p[16] = {0, 11, 6, 13, 10, 1, 12, 7, 5, 14, 3, 8, 15, 4, 9, 2};
static uint8_t tau_inverse_p[16] = {0, 5, 15, 10, 13, 8, 2, 7, 11, 14, 4, 1, 6, 3, 9, 12};

/// @brief permutation the state by p, the result is stored in state
/// @param state the state to be permuted
/// @param p the permutation array
void permutation(uint8_t state[16], uint8_t p[16])
{
    uint8_t temp[16];
    for (int i = 0; i < 16; i++)
    {
        temp[i] = state[p[i]];
    }
    for (int i = 0; i < 16; i++)
    {
        state[i] = temp[i];
    }
}

#define rotate_left(x, n) (((x) << (n)) | ((x) >> (4 - (n))) & 0x0F)

void mix_column(uint8_t state[16])
{
    uint8_t temp[16];
    uint8_t index;

    for (int i = 0; i < 4; i++)
    {
        for (size_t j = 0; j < 4; j++)
        {
            index = i + 4 * j;
            temp[index] = rotate_left(state[(index + 4) % 16], 1) ^ rotate_left(state[(index + 8) % 16], 2) ^ rotate_left(state[(index + 12) % 16], 3);
        }
    }

    for (int i = 0; i < 16; i++)
    {
        state[i] = temp[i];
    }
}

static uint8_t S[16] = {4, 7, 9, 11, 12, 6, 14, 15, 0, 5, 1, 13, 8, 3, 2, 10};
static uint8_t S_inverse[16] = {8, 10, 14, 13, 0, 9, 5, 1, 12, 2, 15, 3, 4, 11, 6, 7};

void s_box(uint8_t state[16], uint8_t s[16])
{
    for (int i = 0; i < 16; i++)
    {
        state[i] = s[state[i]];
    }
}



#define qarmav2()                       \
    {                                   \
        asm volatile("add r0, r0, #1"); \
    }

static void qarma_cipher(int argc, char *argv[])
{

    uint32_t start, end, elapsed;
    start = SysTick->VAL;

    // Your code Start
    a += 1;
    // Your code End
    end = SysTick->VAL;

    elapsed = start > end ? (start - end) : (start + (SysTick->LOAD - end));

    rt_kprintf("Execution time: %lu cycles\n", elapsed);
}

MSH_CMD_EXPORT_ALIAS(qarma_cipher, qarma, qarma cipher);