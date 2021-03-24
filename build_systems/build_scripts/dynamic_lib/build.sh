#!/bin/bash

CXX=c++

# Compile lib code
$CXX -fPIC -c lib.cc -o lib.o

# Build dynamic lib
$CXX -shared -Wl,-o,liblib.so lib.o

# Build binary with dynamic library dependency
$CXX main.cc -L. -llib -o main

# export LD_LIBRARY_PATH/DYLD_LIBRARY_PATH to find SO

