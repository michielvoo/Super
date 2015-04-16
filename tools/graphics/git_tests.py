import unittest
from StringIO import StringIO
import struct

from gif import Image

class ImageTests(unittest.TestCase):

# Test open

    def test_open_returns_instance(self):
        # Arrange
        header = self._header()
        buffer = StringIO(header)

        # Act
        image = Image.open(buffer)

        # Assert
        self.assertIsNotNone(image)


    def test_open_raises_ValueException_for_invalid_GIF_image_header(self):
        # Arrange
        empty = ""
        not_gif = self._header(prefix="PNG89a")

        headers = [empty, not_gif]
        for header in headers:
            buffer = StringIO(header)

            # Act and assert
            with self.assertRaises(ValueError):
                image = Image.open(buffer)


    def test_open_raises_ValueException_for_unsupported_GIF_version(self):
        # Arrange
        header = self._header(prefix="GIF87a")
        buffer = StringIO(header)

        # Act and assert
        with self.assertRaises(ValueError):
            image = Image.open(buffer)


    def test_open_raises_ValueException_for_unsupported_dimensions(self):
        # Arrange
        headers = [
            self._header(width=65), 
            self._header(height=65),
            self._header(width=65, height=65)
        ]

        for header in headers:
            buffer = StringIO(header)

            # Act and assert
            with self.assertRaises(ValueError):
                image = Image.open(buffer)


    def test_open_raises_ValueException_if_GIF_image_has_no_global_color_table(self):
        # Arrange
        header = self._header(global_color_table=False)
        buffer = StringIO(header)

        # Act and assert
        with self.assertRaises(ValueError):
            image = Image.open(buffer)


    def test_open_raises_ValueException_if_GIF_image_has_more_than_16_colors(self):
        # Arrange
        header = self._header(color_depth=5)
        buffer = StringIO(header)

        # Act and assert
        with self.assertRaises(ValueError):
            image = Image.open(buffer)


    def test_dimensions_attribute_is_read_from_GIF_image_header(self):
        # Arrange
        expected = (1, 2)
        header = self._header(width=expected[0], height=expected[1])
        buffer = StringIO(header)

        # Act
        actual = Image.open(buffer).dimensions

        # Assert
        self.assertEqual(expected, actual)

# Test colors

    def test_colors_returns_iterable_of_tuples(self):
        # Arrange
        expected = [(10, 20, 30), (40, 50, 60)]

        # Flatten into a list
        color_values = [ i for t in expected for i in t ]

        header = self._header(color_depth=1)
        color_data = struct.pack("B" * len(color_values), *color_values)
        buffer = StringIO(header + color_data)

        # Act
        actual = Image.open(buffer).colors

        # Assert
        self.assertEqual(expected, actual)

# Helpers

    def _header(self, prefix="GIF89a", width=16, height=16, global_color_table=True, color_depth=2):
        header = prefix

        # Width and height are packed as little-endian
        header += struct.pack("<h", width)
        header += struct.pack("<h", height)

        field = 0;
        if global_color_table:
            # MSB indicated presence of a global color table
            field += 0x80
        field += color_depth - 1

        header += struct.pack('B', field)

        # Background color index
        header += struct.pack('B', 0)

        # Pixel aspect ratio
        header += struct.pack('B', 1)

        return header

if __name__ == "__main__":
    unittest.main()

#