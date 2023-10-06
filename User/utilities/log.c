//
// Created by xjh on 2023/9/22.
//

#include "log.h"
#include <stdio.h>
#include <stdlib.h>

#include <stdbool.h>
#include <stdarg.h>
#include <string.h>
#include "main.h"
#include "usart.h"

#define PUTCHAR_PROTOTYPE int __io_putchar(int ch)

PUTCHAR_PROTOTYPE {
    return HAL_UART_Transmit(&huart2, (const uint8_t *) &ch, 1, 1000);
}

#define MAX_LOG_MSG_LEN            (512)

#if defined(__linux__)
#undef  MAX_LOG_MSG_LEN
#define MAX_LOG_MSG_LEN                  (1023)
#endif

//static char *level_str[] = {
//        "#GRN#", "#GRN#", "#ORG#", "#RED#",
//};
static char *level_str[] = {
        "DEBUG", "INFO", "WARNING", "ERROR",
};

LOG_LEVEL g_log_level = LOG_DEBUG;

static const char *get_filename(const char *p) {
    char ch = '/';
    const char *q = strrchr(p, ch);
    if (q == NULL) {
        q = p;
    } else {
        q++;
    }
    return q;
}

void Log_Set_Level(LOG_LEVEL logLevel) {
    g_log_level = logLevel;
}

LOG_LEVEL Log_Get_Level(void) {
    return g_log_level;
}

static bool log_lock = false; //support multi thread
void Log_writter(const char *file, const char *func, const int line, const int level, const char *fmt, ...) {
    if (level < g_log_level) {
        return;
    }

    if (log_lock) {
        return;
    } else {
        log_lock = true;
    }

    const char *file_name = get_filename(file);

    printf("%s|%s|%s(%d): ", level_str[level], file_name, func, line);

    va_list ap;
    va_start(ap, fmt);
    vprintf(fmt, ap); // this maybe buffer overflow
    va_end(ap);

    printf("\r\n");

    log_lock = false;
    return;
}

void HexDump(const uint8_t *pData, unsigned int len) {
    for (int i = 0; i < len; i++) {
        printf("%02x ", pData[i]);
    }
    printf("\n\r");
}

