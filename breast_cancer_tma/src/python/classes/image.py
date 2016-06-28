"""Image.py

Image        - Represents an image with secondary attributes such as a spot name and cohort number
Patch        - Represents a patch derived from an Image with secondary attributes
ImageSet     - Represents the set of images for a particular iteration of the pipline.
ImageSetList - Represents the list of image filenames that make up a pipeline run
"""

import math
import sys
from StringIO import StringIO
from cPickle import dump, Unpickler
from struct import unpack
from zlib import decompress

import numpy as np
from numpy import fromstring, uint8, uint16
import scipy.io as sio


class Image(object):

    """
    An image composed of an array of doubles plus secondary attributes
    The secondary attributes include:

    spot_name - numbered spot name corresponding to its location in
                the tissue microarray (e.g. '001')

    cohort_num - number corresponding to its cancer subtype
                classification or cancer cell line:
                1: ER+ IDC
                2: ER+ ILC
                3: ER- IDC
                4: HER2+ IDC
                5: MCF7
                6: MCF10A
                7: MDA-MB-231
                8: MDA-MB-468

    xy - an array containing the spatial (xy) coordinates for each
         cell measured from the top-left corner

    tilesize - height and width (in pixels) of the child patches
               derived from image
    
    threshold - number of cells required for child patches to be
                considered informative, and thus retained

    parent_image - for derived images, the the parent that was used
                   to create this image. This image may inherit
                   attributes from the parent image, such as
                   spot_name, cohort_num etc.

    patches - child images of size tilesize x tilesize derived by
              splitting this image into patches

    path_name - the path name to the file holding the image

    file_name - the file name of the file holding the image

    patches_outdir - path name to the directory contain child patches

    """

    def __init__(self,
                 image=None,
                 spot_name=None,
                 cohort_num=None,
                 xy=None,
                 tilesize=256,
                 threshold=4,
                 parent_image=None,
                 patches=None,
                 path_name=None,
                 file_name=None,
                 patches_outdir=None
        self.__image = None
        self.__spot_name = None
        self.__

class ImageSet(object):
    """docstring for ImageSet"""
    def __init__(self, arg):
        super(ImageSet, self).__init__()
        self.arg = arg
        




