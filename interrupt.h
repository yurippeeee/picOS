#ifndef _INTERRUPT_H_INCLUDED_
#define _INTERRUPT_H_INCLUDED_

static char softvec;
#define SOFTVEC_ADDR (&softvec)

typedef short softvec_type_t;
typedef void (*softvec_handler_t)(softvec_type_t type, unsigned long sp);

#define SOFTVECS ((softvec_handler_t *)SOFTVEC_ADDR)

int softvec_init(void);
int softvec_setintr(softvec_type_t type, softvec_handler_t handler);
void soft_interrupt(softvec_type_t type, unsigned long sp);

#endif