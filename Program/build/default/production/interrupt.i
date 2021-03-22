# 1 "interrupt.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 288 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.10\\pic\\include\\language_support.h" 1 3
# 2 "<built-in>" 2
# 1 "interrupt.c" 2
# 1 "./defines.h" 1



typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned long uint32;



volatile uint8 WREG __attribute__((address(0xFE8)));

typedef uint32 pic_thread_id_t;
typedef int (*pic_func_t)(int argc, char *argv[]);
typedef void (*pic_handler_t)(void);
# 1 "interrupt.c" 2

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
# 2 "interrupt.c" 2

# 1 "./interrupt.h" 1



static char softvec;


typedef short softvec_type_t;
typedef void (*softvec_handler_t)(softvec_type_t type, unsigned long sp);



int softvec_init(void);
int softvec_setintr(softvec_type_t type, softvec_handler_t handler);
void soft_interrupt(softvec_type_t type, unsigned long sp);
# 3 "interrupt.c" 2


int softvec_init(void)
{
    int type;
    for(type = 0; type < 2; type++)
        softvec_setintr(type, 0);
    return 0;
}

int softvec_setintr(softvec_type_t type, softvec_handler_t handler)
{
    ((softvec_handler_t *)(&softvec))[type] = handler;
    return 0;
}

void soft_interrupt(softvec_type_t type, unsigned long sp)
{
    softvec_handler_t handler = ((softvec_handler_t *)(&softvec))[type];
    if(handler)
        handler(type, sp);
}
