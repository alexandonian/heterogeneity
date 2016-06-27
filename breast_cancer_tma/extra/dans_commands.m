load('StructData_CC_Pheno.mat');
cohort
cohort(1)
cohort(8)
cohort(4)
cohort(4).spot(1);  
x =cohort(1).spot(1);
size(x)
x =cohort(1).spot(1)
x =cohort(1).spot(1).features;
size(x)
x = x(1:9,:);
cohort(1).spot(1).micro(1:10)
x
size(x)
max(max(x))
min(min(x))
x(x<1) = 1;
x = log(x);
max(max(x))