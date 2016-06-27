function [Im] = showPseudoColoredIm(spot_name)
%showPseudoColoredIm Shows pseuodo-colored image

% I ought to check if it is a valid spot name...
if ~ischar(spot_name)
   warning('spot name must be a string!')
% elseif ~ sum(strcmp(spot_name, list_of_spot_names))
%     error('not a valide spot name')
end

% Load adjusted images (maximized contrast)

base_path = '/home/alexandonian/heterogeneity/Breast_Cancer_TMA/images/';
ER = imread([base_path, 'ER-myadj/ER_AFRemoved_', spot_name, '-myadj.tif']);
PR = imread([base_path, 'PR-myadj/PR_AFRemoved_', spot_name, '-myadj.tif']);
HER2 = imread([base_path, 'HER2-myadj/Her2_AFRemoved_', spot_name, '-myadj.tif']);

Im = cat(3, ER, PR, HER2);
imshow(Im);

end

