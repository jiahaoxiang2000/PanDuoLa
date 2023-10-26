//
// Created by xjh on 2023/10/26.
//


#include "star.h"


static int sbox[16] = {0x4, 0x5, 0xE, 0x9, // 4*4S盒
                       0xB, 0x8, 0xD, 0xA,
                       0xF, 0xC, 0x3, 0x6,
                       0x1, 0x0, 0x7, 0x2};
static int P[8] = {1, 7, 4, 2, 3, 0, 5, 6};// P盒
static int rcon[5] = {0, 1, 0, 1, 1};//轮常量

// 密钥扩展
static void CharToBit(u8 input[], int output[], int n) {
    for (int j = 0; j < n; j++) {
        for (int i = 0; i < 8; i++) {
            output[7 * (j + 1) - i + j] = (input[j] >> i) & 1;
        }
    }
}

static void Xor(int input[8], int output[8], int L[8])//异或运算
{
    for (int i = 0; i < 8; i++) {
        L[i] = input[i] ^ output[i];
    }
}

// F函数
void F(u8 in, u16 inkey, u8 *out) {

    in = in ^ inkey;
    u8 s_out;
    int s_out1[8] = {0};
    int s_out2[8] = {0};
    int height;
    height = ((in & 0xf0) >> 4);
    //取高四位
    int low;
    low = (in & 0x0f);
    //取低四位
    height = sbox[height];
    low = sbox[low];
    s_out = height << 4 | low;
    for (int i = 0; i < 8; i++) {
        s_out1[i] = (s_out >> (7 - i)) & 1;
    }
    for (int i = 0; i < 8; i++) {
        s_out2[P[i]] = s_out1[i];
    }
    *out = (s_out2[0] << 7) | (s_out2[1] << 6) | (s_out2[2] << 5) | (s_out2[3] << 4) | (s_out2[4] << 3) |
           (s_out2[5] << 2) | (s_out2[6] << 1) | s_out2[7];
}

// 密钥进加密流程
void SubKeyjiami1(u8 *k, u8 *p) {
    u8 Rcon1[8] = {0xda, 0x31, 0x6f, 0x58, 0x9f, 0xcb, 0x7c, 0xf7};
    u8 fout[8] = {0};
    u8 temp[8] = {0};
    for (int i = 0; i < 1; i++) {
        F(p[0], Rcon1[0], &fout[0]);
        F(p[2], Rcon1[1], &fout[1]);
        F(p[4], Rcon1[2], &fout[2]);
        F(p[6], Rcon1[3], &fout[3]);
        F(fout[1] ^ p[3], Rcon1[4], &fout[4]);
        F(fout[0] ^ p[1], Rcon1[5], &fout[5]);
        F(fout[3] ^ p[7], Rcon1[6], &fout[6]);
        F(fout[2] ^ p[5], Rcon1[7], &fout[7]);
        temp[0] = fout[5] ^ p[2];
        temp[1] = fout[7] ^ p[6];
        temp[2] = fout[0] ^ p[1];
        temp[3] = fout[6] ^ p[4];
        temp[4] = fout[3] ^ p[7];
        temp[5] = fout[4] ^ p[0];
        temp[6] = fout[1] ^ p[3];
        temp[7] = fout[2] ^ p[5];
        for (int i = 0; i < 8; i++) {
            p[i] = temp[i];
        }
    }
}

void SubKeyjiami2(u8 *k, u8 *p) {
    u8 Rcon2[8] = {0x92, 0xb1, 0x2e, 0xdd, 0x1c, 0x54, 0xaa, 0x80};
    u8 fout[8] = {0};
    u8 temp[8] = {0};
    for (int i = 0; i < 1; i++) {
        F(p[0], Rcon2[0], &fout[0]);
        F(p[2], Rcon2[1], &fout[1]);
        F(p[4], Rcon2[2], &fout[2]);
        F(p[6], Rcon2[3], &fout[3]);
        F(fout[1] ^ p[3], Rcon2[4], &fout[4]);
        F(fout[0] ^ p[1], Rcon2[5], &fout[5]);
        F(fout[3] ^ p[7], Rcon2[6], &fout[6]);
        F(fout[2] ^ p[5], Rcon2[7], &fout[7]);
        temp[0] = fout[5] ^ p[2];
        temp[1] = fout[7] ^ p[6];
        temp[2] = fout[0] ^ p[1];
        temp[3] = fout[6] ^ p[4];
        temp[4] = fout[3] ^ p[7];
        temp[5] = fout[4] ^ p[0];
        temp[6] = fout[1] ^ p[3];
        temp[7] = fout[2] ^ p[5];
        for (int i = 0; i < 8; i++) {
            p[i] = temp[i];
        }
    }
}

