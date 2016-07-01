"""Image.py

Image        - Represents an image with secondary attributes such as a spot name and cohort number
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
    An image composed of numpy ndarray plus secondary attributes
    The secondary attributes include:

    image_name - name of image corresponding to its location in
                 the tissue microarray (e.g. '001')

    class_num - number corresponding to its designatation to a particular
                subtype classification

    xy - an array containing the spatial (xy) coordinates for each
         feature measured from the top-left corner

    tilesize - height and width (in pixels) of the child patches
               derived from image

    threshold - number of instances of a particular feature 
                required for child patches to be
                considered informative

    parent_image - for derived images, the the parent that was used
                   to create this image. This image may inherit
                   attributes from the parent image, such as
                   image name and class number, cohort_num etc.

    patches - child images of size tilesize x tilesize derived by
              splitting this image into patches

    path_name - the path name to the file holding the image

    file_name - the file name of the file holding the image

    patches_outdir - path name to the directory contain child patches

    """

    def __init__(self,
                 images=None,
                 channels=None,
                 image_name=None,
                 class_num=None,
                 xy=None,
                 tilesize=256,
                 threshold=4,
                 parent_image=None,
                 patches=None,
                 path_name=None,
                 file_name=None,
                 patches_outdir=None):

        if images is not None:
            self.images = images
        if image_name is not None:
            self.Image_name = Image
        if class_num is not None:
            self.class_num = class_num
        if features is not None:
            self.features = features
        if xy is not None:
            self.xy = xy

    def split_into_patches(self, channel=None, patch_shape=(256, 256), overlap=None):
        pass

        # TODO: determine whether patch all channels at once, or individual channels
        # Note: use skimage.util.shape.view_as_windows()
        # Stride = shape[0] - overlap
        # or if you want overlap in both x and y dimens stride = patch_shape - overlap
        # where type(stride)==type(patch_shape)==type(overlap) == tuple of length n dimensions\
        # overlap cannot be larger than patch_shape - 1 nor small

        # USING view_as_windows(image, patch_shape, step)
        # for and MxNx3 image, I want each patch to tilesize x tilesize x 3 patch (3D) patch
        # so patch_shape=(tilesize, tilesize, 3)
        # for nonoverlapping patches, our step in dims 0 and 1 should be the same as tilesize
        # so, step(tilesize, tilesize, 1)

        if biomarker:
            im = self.images[biomarker]
        else:
          im = self.nd_image


    def show(self, channel):
        """Show grayscale image of Image labeled with biomarer"""
        Image.fromarray(self.images[biomarker]).show()

    def show_pseudo_image(self, channel_list):
        pass
        # TODO: call make_nchannel_image for 3 channels of interest

    def get_informative_channels(self):
        pass
        # TODO: will require analysis
        # call make_nchannel_image