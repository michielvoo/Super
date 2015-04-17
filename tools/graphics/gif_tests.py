import unittest
from StringIO import StringIO
import struct

from gif import Image

class ImageTests(unittest.TestCase):

# Test open

    def test_open_returns_instance(self):
        # Arrange
        data = self._get_data_stream()
        buffer = StringIO(data)

        # Act
        image = Image.decode(buffer)

        # Assert
        self.assertIsNotNone(image)


    def test_open_GIF87a_returns_instance(self):
        # Arrange
        data = self._get_data_stream(prefix="GIF87a")
        buffer = StringIO(data)

        # Act
        image = Image.decode(buffer)

        # Assert
        self.assertIsNotNone(image)


    def test_open_raises_ValueException_for_invalid_GIF_image_header(self):
        # Arrange
        empty = ""
        not_gif = self._get_data_stream(prefix="PNG89a")

        headers = [empty, not_gif]
        for header in headers:
            buffer = StringIO(header)

            # Act and assert
            with self.assertRaises(ValueError):
                image = Image.decode(buffer)


    def test_open_raises_ValueException_for_unsupported_GIF_version(self):
        # Arrange
        data = self._get_data_stream(prefix="GIF88a")
        buffer = StringIO(data)

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
            buffer = StringIO(d)

            # Act and assert
            with self.assertRaises(ValueError):
                image = Image.decode(buffer)


    def test_open_raises_ValueException_if_GIF_image_has_no_global_color_table(self):
        # Arrange
        data = self._get_data_stream(global_color_table=False)
        buffer = StringIO(data)

        # Act and assert
        with self.assertRaises(ValueError):
            image = Image.decode(buffer)


    def test_open_raises_ValueException_if_GIF_image_has_more_than_16_colors(self):
        # Arrange
        data = self._get_data_stream(color_depth=5)
        buffer = StringIO(data)

        # Act and assert
        with self.assertRaises(ValueError):
            image = Image.decode(buffer)


    def test_dimensions_attribute_is_read_from_GIF_image_header(self):
        # Arrange
        expected = (1, 2)
        data = self._get_data_stream(width=expected[0], height=expected[1])
        buffer = StringIO(data)

        # Act
        actual = Image.decode(buffer).dimensions

        # Assert
        self.assertEqual(expected, actual)

# Test colors

    def test_colors_property_is_iterable_of_tuple(self):
        # Arrange
        expected = [(10, 20, 30), (40, 50, 60)]

        # Flatten RGB tuples into a list
        color_values = [ i for t in expected for i in t ]

        data = self._get_data_stream(color_depth=1, global_colors=color_values)
        buffer = StringIO(data)

        # Act
        actual = Image.decode(buffer).colors

        # Assert
        self.assertEqual(expected, actual)

# Test pixels

    def test_decode_raises_ValueException_if_block_is_not_supported(self):
        # Arrange
        block = chr(0x42)
        data = self._get_data_stream(blocks=[block, ])
        buffer = StringIO(data)

        # Act + assert
        with self.assertRaises(ValueError):
            image = Image.decode(buffer)


    def test_decode_raises_ValueException_if_image_descriptor_block_has_local_color_table(self):
        # Arrange
        block = self._get_image_descriptor_block(local_color_table=True)
        data = self._get_data_stream(blocks=[block, ])
        buffer = StringIO(data)

        # Act + assert
        with self.assertRaises(ValueError):
            image = Image.decode(buffer)


    def test_decode_raises_ValueException_if_image_descriptor_block_is_interlaced(self):
        # Arrange
        block = self._get_image_descriptor_block(interlaced=True)
        data = self._get_data_stream(blocks=[block, ])
        buffer = StringIO(data)

        # Act + assert
        with self.assertRaises(ValueError):
            image = Image.decode(buffer)


    def test_pixels_property_is_iterable_of_int(self):
        # Arrange

        # Act

        # Assert
        pass

# Helpers

    """ Returns a GIF image data stream
    """
    def _get_data_stream(self, 
            prefix="GIF89a", 
            width=16, 
            height=16, 
            global_color_table=True, 
            color_depth=2, 
            global_colors=[], 
            blocks=[]):

        data = prefix

        # Width and height are packed as little-endian
        data += struct.pack("<h", width)
        data += struct.pack("<h", height)

        field = 0;

        if global_color_table:
            # MSB indicated presence of a global color table
            field += 0x80

        field += color_depth - 1

        data += struct.pack('B', field)

        # Background color index
        data += struct.pack('B', 0)

        # Pixel aspect ratio
        data += struct.pack('B', 1)

        if not global_colors:
            # Generate some random colors
            global_colors = [ i for i in 3 * range(pow(2, color_depth)) ]

        data += struct.pack("B" * len(global_colors), *global_colors)

        # Add all blocks
        for block in blocks:
            data += block

        # Add the trailing byte
        data += struct.pack('B', 0x3b)

        return data


    """ Returns an image descriptor block
    """
    def _get_image_descriptor_block(self, 
            left=0, 
            top=0, 
            width=8, 
            height=8, 
            local_color_table=False, 
            interlaced=False):

        data = chr(0x2c) + struct.pack("<hhhh", left, top, width, height)

        field = 0

        if local_color_table:
            field += 0x80

        if interlaced:
            field += 0x40

        data += struct.pack("B", field)

        return data


if __name__ == "__main__":
    unittest.main()

#