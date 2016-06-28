load('Images.mat')

patch = [];
pseudo_patch = [];

% Load ER, PR and HER2 patches in a spot and concatenate then
% along the 3rd dimension

for k = 1:3
    
    Im = imread(Images{k, 11}.patches{36}.path);
    pseudo_Im = Im;
    Im(Im < 1) = 0;
    Im = uint16(log(double(Im)));
    patch = cat(3, patch, Im);
    pseudo_patch = cat(3, pseudo_patch, pseudo_Im);
    
    
end
imshow(pseudo_patch);
imshow(pseudoAdj(pseudo_patch))