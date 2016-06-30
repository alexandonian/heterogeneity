"""Patch.py

Patch - Represents a patch derived from a Image with secondary attributes
"""


class Patch(object):

    def __init__(self):

        # Relatives paths to data and image directories
        self.path = {'data': '../../../data-99Images/',
                     'image': '../../../images/'}

        # Load .csv data files containing cell spatial coords
        # and biomarker intensities
        self.data_files = [f for f in listdir(self.path['data'])
                           if isfile(join(self.path['data'], f)) and
                           f.endswith('.csv')]

        # Prepare an empyt dict to hold Image objects
        self.Images = {}