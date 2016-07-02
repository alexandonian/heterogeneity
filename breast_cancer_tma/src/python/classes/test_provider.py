from image import *
from values import Strings
from provider import ImageProvider
from visualization import*

path_to_images = ['../../../images/ER-allTissue/ER_AFRemoved_011.tif',
                  '../../../images/PR-allTissue/PR_AFRemoved_011.tif',
                  '../../../images/HER2-allTissue/Her2_AFRemoved_011.tif']
path_to_features = ['../../../data/011_Quant.csv']
channel_list = ['ER', 'PR', 'HER2']

image_shape = (2048, 2048)
path = {'images': path_to_images,
        'features': path_to_features}
file_name = {'images': 'image_names',
             'feature': 'feature_name'}
im_type_info = {'path': path,
                'file_name': file_name,
                'channel_list': channel_list,
                'image_shape': image_shape}

image_info = {Strings.IF: im_type_info}

ip = ImageProvider(image_info)

im = ip.generate_image_obj()
im.split_into_patches()
print im.patches[1,1,:,:].shape
# show_subset_patches(im, (5,5))
