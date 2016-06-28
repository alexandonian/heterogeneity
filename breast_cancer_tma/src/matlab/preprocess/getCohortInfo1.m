function [cohort_num, xy] = getCohortInfo1(spot_name, cohort)
%getCohortInfo Determines the cohort number and fetches the spatial
%coordinates for the spot labeled spot_num.

for i = 1:8
    
    % Match spot_num to a spot name in cohort
    c_i = {cohort(i).spot.name};
    idx = strcmp(spot_name, c_i);
    
    % If there is a match, get the cohort num and xy coords.
    if sum(idx)
        cohort_num = i;
        xy = cohort(i).spot(idx).xy;
        return
    end
end
warning('Spot does not belong to any cohorts!');
end

% Junk
% c1 = {cohort(1).spot.name};
% c2 = {cohort(2).spot.name};
% c3 = {cohort(3).spot.name};
% c4 = {cohort(4).spot.name};
%
% if sum(strcmp(spot_name, c1))
%     cohort_num = 1;
% elseif sum(strcmp(spot_name, c2))
%     cohort_num = 2;
% elseif sum(strcmp(spot_name, c3))
%     cohort_num = 3;
% elseif sum(strcmp(spot_nam, c4))
%     cohort_num = 4;
% else
%     cohort_num = 0;
%     warning('Spot does not belong to any cohorts!')