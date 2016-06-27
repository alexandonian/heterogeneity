function [patchadj] = pseudoAdj(patch)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

ER = patch(:,:,1);
PR = patch(:,:,2);
HER2 =  patch(:,:,3);

ERx = double(ER(:));
PRx = double(PR(:));
HER2x = double(HER2(:));

low_high = [prctile(ERx, 5)/max(PRx), prctile(PRx, 95)/max(PRx);...
    prctile(PRx, 5)/max(PRx), prctile(PRx, 95)/max(PRx);...
    prctile(HER2Rx, 5)/max(PRx), prctile(HER2x, 95)/max(PRx)];

ERadj = imadjust(ER);
PRx = double(PR(:));
PRadj = imadjust(PR, [prctile(PRx, 5)/max(PRx), prctile(PRx, 95)/max(PRx)+ 0.0001]);
HER2adj = imadjust(HER2);

patchadj = cat(3, ERadj, PRadj, HER2adj);


end

