import struct

class Image(object):
    @classmethod
    def open(class_, buffer):
        return Image(buffer)

    _max_color_depth = 4
    _max_colors = pow(2, _max_color_depth)

    @property
    def dimensions(self):
        return self._dimensions

    def __init__(self, buffer):
        try:
            header = struct.unpack("<3s3shhBBB", buffer.read(13))
        except struct.error:
            raise ValueError("Invalid GIF file")

        # Initialize fields
        self._id = header[0]
        self._version = header[1]
        self._dimensions = (header[2], header[3])
        self._fields = header[4]
        self._color_depth = (self._fields & 0x07) + 1
        self._background_color_index = header[5]
        self._pixel_aspect_ratio = header[6]
        
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

        if self._color_depth > self._max_color_depth:
            raise ValueError("Number of colors may not exceed " + str(self._max_color_depth))

#