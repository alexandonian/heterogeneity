"""
image.py

Image    - Represents an image with secondary attributes
Patch    - Represents a patch with secondary attributes derived from an Image
ImageSet - Represents the set of Images for a particular iteration of the pipline.
"""

import math
import sys
from StringIO import StringIO
from cPickle import dump, Unpickler
from struct import unpack
from zlib import decompress
import numpy as np
import pandas as pd
from numpy import fromstring, uint8, uint16
from os import listdir
from os.path import isfile, join
from PIL import Image as Pimage
from skimage.util import shape
import scipy.io as sio
from values import Strings


class Image(object):

    """
    # TODO: Rewrite this
    An image composed of numpy ndarray plus secondary attributes
    The secondary attributes include:

    image_name - name of image containing information such as the the image
                 type, level or processing and position in data set
                 (e.g. 'ER_AFRemoved_001.tif').

    class_num - number corresponding to its designatation to a particular
                subtype classification

    xy - an array containing the spatial (xy) coordinates for each
         feature measured from the top-left corner

    patch_shape - height and width (in pixels) of the child patches
                  derived from image

    threshold - number of instances of a particular feature required
                for child patches to be considered informative

    parent_image - for derived images, the the parent that was used
                   to create this image. This image may inherit
                   attributes from the parent image, such as
                   image name and class number etc.

    patches - child images of shape patch_shape derived by
              splitting this image into patches

    file_name - the file name of the file holding the image

    TO BE REMOVED:-----------------------------------------------------

    patches_outdir - path name to the directory contain child patches

    path_name - the path name to the file holding the image

    """

    def __init__(self, image_info=None, im_data=None, feat_date=None):

        # TODO: Error and None checking
        self.info = image_info
        self.images = im_data
        self.features = feat_date

        # TODO: add properties using decorator syntax
        @property
        def images(self):
            return self._images

        

    def split_into_patches(self,
                           channel=None,
                           patch_shape=(256, 256, 3),
                           overlap=0):
        """
        Split an MxNxC image (where C is the number of channels) into patches.

        Inputs:
        - channel: Image channel as indicated by.
        - patch_shape: .
        :param patch_shape:
        :param channel:
        """

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

        # TODO: LOTS OF ERROR CHECKING!!
        if channel:
            im = self.images[channel]
        else:
            im = self.images[Strings.IF]
        if patch_shape != im.shape:
            patch_shape = (256, 256, im.shape[2])

        step = tuple((patch_shape[0] - overlap, patch_shape[1] - overlap, 1))

        self.patches = shape.view_as_windows(im, patch_shape, step)

    def get_informative_channels(self):
        pass
        # TODO: will require analysis
        # call make_nchannel_image


class Patch(Image):

    def __init__(self, im_info, patch_data, feat_data):
        pass

    def is_informative(self):
        pass


