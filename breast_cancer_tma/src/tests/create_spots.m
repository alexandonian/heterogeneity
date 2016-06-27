addpath(genpath('/home/alexandonian/heterogeneity/breast_cancer_tma'));
run /home/alexandonian/heterogeneity/breast_cancer_tma/src/setup/make_TMA_struct

file_name = {'ER_AFRemoved_011.tif', 'PR_AFRemoved_011.tif', 'Her2_AFRemoved_011.tif'};
ER = Spot(file_name{1}, TMA);
PR = Spot(file_name{2}, TMA);
HER2 = Spot(file_name{3}, TMA);

% spot2 = Spot3D(ER, PR, HER2);