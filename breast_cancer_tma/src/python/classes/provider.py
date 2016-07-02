import sys
from os import listdir
from os.path import isfile, join
import pandas as pd
from PIL import Image as Pimage
from skimage import util
from image import *
from values import *


class ImageProvider(object):

    def __init__(self, image_info):

        # path = {'images': 'path_to_images',
        #         'features': 'path_to feature_file'}
        # file_name = {'images': 'image_names',
        #              'feature': 'feature_name'}
        # im_type_info = {'path': path,
        #                 'file_name': file_name,
        #                 'channel_list': channel_list
                           # 'image_shape': (2048, 2048)}

        # image_info = {Strings.IF: im_type_info}
        self.image_info = image_info

    def generate_image_obj(self):

        im_data = {}
        feat_data = {}

        for type, im_type_info in self.image_info.items():

            im_data[type] = self.load_images_by_type(type)
            feat_data[type] = self.load_features_by_type(type)
            image_obj = Image(self.image_info, im_data, feat_data)

        return image_obj

    def load_images_by_type(self, type):

        if type == Strings.IF:

            image_shape = self.image_info[Strings.IF]['image_shape']
            im_paths = self.image_info[Strings.IF]['path']['images']
            channel_list = self.image_info[Strings.IF]['channel_list']
            print image_shape
            print len(channel_list)
            nd_image = np.zeros((image_shape[0], image_shape[1], len(channel_list)))
            
            for i, path in enumerate(im_paths):
                with Pimage.open(path).convert('L') as im:
                    im = np.array(im)
                    nd_image[:, :, i] = util.img_as_float(im)

            return nd_image
        return None

    def load_features_by_type(self, type):

        if type == Strings.IF:

            feats = {'xy': None,
                     'intensity': None}

            feat_path = self.image_info[Strings.IF]['path']['features'][0]
            df = pd.read_csv(feat_path)

            # Load spatial xy coordinates
            feats['xy'] = (
                np.concatenate((np.reshape(df.Cell_X, (-1, 1)),
                                np.reshape(df.Cell_Y, (-1, 1))), axis=1))

            # Based on column headers, read biomarker identities
            # and expression locations
            bio, loc, col = (
                zip(*[(col.split('_')[0], col.split('_')[1], col)
                    for col in list(df) if col.split('_')[0] != 'Cell']))

            # Extract a list of unique biomarkers and expression locations
            biomarkers = list(set(bio))
            locations = list(set(loc))

            # Load intensities for all channels and all locations
            k = 0
            intensity = {}
            # channels = self.image_info[Strings.IF]['channel_list']
            for bio in biomarkers:
                intensity[bio] = {}
                for loc in locations:
                    intensity[bio][loc] = df[col[k]].values
                    k += 1
            feats['intensity'] = intensity

            return feats
        return None

    @staticmethod
    def determine_image_name(type, file_name):
        pass

    @staticmethod
    def determine_class_num(type, image_name):
        pass


class ImageSetProvider(object):

    def __init__(self):

        # TODO: a list of imaging modalities OR a a dictionary containing
        # imaging modalites mapped to their paths something like that
        self.modalities = None
        self.paths = {'image': [],
                      'feature': []}

    def fetch_modality_info(self, modality):
        """
        Fetch information about the imaging modality such as features of
        interest, number of feature channels etc.

        Example, for multiplexed immunofluorescence imaging modality, we want
        to know:
        - features: biomarker intensity at xy locations
        - number of features: how many biomarkers are we interested in
        """

        if modality == 'IF':

            fetcher = infoHelper()
            info = fetcher.fetch_IF_info('i')
        return info

    def fetch_features(self, modality, info):
        """

        """
        pass

        if modality == "IF":

            fetcher = featureHelper()
            features = fetcher.fetch_IF_features()

        return features

    def fetch_images(self, modality, info):
        pass

        if modality == 'IF':

            fetcher = imageHelper()
            images = fetcher.fetch_IF_images()

        return images


class infoHelper(object):

    def __init__(self):
        pass

    @staticmethod
    def fetch_IF_info(param):
        if param == "i":

            print 'test'

    @staticmethod
    def fetch_WSI_info(param):
        pass

    @staticmethod
    def fetch_IHC_info(param):
        pass

    @staticmethod
    def fetch_HaE_info(param):
        pass

    @staticmethod
    def fetch_IMS_info(param):
        pass

    @staticmethod
    def fetch_ISH_info(param):
        pass


class featureHelper(object):

    def __init__(self):
        pass

    @staticmethod
    def fetch_IF_info(param):
        if param == "i":

            print 'test'

    @staticmethod
    def fetch_WSI_features(param):
        pass

    @staticmethod
    def fetch_IHC_features(param):
        pass

    @staticmethod
    def fetch_HaE_features(param):
        pass

    @staticmethod
    def fetch_IMS_features(param):
        pass

    @staticmethod
    def fetch_ISH_features(param):
        pass


class imageHelper(object):

    def __init__(self):
        pass

    @staticmethod
    def fetch_IF_info(param):
        if param == "i":

            print 'test'

    @staticmethod
    def fetch_WSI_image(param):
        pass

    @staticmethod
    def fetch_IHC_images(param):
        pass

    @staticmethod
    def fetch_HaE_images(param):
        pass

    @staticmethod
    def fetch_IMS_images(param):
        pass

    @staticmethod
    def fetch_ISH_images(param):
        pass