class ImageSet(object):

    def __init__(self, data_dir=None, image_dir=None):

        # Relatives paths to data and image directories
        if data_dir and image_dir:
            self.path = {'data': data_dir, 'image': image_dir}
        else:
            self.path = {'data': '../../../data/',
                         'image': '../../../images/'}

        # Load .csv data files containing cell spatial coords
        # and biomarker intensities
        self.data_files = [f for f in listdir(self.path['data'])
                           if isfile(join(self.path['data'], f)) and
                           f.endswith('.csv')]

        # Prepare an empty dict to hold Image objects
        self.images = {}
        self.df = None
        self.biomarkers = None
        self.locations = None
    #     TODO:
    # self.load_data
    #     self.fetch_data
    #     self.parse_data
    # self.load_images
    #     self.fetch_image_files
    #     self.load_image

    # TODO: Refactor this section to make it 'flatter'
    def generate_images(self):
        """Populates ImageSet.Images, a dict contain Images indexed by Image name."""
        for f in self.data_files:

            # Parse filename for Image name and map it to a cohort
            image_name = f.split('_')[0]
            class_num = self.determine_class(image_name)

            # Read .csv file into a Pandas dataframe object
            self.df = pd.read_csv(join(self.path['data'], f))

            # Get Spatial xy coordinates
            xy = np.concatenate((np.reshape(self.df.Cell_X, (-1, 1)),
                                 np.reshape(self.df.Cell_Y, (-1, 1))), axis=1)

            # Based on column headers, read biomarker identities
            # and expression locations
            bio, loc, col = (
                zip(*[(col.split('_')[0], col.split('_')[1], col)
                    for col in list(self.df) if col.split('_')[0] != 'Cell']))

            # Extract a list of unique biomarkers and expression locations
            self.biomarkers = list(set(bio))
            self.locations = list(set(loc))

            k = 0
            features = {}
            images = {}
            nd_image = np.zeros((2048, 2048, len(self.biomarkers)))
            channel_idx = []

            for i, bio in enumerate(self.biomarkers):
                features[bio] = {}

                # Get path to image of biomarker and Image
                image_bio_dir = [join(self.path['image'], f)
                                 for f in listdir(self.path['image'])
                                 if bio.lower() in f.lower()]
                if image_bio_dir:
                    image_file = [join(image_bio_dir[0], f)
                                  for f in listdir(image_bio_dir[0])
                                  if image_name in f]
                    if image_file:
                        with Pimage.open(image_file[0]).convert("L") as im:
                            image = np.array(im)
                            images[bio] = image
                            # VS. (ASK ABOUT THIS)
                            nd_image[:, :, i] = self.im2double(image)
                            channel_idx.append(bio)

                            # print image_file[0]
                    else:
                        # TODO: add exception instead of print statement
                        print "missing image"
                        print image_name
                else:
                    # TODO: add exception instead of print statement
                    print 'missing image directory'

                for loc in self.locations:
                    features[bio][loc] = self.df[col[k]].values
                    k += 1

            self.images[image_name] = Image(images, self.biomarkers, nd_image, image_name, class_num,
                                            xy, features, patch_shape=(256, 256, 3),
                                            patches=None)

    def get_image(self, image_name):
        return self.images[image_name]

    def fetch_data(self, data_file):
        image_name = data_file.split('_')[0]
        class_num = self.determine_class(image_name)

        # Read .csv file into a Pandas dataframe object
        self.df = pd.read_csv(join(self.path['data'], data_file))

        # Get Spatial xy coordinates
        xy = np.concatenate((np.reshape(self.df.Cell_X, (-1, 1)),
                             np.reshape(self.df.Cell_Y, (-1, 1))), axis=1)

        # Based on column headers, read biomarker identities
        # and expression locations
        bio, loc, col = (
            zip(*[(col.split('_')[0], col.split('_')[1], col)
                for col in list(self.df) if col.split('_')[0] != 'Cell']))
        return bio, loc, col

    def load_images(self):
        pass

    def load_image(self):
        pass

    def load_image_set_props(self):
        pass

    def im2double(self, im):
        min_val = np.min(im.ravel())
        max_val = np.max(im.ravel())
        out = (im.astype('float') - min_val) / (max_val - min_val)
        return out

    def determine_class(self, image_name):
        """Generates cohort num based on Image name."""
        cohort_1 = ['000', '005', '026', '031', '046', '055', '060', '081',
                    '086']
        cohort_2 = ['001', '006', '011', '016', '025', '030', '043', '045',
                    '056', '061', '066', '076', '080', '085', '096']
        cohort_3 = ['002', '007', '012', '017', '020', '024', '029', '032',
                    '034', '036', '039', '044', '049', '052', '057', '062',
                    '067', '071', '072', '079', '084', '089', '091', '095']
        cohort_4 = ['003', '008', '013', '015', '018', '021', '023', '028',
                    '033', '038', '041', '048', '053', '058', '063', '065',
                    '068', '070', '073', '078', '083', '088', '090', '093']
        cohort_5 = ['022', '035', '037', '047', '059', '069', '075', '087']
        cohort_6 = ['004', '014', '050', '097']
        cohort_7 = ['009', '010', '019', '027', '042', '077', '092', '098']
        cohort_8 = ['040', '051', '054', '064', '074', '082', '094']
        cohorts = [cohort_1, cohort_2, cohort_3, cohort_4, cohort_5, cohort_6,
                   cohort_7, cohort_8]

        for i in range(len(cohorts)):
            if image_name in cohorts[i]:
                return i
        else:
            print 'Image does not belong to any cohorts!'

