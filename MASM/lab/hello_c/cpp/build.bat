@echo off

ml64.exe /c asmfunc.asm
cl.exe c.cpp asmfunc.obj
