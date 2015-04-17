import struct

class Image(object):
    @classmethod
    def decode(class_, buffer):
        return Image(buffer)

    _max_color_depth = 4
    _max_colors = pow(2, _max_color_depth)
    _colors = []
    _pixels = []

    @property
    def dimensions(self):
        return self._dimensions

    @property
    def colors(self):
        return self._colors

    @property
    def pixels(self):
        return self._pixels

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

        # Extract global color table from the buffer
        self._colors = self._get_global_color_table_colors(buffer)

        # Extract pixels from the buffer
        self._pixels = self._get_pixels(buffer)


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


    """ Extracts the colors as RGB tuples from the global color table.
    """
    def _get_global_color_table_colors(self, buffer):
        length = 3 * pow(2, self._color_depth)
        indices = range(0, length, 3)

        # For each index (0, 3, 6, ...), collect 3 bytes into a tuple, converting the bytes to int
        colors = [ tuple( [ ord(v) for v in buffer.read(3) ] ) for i in indices ]

        return colors


    """ Decompresses the first image block and returns the pixels.
    """
    def _get_pixels(self, buffer):
        blocks = self._get_blocks(buffer)
        pass

    def _get_blocks(self, buffer):
        # Trailing byte as str
        EOF = chr(0x3b)

        # Read next byte as str
        b = None
        while b != EOF:
            b = buffer.read(1)
            if b == '':
                raise ValueError("Invalid GIF image, last byte should be {}".format(hex(0x3b)))

#