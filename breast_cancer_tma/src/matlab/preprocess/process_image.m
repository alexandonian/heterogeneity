function [Patches] = process_image(Im_info, tilesize, threshold)
%process_image Split images into patches of size tilesize x tilesize and retain
%only patches that contain threshold+ cells. 

% process_image accepts three parameters:
% 
% - Im_info: a struct containting information about image
% - tilesize: the desired height and width of patch
% - threshold: minimum number of cells needed to be considered informative

% process_image returns a cell array, Patches, which contains info about
% individual patches

%% Call VIPS dzsave to split image into patches 

% Create vips dzsave command to make a 1-layer image pyramid
% (i.e. tile image into non-overlapping patches)

base_command = 'vips dzsave %s %s --tile-size %d --depth one --suffix .png';
outdir = ['~/heterogeneity/Breast_Cancer_TMA/proc_images/cohort_',...
    num2str(Im_info.cohort_num), '/', Im_info.filename(1:end-4)];



% Format and call system command
vips_command = sprintf(base_command, Im_info.path, outdir, tilesize);

% disp(vips_command);
 system(vips_command);

%% Determie which patches contain threshold+ cells

% Gather patches
d = dir([outdir, '_files/0/*.png']);
patch_filenames = {d.name};
nPatches = numel(patch_filenames);
Patches = cell(nPatches, 1);

make_empty_patch_dir = sprintf('mkdir %s', [outdir, '_files/emptypatches']);
system(make_empty_patch_dir);


% Prune cells with too few cells
for i = 1:nPatches
    
    % Build patch_info struct
    patch_info = Im_info;
    patch_info.filename  = patch_filenames{i};
    patch_info.path = [outdir, '_files/0/', patch_filenames{i}];
    patch_info.empty = 0; % assume the patch isn't empty at first
    patch_info.num_cells = detectCells(patch_info, tilesize);
    
    
    % Determine if the patch has enough cells
    if (patch_info.num_cells < threshold)
        
        % Move empty patches to a different directory
        patch_info.empty = 1;
        patch_info.num_cells = 
        move_empty_patch = sprintf('mv %s %s', [outdir, '_files/0/', patch_filenames{i}],...
            [outdir, '_files/emptypatches']);
        system(move_empty_patch);
    end
    
    % Store patch info to be used later
    Patches{i} = patch_info;
end
end

