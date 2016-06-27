
function cellQ = loadCellQuantFromSpot(filehdr,spotId,featureIdx);

    filename = fullfile(filehdr, strcat(spotId, '_Quant.csv'));

    delimiterIn = ',';
    headerlinesIn = 1;
    %changed 4/2/15 if it doesn't work change back.
    A = importdata(filename,delimiterIn,headerlinesIn); 
    %A = importdata(filename,delimiterIn,headerlinesIn);
    A = A.data;

    cellQ = A(:,featureIdx);
end