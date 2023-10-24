#include "rtdef.h"
#include "rtthread.h"
#include "mfrc522.h"
#include "drv_lcd.h"

#define DBG_TAG                        "uid.cipher"
#define DBG_LVL                        DBG_INFO

#include <rtdbg.h>

static MIFARE_Key key;
static Uid *uid;

// Init array that will store new NUID
static byte nuidPICC[4];
static uint8_t Plaintext[20];


//
// Created by xjh on 2023/10/24.
//
static int ic_card_cipher_thread(void) {
    LOG_I("start ic card cipher thread");

    // initial RC522
    MFRC522(MFRC522_SS_PIN, MFRC522_RST_PIN);
    PCD_Init(); // Init MFRC522
    uid = get_uid();

    while (1) {
        if (!PICC_IsNewCardPresent() || !PICC_ReadCardSerial()) {
            rt_thread_mdelay(50);
            continue;
        }

        if (uid->uidByte[0] != nuidPICC[0] ||
            uid->uidByte[1] != nuidPICC[1] ||
            uid->uidByte[2] != nuidPICC[2] ||
            uid->uidByte[3] != nuidPICC[3]) {
            LOG_I("A new card has been detected.\n");
            // Store NUID into nuidPICC array
            for (byte i = 0; i < 4; i++) {
                nuidPICC[i] = uid->uidByte[i];
            }

            rt_snprintf((char *) Plaintext, sizeof(Plaintext), "%x%x%x%x",
                        nuidPICC[0], nuidPICC[1], nuidPICC[2], nuidPICC[3]);
            // show id card information on lcd
            lcd_clear(BLACK);
            lcd_set_color(BLACK, WHITE);
            lcd_show_string(10, 10, 24, "Plaintext:%s", Plaintext);
        }
    }
    // Halt PICC
    PICC_HaltA();
    // Stop encryption on PCD
    PCD_StopCrypto1();
    PCD_End();
}

static int ic_card_cipher(int argc, char **argv) {
    rt_thread_t tid;
    int stack_size = 4096;

    tid = rt_thread_create("ic_card_cipher", (void (*)(void *)) ic_card_cipher_thread,
                           NULL, stack_size, RT_THREAD_PRIORITY_MAX / 2 - 1, 10);

    if (tid != RT_NULL) {
        rt_thread_startup(tid);
    }
}

#ifdef FINSH_USING_MSH
MSH_CMD_EXPORT(ic_card_cipher, encrypt ic card uid);
#endif