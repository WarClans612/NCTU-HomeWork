#!/bin/sh

if [ ! -d "build" ]; then
# mkdir build && cd build
# cmake ..
    # echo "hh"
    mkdir build
fi

cd build
cmake ..
make
cp serial_m ../
cd ..
