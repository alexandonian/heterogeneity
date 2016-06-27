%extractXYlocs.m
%input: data structure "cohort" with fields "spot" (struct),
% "numSpots","numCells". "name"
%       array cInds to denote which cohorts to include (values can be 1-8)
%output: 1 matrix that is 2xnumCells with each cell's xy location

function [xy] = extractXYlocs(cohort,cInds)
xy = [];

for i = cInds
    ci = cohort(i);
    for j = 1:cohort(i).numSpots
        xytemp = cohort(i).spot(j).xy;
        xy = [xy xytemp];
    end
end

end