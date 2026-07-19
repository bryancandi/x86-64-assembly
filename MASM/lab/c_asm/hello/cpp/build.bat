@echo off

ml64.exe /c asmfunc.asm
cl.exe hello.cpp asmfunc.obj
