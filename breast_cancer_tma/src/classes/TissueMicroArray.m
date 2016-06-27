classdef TissueMicroArray < ImageSet
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        num_biomarkers = 3;
        biomarkers = {'ER', 'PR', 'HER2'};     
    end
    
    methods
        function obj = TissueMicroArray(image_dir)
            load_TMA;
            
            d = dir([image_dir, obj.biomarkers{1},'-allTissue/']); 
            disp(d)
            obj.images = cell(obj.num_biomarkers, numel({d.name}));
            
            for i = 1:obj.num_biomarkers
                
                d = dir([image_dir, obj.biomarkers{i},'-allTissue/*.tif']);
                filenames = {d.name};
                for j = 1: numel(filenames)
                   obj.images{i, j} = Spot(filenames{j}, TMA);
                   obj.images{i, j}.split_into_patches();
                end
                
            end
            obj.num_images = i * j;
        end
    end
    
end
