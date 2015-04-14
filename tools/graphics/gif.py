# TODO
# Parse header
# Validate GIF
# Validate 89a
# Validate dimensions
# Validate global color table
# Validate maximum colors?
# Decompress data blocks
# Convert palette
# Convert pixels to characters

class Image(object):
    @classmethod
    def open(class_, buffer):
        return 42