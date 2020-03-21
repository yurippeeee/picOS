#ifndef _KOZOS_SYSCALL_H_INCLUDED_
#define _KOZOS_SYSCALL_H_INCLUDED_

#include "defines.h"

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

#endif