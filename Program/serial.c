#include "defines.h"
#include "serial.h"
#include "port.h"
#include "intr.h"

int serial_init()
{
    volatile struct eusart *est = &EUSART;
    
    //?????
    TRISB = 0x20;
    ANSELH = 0x00;
    ANSEL = 0x00;
    
    //EUSART??
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
    asm("bsf 0xf9d,4");
}
void serial_intr_send_disable()
{
    asm("bcf 0xf9d,4");
}
int serial_intr_is_send_enable()
{
    volatile struct i_efp *iefp  =  &I_EFP;
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
    asm("bcf 0xf9e,5");
    //iefp->pir1 &= 0x00;
    return c;
}

void serial_intr_recv_enable()
{
    asm("bsf 0xf9d,5");
}
void serial_intr_recv_disable()
{
    asm("bcf 0xf9d,5");
}
int serial_intr_is_recv_enable()
{
    volatile struct i_efp *iefp  =  &I_EFP;
    return (iefp->pie1 & 0x20) ? 1 : 0;    
}