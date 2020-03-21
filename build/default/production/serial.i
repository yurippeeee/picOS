# 1 "serial.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 288 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.10\\pic\\include\\language_support.h" 1 3
# 2 "<built-in>" 2
# 1 "serial.c" 2
# 1 "./defines.h" 1



typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned long uint32;



volatile uint8 WREG __attribute__((address(0xFE8)));
# 1 "serial.c" 2

# 1 "./serial.h" 1






volatile struct eusart EUSART __attribute__((address(0xFAB)));


volatile uint8 BAUDRATE __attribute__((address(0xFB8)));

struct eusart {
    volatile uint8 rcsta;
    volatile uint8 txsta;
    volatile uint8 txreg;
    volatile uint8 rcreg;
    volatile uint8 spbrg;
    volatile uint8 spbrgh;
};


int serial_init();

int serial_is_send_enable();
int serial_send_byte(unsigned char c);
void serial_intr_send_enable();
void serial_intr_send_disable();
int serial_intr_is_send_enable();

int serial_is_recv_enable();
uint8 serial_recv_byte();
void serial_intr_recv_enable();
void serial_intr_recv_disable();
int serial_intr_is_recv_enable();
# 2 "serial.c" 2

# 1 "./port.h" 1

volatile uint8 TRISB __attribute__((address(0xF93)));


volatile uint8 PORTB __attribute__((address(0xF81)));


volatile uint8 ANSELH __attribute__((address(0xF7F)));


volatile uint8 ANSEL __attribute__((address(0xF7E)));


volatile uint8 OSCCON __attribute__((address(0xFD3)));
# 3 "serial.c" 2

# 1 "./intr.h" 1
# 12 "./intr.h"
volatile struct intcon INTCON __attribute__((address(0xFF0)));


volatile struct i_efp I_EFP __attribute__((address(0xF9D)));


volatile uint8 RCON __attribute__((address(0xFD0)));


volatile uint8 STATUS __attribute__((address(0xFD8)));


volatile uint8 BSR __attribute__((address(0xFE0)));

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
# 4 "serial.c" 2


int serial_init()
{
    volatile struct eusart *est = &EUSART;


    TRISB = 0x20;
    ANSELH = 0x00;
    ANSEL = 0x00;


    est->txsta = 0x24;
    est->rcsta = 0x90;
    est->spbrg = 52;
    est->spbrgh = 0;
    return 0;
}

int serial_is_send_enable()
{
    volatile struct eusart *est = &EUSART;
    return (est->txsta & 0x02);
}

int serial_send_byte(unsigned char c)
{
    volatile struct eusart *est = &EUSART;

    while(!serial_is_send_enable());

    est->txreg = c;

    return 0;
}

void serial_intr_send_enable()
{
    __asm("bsf 0xf9d,4");
}
void serial_intr_send_disable()
{
    __asm("bcf 0xf9d,4");
}
int serial_intr_is_send_enable()
{
    volatile struct i_efp *iefp = &I_EFP;
    return (iefp->pie1 & 0x10) ? 1 : 0;
}





int serial_is_recv_enable()
{
    volatile struct i_efp *iefp = &I_EFP;
    return (iefp->pir1 & 0x20);
}

uint8 serial_recv_byte()
{
    volatile struct eusart *est = &EUSART;
    volatile struct i_efp *iefp = &I_EFP;
    uint8 c;

    while(!serial_is_recv_enable());

    c = est->rcreg;
    __asm("bcf 0xf9e,5");

    return c;
}

void serial_intr_recv_enable()
{
    __asm("bsf 0xf9d,5");
}
void serial_intr_recv_disable()
{
    __asm("bcf 0xf9d,5");
}
int serial_intr_is_recv_enable()
{
    volatile struct i_efp *iefp = &I_EFP;
    return (iefp->pie1 & 0x20) ? 1 : 0;
}
