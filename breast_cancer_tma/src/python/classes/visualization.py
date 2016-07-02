import matplotlib.pyplot as plt


def show(image):
    """ Show grayscale image of the desired image channel. """
    pass


def show_pseudo_image(image):
    pass


# show_subset_patches
def show_subset_patches(image, subplot_shape):
    image.split_into_patches()
    patches = image.patches
    k = 1
    for i in range(subplot_shape[0]):
        for j in range(subplot_shape[1]):
            plt.subplot(subplot_shape[0], subplot_shape[1], k)
            patch = patches[i, j, :, :]
            plt.imshow(patch)
            k += 1
    plt.show()
