classdef (Abstract) ImageSet < handle
    %ImageSet Represents the set of images for a particular iteration of
    %the pipline.
    %   Detailed explanation goes here
    
    properties
        images;
        num_images;
%         num_biomarkers = 3;
%         biomarkers = {'ER', 'PR', 'HER2'};
        file_name_list;
        image_dir;
    end
    
    methods
       
    end
    
end

