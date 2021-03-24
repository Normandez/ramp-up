#!/bin/bash

CXX=c++
ARCHIVE=ar

# Compile lib
$CXX -c lib.cc -o lib.o

# Create static lib
$ARCHIVE rcs liblib.a lib.o

# Build main with statically linked liblib.a
$CXX main.cc -L. -llib -o main

