#include "lib.h"
#include "intr.h"
#include "defines.h"

//??????????????
#define USART_RX_E

void intr_init()
{
    RCON = 0x00;
    volatile struct intcon *itc  =  &INTCON;
    itc->intcon = 0xC0;
}



void intr()
{
    volatile struct intcon *itc  =  &INTCON;
    volatile struct i_efp *iefp  =  &I_EFP;
    
#ifdef TMR0_E
    if(itc->intcon & 0x04)
        tmr0();
#endif 
    
#ifdef INT0_E
    if(itc->intcon & 0x02)
        int0();
#endif
    
#ifdef RAB_E
    if(itc->intcon & 0x01)
        rab();
#endif
    
#ifdef INT1_E
    if(itc->intcon3 & 0x01)
        int1();
#endif
    
#ifdef INT2_E
    if(itc->intcon3 & 0x02)
        int2();
#endif
    
#ifdef TMR1_E
    if(iefp->pir1 & 0x01)
        tmr1();
#endif
    
#ifdef TMR2_E
    if(iefp->pir1 & 0x02)
        tmr2();
#endif
    
#ifdef CCP1_E
    if(iefp->pir1 & 0x04)
        ccp1();
#endif
    
#ifdef MSSP_E
    if(iefp->pir1 & 0x08)
        mssp();
#endif
    
#ifdef USART_TX_E
    if(iefp->pir1 & 0x10)
        puts();
#endif
    
#ifdef USART_RX_E
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
#endif
    
#ifdef AD_E
    if(iefp->pir1 & 0x40)
        ad();
#endif
    
#ifdef TMR3_E
    if(iefp->pir2 & 0x02)
        tmr3();
#endif
    
#ifdef BUS_COL_E
    if(iefp->pir2 & 0x08)
        bus_col();
#endif
    
#ifdef EEPROM_E
    if(iefp->pir2 & 0x10)
        eeprom();
#endif
    
#ifdef COMP2_E
    if(iefp->pir2 & 0x20)
        comp2();
#endif
    
#ifdef COMP1_E
    if(iefp->pir2 & 0x40)
        comp1();
#endif
    
#ifdef OSC_FAIL_E
    if(iefp->pir2 & 0x80)
        osc_fail();
#endif
}