# 1 "main.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 288 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.10\\pic\\include\\language_support.h" 1 3
# 2 "<built-in>" 2
# 1 "main.c" 2
#pragma config FOSC = IRC
#pragma config PLLEN = OFF
#pragma config PCLKEN = ON
#pragma config FCMEN = OFF
#pragma config IESO = OFF


#pragma config PWRTEN = OFF
#pragma config BOREN = SBORDIS
#pragma config BORV = 19


#pragma config WDTEN = OFF
#pragma config WDTPS = 32768


#pragma config HFOFST = ON
#pragma config MCLRE = OFF


#pragma config STVREN = ON
#pragma config LVP = ON
#pragma config BBSIZ = OFF
#pragma config XINST = OFF


#pragma config CP0 = OFF
#pragma config CP1 = OFF


#pragma config CPB = OFF
#pragma config CPD = OFF


#pragma config WRT0 = OFF
#pragma config WRT1 = OFF


#pragma config WRTC = OFF
#pragma config WRTB = OFF
#pragma config WRTD = OFF


#pragma config EBTR0 = OFF
#pragma config EBTR1 = OFF


#pragma config EBTRB = OFF






# 1 "./serial.h" 1
# 1 "./defines.h" 1



typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned long uint32;



volatile uint8 WREG __attribute__((address(0xFE8)));

typedef uint32 pic_thread_id_t;
typedef int (*pic_func_t)(int argc, char *argv[]);
typedef void (*pic_handler_t)(void);
# 1 "./serial.h" 2






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
# 54 "main.c" 2

# 1 "./lib.h" 1





int putc(unsigned char c);
int puts(unsigned char *str);
unsigned char getc(void);
int gets(unsigned char *buf);


void *memset(void *buf, int ch, long n);
void *memcpy(void * restrict s1, const void * restrict s2, long n);
int memcmp(const void *buf1, const void *buf2, long n);


int strlen(const char *s);
char *strcpy(char * restrict s1, const char * restrict s2);
int strcmp(const char *s1, const char *s2);
int strncmp(const char *s1, const char *s2, int len);


int putxval(unsigned long value, int column);
# 55 "main.c" 2

# 1 "./port.h" 1

volatile uint8 TRISB __attribute__((address(0xF93)));


volatile uint8 PORTB __attribute__((address(0xF81)));


volatile uint8 ANSELH __attribute__((address(0xF7F)));


volatile uint8 ANSEL __attribute__((address(0xF7E)));


volatile uint8 OSCCON __attribute__((address(0xFD3)));
# 56 "main.c" 2

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
# 57 "main.c" 2


extern volatile uint8 intr_stack[3];


void main(void) {
    OSCCON = 0x62;
    serial_init();
    intr_init();
    serial_intr_send_enable();
    serial_intr_recv_enable();

    while(1){

        puts("Hello takuya!\n");
        for(int i=0; i<100; i++)
            for(int j=0; j<100; j++);

    }
    return;
}

void __attribute__((picinterrupt(("")))) isr(void)
{
    volatile struct intcon *itc = &INTCON;


    intr_stack[0] = WREG;
    intr_stack[1] = STATUS;
    intr_stack[2] = BSR;


    itc->intcon = 0x00;
    intr();
    itc->intcon = 0xC0;


    BSR = intr_stack[2];
    WREG = intr_stack[0];
    STATUS = intr_stack[1];

}
