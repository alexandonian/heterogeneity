classdef Patch < Image
    %Patch Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        num_cells;
        parent_image;
        biomarker;
        triplets;
    end
    
    properties (Dependent)
        empty = false;
    end
    
    methods
        
        % Class Constructor
        function obj = Patch(parent, file_name)
            obj.file_name = file_name;
            obj.spot_name = parent.spot_name;
            obj.cohort_num = parent.cohort_num;
            obj.biomarker = parent.biomarker;
            obj.tilesize = parent.tilesize;
            obj.xy = parent.xy;
            obj.features = parent.features;
            obj.parent_image = parent;
            obj.path_name = [parent.patches_outdir, '_files/0/', obj.file_name];
            [obj.num_cells, obj.xy, obj.features] = ...
                obj.detectCells(obj.tilesize);
            %             obj.image = im2double(imread(obj.path_name));
        end
        
        function [num_cells, xy, features] = detectCells(obj, tilesize)
            %detectCells Determines number and location of cells in patch.
            
            % Get the tile postion and coords of top left hand corner of patch
            idx = regexp(obj.file_name, '\d');
            coords = [str2double(obj.file_name(idx(1))), ...
                str2double(obj.file_name(idx(2)))];
            coords = tilesize * coords;
            
            % Determine which cells are within the patch
            cells = obj.xy(1,:) >= coords(1) & obj.xy(1,:) < (coords(1) + tilesize) & ...
                obj.xy(2,:) >= coords(2) & obj.xy(2,:) < (coords(2) + tilesize);
            
            num_cells = sum(cells);  % number of cells in patch
            xy = obj.xy(:, cells); % spatial coords of cells in patch
            features = obj.features(:, cells); % biomarker intensities
            
        end
        
        function generate_triplets(obj)
            
            D = squareform(pdist(obj.xy'));
            [~, idx] = sort(D,2);
            closest = idx(:, 2:4);
            triplet_matrix = zeros(9, 6, obj.num_cells);
            
            
            for i = 1:obj.num_cells
                
                switch obj.biomarker
                    case 'ER'
                        ABC = obj.features(1:3,closest(i,:)); % ABC as columns
                    case 'PR'
                        ABC = obj.features(4:6,closest(i,:));
                    case 'HER2'
                        ABC = obj.features(7:9,closest(i,:));
                end
                
                A = ABC(:,1); B = ABC(:,2); C = ABC(:,3);
                
                triplet_matrix(:,:, i) = ...
                    [A, A, B, B, C, C;...
                     B, C, A, C, A, B;...
                     C, B, C, A, B, A];                
            end
            obj.triplets = triplet_matrix;
        end
        
        function value = get.empty(obj)
            if obj.num_cells < obj.threshold
                value = true;
            else
                value = false;
            end
            
        end
        
    end
    
end

