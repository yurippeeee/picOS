#define TRISB TRISB
volatile uint8 TRISB __at(0xF93);

#define PORTB PORTB
volatile uint8 PORTB __at(0xF81);

#define ANSELH ANSELH
volatile uint8 ANSELH __at(0xF7F);

#define ANSEL ANSEL
volatile uint8 ANSEL __at(0xF7E);

#define OSCCON OSCCON
volatile uint8 OSCCON __at(0xFD3);