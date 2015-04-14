import unittest
from StringIO import StringIO

from gif import Image

header = "GIF89a\x00\x00\x00\x00\x00"

class ImageTests(unittest.TestCase):

    def test_open_returns_instance(self):
        buffer = StringIO(header)
        image = Image.open(buffer)
        self.assertIsNotNone(image)

    def test_open_raises_ValueException_for_invalid_GIF_image_header(self):
        empty = ""
        not_gif = "PNG89a\x00\x00\x00\x00\x00"
        not_89a = "GIF87a\x00\x00\x00\x00\x00"

        headers = [empty, not_gif, not_89a]
        for header in headers:
            buffer = StringIO(header)
            with self.assertRaises(ValueError):
                image = Image.open(buffer)

if __name__ == "__main__":
    unittest.main()

#