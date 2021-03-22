# 1 "lib.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 288 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.10\\pic\\include\\language_support.h" 1 3
# 2 "<built-in>" 2
# 1 "lib.c" 2
# 1 "./defines.h" 1



typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned long uint32;



volatile uint8 WREG __attribute__((address(0xFE8)));

typedef uint32 pic_thread_id_t;
typedef int (*pic_func_t)(int argc, char *argv[]);
typedef void (*pic_handler_t)(void);
# 1 "lib.c" 2

# 1 "./serial.h" 1






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
# 2 "lib.c" 2

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
