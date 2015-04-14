#!/usr/bin/python

import argparse
import struct

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

# Validate GIF file header
try:
    header = struct.unpack("<3s3shhb", file.read(11))

    id = header[0]
    version = header[1]

    if id == "GIF" and (version != "87a" and version != "89a"):
        raise Exception
except:
    print "\"{}\" is not a valid GIF file".format(source)
    exit()

# Validate maximum sprite width and height
width = header[2]
height = header[3]

if width > 64 or height > 64:
    print "Unable to convert \"{}\" because its width or height exceeds 64 pixels".format(source)
    exit()

# Check that the file has a global color table
fields = header[4]

if not fields & 0x80:
    print "Unable to convert \"{}\" because it does not have a global color table".format(source)
    exit()

#