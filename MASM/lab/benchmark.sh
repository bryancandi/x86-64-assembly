#!/bin/bash

INPUT=370
RUNS=1000

time {
  for ((i=0; i<RUNS; i++)); do
    printf "%s\n" "$INPUT" | ./fibonacci256.exe > /dev/null
  done
}
