#!/bin/bash

set -e

echo "Making Files ..."
make -f Makefile

echo "Brewing ..."
source ./macsetup

echo "linking your files ..."
source ./linkfolders

echo "installing files and folders ..."
source ./install

echo "Done."
