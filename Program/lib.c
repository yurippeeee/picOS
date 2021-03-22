#include "defines.h"
#include "serial.h"
int putc(unsigned char c)
{
    if(c == '\n')
        serial_send_byte('\r');
    return serial_send_byte(c);
}

int puts(unsigned char *str)
{
    while(*str)
        putc(*(str++));
    return 0;
}

unsigned char getc(void)
{
    unsigned char c = serial_recv_byte();
    c = (c == '\r') ? '\n' : c;
    putc(c);
    return c;
}

int gets(unsigned char *buf)
{
    int i=0;
    unsigned char c;
    do {
        c = getc();
        if(c == '\n')
            c = '\0';
        buf[i++] = c;
    }while (c);
    return i-1;
}

void *memset(void *buf, int ch, long n)
{
    char *p;
    for(p=buf; n>0; n--)
        *(p++)=ch;
    return buf;
}

void *memcpy(void * restrict s1, const void * restrict s2, uint16 n)
{
    char *d = s1;
    const char *s = s2;
    while(n>0)
    {
        *(d++) = *(s++);
        n--;
    }
    return s1;
}

int memcmp(const void *buf1, const void *buf2, long n)
{
    const char *p1 = buf1;
    const char *p2 = buf2;
    while(n>0)
    {
        if(*p2 != *p1)
            return (*p1 > *p2) ? 1 : -1;
        p1++;
        p2++;
    }
    return 0;
}

int strlen(const char *s)
{
    int n = 0;
    while(*s)
    {
        s++;
        n++;
    }
    return n;
}

char *strcpy(char * restrict s1, const char * restrict s2)
{   
    while(*s2)
    {
        *s1 = *s2;
    }
    return s1;
}

int strcmp(const char *s1, const char *s2)
{
    while(*s1 || *s2)
    {
        if(*s1 != *s2)
            return (*s1 > *s2) ? 1 : -1;
        s1++;
        s2++;
    }
    return 0;
}

int strncmp(const char *s1, const char *s2, int len)
{
    while((*s1 || *s2) && (len > 0))
    {
        if(*s1 != *s2)
            return (*s1 > *s2) ? 1 : -1;
        s1++;
        s2++;
        len--;
    }
}

int putxval(unsigned long value, int column)
{
    char buf[9];
    char *p;
    p = buf + sizeof(buf) - 1;
    *(p--) = '\0';
    
    if(!value && !column)
        column++;
    
    while(value || column)
    {
        *(p--) = "0123456789"[value & 0xf];
        value >>= 4;
        if(column)
            column--;
    }
    
    puts(p+1);
    
    return 0;
}