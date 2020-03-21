#ifndef _DEFINES_H_INCLUDED_
#define _DEFINES_H_INCLUDED_

typedef unsigned char  uint8;
typedef unsigned short uint16;
typedef unsigned long  uint32;

#define NULL 0
#define WREG WREG
volatile uint8 WREG __at(0xFE8);

typedef uint32 pic_thread_id_t;
typedef int (*pic_func_t)(int argc, char *argv[]);
typedef void (*pic_handler_t)(void);

#endif