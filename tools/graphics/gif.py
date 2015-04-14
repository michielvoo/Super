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
            raise ValueError("Invalid GIF file, only GIF89a is supported")

#