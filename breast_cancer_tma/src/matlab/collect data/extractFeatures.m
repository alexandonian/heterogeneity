%extractXYlocs.m
%input: data structure "cohort" with fields "spot" (struct),
% "numSpots","numCells". "name"
%       array cInds to denote which cohorts to include (values can be 1-8)
%       integer (0 or 1) logFlag to denote if log conversion happens
%output: 1 matrix that is numFeats x numCells

function [feats] = extractFeatures(cohort,cInds,logFlag)
feats = [];

for i = cInds
    ci = cohort(i);
    for j = 1:cohort(i).numSpots
        ftemp = cohort(i).spot(j).features;
        if logFlag
            ftemp(ftemp < 1) = 1;
            ftemp = log(ftemp);
        end
        feats = [feats ftemp];
    end
end

end