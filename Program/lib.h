#include "defines.h"
#ifndef _LIB_H_INCLUDED_
#define _LIB_H_INCLUDED_

//USART??
int putc(unsigned char c);
int puts(unsigned char *str);
unsigned char getc(void);
int gets(unsigned char *buf);

//???????
void *memset(void *buf, int ch, long n);
void *memcpy(void * restrict s1, const void * restrict s2, long n);
int memcmp(const void *buf1, const void *buf2, long n);

//char??????
int strlen(const char *s);
char *strcpy(char * restrict s1, const char * restrict s2);
int strcmp(const char *s1, const char *s2);
int strncmp(const char *s1, const char *s2, int len);

//?????
int putxval(unsigned long value, int column);
#endif