#include "include/MyC.h"
#include "stdio.h"

void my_c_func1()
{
    printf("++++++++++++ my_c_func1()\n");
}

void my_c_func2(struct tty *tty)
{
    printf("\n");
    printf("(*tty).num1: %x\n", (*tty).num1);
    (*tty).num1 = 888;
}

void my_c_func3(struct tty tty)
{
    printf("\n");
    printf("tty.num1: %x\n", tty.num1);
    tty.num1 = 888;
    printf("&tty: %p\n", &tty);
}

void createPseudoTerminal(struct tty **tty)
{
    printf("\n");
    printf("createPseudoTerminal()\n");
    printf("(*tty)->num1: %x\n", (*tty)->num1);
    printf("(**tty).num2: %x\n", (**tty).num2);
    // printf("**tty: %x\n", **tty);
    printf("*tty: %p\n", *tty);
    printf("tty: %p\n", tty);
    printf("&tty: %p\n", &tty);
    (*tty)->num1 = 1;
    (**tty).num2 = 2;
    printf("(*tty)->num1: %x\n", (*tty)->num1);
    printf("(**tty).num2: %x\n", (**tty).num2);
    printf("\n");
    // *tty = pty_open_fake(&ios_pty_driver);
    // if (IS_ERR(*tty))
    //     return nil;
    // return (__bridge Terminal *) (*tty)->data;
}
