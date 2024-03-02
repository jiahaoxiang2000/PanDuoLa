#include "qarmav2.h"
#include <rtthread.h>

static void qarma_cipher(int argc, char *argv[]){
    rt_kprintf("qarma cipher\n");
}

MSH_CMD_EXPORT_ALIAS(qarma_cipher, qarma, qarma cipher);