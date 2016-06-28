classdef Spot < Image
    %Spot An TMA Spot derived from the Image class with secondary
    %attributes
    %   The secondary attributes include:
    %
    %   biomarker - immunofluorescent biomarker (e.g. 'ER', 'PR', 'HER2')
    %
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % NOTE: Class constructor requires filename of image and TMA stuct.
    %
    %   filename: must be of the form
    %   [biomarker]_[processing]_[spot_name].tif
    %
    %   TMA struct: contains path image directory path information and
    %   cohort information. See load_TMA.m for more information
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties
        
        biomarker;
       
    end
    
    methods
        
        % Class Constructor
        function obj = Spot(file_name, TMA_struct)
            
            % Set base path and file name
            obj.base_path = TMA_struct.base_path;
            obj.file_name = file_name;
            
            % Determine spot_name from file_name
            spot = regexp(file_name, '[0-9]{2,3}', 'Match');
            obj.spot_name = spot{end};
            
            % Determine biomarker from file_name
            bio = regexp(file_name, '^[^_]+(?=_)', 'Match');
            obj.biomarker = bio{end};
            
            switch obj.biomarker
                case 'ER'
                    obj.path_name = strcat(TMA_struct.image_dirs{1}, file_name);
                case 'PR'
                    obj.path_name = strcat(TMA_struct.image_dirs{2}, file_name);
                case 'HER2'
                    obj.path_name = strcat(TMA_struct.image_dirs{3}, file_name);
                case 'Her2'
                     obj.path_name = strcat(TMA_struct.image_dirs{3}, file_name);
                otherwise
                    error(['Biomarker type (%s) not detected:',...
                        'check file name (biomarker should be in ALL CAPS'],...
                        obj.biomarer)
            end
            
            % Determine cohort_num and spatial coords using TMA info
            [obj.cohort_num, obj.xy, obj.features] = obj.getCohortInfo(TMA_struct);
            
            % Load image
            %             obj.image = im2double(imread(obj.path_name));
            
        end

        % Utility function for class constructor
        function [cohort_num, xy, features] = getCohortInfo(obj, TMA)
            %getCohortInfo Determines the cohort number and fetches the spatial
            %coordinates for the spot labeled spot_num.
            
            for i = 1:8
                
                % Match spot_num to a spot name in cohort
                c_i = {TMA.cohort(i).spot.name};
                idx = strcmp(obj.spot_name, c_i);
                
                % If there is a match, get the cohort num and xy coords.
                if sum(idx)
                    cohort_num = i;
                    xy = TMA.cohort(i).spot(idx).xy;
                    features = TMA.cohort(i).spot(idx).features;
                    return
                end
            end
            warning('Spot does not belong to any cohorts!');
        end
        
    end
    
end

