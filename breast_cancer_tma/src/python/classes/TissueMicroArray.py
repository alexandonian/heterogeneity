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

class TissueMicroArray(object):

    def __init__(self):
    	self.data = '../../../data-99spots'
    	self.files = [f for f in listdir(self.data) if isfile(join(self.data, f)) and f.endswith('.csv')]
    	self.spots = []

    	for f in self.files:

    		df = pd.read_csv(join(self.data,f))
    		spot_name = f.split('_')[0]
    		cohort_num = 1
    		a = self.determineCohort(spot_name)
    		xy = np.concatenate((np.reshape(df.Cell_X, (-1,1)), np.reshape(df.Cell_Y, (-1,1))),axis=1)
    		biomarker, location, col = zip(*[(col.split('_')[0], col.split('_')[1], col) for col in list(df) if col.split('_')[0] != 'Cell'])
    		uniq_biomarker = list(set(biomarker))
    		uniq_location = list(set(location))

    		k = 0
    		features = {}    	
    		images = {}
    		for i, bio in enumerate(uniq_biomarker):
    			features[bio] = {}
    			images[bio] = 
    			for j, loc in enumerate(uniq_location):
    				features[bio][loc] = df[col[k]].values
    				k+=1


    		self.spots.append(Spot(None, spot_name, cohort_num, features, xy, tilesize=256, patches=None))


    def determineCohort(self,spot_name):
    	cohort_1 = ['000', '005', '026', '031', '046', '055', '060', '081', '086']
    	cohort_2 = ['001', '006', '011', '016', '025', '030', '043', '045', '056',
    		'061', '066', '076', '080', '085', '096']
    	cohort_3 = ['002', '007', '012', '017', '020', '024', '029', '032', '034',
    		'036', '039', '044', '049', '052', '057', '062', '067', '071', '072',
    		'079', '084', '089', '091', '095']
    	cohort_4 = ['003', '008', '013', '015', '018', '021', '023', '028', '033',
    	'038', '041', '048', '053', '058', '063', '065', '068', '070', '073','078', 
    	'083', '088', '090', '093']
    	cohort_5 = ['022', '035', '037', '047', '059', '069', '075', '087']
    	cohort_6 = ['004', '014', '050', '097']
    	cohort_7 = ['009', '010', '019', '027', '042', '077', '092', '098']
    	cohort_8 = ['040', '051', '054', '064', '074', '082', '094']
    	cohorts =[cohort_1, cohort_2, cohort_3, cohort_4, cohort_5, cohort_6,
    		cohort_7, cohort_8,]
  
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

		if image is not None:
			self.image = image
		if spot_name is not None:
			self.spot_name = spot_name
		if cohort_num is not None:
			self.cohort_num = cohort_num
		if features is not None:
			self.features = features
		if xy is not None:
			self.xy = xy



tma = TissueMicroArray()
# tma.spots[1].features.keys()
# for i in range(len(tma.spots)):
# 	print tma.spots[i].spot_name

print tma.spots[1].features.keys()

    