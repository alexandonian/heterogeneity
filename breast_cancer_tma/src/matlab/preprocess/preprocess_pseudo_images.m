%% Breast Cancer IF Image Preprocessing
%  Alex Andonian, Dan Spagnolo and Chakra Chennubhotla
%  Department of Computational and Systems Biology
%  June, 2016

% preprocess_images.m is responsible for coordinating all IF image
% preprocessing. Preprocessing for each image goes as follows:
%
% - load image and spatial coordinates of each cell in image
% - split image to a series of nonoverlapping patches
% - determine which patches are informative (>3 cells
% - save images to appropriate cancer subtype folder
% - build 3D patches consisting of ER, PR, HER2
%
% preprocess_images.m depends on the following functions:
%
% - process_image.m
% - getCohortInfo.m
% - detectCells.m
% - pseudoAdj.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 						UNDER CONSTRUCTION!!!                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialization

% Files paths
base_path   = '~/heterogeneity/Breast_Cancer_TMA/';
ER_path     = [base_path, 'images/ER-myadj/'];
PR_path     = [base_path, 'images/PR-myadj/'];
HER2_path   = [base_path, 'images/HER2-myadj/'];
image_paths = {ER_path, PR_path, HER2_path};
cohort_path = [base_path, 'MAT_files/StructData_CC_Pheno.mat'];


% Variable delcaration and initialization
load(cohort_path);
file_names = cell(3,2);
nImages     = zeros(3,1);
nBioMarkers = 3;


% Tunable Parameters
tilesize = 256;
nCellThreshold = 4;

% Load file names and spot numbers
for i = 1:nBioMarkers
    
    d = dir([image_paths{i}, '*.tif']);
    file_names{i,1} = {d.name};    
    digits = regexp({d.name}, '\d{2,3}', 'Match');
    file_names{i,2} = digits(:);
    nImages(i) = numel(file_names{i});
end

Images = cell(nBioMarkers, nImages(1));
%% Process images individually

for i = 1:nBioMarkers
    
    for j = 1:nImages(1);
        
        % Build Im_info struct
        Im_info            = struct();
        Im_info.path       = [image_paths{i}, file_names{i}{j}];
        Im_info.filename   = file_names{i}{j};
        Im_info.spot_name  = file_names{i, 2}{j}{:}; % e.g. '001'
        [Im_info.cohort_num, Im_info.xy] = getCohortInfo(Im_info.spot_name, cohort);
        
        % Only process images from 4 cancer subtypes (not cell lines)
        if sum(Im_info.cohort_num == 1:4)
            Im_info.patches = process_pseudo_image(Im_info, tilesize, nCellThreshold);
        end   

        Images{i,j} = Im_info;     
    end
end

save('pseudo_Images.mat', 'Images');


%% Assemble 3D patches by concatenating ER, PR, and HER3 patches along dim 3


for i = 1:nImages(1);
    
    for j = 1:numel(Images{1, i}.patches)
        
        patch = [];
   
        
        % Load ER, PR and HER2 patches in a spot and concatenate then
        % along the 3rd dimension
        
        for k = 1:nBioMarkers
            
            Im = imread(Images{k, i}.patches{j}.path);
            patch = cat(3, patch, Im);
            
        end
        
         imwrite(patch, [base_path, 'pseudo-colored_patches/pseudo_cohort_', ...
             num2str(Images{1, i}.cohort_num), '_', ...
             Images{1, i}.spot_name, '_', ...
             Images{1, i}.patches{j}.filename]);      
    end
end

