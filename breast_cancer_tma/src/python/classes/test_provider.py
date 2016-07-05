from image import *
from values import Strings
from provider import ImageProvider
from visualization import*
import thunder as td
from showit import image

path_to_images = ['../../../images/ER-allTissue/ER_AFRemoved_013.tif',
                  '../../../images/PR-allTissue/PR_AFRemoved_013.tif',
                  '../../../images/HER2-allTissue/Her2_AFRemoved_013.tif']
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
values = im.images[Strings.IF][:, :, :]
# values = np.append(values, np.ones((2048, 2048, 1)),axis=2)
test = np.empty((1, 2048, 2048, 3))
test[0,:, :, :] = values
plt.imshow(im.images[Strings.IF][:, :, :])
# plt.show()

i = td.images.fromarray(test)
print i
image(i.first())



# show_subset_patches(im, (5,5))
