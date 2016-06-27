%% Inital Exploration

load('/Users/alexandonian/TECBio/Breast Cancer TMA/MAT files/StructData_CC_Pheno.mat')

numCohorts = 4;

figure

for i = 1:numCohorts
    ER = [];
    PR = [];
    HER2 =  [];
    
    for j = 1:cohort(i).numSpots
%          spots{end+1} = cohort(i).spot(j).features(1:9,:);
           e = cohort(i).spot(j).features(1:3, :);
           ER = [ER mean(e, 1)];
           p = cohort(i).spot(j).features(4:6, :);
           PR = [PR mean(p, 1)];
           h = cohort(i).spot(j).features(7:9, :);
           HER2 = [HER2 mean(h, 1)];
    end
    
    subplot(2, 2, i)
    plot3(log(ER), log(PR), log(HER2), 'linestyle', 'none', 'marker', '.')
end

figure; 
plot3(log(ER), log(PR), log(HER2), 'linestyle', 'none', 'marker', '.')

%% Distance

figure
cNum = 1;
for cNum = 1:4
    dist = zeros(1,cohort(cNum).numSpots);
    for i = 1:cohort(cNum).numSpots
%         subplot(3,3, i)
%         plot(cohort(cNum).spot(i).xy(1,:), cohort(cNum).spot(i).xy(2,:),'linestyle', 'none', 'marker', '.', 'markersize', 5)
%         disp(mean(pdist(cohort(cNum).spot(i).xy')))
        dist(i) = mean(pdist(cohort(cNum).spot(i).xy'));
    end
    disp('Mean: ')
    disp(mean(dist))
    disp std
    disp(std(dist))
    
end
xy = cohort(1).spot(1).xy;
len = length(cohort(1).spot(1).xy);
dist = zeros(i, j);
% for i = 1:len
%     for j = 1:len
%         if i == j
%             continue
%         end
%         dist(i, j) = sqrt(xy(:,i).^2 + xy(:,j).^2);
%     end
% end

%% View Data

nCohorts = 4;
for i = 1:nCohorts
    for j = 1:cohort(i).numSpots
        figure
        e = cohort(i).spot(j).features(2, :);
        scatter(cohort(i).spot(j).xy(1,:), cohort(i).spot(j).xy(2,:), 20, e, 'filled')
        title(['Cohort' num2str(i)])
    end
end