#include "defines.h"

#ifndef _SERIAL_H_INCLUDED_
#define _SERIAL_H_INCLUDED_

#define EUSART EUSART
volatile struct eusart  EUSART __at(0xFAB);

#define BAUDRATE BAUDRATE
volatile uint8 BAUDRATE __at(0xFB8);
//EUSART??????
struct eusart {
    volatile uint8 rcsta;
    volatile uint8 txsta;
    volatile uint8 txreg;
    volatile uint8 rcreg;
    volatile uint8 spbrg;
    volatile uint8 spbrgh;
};

//???????????
int serial_init();
//??????????
int serial_is_send_enable();
int serial_send_byte(unsigned char c);
void serial_intr_send_enable();
void serial_intr_send_disable();
int serial_intr_is_send_enable();
//??????????
int serial_is_recv_enable();
uint8 serial_recv_byte();
void serial_intr_recv_enable();
void serial_intr_recv_disable();
int serial_intr_is_recv_enable();

#endif
