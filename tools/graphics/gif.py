import struct

class Image(object):
    @classmethod
    def open(class_, buffer):
        return Image(buffer)

    header = {}

    def __init__(self, buffer):
        data = struct.unpack("<3s3shhb", buffer.read(11))
        self.header["id"] = data[0]
        self.header["version"] = data[1]
        pass
