from __future__ import print_function
from __future__ import unicode_literals
from io import BytesIO
import struct
import unittest

from gif import Image

class ImageTests(unittest.TestCase):

# Test open

    def test_open_returns_instance(self):
        # Arrange
        data = self._get_data_stream()
        buffer = BytesIO(data)

        # Act
        image = Image.decode(buffer)

        # Assert
        self.assertIsNotNone(image)


    def test_open_GIF87a_returns_instance(self):
        # Arrange
        data = self._get_data_stream(prefix=b"GIF87a")
        buffer = BytesIO(data)

        # Act
        image = Image.decode(buffer)

        # Assert
        self.assertIsNotNone(image)


    def test_open_raises_ValueException_for_invalid_GIF_image_header(self):
        # Arrange
        empty = b''
        not_gif = self._get_data_stream(prefix=b"PNG89a")

        headers = [empty, not_gif]
        for header in headers:
            buffer = BytesIO(header)

            # Act and assert
            with self.assertRaises(ValueError):
                image = Image.decode(buffer)


    def test_open_raises_ValueException_for_unsupported_GIF_version(self):
        # Arrange
        data = self._get_data_stream(prefix=b"GIF88a")
        buffer = BytesIO(data)

        # Act and assert
        with self.assertRaises(ValueError):
            image = Image.decode(buffer)


    def test_open_raises_ValueException_for_unsupported_dimensions(self):
        # Arrange
        data = [
            self._get_data_stream(width=65), 
            self._get_data_stream(height=65),
            self._get_data_stream(width=65, height=65)
        ]

        for d in data:
            buffer = BytesIO(d)

            # Act and assert
            with self.assertRaises(ValueError):
                image = Image.decode(buffer)


    def test_open_raises_ValueException_if_GIF_image_has_no_global_color_table(self):
        # Arrange
        data = self._get_data_stream(global_color_table=False)
        buffer = BytesIO(data)

        # Act and assert
        with self.assertRaises(ValueError):
            image = Image.decode(buffer)


    def test_open_raises_ValueException_if_GIF_image_has_more_than_16_colors(self):
        # Arrange
        data = self._get_data_stream(color_depth=5)
        buffer = BytesIO(data)

        # Act and assert
        with self.assertRaises(ValueError):
            image = Image.decode(buffer)


    def test_dimensions_attribute_is_read_from_GIF_image_header(self):
        # Arrange
        expected = (1, 2)
        data = self._get_data_stream(width=expected[0], height=expected[1])
        buffer = BytesIO(data)

        # Act
        actual = Image.decode(buffer).dimensions

        # Assert
        self.assertEqual(expected, actual)

# Test colors

    def test_colors_property_is_iterable_of_tuple(self):
        # Arrange
        colors = expected = [(10, 20, 30), (40, 50, 60)]
        data = self._get_data_stream(color_depth=1, global_colors=colors)
        buffer = BytesIO(data)

        # Act
        actual = Image.decode(buffer).colors

        # Assert
        self.assertEqual(expected, actual)

# Test pixels

    def test_decode_raises_ValueException_if_block_is_not_supported(self):
        # Arrange
        block = b'\x42'
        data = self._get_data_stream(blocks=[block])
        buffer = BytesIO(data)

        # Act + assert
        with self.assertRaises(ValueError):
            image = Image.decode(buffer)


    def test_decode_raises_ValueException_if_image_descriptor_block_has_local_color_table(self):
        # Arrange
        block = self._get_image_descriptor_block(local_color_table=True)
        data = self._get_data_stream(blocks=[block])
        buffer = BytesIO(data)

        # Act + assert
        with self.assertRaises(ValueError):
            image = Image.decode(buffer)


    def test_decode_raises_ValueException_if_image_descriptor_block_is_interlaced(self):
        # Arrange
        block = self._get_image_descriptor_block(interlaced=True)
        data = self._get_data_stream(blocks=[block])
        buffer = BytesIO(data)

        # Act + assert
        with self.assertRaises(ValueError):
            image = Image.decode(buffer)


    def test_decode_raises_ValueError_if_image_descriptor_block_is_missing_sub_blocks(self):
        # Arrange
        block = self._get_image_descriptor_block(pixels=[])
        data = self._get_data_stream(blocks=[block])
        buffer = BytesIO(data)

        # Act + assert
        with self.assertRaises(ValueError):
            image = Image.decode(buffer)


    def test_decode_raises_ValueError_if_image_descriptor_block_has_invalid_trailing_sub_block(self):
        # Arrange
        block = self._get_image_descriptor_block(pixels=[0, 0, 0, 0])
        block += b'\x0c' # Add a random byte to the end of the block

        data = self._get_data_stream(blocks=[block])
        buffer = BytesIO(data)

        # Act + assert
        with self.assertRaises(ValueError):
            image = Image.decode(buffer)

    def test_decode_raises_ValueError_if_image_descriptor_block_has_invalid_sub_block(self):
        # Arrange
        block = self._get_image_descriptor_block(pixels=[0, 0, 0, 0])
        block = block[0:len(block) - 2] + bytes(block[-1]) # Remove a byte from the sub block 

        data = self._get_data_stream(blocks=[block])
        buffer = BytesIO(data)

        # Act + assert
        with self.assertRaises(ValueError):
            image = Image.decode(buffer)

