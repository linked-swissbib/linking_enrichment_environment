#!/bin/bash
#bensamfx
#5.8.16

# Copies reshapeRDF binaries and resources to program directories
# ! Is machine specific


# Delete old binaries
rm -rf /usr/local/swissbib/reshaperLab/*

# Copy new binaries etc. to the location
cp -r reshaper-tool/* /usr/local/swissbib/reshaperLab

echo Done

