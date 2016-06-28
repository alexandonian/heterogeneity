%% make_TMA_struct.m
% Simple Script to Create TMA Struct to be used by TissueMicroArray Class 
% constructor.

%% Set Path of Cohort.mat file
TMA_struct =load('../mat_files/StructData_CC_Pheno.mat');

%% Set path of the project's base directory
TMA_struct.base_path = '/Users/alexandonian/heterogeneity/breast_cancer_tma/';

% Set Biomarkers used in Study
TMA_struct.biomarkers = {'ER', 'PR', 'HER2'};
TMA_struct.num_biomarkers = length(TMA_struct.biomarkers);

%% Set paths of individual biomarker image directories
TMA_struct.image_dirs = {...
    [TMA_struct.base_path, 'images/ER-allTissue/'],...
    [TMA_struct.base_path, 'images/PR-allTissue/'],...
    [TMA_struct.base_path, 'images/HER2-allTissue/'],...
    [TMA_struct.base_path, 'images/ER-allTissue/'],...
    [TMA_struct.base_path, 'images/PR-myadj/'],...
    [TMA_struct.base_path, 'images/HER2-myadj/']};

% Determine number of spots in TMA. NOTE: all image directories must
% contain same number of images!!!! Otherwise, we will encounter issues!
num_images = zeros(TMA_struct.num_biomarkers, 1);
for i = 1: TMA_struct.num_biomarkers
    d = dir([TMA_struct.image_dirs{i}, '*.tif']);
    num_images(i) = length({d.name});
end

if sum(num_images(1) ~= num_images)
    error('All image directories must contain the same number of images!')
    for i = 1: TMA_struct.num_biomarkers
       fprintf('%s has %d images \n', TMA_struct.image_dirs{i}, num_images(i)); 
    end
end

TMA_struct.num_spots = num_images(1);
%% Save TMA Stuct to mat_files directory

save('../mat_files/TMA_struct.mat', 'TMA_struct');

    




    
    