# Helpers

    def _get_data_stream(self, 
            prefix=b"GIF89a", 
            width=2, 
            height=2, 
            global_color_table=True, 
            color_depth=2, 
            global_colors=[], 
            blocks=[]):
        """ Returns a GIF image data stream
        """

        data = prefix

        # Width and height are packed as little-endian
        data += struct.pack(b"<h", width)
        data += struct.pack(b"<h", height)

        field = 0;

        if global_color_table:
            # MSB indicated presence of a global color table
            field += 0x80

        if color_depth > 8:
            raise ValueError("Color depth may not exceed 8")
        field += color_depth - 1

        data += struct.pack(b'B', field)

        # Background color index
        data += struct.pack(b'B', 0)

        # Pixel aspect ratio
        data += struct.pack(b'B', 1)

        number_of_colors = pow(2, color_depth)
        if not global_colors:
            # Generate some random colors
            color_values = [c for c in range(number_of_colors) for v in range(3)]
        else:
            if len(global_colors) != number_of_colors:
                raise ValueError("Please provide colors matching the color depth argument when creating a test data stream")

            if len(global_colors) > 256:
                raise ValueError("Number of colors in the global color table may not exceed 256")

            # Flatten RGB tuples into a list
            color_values = [ i for t in global_colors for i in t ]

        data += struct.pack(b'B' * len(color_values), *color_values)

        if not blocks:
            # Generate a valid image descriptor block using only color 0
            pixels = [0 for i in range(width * height)]
            block = self._get_image_descriptor_block(width=width, height=height, pixels=pixels)
            data += block
        else:
            # Add all blocks
            for block in blocks:
                data += block

        # Add the trailing block
        data += struct.pack(b'B', 0x3b)

        return data


    def _get_image_descriptor_block(self,
            width=0, 
            height=0, 
            local_color_table=False, 
            interlaced=False,
            pixels=[]):
        """ Creates an image descriptor block
            Returns a bytes object
        """

        block = b'\x2c' + struct.pack(b"<hhhh", 0, 0, width, height)

        field = 0

        if local_color_table:
            field += 0x80

        if interlaced:
            field += 0x40

        block += struct.pack(b'B', field)

        data = self._compress_data(bytes(pixels))

        block += self._make_sub_blocks(data)

        return block

    def _compress_data(self, data):
        """ Compresses the bytes data using the GIF compression algorithm
            Returns a str object
        """

        # TODO: implement LZW algorithm
        return data


    def _make_sub_blocks(self, data):
        """ Creates 256 byte blocks from the data.
            Returns a bytes object
        """

        sub_blocks = b''

        if len(data) < 256:
            # Add the single data sub block
            size = len(data)
            sub_blocks += bytes([size]) + data
        else:
            offset = 0
            size = len(data) - offset
            while size >= 256:
                # Add as many large (255 bytes + 1 size byte) sub blocks
                sub_blocks += bytes([255]) + data[offset:256]
                offset += 256
                size = len(data) - offset

            # Add the last data sub block
            sub_blocks += bytes([size]) + data[offset:]

        # Add the trailing \x00 and return
        sub_blocks += b'\x00'
        return sub_blocks


if __name__ == "__main__":
    unittest.main()

#