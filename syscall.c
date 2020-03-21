#include "defines.h"
#include "picOS.h"
#include "syscall.h"

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
    pic_syscall(PIC_SYSCALL_TYPE_EXIT, NULL);
}