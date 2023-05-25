function segmentation_multiple_images(ImFolder, SegFolder, network, specificImageName,flag_showmask)
    % AUTHOR: Mariachiara Stellato (E-mail: mariachiarastellato@gmail.com)
    % FUNCTION DESCRIPTION: 
    %   this function segments a folder of images given as an input by using the
    %   network given as an input. If specificImageName is empty the whole
    %   folder is segmented, if a name is specified only the image with
    %   that name will be segmented. 
    %   if the flag_showmask == 1 the image and the relative mask will be
    %   shown as a figure. 
    %   WARNING: if in the SegFolder there is already a saved image with
    %   the same name of a new segmentation, the new segmented image will
    %   substitute the old one. 
    % INPUTS:
    %   ImFolder:               string containing the path of the folder containing
    %                           the images we want to segment
    %   SegFolder:              string containing the path of the folder in which 
    %                           the segmented images will be saved
    %   network:                directory of the .mat file containing the network to be
    %                           used 
    %   specificImageName:      for segmenting a single image, add the specific name of
    %                           the image. If you want to segment all the images in the
    %                           folder, add an empty space. 
    %   flag_showmask:          if set to 1 the original image and the
    %                           segmented one will be shown in the same maltab figure. 
    
    % MiAi (Microscopy & Artificial Intelligence) Toolbox
    % Copyright © 2022 Mariachiara Stellato, Filippo Piccinini,   
    % University of Bologna, Italy. All rights reserved.
    %
    % This program is free software; you can redistribute it and/or modify it 
    % under the terms of the GNU General Public License version 3 (or higher) 
    % as published by the Free Software Foundation. This program is 
    % distributed WITHOUT ANY WARRANTY; without even the implied warranty of 
    % MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
    % General Public License for more details.

    %load the DAGNetwork from the .m file
    load(network, 'net');

    %segmentation of the whole folder
    if specificImageName == "none"
        image = imageDatastore(ImFolder, ...
        'IncludeSubfolders',true, ...
        'LabelSource','foldernames');
        FilesNames = image.Files;
        %check that there are images in the file
        if isempty(FilesNames)
        error('In the selected ImageFolder there are not images.');
        else
        num = numel(FilesNames);
        for i=1:num
            BarWaitWindows = msgbox(['Please wait... ' ,'Folder analysed: ', ImFolder, ', Completed: ', num2str(round(100*(i/num))), '%.']);
            pause(2*eps);
            I = readimage(image,i);
            [a,b,c] = size(I);
            I = imresize(I,[500,500]); 
            if c~=1 && c~=3
                ImInpN = I(:,:,1);
                I= ImInpN;
                clear ImInpN
            end
            if size(I,3) == 3
                I = rgb2gray(I);
            end
            %check that the images are spheroids with a white background
            test = [I(1,1), I(500,500), I(1,500), I(500,1)];
            if test(1) < 200 && test(2) < 200 && test(3) < 200 && test(4) < 200 
                errordlg('The images must have white background and dark spheroid to be correctly segmented');
                break; 
            end

            %segmentation 
            im = FUNC.seg_and_fill(I,net);   
            I = imresize(I,[a b]);
            im = imresize(im,[a,b]);

            %save the segmented masks
            FUNC.ISaveImages(FilesNames(i),SegFolder,im);

            %plot the image and mask if the flag is activated
            if flag_showmask == 1
                try
                    FUNC.IPlotImagesAndMasks(a,im,I,FilesNames(i))
                    hFinalFigure = gcf;
                    pause(2*eps);
                    waitforbuttonpress
                    pause(2*eps);
                    close(hFinalFigure);
                    pause(2*eps);
                catch err
                    
                    errordlg(err.message) 
                end

                
            end
            if exist('BarWaitWindows', 'var')
                        if ishandle(BarWaitWindows)
                            pause(2*eps);
                            delete(BarWaitWindows);
                            pause(2*eps);
                        end
            end
        end
        end
    else
    
    %segment the specific image if the specific image name is defined
    file_name = FUNC.IGetFileName(ImFolder,specificImageName);
    im = imread(file_name);
    [a,b,c] = size(im);
    im = imresize(im,[500,500]);
    if c~=1 && c~=3
        ImInpN = im(:,:,1);
        im= ImInpN;
        clear ImInpN
    end
    if size(im,3) == 3
        im = rgb2gray(im);
    end
    %test that the image is correct 
        test = [im(1,1), im(500,500), im(1,500), im(500,1)];
    if test(1) < 200 && test(2) < 200 && test(3) < 200 && test(4) < 200 
       
        errordlg('The images must have white background and dark spheroid to be correctly segmented');
                    
    end
    %segmentation
    I = seg_and_fill(im,net);
    I = imresize(I,[a b]);
    im = imresize(im,[a,b]);

    %save the mask
    imgName = [SegFolder, filesep , specificImageName, '.tiff'];
    imwrite(I,imgName); 

    %plot the image and mask if the flag is activated
    if flag_showmask == 1
        try 
            FUNC.IPlotImagesAndMasks(I,im,file_name)
            hFinalFigure = gcf;
            waitforbuttonpress;
            close(hFinalFigure);
            
        catch
        end
    end
    end
end
