#!/bin/sh

# Remove object files, listings, ROM files, and symbol files
find . -name "*.o"   -type f | xargs rm
find . -name "*.lst" -type f | xargs rm
find . -name "*.rom" -type f | xargs rm
find . -name "*.sym" -type f | xargs rm