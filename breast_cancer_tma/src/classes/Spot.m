classdef Spot < Image
    %Spot An image composed of an array of doubles plus secondary attributes
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
        
        %         image;
        %         spot_name;
        %         cohort_num;
                biomarker;
        %         xy;
        %         tilesize = 256;
        %         threshold = 4;
        %         parent_image;
                patches;
                patches_outdir;
        %         path_name;
        %         file_name;
        %         base_path;
        
    end
    
    methods
        
        % Class Constructor
        function obj = Spot(file_name, TMA)
            
            % Set base path and file name
            obj.base_path = TMA.base_path;
            obj.file_name = file_name;
            
            % Determine spot_name from file_name
            spot = regexp(file_name, '[0-9]{2,3}', 'Match');
            obj.spot_name = spot{end};
            
            % Determine biomarker from file_name
            bio = regexp(file_name, '^[^_]+(?=_)', 'Match');
            obj.biomarker = bio{end};
            
            switch obj.biomarker
                case 'ER'
                    obj.path_name = strcat(TMA.paths{1}, file_name);
                case 'PR'
                    obj.path_name = strcat(TMA.paths{2}, file_name);
                case 'HER2'
                    obj.path_name = strcat(TMA.paths{3}, file_name);
                otherwise
                    error('Biomarker type not detected: check file name (biomarker should be in ALL CAPS')
            end
            
            % Determine cohort_num and spatial coords using TMA info
            [obj.cohort_num, obj.xy, obj.features] = obj.getCohortInfo(TMA);
            
            % Load image
%             obj.image = im2double(imread(obj.path_name));
            
        end
        
        % Split Image into patches
        function split_into_patches(obj, varargin)
            
            % Check for tilesize argument
            if nargin > 2
                error('Too many input arguments!')
            elseif nargin == 2
                obj.tilesize = varargin{1};
            end
            
            % Format and call VIPS dzsave command
            base_command = ['vips dzsave %s %s --tile-size %d',...
                ' --depth one --suffix .png'];
            obj.patches_outdir = [obj.base_path, 'proc_images/cohort_',...
                num2str(obj.cohort_num), '/', obj.file_name(1:end-4)];
            
            vips_command = sprintf(base_command, obj.path_name, obj.patches_outdir, obj.tilesize);
%             disp(vips_command);
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
        
        % Display Image
        function show(obj)
            obj.image = im2double(imread(obj.path_name));
            imshow(obj.image);
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
        
    end % methods
    
end

