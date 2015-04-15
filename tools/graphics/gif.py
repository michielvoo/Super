import struct

class Image(object):
    @classmethod
    def open(class_, buffer):
        return Image(buffer)

    def __init__(self, buffer):
        try:
            header = struct.unpack("<3s3shhB", buffer.read(11))
        except struct.error:
            raise ValueError("Invalid GIF file")

        # Initialize fields
        self._id = header[0]
        self._version = header[1]
        self.dimensions = (header[2], header[3])
        self._fields = header[4]
        self._color_depth = (self._fields & 0x07) + 1
        
        self._validate()

    """ Performs several checks on the GIF file to determine if it is supported. This method will 
        raise an exception if the GIF file uses unsupported features.
    """
    def _validate(self):
        if self._id != "GIF" or self._version != "89a":
            raise ValueError("GIF89a images are not supported")

        if any(d > 64 for d in self.dimensions):
            raise ValueError("Dimensions may not exceed 64 by 64 pixels")
        
        if not self._fields & 0x80:
            raise ValueError("GIF images without a global color table are not supported")

        if self._color_depth > 2:
            raise ValueError("Color depth may not exceed 2")

#