import unittest
from StringIO import StringIO

from gif import Image

class ImageTests(unittest.TestCase):
    def test_open(self):
        buffer = StringIO("GIF89a")
        image = Image.open(buffer)
        self.assertIsInstance(image, Image)

if __name__ == "__main__":
    unittest.main()

#