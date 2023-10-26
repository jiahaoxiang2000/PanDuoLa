//
// Created by xjh on 2023/10/26.
//

#ifndef RTTHREAD_STAR_H
#define RTTHREAD_STAR_H

#include <stdint-gcc.h>

typedef uint8_t u8;
typedef uint16_t u16;

void star_encrypt(u8 *k, u8 *p);
void star_decrypt(u8 *c, u8 *k, u8 *p);

#endif //RTTHREAD_STAR_H
