import unittest
from StringIO import StringIO

from gif import Image

class ImageTests(unittest.TestCase):

    def test_open_returns_instance(self):
        buffer = StringIO("GIF89a\x40\x00\x40\x00\x80")
        image = Image.open(buffer)
        self.assertIsNotNone(image)

    def test_open_raises_ValueException_for_invalid_GIF_image_header(self):
        empty = ""
        not_gif = "PNG___\x40\x00\x40\x00\x80"

        headers = [empty, not_gif]
        for header in headers:
            buffer = StringIO(header)
            with self.assertRaises(ValueError):
                image = Image.open(buffer)

    def test_open_raises_ValueException_for_unsupported_GIF_version(self):
        buffer = StringIO("GIF87a\x40\x00\x40\x00\x80")
        with self.assertRaises(ValueError):
            image = Image.open(buffer)

    def test_open_raises_ValueException_for_unsupported_dimensions(self):
        buffer = StringIO("GIF89a\x41\x00\x41\x00\x80")
        with self.assertRaises(ValueError):
            image = Image.open(buffer)

    def test_open_raises_ValueException_if_GIF_image_has_no_global_color_table(self):
        buffer = StringIO("GIF89a\x00\x01\x00\x01\x80")
        with self.assertRaises(ValueError):
            image = Image.open(buffer)

    def test_dimensions_attribute_is_read_from_GIF_image_header(self):
        buffer = StringIO("GIF89a\x40\x00\x20\x00\x80")
        actual = Image.open(buffer).dimensions
        expected = (64, 32)
        self.assertEqual(expected, actual)


if __name__ == "__main__":
    unittest.main()

#