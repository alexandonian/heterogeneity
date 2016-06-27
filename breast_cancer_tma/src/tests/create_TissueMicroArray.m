%% Create a TissueMicroArray Object

%% Add files to MATLAB path and run setup script

addpath(genpath('/home/alexandonian/heterogeneity/breast_cancer_tma'));
run /home/alexandonian/heterogeneity/breast_cancer_tma/src/setup/make_TMA_struct

%% Generate TissueMicroArray

TMA = TissueMicroArray(TMA_struct);




