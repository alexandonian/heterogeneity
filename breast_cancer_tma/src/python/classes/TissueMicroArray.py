"""TissueMicroArray.py

Spot              - Represents a spot with secondary attributes such as a mask and labels
Patch             - Represents a patch derived from a Spot with secondary attributes
TissueMicroArray  - Represents the set of spots for a particular iteration of the pipline.
"""

import pandas as pd
import numpy as np
from os import listdir
from os.path import isfile, join
from PIL import Image
from sklearn.feature_extraction.image import feature_extraction.image.extract_patches2d


class TissueMicroArray(object):

    def __init__(self):

        # Relatives paths to data and image directories
        self.path = {'data': '../../../data-99spots/',
                     'image': '../../../images/'}

        # Load .csv data files containing cell spatial coords
        # and biomarker intensities
        self.data_files = [f for f in listdir(self.path['data'])
                           if isfile(join(self.path['data'], f)) and
                           f.endswith('.csv')]

        # Prepare an empyt dict to hold spot objects
        self.spots = {}

    def generate_spots(self):
        """Populates TMA.spots, a dict contain spots indexed by spot name."""
        for f in self.data_files:

            # Parse filename for spot name and map it to a cohort
            spot_name = f.split('_')[0]
            cohort_num = self.determine_cohort(spot_name)

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
            for i, bio in enumerate(self.biomarkers):
                features[bio] = {}

                # Get path to image of biomarker and spot
                image_bio_dir = [join(self.path['image'], f)
                                 for f in listdir(self.path['image'])
                                 if bio.lower() in f.lower()]
                if image_bio_dir:
                    image_file = [join(image_bio_dir[0], f)
                                  for f in listdir(image_bio_dir[0])
                                  if spot_name in f]
                    if image_file:
                        with Image.open(image_file[0]).convert("L") as im:
                            images[bio] = np.array(im)
                            # print image_file[0]
                    else:
                        # TODO: add exception instead of print statement
                        print "missing image"
                        print spot_name
                else:
                    # TODO: add exception instead of print statement
                    print 'missing image directory'

                for j, loc in enumerate(self.locations):
                    features[bio][loc] = self.df[col[k]].values
                    k += 1

            self.spots[spot_name] = Spot(images,
                                         spot_name,
                                         cohort_num,
                                         features,
                                         xy,
                                         tilesize=256,
                                         patches=None)

    def load_images(self):
        pass
    def load_TMA_props(self):
        pass

    def determine_cohort(self, spot_name):
        """Generates cohort num based on spot name."""
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
            if spot_name in cohorts[i]:
                return i
        else:
            print 'Spot does not belong to any cohorts!'


class Spot(object):

    def __init__(self, images=None,
                 spot_name=None,
                 cohort_num=None,
                 features=None,
                 xy=None,
                 tilesize=256,
                 patches=None):

        if images is not None:
            self.images = images
        if spot_name is not None:
            self.spot_name = spot_name
        if cohort_num is not None:
            self.cohort_num = cohort_num
        if features is not None:
            self.features = features
        if xy is not None:
            self.xy = xy

    def split_into_patches(self, biomarker=None, tilesize=256):


tma = TissueMicroArray()
tma.generate_spots()
# tma.spots[1].features.keys()
# for i in range(len(tma.spots)):
#   print tma.spots[i].spot_name

Image.fromarray(tma.spots['011'].images['ER']).show()
