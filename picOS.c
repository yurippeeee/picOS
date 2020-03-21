#include "defines.h"
#include "picOS.h"
#include "intr.h"
#include "syscall.h"
#include "lib.h"

#define THREAD_NUM 6
#define THREAD_NAME_SIZE 15

uint8 userstack[THREAD_NUM*6];
uint8 userstack_pointer;

//??????????????????
typedef struct _pic_context{
    uint8 sp;
}pic_context;

//????????
typedef struct _pic_thread{
    struct _pic_thread *next;
    char name[THREAD_NAME_SIZE+1];
    char stack;
    
    struct {
        pic_fanc_t func;
        int argc;
        char **argv;
    }init;
    
    struct {
        pic_syscall_type_t type;
        pic_syscall_param_t *param;
    }syscall;
    
    pic_context context;
}pic_thread;

//???????????????????
static struct {
    pic_thread *head;
    pic_thread *tail;
}readyque;


static pic_thread *current;                 //??????????
static pic_thread threads[THREAD_NUM];      //???????
static pic_handler_t handlers[1];           //???????????

//?????????????
void dispatch(pic_context *context)
{
    WREG = *(++context);
    STATUS = *(++context);
    BSR = *(++context);
}

//??????????
static int getcurrent(void)
{
    if(current == NULL)
    {
        return -1;
    }
    
    readyque.head =current->next;
    if(readyque.head == NULL)
    {
        readyque.tail = NULL;
    }
    
    current->next = NULL;
    
    return 0;
}

//????????????????????
static int putcurrent(void)
{
    if(current == NULL)
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

//??????????
static void thread_end(void)
{
    pic_exit();
}

//?????????????????
static void thread_init(pic_thread *thp)
{
    thp->init.func(thp->init.argc, thp->init.argv);
    thread_end();
}

//???????(??????????)
static pic_thread_id_t thread_run(pic_func_t func, char *name, int stacksize, int argc, char *argv[])
{
    int i;
    pic_thread *thp;
    uint8 *sp;
    static char 
    thread_stack = userstack_pointer;
    
    for (i=0; i<THREADNUM; i++)
    {
        thp = &threads[i];
        if(!thp->init.func)
            break;
    }
    if(i == THREAD_NUM)
        return -1;
    
    memset(thp, 0, sizeof(*thp));
    
    strcpy(thp->name, name);
    thp->next = NULL;
    
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

//???????(?????????????)
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

//??????????
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

//????????????
static void syscall_proc(pic_syscall_type_t type, pic_syscall_param_t *p)
{
    getcurrent();
    call_functions(type, p);
}

//?????????????
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