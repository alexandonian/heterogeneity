

class ImageProvider(object):

    def __init__(self):
        pass
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

a = ImageProvider()
a.fetch_modality_info('IF')