#!/bin/bash

nasm -f elf64 $1.asm -o $1.o
gcc $1.o -o $1