// 密钥扩展
static void SubKey(u8 K[16], u8 subkey[20][8]) {
    u8 Ka[8] = {0};
    u8 Kb[8] = {0};
    u8 Ka_out[8] = {0};
    u8 Kb_out[8] = {0};
    u8 K1[16] = {0};
    int subkey_temp[64] = {0};
    int bitk[128] = {0};
    int temp_s[4] = {0};
    int temp_xor[5] = {0};
    int temp1[128] = {0};

    for (int i = 0; i < 8; i++) {
        Ka[i] = K[i];
        Kb[i] = K[i + 8];
    }
    SubKeyjiami1(Ka, Ka_out);
    SubKeyjiami2(Kb, Kb_out);
    for (int i = 0; i < 8; i++) {
        K1[i] = Ka_out[i];
        K1[i + 8] = Kb_out[i];
    }
    CharToBit(K1, bitk, 16);
    for (int k = 0; k < 20; k++) {
        if (k % 2 == 0) {   //偶次轮进行循环左移17位，再将k7,k6,k5,k4进S盒
            for (int j = 0; j < 128; j++) {
                temp1[j] = bitk[(j + 17) % 128];
            }
            int sboxin = 0;
            int sboxout = 0;
            sboxin = temp1[120] << 3 | temp1[121] << 2 | temp1[122] << 1 | temp1[123];
            sboxout = sbox[sboxin];
            for (int j = 0; j < 4; j++) {
                temp1[j + 120] = (sboxout >> (3 - j)) & 1;
            }
            for (int j = 0; j < 64; j++) {
                subkey_temp[j] = temp1[64 + j];
            }
            for (int j = 0; j < 128; j++) {
                bitk[j] = temp1[j];
            }
        } else {
            int temp1[128] = {0};
            for (int j = 0; j < 128; j++) {
                temp1[j] = bitk[(j + 61) % 128];
            }
            for (int j = 0; j < 5; j++) {
                temp1[j + 12] = temp1[j + 12] ^ rcon[j];
            }
            for (int j = 0; j < 64; j++) {
                subkey_temp[j] = temp1[j];
            }
            for (int j = 0; j < 128; j++) {
                bitk[j] = temp1[j];
            }
        }
        for (int j = 0; j < 8; j++) {
            subkey[k][j] = subkey_temp[j * 8] << 7 | subkey_temp[j * 8 + 1] << 6 | subkey_temp[j * 8 + 2] << 5 |
                           subkey_temp[j * 8 + 3] << 4 | subkey_temp[j * 8 + 4] << 3 | subkey_temp[j * 8 + 5] << 2 |
                           subkey_temp[j * 8 + 6] << 1 | subkey_temp[j * 8 + 7];

        }
    }
}

void star_encrypt(u8 *k, u8 *p) {
    u8 subkey[20][8] = {0};
    u8 fout[8] = {0};
    u8 temp[8] = {0};
    SubKey(k, subkey);
    for (int i = 0; i < 19; i++) {
        u8 fout[8] = {0};
        F(p[0], subkey[i][0], &fout[0]);
        F(p[2], subkey[i][1], &fout[1]);
        F(p[4], subkey[i][2], &fout[2]);
        F(p[6], subkey[i][3], &fout[3]);
        F(fout[1] ^ p[3], subkey[i][4], &fout[4]);
        F(fout[0] ^ p[1], subkey[i][5], &fout[5]);
        F(fout[3] ^ p[7], subkey[i][6], &fout[6]);
        F(fout[2] ^ p[5], subkey[i][7], &fout[7]);
        temp[0] = fout[5] ^ p[2];
        temp[1] = fout[7] ^ p[6];
        temp[2] = fout[0] ^ p[1];
        temp[3] = fout[6] ^ p[4];
        temp[4] = fout[3] ^ p[7];
        temp[5] = fout[4] ^ p[0];
        temp[6] = fout[1] ^ p[3];
        temp[7] = fout[2] ^ p[5];
        for (int i = 0; i < 8; i++) {
            p[i] = temp[i];
        }
    }
    F(p[0], subkey[19][0], &fout[0]);
    F(p[2], subkey[19][1], &fout[1]);
    F(p[4], subkey[19][2], &fout[2]);
    F(p[6], subkey[19][3], &fout[3]);
    F(fout[1] ^ p[3], subkey[19][4], &fout[4]);
    F(fout[0] ^ p[1], subkey[19][5], &fout[5]);
    F(fout[3] ^ p[7], subkey[19][6], &fout[6]);
    F(fout[2] ^ p[5], subkey[19][7], &fout[7]);
    temp[0] = fout[1] ^ p[3];
    temp[1] = fout[4] ^ p[0];
    temp[2] = fout[0] ^ p[1];
    temp[3] = fout[5] ^ p[2];
    temp[4] = fout[3] ^ p[7];
    temp[5] = fout[6] ^ p[4];
    temp[6] = fout[2] ^ p[5];
    temp[7] = fout[7] ^ p[6];
    for (int i = 0; i < 8; i++) {
        p[i] = temp[i];
    }
}

