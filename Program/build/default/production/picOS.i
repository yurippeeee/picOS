# 1 "picOS.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 288 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.10\\pic\\include\\language_support.h" 1 3
# 2 "<built-in>" 2
# 1 "picOS.c" 2
# 1 "./defines.h" 1



typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned long uint32;



volatile uint8 WREG __attribute__((address(0xFE8)));

typedef uint32 pic_thread_id_t;
typedef int (*pic_func_t)(int argc, char *argv[]);
typedef void (*pic_handler_t)(void);
# 1 "picOS.c" 2

# 1 "./picOS.h" 1




# 1 "./syscall.h" 1





typedef enum {
    PIC_SYSCALL_TYPE_RUN = 0,
    PIC_SYSCALL_TYPE_EXIT,
}pic_syscall_type_t;

typedef struct {
    union {
        struct {
            pic_func_t func;
            char *name;
            int stacksize;
            int argc;
            char **argv;
            pic_thread_id_t ret;
        }run;
        struct {
            int dummy;
        }exit;
    }un;
}pic_syscall_param_t;
# 5 "./picOS.h" 2


pic_thread_id_t pic_run(pic_func_t func, char *name, int stacksize, int argc, char *argv[]);

void pic_exit(void);

void pic_start(pic_func_t func, char *name, int stacksize, int argc, char *argv[]);

void pic_sysdown(void);

void pic_syscall(pic_syscall_type_t type, pic_syscall_param_t *param);

int test_main(int argc, char *argv[]);
# 2 "picOS.c" 2

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
# 3 "picOS.c" 2


# 1 "./lib.h" 1





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
# 5 "picOS.c" 2

# 1 "./interrupt.h" 1



static char softvec;


typedef short softvec_type_t;
typedef void (*softvec_handler_t)(softvec_type_t type, unsigned long sp);



int softvec_init(void);
int softvec_setintr(softvec_type_t type, softvec_handler_t handler);
void soft_interrupt(softvec_type_t type, unsigned long sp);
# 6 "picOS.c" 2





uint8 userstack[6*6];
static char userstack_pointer = 0;


typedef struct _pic_context{
    uint8 sp;
}pic_context;


typedef struct _pic_thread{
    struct _pic_thread *next;
    char name[15 +1];
    char stack;

    struct {
        pic_func_t func;
        int argc;
        char **argv;
    }init;

    struct {
        pic_syscall_type_t type;
        pic_syscall_param_t *param;
    }syscall;

    pic_context context;
}pic_thread;


static struct {
    pic_thread *head;
    pic_thread *tail;
}readyque;


static pic_thread *current;
static pic_thread threads[6];
static pic_handler_t handlers[1];


void dispatch(pic_context *context)
{
    WREG = *(++context);
    STATUS = *(++context);
    BSR = *(++context);
}


static int getcurrent(void)
{
    if(current == 0)
    {
        return -1;
    }

    readyque.head =current->next;
    if(readyque.head == 0)
    {
        readyque.tail = 0;
    }

    current->next = 0;

    return 0;
}


static int putcurrent(void)
{
    if(current == 0)
    {
        return -1;
    }

    if(readyque.tail)
    {
        readyque.tail->next = current;
    }
    else
    {
        readyque.head = current;
    }
    readyque.tail = current;

    return 0;
}


static void thread_end(void)
{
    pic_exit();
}


static void thread_init(pic_thread *thp)
{
    thp->init.func(thp->init.argc, thp->init.argv);
    thread_end();
}


static pic_thread_id_t thread_run(pic_func_t func, char *name, int stacksize, int argc, char *argv[])
{
    int i;
    pic_thread *thp;
    uint8 *sp;
    static char thread_stack = userstack_pointer;

    for (i=0; i<6; i++)
    {
        thp = &threads[i];
        if(!thp->init.func)
            break;
    }
    if(i == 6)
        return -1;

    memset(thp, 0, sizeof(*thp));

    strcpy(thp->name, name);
    thp->next = 0;

    thp->init.func = func;
    thp->init.argc = argc;
    thp->init.argv = argv;

    memset(thread_stack, 0, stacksize);
    thread_stack += stacksize;

    thp->stack = thread_stack;

    sp = (uint8 *)thp->stack;
    *(--sp) = (uint8)thread_end;
    *(--sp) = (uint8)thread_init;

    *(--sp) = 0;
    *(--sp) = 0;
    *(--sp) = 0;

    *(--sp) = (uint32)thp;

    thp->context.sp = (uint32)thp;
    thp->context.sp = (uint32)sp;

    putcurrent();
    current = thp;
    putcurrent();

    return (pic_thread_id_t)current;
}


static int thread_exit(void)
{
    puts(current->name);
    puts("EXIT.\n");
    memset(current, 0, sizeof(*current));
    return 0;
}

static int setintr(softvec_type_t type, pic_handler_t handler)
{
    static void thread_intr(softvec_type_t type, unsigned long sp);

    softvec_setintr(type, thread_intr);
    handlers[type] = handler;

    return 0;
}


static void call_functions(pic_syscall_type_t type, pic_syscall_param_t *p)
{
    switch (type)
    {
        case PIC_SYSCALL_TYPE_RUN:
            p->un.run.ret = thread_run(p->un.run.func, p->un.run.name, p->un.run.stacksize, p->un.run.argc, p->un.run.argv);
            break;
        case PIC_SYSCALL_TYPE_EXIT:
            thread_exit();
            break;
        default:
            break;
    }
}


static void syscall_proc(pic_syscall_type_t type, pic_syscall_param_t *p)
{
    getcurrent();
    call_functions(type, p);
}


static void schedule(void)
{
    if(!readyque.head)
        pic_sysdown();

    current = readyque.head;
}

static void syscall_intr(void)
{
    syscall_proc(current->syscall.type, current->syscall.param);
}

static void softerr_intr(void)
{
    puts(current->name);
    puts("DOWN.\n");
    getcurrent();
    thread_exit();
}

static void thread_intr(softvec_type_t type, unsigned long sp)
{
    current->context.sp = sp;
    if(handlers[type])
        handlers[type]();

    schedule();

    dispatch(&current->context);
}

void pic_start(pic_func_t func, char *name, int stacksize, int argc, char *argv[])
{
    current = 0;

    readyque.head = readyque.tail = 0;
    memset(threads, 0, sizeof(threads));
    memset(handlers, 0, sizeof(handlers));

    setintr(1, syscall_intr);
    setintr(0, softerr_intr);

    current = (pic_thread *)thread_run(func, name, stacksize, argc, argv);
    dispatch(&current->context);
}

void pic_sysdown(void)
{
    puts("system error!\n");
    while(1);
}

void pic_syscall(pic_syscall_type_t type, pic_syscall_param_t *param)
{
    current->syscall.type = type;
    current->syscall.param = param;
}
