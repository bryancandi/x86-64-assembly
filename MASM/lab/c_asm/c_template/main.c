/*
 * main.c
 *
 * C driver program to demonstrate calling printf() from assembly language.
 */

#include <stdio.h>

extern void asmFunc(void); // Declare external assembly function

int main(void)
{
    printf("Calling asmFunc:\n");
    asmFunc();
    printf("Returned from asmFunc\n");
    return 0;
}
