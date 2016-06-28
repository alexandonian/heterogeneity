%extractNames.m
%input: data structure "cohort" with fields "spot" (struct),
% "numSpots","numCells". "name"
%       array cInds to denote which cohorts to include (values can be 1-8)
%output: 1 cell array that is 1xnumSpots with each spot's name/number

function [names] = extractNames(cohort,cInds)
names = {};
kk=0;
for i = cInds
    ci = cohort(i);
    for j = 1:cohort(i).numSpots
        kk=kk+1;
        nametmp = cohort(i).spot(j).name;
        names{kk} = nametmp;
    end
end

end