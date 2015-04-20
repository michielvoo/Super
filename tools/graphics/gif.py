import struct

class Image(object):
    @classmethod
    def decode(class_, buffer):
        return Image(buffer)

    _max_color_depth = 4
    _max_colors = pow(2, _max_color_depth)
    _colors = []
    _pixels = []
    _frames = []

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
            raise ValueError("Unsupported file, unable to recognize header")

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
        self._process_data_blocks(buffer)


    """ Performs several checks on the GIF file to determine if it is supported. This method will 
        raise an exception if the GIF file uses unsupported features.
    """
    def _validate(self):
        if self._id != "GIF" or self._version not in ["87a", "89a"]:
            message = "Unsupported file, {}{} images are not supported"
            raise ValueError(message.format(self._id, self._version))

        if any(d > 64 for d in self.dimensions):
            raise ValueError("Unsupported GIF image, dimensions may not exceed 64 by 64 pixels")
        
        if not self._fields & 0x80:
            raise ValueError("Unsupported GIF image, no global color table")

        if self._color_depth > self._max_color_depth:
            message = "Unsupported GIF image, number of colors may not exceed {}"
            raise ValueError(message.format(self._max_color_depth))


    """ Extracts the colors as RGB tuples from the global color table.
    """
    def _get_global_color_table_colors(self, buffer):
        length = 3 * pow(2, self._color_depth)
        indices = range(0, length, 3)

        # For each index (0, 3, 6, ...), collect 3 bytes into a tuple, converting the bytes to int
        colors = [ tuple( [ ord(v) for v in buffer.read(3) ] ) for i in indices ]

        return colors


    """ Processes all data blocks (only supports image descriptor block)
    """
    def _process_data_blocks(self, buffer):
        # Trailing byte
        EOF = 0x3b
        IMAGE = 0x2c

        # Read/process all blocks
        b = None
        while b != chr(EOF):
            b = buffer.read(1)
            if b == '':
                # Unexpected end of the buffer
                eof_as_str = hex(EOF)
                message = "Invalid GIF image, last byte should be {}"
                raise ValueError(message.format(eof_as_str))

            if b == chr(IMAGE):
                # Process an image descriptor block
                image = self._get_image_from_image_descriptor_block(buffer)
                self._frames.append(image)

            elif b != chr(EOF):
                # Unsupported block which is not the trailer
                identifier = hex(ord(b))
                message = "Unsupported GIF image, block identified by {} is not supported"
                raise ValueError(message.format(identifier))


    """ Read the next image descriptor block from the buffer
    """
    def _get_image_from_image_descriptor_block(self, buffer):
        try:
            header = struct.unpack("<hhhhB", buffer.read(9))
        except struct.error:
            raise ValueError("Invalid GIF file, invalid header for image descriptor block")

        image = {}
        image["left"] = header[0]
        image["top"] = header[1]
        image["width"] = header[2]
        image["height"] = header[3]

        field = header[4]

        if field & 0x80:
            raise ValueError("Unsupported GIF image, local color tables are not supported")

        if field & 0x40:
            raise ValueError("Unsupported GIF image, interlacing is not supported")

        sub_blocks = self._get_image_descriptor_sub_blocks(buffer)

        # Decompress sub blocks

        return image


    def _get_image_descriptor_sub_blocks(self, buffer):
        # Each sub block has chunks, each chunk is (up to) 255 bytes
        # Each chunk starts with a byte which is the lenght of the chunk

        data = None
        b = None
        while 1:
            b = buffer.read(1)

            if b == '':
                # Premature end of the data stream
                raise ValueError("Invalid GIF file, missing image descriptor sub block(s)")

            size = ord(b)
            if size == 0:
                # Last sub block
                break

            sub_block = buffer.read(size)
            if len(sub_block) < size:
                # Premature end of the data stream
                raise ValueError("Invalid GIF file, missing bytes in image descriptor sub block")

            data += sub_block

        pass

#