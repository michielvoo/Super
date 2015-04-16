import struct

class Image(object):
    @classmethod
    def open(class_, buffer):
        return Image(buffer)

    _data = None
    _max_color_depth = 4
    _max_colors = pow(2, _max_color_depth)
    _colors = []

    @property
    def dimensions(self):
        return self._dimensions

    @property
    def colors(self):
        if not self._colors:
            self._colors = self._get_global_color_table_colors()
        return self._colors

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

        # Get the rest of the binary data from the file
        self._data = buffer.read()

    """ Performs several checks on the GIF file to determine if it is supported. This method will 
        raise an exception if the GIF file uses unsupported features.
    """
    def _validate(self):
        if self._id != "GIF" or self._version not in ["87a", "89a"]:
            raise ValueError("{}{} images are not supported".format(self._id, self._version))

        if any(d > 64 for d in self.dimensions):
            raise ValueError("Dimensions may not exceed 64 by 64 pixels")
        
        if not self._fields & 0x80:
            raise ValueError("GIF images without a global color table are not supported")

        if self._color_depth > self._max_color_depth:
            raise ValueError("Number of colors may not exceed " + str(self._max_color_depth))


    """ Extracts the colors as RGB tuples from the global color table
    """
    def _get_global_color_table_colors(self):
        length = 3 * pow(2, self._color_depth)
        indices = range(0, length, 3)

        # For each index (0, 3, 6, ...), collect 3 bytes into a tuple, converting the bytes to int
        colors = [ tuple( [ ord(v) for v in self._data[i:i + 3] ] ) for i in indices ]

        return colors

#