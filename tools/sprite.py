#!/usr/bin/python

import argparse

parser = argparse.ArgumentParser(description="Converts a sprite stored as a GIF file into its VRAM (character) and CGRAM (palette) data.")
parser.add_argument("source", type=str)
args = parser.parse_args()

source = args.source

# Validate file extension
if source.endswith(".gif") == False:
    print "Only .gif files are supported"
    exit()

# Check that file exists and we have access to it
try:
    file = open(source, 'r')
except IOError as err:
    print "Unable to open \"{}\"".format(source)
    exit()

#