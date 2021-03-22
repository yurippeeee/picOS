# 1 "syscall.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 288 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "C:\\Program Files (x86)\\Microchip\\xc8\\v2.10\\pic\\include\\language_support.h" 1 3
# 2 "<built-in>" 2
# 1 "syscall.c" 2
# 1 "./defines.h" 1



typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned long uint32;



volatile uint8 WREG __attribute__((address(0xFE8)));

typedef uint32 pic_thread_id_t;
typedef int (*pic_func_t)(int argc, char *argv[]);
typedef void (*pic_handler_t)(void);
# 1 "syscall.c" 2

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
# 2 "syscall.c" 2



pic_thread_id_t pic_run(pic_func_t func, char *name, int stacksize, int argc, char *argv[])
{
    pic_syscall_param_t param;
    param.un.run.func = func;
    param.un.run.name = name;
    param.un.run.stacksize = stacksize;
    param.un.run.argc = argc;
    param.un.run.argv = argv;
    pic_syscall(PIC_SYSCALL_TYPE_RUN, &param);
    return param.un.run.ret;
}

void pic_exit(void)
{
    pic_syscall(PIC_SYSCALL_TYPE_EXIT, 0);
}
