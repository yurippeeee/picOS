#ifndef _picOS_H_INCLUDED_
#define _picOS_H_INCLUDED_

#include "defines.h"
#include "syscall.h"

pic_thread_id_t pic_run(pic_func_t func, char *name, int stacksize, int argc, char *argv[]);

void pic_exit(void);

void pic_start(pic_func_t func, char *name, int stacksize, int argc, char *argv[]);

void pic_sysdown(void);

void pic_syscall(pic_syscall_type_t type, pic_syscall_param_t *param);

int test_main(int argc, char *argv[]);

#endif

