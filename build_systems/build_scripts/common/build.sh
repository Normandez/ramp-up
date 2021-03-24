#!/bin/bash

ASM=as
CXX=c++
LINK=ld

# Preprocess
$CXX -E main.cc -o main.i

# Compile
$CXX -S main.i -o main.s

# Assembly
$ASM main.s -o main.o

# Steps 1-3 can be replaced with the following single command
# c++ -c main.cc -o main.o 

# Linkage
$LINK main.o -lc -lstdc++ -o main

