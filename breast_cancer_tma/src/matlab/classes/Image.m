classdef (Abstract) Image < handle
    %Image An image composed of an array of doubles plus secondary
    %attributes
    %   The secondary attributes include:
    %
    %     
    %
    %    spot_name - numbered spot name corresponding to its location in
    %                the tissue microarray (e.g. '001')
    %
    %    cohort_num - number corresponding to its cancer subtype
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
    %    xy - an array containing the spatial (xy) coordinates for each
    %         cell measured from the top-left corner
    %
    %    tilesize - height and width (in pixels) of the child patches
    %               derived from image
    %
    %    threshold - number of cells required for child patches to be
    %                considered informative, and thus retained
    %
    %    parent_image - for derived images, the the parent that was used
    %                   to create this image. This image may inherit
    %                   attributes from the parent image, such as
    %                   spot_name, cohort_num etc.
    %
    %    patches - child images of size tilesize x tilesize derived by
    %              splitting this image into patches
    %
    %    path_name - the path name to the file holding the image
    %
    %    file_name - the file name of the file holding the image
    %
    %    patches - child images of size tilesize x tilesize derived by
    %              splitting this image into patches
    %
    %    patches_outdir - path name to the directory contain child patches
    %
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

    
    properties
        
        image;
        adjusted_image
        spot_name;
        cohort_num;
        xy;
        features;
        tilesize = 256;
        threshold = 4;
        path_name;
        path_name_adjusted;
        file_name;
        base_path;
        patches;
        patches_outdir;
        overlap = 0;
        
    end
      
    methods
        
        % Split Image into patches
        function split_into_patches(obj, varargin)
            
            % split_into_patches() splits each image into patches with a
            % default tilesize of 256 pixels
            %
            % split_into_patches(tilesize) splits each image into patches
            % with a tilesize of tilesize.
            %
            % split_into_patches(tilesize, outdir) splits each image into
            % patches with a tilesize of tilesize and save patches in the
            % directory outdir.
            
            % Check for tilesize argument
            if nargin > 3
                error('Too many input arguments!')
            elseif nargin == 3
                obj.patches_outdir = varargin{2};
                obj.tilesize = varargin{1};
            elseif nargin == 2
                obj.tilesize = varargin{1};
                obj.patches_outdir = [obj.base_path, 'patches/cohort_',...
                num2str(obj.cohort_num), '/'];
            else
                obj.patches_outdir = [obj.base_path, 'patches/cohort_',...
                num2str(obj.cohort_num), '/'];
            end
            
            % Check if patches have already been made, otherwise make
            % patches outdir and populate it with patches
            if ~exist(obj.patches_outdir, 'file')
                % TODO: check if outdir exists and make it if it doesn't
                make_dir = sprintf('mkdir -p %s', obj.patches_outdir);
                system(make_dir);
            end
            
            % Format and call VIPS dzsave command
            base_command = ['vips dzsave %s %s --tile-size %d',...
                ' --depth one --overlap %d --suffix .png'];
            vips_command = sprintf(base_command, obj.path_name,...
                obj.patches_outdir, obj.tilesize, obj.overlap);
            
             disp(vips_command);
            system(vips_command);
            
            % Gather patch information and prepare patch array
            d = dir([obj.patches_outdir, '_files/0/*.png']);
            patch_filenames = {d.name};
            nPatches = numel(patch_filenames);
            obj.patches = cell(nPatches, 1);
            
            % Create Patch objects
            for i = 1:nPatches
                obj.patches{i} = Patch(obj, patch_filenames{i});
            end            
        end
                  
        % Adjust Contrast for pseudo-colored images
        function adjust_contrast(obj)
            adj_image = imadjust(obj.image);
            obj.save_image(adj_image, [obj.file_name, '_adjusted'])
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
                filename = varargin{1};
                imwrite(obj.image, [target_dir, filename]);
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
        
        % Getters and Setters ---------------------------------------------
        
        function image = get.image(obj)
            % Load on demand from HD
            image = im2double(imread(obj.path_name));
        end
        
        function adjusted_image = get.adjusted_image(obj)
            % Load on demand from HD
            adjusted_image = im2double(imread(obj.path_name_adjusted));
        end
    end 
    
end

