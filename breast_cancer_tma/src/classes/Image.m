classdef (Abstract) Image < handle
    %Image An image composed of an array of doubles plus secondary attributes
    %   The secondary attributes include:
    %
    %     spot_name - numbered spot name corresponding to its location in the
    %                 tissue microarray (e.g. '001')
    %
    %     cohort_num - number corresponding to its cancer subtype
    %                  classification or cancer cell line:
    %                  1: ER+ IDC
    %                  2: ER+ ILC
    %                  3: ER- IDC
    %                  4: HER2+ IDC
    %                  5: MCF7
    %                  6: MCF10A
    %                  7: MDA-MB-231
    %                  8: MDA-MB-468
    %
    %     biomarker - immunofluorescent biomarker (e.g. 'ER', 'PR', 'HER2')
    %
    %     xy - an array containing the spatial (xy) coordinates for each cell
    %          measured from the top-left corner
    %
    %     tilesize - height and width (in pixels) of the child patches
    %                derived from image
    %
    %     threshold - number of cells required for child patches to be
    %                 considered informative, and thus retained
    %
    %     parent_image - for derived images, the the parent that was used to
    %                    create this image. This image may inherit attributes from the parent
    %                    image, such as spot_name, cohort_num etc.
    %
    %     patches - child images of size tilesize x tilesize derived by
    %               splitting this image into patches
    %
    %     path_name - the path name to the file holding the image
    %
    %     file_name - the file name of the file holding the image
    %
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % NOTE: Class constructor requires filename of image and TMA stuct.
    %
    %   filename: must be of the form [biomarker]_[processing]_[spot_name].tif
    %
    %   TMA struct: contains path image directory path information and cohort
    %   information. See load_TMA.m for more information
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties
        
        image;
        adjusted_image
        spot_name;
        cohort_num;
%         biomarker;
        xy;
        features;
        tilesize = 256;
        threshold = 4;
%         parent_image;
%         patches;
        path_name;
        file_name;
        base_path;
        
        
        
    end
      
    methods
        
        % Split Image into patches
        function split_into_patches(obj, varargin)
            
            % Check for tilesize
            if nargin > 2
                error('Too many input arguments!')
            elseif nargin == 2
                obj.tilesize = varargin{1};
            end
            
            % Format and call VIPS dzsave command
            base_command = ['vips dzsave %s %s --tile-size %d',... 
                '--depth one --suffix .png'];
            outdir = [obj.base_path, 'proc_images/cohort_',...
                num2str(obj.cohort_num), '/', obj.filename(1:end-4), '/'];
            
            vips_command = sprintf(base_command, Im_info.path, outdir, obj.tilesize);
%             disp(vips_command);
            system(vips_command);
            
        end
        
        % Adjust Contrast for pseudo-colored images
        function adjust_contrast(obj)
            obj.adjusted_image = imadjust(obj.image);
        end
        
        % Display Image
        function show(obj)            
            imshow(obj.image);
        end
        
         % Display Contrast Image
        function show_contrast(obj)
            obj.adjust_contrast();
            imshow(obj.adjusted_image);
        end
        
        % Save Image
        function save_image(obj, target_dir, varargin)
            
            % Check that target_dir ends with '/'
            if ischar(target_dir)
                if ~(target_dir(end) == '/')
                    target_dir(end + 1) = '/';
                end
            else
                error('Target Directory must be a string')
            end
            
            % Check for new file name argument
            if nargin > 3
                error('Too many input arguments!')
            elseif nargin == 3
                file_name = varargin{1};
                imwrite(obj.image, [target_dir, file_name]);
            else
                imwrite(obj.image, [target_dir, obj.file_name]);
            end                                              
        end
        
        % Move Image to new directory
        function move(obj, target_dir)
            
            % Check that target_dir ends with '/'
            if ischar(target_dir)
                if ~(target_dir(end) == '/')
                    target_dir(end + 1) = '/';
                end
            else
                error('Target Directory must be a string')
            end
            
            
            % Format and call mv sytem call
            move = sprintf('mv %s %s', obj.path_name, target_dir);
            status = system(move);
            
            % Make sure move was succesful
            if status == 0
                obj.path_name = [target_dir, obj.file_name];
            else
                error('Move was unsuccesful')
            end
        end
        
        % Utility function for class constructor
        function [cohort_num, xy] = getCohortInfo(obj, TMA)
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
                    return
                end
            end
            warning('Spot does not belong to any cohorts!');
        end
        
        % Getters and Setters
        
        function image = get.image(obj)
            image = im2double(imread(obj.path_name));
        end
        
        function adjusted_image = get.adjusted_image(obj)
            adjusted_image = im2double(imread(obj.path_name));
        end
        
        function set.image(obj, image)
            obj.image = image;
        end
        
         function set.adjusted_image(obj, adjusted_image)
            obj.adjusted_image = adjusted_image;
        end
        
    end 
    
end

