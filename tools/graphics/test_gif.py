import unittest
from StringIO import StringIO

from gif import Image

class ImageTests(unittest.TestCase):

    def test_open_returns_instance(self):
        buffer = StringIO("GIF89a\x00\x00\x00\x00\x00")
        image = Image.open(buffer)
        self.assertIsNotNone(image)

    def test_open_raises_ValueException_for_invalid_GIF_image_header(self):
        empty = ""
        not_gif = "PNG___\x00\x00\x00\x00\x00"

        headers = [empty, not_gif]
        for header in headers:
            buffer = StringIO(header)
            with self.assertRaises(ValueError):
                image = Image.open(buffer)

    def test_open_raises_ValueException_for_unsupported_GIF_version(self):
        buffer = StringIO("GIF87a\x00\x00\x00\x00\x00")
        with self.assertRaises(ValueError):
            image = Image.open(buffer)

    def test_open_raises_ValueException_for_unsupported_dimensions(self):
        buffer = StringIO("GIF89a\x00\x01\x00\x01\x00")
        with self.assertRaises(ValueError):
            image = Image.open(buffer)

if __name__ == "__main__":
    unittest.main()

#