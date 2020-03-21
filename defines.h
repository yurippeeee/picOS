#ifndef _DEFINES_H_INCLUDED_
#define _DEFINES_H_INCLUDED_

typedef unsigned char  uint8;
typedef unsigned short uint16;
typedef unsigned long  uint32;

#define NULL (void(*0))
#define WREG WREG
volatile uint8 WREG __at(0xFE8);

#endif