// 解密
void star_decrypt(u8 *c, u8 *k, u8 *p) {
    u8 subkey[20][8] = {0};
    u8 fout[8] = {0};
    u8 temp[8] = {0};
    u8 c_temp[8] = {0};
    SubKey(k, subkey);
    F(c[0], subkey[19][4], &fout[4]);
    F(c[2], subkey[19][5], &fout[5]);
    F(c[4], subkey[19][6], &fout[6]);
    F(c[6], subkey[19][7], &fout[7]);
    F(fout[4] ^ c[1], subkey[19][0], &fout[0]);
    F(fout[5] ^ c[3], subkey[19][1], &fout[1]);
    F(fout[6] ^ c[5], subkey[19][2], &fout[2]);
    F(fout[7] ^ c[7], subkey[19][3], &fout[3]);
    c_temp[0] = fout[4] ^ c[1];
    c_temp[1] = fout[0] ^ c[2];
    c_temp[2] = fout[5] ^ c[3];
    c_temp[3] = fout[1] ^ c[0];
    c_temp[4] = fout[6] ^ c[5];
    c_temp[5] = fout[2] ^ c[6];
    c_temp[6] = fout[7] ^ c[7];
    c_temp[7] = fout[3] ^ c[4];

    for (int i = 18; i >= 0; i--) {
        u8 fout[8] = {0};
        F(c_temp[6], subkey[i][4], &fout[4]);
        F(c_temp[2], subkey[i][5], &fout[5]);
        F(c_temp[4], subkey[i][6], &fout[6]);
        F(c_temp[7], subkey[i][7], &fout[7]);
        F(fout[4] ^ c_temp[5], subkey[i][0], &fout[0]);
        F(fout[5] ^ c_temp[0], subkey[i][1], &fout[1]);
        F(fout[6] ^ c_temp[3], subkey[i][2], &fout[2]);
        F(fout[7] ^ c_temp[1], subkey[i][3], &fout[3]);
        temp[0] = fout[4] ^ c_temp[5];
        temp[1] = fout[0] ^ c_temp[2];
        temp[2] = fout[5] ^ c_temp[0];
        temp[3] = fout[1] ^ c_temp[6];
        temp[4] = fout[6] ^ c_temp[3];
        temp[5] = fout[2] ^ c_temp[7];
        temp[6] = fout[7] ^ c_temp[1];
        temp[7] = fout[3] ^ c_temp[4];
        for (int i = 0; i < 8; i++) {
            c_temp[i] = temp[i];
        }
    }
    for (int i = 0; i < 8; i++) {
        p[i] = c_temp[i];
    }
}

//
//int main()
//{
//    u8 P[8] = { 0x01,0x23,0x45,0x67,0x89,0xab,0xcd,0xef };
//    u8 K[16] = { 0x01,0x23,0x45,0x67,0x89,0xab,0xcd,0xef,0x01,0x23,0x45,0x67,0x89,0xab,0xcd,0xef };
//    u8 P_C[8] = { 0 };
//    star_encrypt(K, P);
//    printf("加密输出的密文为\n");
//    for (int i = 0; i < 8; i++)
//    {
//        printf("%02x ", P[i]);
//    }
//    printf("\n");
//    star_decrypt(P, K, P_C);
//    printf("\n");
//    printf("解密输出的明文为\n");
//    for (int i = 0; i < 8; i++)
//    {
//        printf("%02x ", P_C[i]);
//    }
//    printf("\n");
//}
