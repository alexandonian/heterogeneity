%conglomerateSubCellData.m

% get each of the individual biomarker channels for each spot, take mean,
% concatenate mean expressions, accumulate for all spots.

% input:    filelocs = location of data files
%           datalocs = indicies in data file of the discrete biomarkers
%           datasources = individual cell arrays of cohort spots
%           sourcenames = names of the cohorts

% output:   X = (#biomarkers x numCells) contains log of mean expression 
%               for ER HER2 and PR
%           Xlin = (#biomarkers x numCells) contains linear mean expression
%               for ER HER2 and PR
%           ID = (3 x numCells) contains x location, y location, and 
%               spot # for each cell

function [X Xlog ID Xcohort] = conglomerateSubCellData(fileloc, datalocs, datasources, sourcenames)

X = [];
Xlog = [];
Xcohort = {};
ID = [];

% set up data locs
xy_i = datalocs{1};
er_i = datalocs{2};
her_i = datalocs{3};
pr_i = datalocs{4};
egfr_i = datalocs{5};
pcad_i = datalocs{6};

kk=0;
for i = 1:length(datasources)
    cohort = datasources{i};
    Xc = [];
    for j = 1:length(cohort)
        %update count
        kk= kk+1;
        
        %grab data
        xyQ = loadCellQuantFromSpot(fileloc,cohort{j},xy_i)';
        erQ = loadCellQuantFromSpot(fileloc,cohort{j},er_i)';
        herQ = loadCellQuantFromSpot(fileloc,cohort{j},her_i)';
        prQ = loadCellQuantFromSpot(fileloc,cohort{j},pr_i)';
        egfrQ = loadCellQuantFromSpot(fileloc,cohort{j},egfr_i)';
        pcadQ = loadCellQuantFromSpot(fileloc,cohort{j},pcad_i)';
        cellQ = [erQ ; herQ ; prQ ; egfrQ ; pcadQ];
        
        if size(erQ,2) < 100
            disp([cohort{j} ' < 100 cells at ' num2str(size(erQ,2)) ' cells']);
        end
        
        % save linear pts
        X = [X cellQ];
        
        idQ = repmat(kk,1,size(xyQ,2));
        cohortQ = repmat(i,1,size(xyQ,2));
        temp = [xyQ;idQ;cohortQ];
        ID = [ID temp];
        
        Xc = [Xc cellQ];
    end
    Xcohort{i} = Xc;
  
end

Xlog = X;
Xlog(Xlog < 1) = 1;
Xlog = log(Xlog);

nonCellline = 0;
for xx = 1:length(datasources)
    disp(['Number of cells in ' sourcenames{xx} ' cohort is ' num2str(nnz(ID(4,:)==xx))]);
    if xx <= 4
       nonCellline = nonCellline +  nnz(ID(4,:)==xx);
    end
end
disp(['Number of cells in non-cell-line data is ' num2str(nonCellline)]);


end