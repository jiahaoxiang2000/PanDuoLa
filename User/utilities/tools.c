//
// Created by xjh on 2023/9/22.
//

#include "tools.h"
#include "stm32l4xx_hal.h"


void delay_us(uint32_t u_delay) {
    uint32_t ticks;
    uint32_t t_old, t_now, t_cnt = 0;
    uint32_t reload = SysTick->LOAD;
    ticks = u_delay * 80; // sys_clock / 1000 * u_delay;
    t_old = SysTick->VAL;

    while (1) {
        t_now = SysTick->VAL;

        if (t_now != t_old) {
            if (t_now < t_old)t_cnt += t_old - t_now;
            else t_cnt += reload - t_now + t_old;

            t_old = t_now;
            if (t_cnt >= ticks)break;
        }
    }
}