%collectData.m
%collect subcellular data, convert to log, observe scatter & data
%tendencies

clear all, close all hidden; clc;
%addpath ompbox10/
%addpath ksvdbox13/

%% SET UP PARAMETERS

% location of the necessary data files.
filehdr = '/home/alexandonian/heterogeneity/Breast_Cancer_TMA/data-99spots';

% ALL SPOTS, ER+ IDC, ER+ ILC, ER- IDC, HER+ IDC
% include all data!
er_pos_idc = {'000','005','026','031','046','055','060','081','086'}; %81
er_pos_ilc = {'001','006','011','016','025','030','043','045','056','061','066','076','080','085','096'}; %16,85
er_neg_idc = {'002','007','012','017','020','024','029','032','034','036','039','044','049','052','057','062','067','071','072','079','084','089','091','095'};%84
her2_pos_idc = {'003','008','013','015','018','021','023','028','033','038','041','048','053','058','063','065','068','070','073','078','083','088','090','093'};
erpr_cell = {'022', '035', '037', '047', '059', '069', '075', '087'};
trip_neg_cell = {'004', '014', '050', '097'}; %50, 97
quad_neg_cell = {'009', '010', '019', '027', '042', '077', '092', '098'}; %42
egfr_pos_cell = {'040', '051', '054', '064', '074', '082', '094'};

% save all spots as a since cell array, and an array of arrays
spots = [er_pos_idc er_pos_ilc er_neg_idc her2_pos_idc erpr_cell trip_neg_cell quad_neg_cell egfr_pos_cell];
cohorts = {er_pos_idc, er_pos_ilc, er_neg_idc, her2_pos_idc, erpr_cell, trip_neg_cell, quad_neg_cell, egfr_pos_cell};
cohort_names = {'ER+ IDC', 'ER+ ILC', 'ER- IDC','HER2+ IDC', 'MCF7', 'MCF10A', 'MDA-MB-231', 'MDA-MB-468'};

% channels of interest
xy_i = 2:3; % x-loc, y-loc
er_i = 10:12;  % er nuc,cyt, mem
her_i = 7:9;   % her2 nuc, cyt, mem
pr_i = 13:15; % pr nuc, cyt, mem
egfr_i = 4:6; % egfr nuc, cyt, mem
pcad_i = 16:18; %pcad nuc, cyt, mem

%% Conglomerate Data
[X Xlog ID Xcohort] = conglomerateSubCellData(filehdr,{xy_i er_i her_i pr_i egfr_i pcad_i},cohorts, cohort_names);
save('totData.mat','X','Xlog','ID');
[cohort] = conglomerateDataStructArray(filehdr,{xy_i er_i her_i pr_i egfr_i pcad_i},cohorts, cohort_names);
save('StructData.mat','cohort');

%% Visualize Data
dims = {'ER-nuc', 'ER-cyt', 'ER-mem','HER2-nuc', 'HER2-cyt', 'HER2-mem','PR-nuc', 'PR-cyt', 'PR-mem','EGFR-nuc', 'EGFR-cyt', 'EGFR-mem','PCAD-nuc', 'PCAD-cyt', 'PCAD-mem'};
cohort_names = {'ER+ IDC', 'ER+ ILC', 'ER- IDC','HER2+ IDC', 'MCF7', 'MCF10A', 'MDA-MB-231', 'MDA-MB-468'};
X = extractFeatures(cohort,[1 2 3 4 5 6 7 8],1);
scatterSubCell(Xcohort, cohort_names, dims);
scatterFromStruct(cohort,cohort_names, dims);
%% 







