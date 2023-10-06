//
// Created by xjh on 2023/9/22.
//

#ifndef LIANGSHANPAI_TOOLS_H
#define LIANGSHANPAI_TOOLS_H

#include <stdint-gcc.h>

/**
 * @brief Delays the program execution by the specified number of microseconds.
 *
 * This function provides a platform-independent way to introduce delay
 * in microseconds. The actual delay achieved may vary based on the platform
 * and system clock frequency.
 * @note different chip should change the sys_clock in this function
 * @param u_delay The number of microseconds to delay.
 */

void delay_us(uint32_t u_delay);

#endif //LIANGSHANPAI_TOOLS_H
