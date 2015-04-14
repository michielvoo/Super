import struct

class Image(object):
    @classmethod
    def open(class_, buffer):
        return Image(buffer)

    def __init__(self, buffer):
        try:
            header = struct.unpack("<3s3shhb", buffer.read(11))
        except struct.error:
            raise ValueError("Invalid GIF file")

        self._id = header[0]
        self._version = header[1]
        
        if self._id != "GIF" or self._version != "89a":
            raise ValueError("Unsupported GIF image, only GIF89a is supported")

        self.dimensions = (header[2], header[3])

        if any(d > 64 for d in self.dimensions):
            raise ValueError("Unsupported GIF image, dimensions may not exceed 64 by 64 pixels")

        self._fields = header[4]

        if not self._fields & 0x80:
            raise ValueError("Unsupported GIF image, no global color table")


#