classdef TissueMicroArray < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        spots;
        biomarkers;
        num_biomarkers;
        num_spots;
        base_path;
        image_dirs
    end
    
    methods
        
        % Class Constructor
        function obj = TissueMicroArray(TMA_struct)
            
            % obj = TissueMicroArray(TMA_Struct) produces as set of Spots
            % and their respective patches bassed on information about the
            % dataset stored in TMA_Struct.
            % See setup/make_TMA.m for setup details.
            
            obj.biomarkers = TMA_struct.biomarkers;
            obj.num_biomarkers = TMA_struct.num_biomarkers;
            obj.num_spots = TMA_struct.num_spots;
            obj.base_path = TMA_struct.base_path;
            obj.image_dirs = TMA_struct.image_dirs;            
            obj.spots = cell(obj.num_biomarkers, obj.num_spots);
            
            for i = 1:obj.num_biomarkers
                
                d = dir([obj.image_dirs{i}, '*.tif']);
                filenames = {d.name};
                
                for j = 1:obj.num_spots
                    obj.spots{i, j} = Spot(filenames{j}, TMA_struct);
                    obj.spots{i, j}.split_into_patches();
                end
            end            
        end
    end
end
