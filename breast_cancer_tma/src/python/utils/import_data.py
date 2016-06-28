import csv
import pandas as pd
import numpy as np
from os import listdir
from os.path import isfile, join
import re

data = '../../../data-99spots/'
files = [f for f in listdir(data) if isfile(join(data, f)) and f.endswith('.csv')]

# for file in files:
#     with open(data+files[1], 'rb') as csvfile:
#         reader = csv.reader(csvfile, delimiter=',', quotechar='|')
#         for row in reader:
#             print ', '.join(row)

csv_file = data + files[1]
df = pd.read_csv(csv_file)
# saved_column = df.column_name #you can also use df['column_name']
# print df['Cell_ID']
a =df[:5]
print a
xy = np.concatenate((np.reshape(df.Cell_X, (-1,1)), np.reshape(df.Cell_Y, (-1,1))),axis=1)
print xy
for col in list(df):
    
     m = re.search('^[^_]+(?=_)', col)
     # print m.group(0)

biomarker = [m.group(0) for col in list(df) for m in [re.search('^[^_]+(?=_)', col)] if col != 'Cell']
# biomarker = list(set(biomarker))
biomarker[:] = list(set((bio for bio in biomarker if bio != 'Cell')))
print biomarker

filename = '011_Quant.csv'
spot_name = re.search('\d{2,3}', filename).group(0)
print spot_name
print type(spot_name)

def determineCohort(spot_name):
    cohort_1 = ['000', '005', '026', '031', '046', '055', '060', '081', '086']
    cohort_2 = ['001', '006', '011', '016', '025', '030', '043', '045', '056',
         '061', '066', '076', '080', '085', '096']
    cohort_3 = ['002', '007', '012', '017', '020', '024', '029', '032', '034',
        '036', '039', '044', '049', '052', '057', '062', '067', '071', '072',
        '079', '084', '089', '091', '095']
    cohort_4 = ['003', '008', '013', '015', '018', '021', '023', '028', '033',
        '038', '041', '048', '053', '058', '063', '065', '068', '070', '073',
        '078', '083', '088', '090', '093']
    if spot_name in cohort_1:
        return 1
    elif spot_name in cohort_2:
        return 2
    elif spot_name in cohort_3:
        return 3
    elif spot_name in cohort_4:
        return 4
    else:
        print 'Spot does not belong to any cohorts!'
print determineCohort(spot_name)





# xy = np.concatenate((np.reshape(df.Cell_X.values,(-1,1)), np.reshape(df.Cell_Y.values, (-1,1)))

# print a[1]
# print df.Cell_ID.values
# print list(df)
# print df.columns.values

# TODO
# to get all biomarkers, parse column headder values using [biomarker]_[location]_Quant
# bio = regexp(file_name, '^[^_]+(?=_)', 'Match');
# to get spot num, parse filename, to get cohort num, map spot name to cohort name (easy)
  # spot = regexp(file_name, '[0-9]{2,3}', 'Match');
# load features (biomarker intensities) as dictionaries features['biomarker'] returns ndarray with intensities,
# another option features[(biomarker, location)] returns intensity for biomarker at location
# where its index in the array corresponds to the cellnumber cell_ID(ith cell has location xy[i] and intensity feaures[biomarker][i])
# store patches in either list or dictionary

# TMA class will read spread sheets, Spots constructor will simply take all the parameters it needs, 

# just like biomarkers will use a dict to store intensity values, imgages will also use dict. 
# e.g. spot.images['biomarker'] returns the biomarker channel image.
# spot class can determine which biomarkers (say 3) are informative, display as rgb
# e.g. spots.display_informative returns RGB image of informative channels
# 

# TODO: make a first pass naive implementation, ask other lab members to help make code more "pythonic"

# for col in a:
#     print df[col].values
