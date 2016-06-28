%extractXYlocs.m
%input: data structure "cohort" with fields "spot" (struct),
% "numSpots","numCells". "name"
%       array cInds to denote which cohorts to include (values can be 1-8)
%output: 1 array that is 1xnumCells containing phenotype labels for each
%cell

function [labs] = extractLabels(cohort,cInds)
labs = [];

for i = cInds
    ci = cohort(i);
    for j = 1:cohort(i).numSpots
        labtemp = cohort(i).spot(j).labels;
        labs = [labs labtemp];
    end
end

end