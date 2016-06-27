classdef spot < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        spot_name;
        cohort_num;
        xy;
        path;
        filename;
        patches
        tilesize = 256;
        threshold = 4;
        cohort_path = '~/TECBio/heterogeneity/Breast_Cancer_TMA/MAT_files/StructData_CC_Pheno.mat'
    end
    
    methods
        
        % Class Constructor
        function obj = spot(spot_name, cohort)
            if nargin < 1
                if ischar(spot_name)
                    obj.spot_name = spot_name;
                    [obj.cohort_num, obj.xy] = getCohortInfo(spot_name, cohort);
                else
                    error('spot name must be a string')
                end
            elseif nargin == 1
                
                
            end
        end
        
        function move(obj, target_dir)
          
            system(['mv ', obj.path,' ',  target_dir])
        end
        
    end
    
end

