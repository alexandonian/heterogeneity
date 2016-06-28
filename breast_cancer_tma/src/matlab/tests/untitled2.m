im = imread('~/heterogeneity/Breast_Cancer_TMA/images/PR-allTissue/PR_AFRemoved_011.tif');


imx =double(im);
x = imx(:);
max(x)
min(x)
[n,s] = hist(x,31);
plot(s,n)
% help prctile
prctile(x,1)
prctile(x,95)
disp('percentage')



figure
for i = 1: 9
subplot(3,3,i)
adj = linspace(0.01, 0.03,9);
imadj = imadjust(im, [0.000, adj(i)]);


imshow(imadj);
end