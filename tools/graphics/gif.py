from __future__ import print_function
from __future__ import unicode_literals
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
            header = struct.unpack(b"<3s3shhBBB", buffer.read(13))
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


    def _validate(self):
        """ Performs several checks on the GIF file to determine if it is supported. This method will 
            raise an exception if the GIF file uses unsupported features.
        """

        if self._id != b"GIF" or self._version not in [b"87a", b"89a"]:
            message = "Unsupported file, {}{} images are not supported"
            raise ValueError(message.format(self._id, self._version))

        if any(d > 64 for d in self.dimensions):
            raise ValueError("Unsupported GIF image, dimensions may not exceed 64 by 64 pixels")
        
        if not self._fields & 0x80:
            raise ValueError("Unsupported GIF image, no global color table")

        if self._color_depth > self._max_color_depth:
            message = "Unsupported GIF image, number of colors may not exceed {}"
            raise ValueError(message.format(self._max_color_depth))


    def _get_global_color_table_colors(self, buffer):
        """ Extracts the colors as RGB tuples from the global color table.
        """

        length = 3 * pow(2, self._color_depth)
        indices = range(0, length, 3)

        # For each index (0, 3, 6, ...), collect 3 bytes into a tuple, converting the bytes to int
        colors = [ tuple( [ int(v) for v in buffer.read(3) ] ) for i in indices ]

        return colors


    def _process_data_blocks(self, buffer):
        """ Processes all data blocks (only supports image descriptor block)
        """

        EOF = b'\x3b'
        IMAGE = b'\x2c'

        # Read/process all blocks
        b = None
        while b != EOF:
            b = buffer.read(1)

            if b == '':
                # Unexpected end of the buffer
                message = "Invalid GIF image, last byte should be \x3b"
                raise ValueError(message.format(eof_as_str))

            if b == IMAGE:
                # Process an image descriptor block
                image = self._get_image_from_image_descriptor_block(buffer)
                self._frames.append(image)

            elif b != EOF:
                # Unsupported block which is not the trailer
                identifier = int(b)
                message = "Unsupported GIF image, block identified by \\x{} is not supported"

                raise ValueError(message.format(identifier))


    def _get_image_from_image_descriptor_block(self, buffer):
        """ Read the next image descriptor block from the buffer
        """

        try:
            header = struct.unpack(b"<hhhhB", buffer.read(9))
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

        compressed_data = self._get_image_descriptor_data(buffer)
        decompressed_data = self._decompress_data(compressed_data)

        # TODO: convert to image (pixel array)
        image = decompressed_data

        return image


    def _get_image_descriptor_data(self, buffer):
        """ Returns the compressed data stored in sub blocks
        """

        data = b''

        while 1:
            b = buffer.read(1)

            if b == b'':
                # Premature end of the data stream
                raise ValueError("Invalid GIF file, missing image descriptor sub block(s)")

            size = int(b[0])
            if size == 0:
                # Last sub block
                break

            sub_block = buffer.read(size)
            if len(sub_block) < size:
                # Premature end of the data stream
                raise ValueError("Invalid GIF file, missing bytes in image descriptor sub block")
            else:
                data += sub_block

        return data


    def _decompress_data(self, data):
        """ Decompresses the LZW-compressed data of an image descriptor block
        """

        return data

#