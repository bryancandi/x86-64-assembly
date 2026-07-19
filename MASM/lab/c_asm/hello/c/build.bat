@echo off

ml64.exe /c asmfunc.asm
cl.exe hello.c asmfunc.obj
