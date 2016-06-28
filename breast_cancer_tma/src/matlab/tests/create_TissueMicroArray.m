%% Create a TissueMicroArray Object

%% Add files to MATLAB path and run setup script

addpath(genpath('../../../'));
run ../setup/make_TMA_struct


%% Generate TissueMicroArray

TMA = TissueMicroArray(TMA_struct);




