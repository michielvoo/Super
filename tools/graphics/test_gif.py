import unittest
from StringIO import StringIO

from gif import Image

class ImageTests(unittest.TestCase):
    def test_open(self):
        buffer = StringIO()
        actual = Image.open(buffer)
        self.assertEqual(42, actual)

if __name__ == "__main__":
    unittest.main()

#