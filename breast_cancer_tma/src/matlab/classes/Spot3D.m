classdef Spot3D < Image & handle
    %Spot3D Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ER;
        PR;
        HER2;
%         image;
%         adjusted_image;
    end
    
    methods
        
        function obj = Spot3D(ER_Spot, PR_Spot, HER2_Spot)
            
            if (ER_Spot.spot_name == PR_Spot.spot_name & ...
                    ER_Spot.spot_name == HER2_Spot.spot_name)
                
                obj.base_path = ER_Spot.base_path;
                obj.spot_name = ER_Spot.spot_name;
                obj.cohort_num = ER_Spot.cohort_num;
                obj.file_name = ['cohort_', num2str(obj.cohort_num), '_',...
                    obj.spot_name, '.png'];
                obj.path_name = [obj.base_path, 'images3D/cohort_', ...
                    num2str(obj.cohort_num) '/', obj.file_name];
            else
                error('Please ensure that all spots have same spot name')
            end
            
            
            %FIX
            obj.ER = ER_Spot;
            obj.PR = PR_Spot;
            obj.HER2 = HER2_Spot;
            image = cat(3, obj.ER.image, obj.PR.image, obj.HER2.image);
            obj.adjusted_image = cat(3, obj.ER.adjusted_image,...
                obj.PR.adjusted_image, obj.HER2.adjusted_image);
            imwrite(image, obj.path_name);
            
            
        end
        
        function show_contrast(obj)
            % TODO;
            imshow(obj.adjusted_image);
        end
        
        
%         function image = get.image(obj)
%             
%             image = cat(3, obj.ER.image, obj.PR.image, obj.HER2.image);
%         end
%         
%         function adjusted_image = get.adjusted_image(obj)
%            adjusted_image = cat(3, obj.ER.adjusted_image,...
%                obj.PR.adjusted_image, ...
%                obj.HER2.adjusted_image);
%         end
    end
    
    
end

