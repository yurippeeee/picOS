#include "defines.h"

#define SOFTVEC_TYPE_NUM         2

//????????
#define SOFTVEC_TYPE_SOFTERR     0
#define SOFTVEC_TYPE_SYSCALL     1


//?????????????
#define INTCON INTCON
volatile struct intcon  INTCON __at(0xFF0);

#define I_EFP I_EFP
volatile struct i_efp   I_EFP  __at(0xF9D);

#define RCON RCON
volatile uint8 RCON __at(0xFD0);

#define STATUS STATUS
volatile uint8 STATUS __at(0xFD8);

#define BSR BSR
volatile uint8 BSR __at(0xFE0);

volatile uint8 intr_stack[3];


struct intcon {
    volatile uint8 intcon3;
    volatile uint8 intcon2;
    volatile uint8 intcon;
};

struct i_efp {
    volatile uint8 pie1;
    volatile uint8 pir1;
    volatile uint8 ipr1;
    volatile uint8 pie2;
    volatile uint8 pir2;
    volatile uint8 ipr2;
};

void intr_init();
void intr();