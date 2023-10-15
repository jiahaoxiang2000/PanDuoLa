/*
 * Copyright (c) 2006-2021, RT-Thread Development Team
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author       Notes
 * 2018-11-06     SummerGift   first version
 */

#include <rtthread.h>
#include <rtdevice.h>
#include <board.h>
#include "drv_lcd.h"

/* defined the LED0 pin: PE7 */
#define LED0_PIN    GET_PIN(E, 7)

int main(void) {
    /* set LED0 pin mode to output */
    rt_pin_mode(LED0_PIN, PIN_MODE_OUTPUT);

    lcd_clear(WHITE);
    lcd_set_color(WHITE, BLACK);
    lcd_show_string(10, 69, 32, "Hello, Xjh!");

    while (1) {
        rt_thread_mdelay(500);
    }
}