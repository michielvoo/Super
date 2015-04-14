import unittest
from StringIO import StringIO

from gif import Image

class ImageTests(unittest.TestCase):
    def test_header_id(self):
        buffer = StringIO("GIF89a\x00\x00\x00\x00\x00")
        image = Image.open(buffer)
        self.assertEqual("GIF", image.header["id"])

    def test_header_version(self):
        buffer = StringIO("GIF89a\x00\x00\x00\x00\x00")
        image = Image.open(buffer)
        self.assertEqual("89a", image.header["version"])

if __name__ == "__main__":
    unittest.main()

#