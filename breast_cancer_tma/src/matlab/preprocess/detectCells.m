function [num_cells, cells_xy] = detectCells(patch_info, tilesize)
%detectCells Determines number and location of cells in patch.
%   
%   num_cells = detectCells(patch_info, tilesize) determines the number of
%   cells, num_cells, contained within the patch patch_info.filename.
%   

% Get the tile postion and coords of top left hand corner of patch
idx = regexp(patch_info.filename, '\d');
coords = [str2double(patch_info.filename(idx(1))), ...
          str2double(patch_info.filename(idx(2)))];
coords = tilesize * coords;

xy = patch_info.xy;

% Determine which cells are within the patch
cells = xy(1,:) >= coords(1) & xy(1,:) < (coords(1) + tilesize) & ...
        xy(2,:) >= coords(2) & xy(2,:) < (coords(2) + tilesize);

num_cells = sum(cells);  % number of cells in patch
cells_xy = xy(:, cells); % spatial coords of cells in patch

end
