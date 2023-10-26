#include "rtdef.h"
#include "rtthread.h"
#include "mfrc522.h"
#include "drv_lcd.h"

#define DBG_TAG                        "uid.cipher"
#define DBG_LVL                        DBG_INFO

#include <rtdbg.h>
#include "star.h"

static MIFARE_Key key;
static Uid *uid;

// Init array that will store new NUID
static uint8_t nuidPICC[8] = {0};
static uint8_t palintext[8] = {0};
static uint8_t ciphertext[8] = {0};

static uint8_t PlaintextStr[20];
static uint8_t EncryptionStr[20];
static uint8_t DecryptionStr[20];


u8 K[16] = {0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef, 0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef};

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
            // get plaintext form id card's uid
            rt_snprintf((char *) PlaintextStr, sizeof(PlaintextStr), "%x%x%x%x",
                        nuidPICC[0], nuidPICC[1], nuidPICC[2], nuidPICC[3]);
            // copy value to palintext
            for (int i = 0; i < 8; ++i) {
                palintext[i] = nuidPICC[i];
            }
            // star encrypt plaintext
            star_encrypt(K, palintext);
            rt_snprintf((char *) EncryptionStr, sizeof(EncryptionStr), "%x%x%x%x",
                        palintext[0], palintext[1], palintext[2], palintext[3]);
            // star decrypt ciphertext
            star_decrypt(palintext, K, ciphertext);
            rt_snprintf((char *) DecryptionStr, sizeof(DecryptionStr), "%x%x%x%x",
                        ciphertext[0], ciphertext[1], ciphertext[2], ciphertext[3]);

            // show id card information on lcd
            lcd_clear(BLACK);
            lcd_set_color(BLACK, WHITE);
            lcd_show_string(10, 10, 24, "Welcome User: Xrh");
            lcd_show_string(10, 34, 24, "Plaintext:%s", PlaintextStr);
            lcd_show_string(10, 58, 24, "Encryption:%s", EncryptionStr);
            lcd_show_string(10, 82, 24, "Decryption:%s", DecryptionStr);
        }
    }
    // Halt PICC
    PICC_HaltA();
    // Stop palintext on PCD
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