#!/bin/bash

nasm -g -F dwarf -f elf64 $1.asm -o $1.o
gcc $1.o -o $1
