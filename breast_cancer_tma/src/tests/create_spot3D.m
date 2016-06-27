load_TMA
file_name = {'ER_AFRemoved_011.tif', 'PR_AFRemoved_011.tif', 'HER2_AFRemoved_011.tif'};

ER = Spot(file_name{1}, TMA);
PR = Spot(file_name{2}, TMA);
HER2 = Spot(file_name{3}, TMA);

spot3 = Spot3D(ER, PR, HER2);