# 1 "intr.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 288 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.10\\pic\\include\\language_support.h" 1 3
# 2 "<built-in>" 2
# 1 "intr.c" 2
# 1 "./lib.h" 1
# 1 "./defines.h" 1



typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned long uint32;



volatile uint8 WREG __attribute__((address(0xFE8)));
# 1 "./lib.h" 2





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
# 1 "intr.c" 2

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
# 2 "intr.c" 2






void intr_init()
{
    RCON = 0x00;
    volatile struct intcon *itc = &INTCON;
    itc->intcon = 0xC0;
}



void intr()
{
    volatile struct intcon *itc = &INTCON;
    volatile struct i_efp *iefp = &I_EFP;
# 73 "intr.c"
    if(iefp->pir1 & 0x20)
    {
        int c;
        static char buf[32];
        static int len;

        c=getc();

        if(c != '\n')
        {
            buf[len++] = c;
        }
        else
        {
            buf[len++] = '\0';
            if(!strncmp(buf, "echo", 4))
            {
                puts(buf+4);
                puts("\n");
            }
            else
            {
                puts("unkown.\n");
            }
            puts("> ");
            len = 0;
        }

    }
# 138 "intr.c"
}
