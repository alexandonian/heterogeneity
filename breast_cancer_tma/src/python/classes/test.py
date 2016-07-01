from image import *
from visualization import*


tma = ImageSet()
bio, loc, col = tma.fetch_data(tma.data_files[0])

print bio, loc, col