#include "defines.h"

#define TMR0 TMR0
volatile struct tmr0 TMR0 __at(0xFD5);

#define TMR1 TMR1
volatile struct tmr1 TMR1 __at(0xFCD);

#define TMR2 TMR2
volatile struct tmr2 TMR2 __at(0xFCA);

#define TMR3 TMR3
volatile struct tmr3 TMR3 __at(0xFB1);


struct tmr0 {
    volatile uint8 t0con;
    volatile uint8 tmr0l;
    volatile uint8 tmr0h;
};

struct tmr1 {
    volatile uint8 t1con;
    volatile uint8 tmr1l;
    volatile uint8 tmr1h;
};

struct tmr2 {
    volatile uint8 t2con;
    volatile uint8 pr2;
    volatile uint8 tmr2;
};

struct tmr3 {
    volatile uint8 t3con;
    volatile uint8 tmr3l;
    volatile uint8 tmr3h;
};