classdef FUNC
    methods(Static)

        function Layers = ConvBatchRelu()
                Layers = [convolution2dLayer([7 7],64,"Name","conv1","BiasLearnRateFactor",0,"Padding",[3 3 3 3],"Stride",[2 2])
                          batchNormalizationLayer("Name","bn_conv1")
                          reluLayer("Name","conv1_relu")];
        end
% ------------------------------------------------------------------------------------------------
        function TempImDirName = process_images(ImagesFolderName, WantedSize, c)
        % AUTHOR: Mariachiara Stellato (E-mail: mariachiarastellato@gmail.com)
        % INPUT: 
        %       imagesFolderName:  folder path of the images to process (string)
        %       WantedSize: size we want the new images to be ([lenght eight])
        %       c: if 1 output images will be 3 color channel, else
        %       grayscales
        % OUTPUT:
        %        TempImDirName: new folder path where the resized and modified images
        %        are stored 
 
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
        
        image = imageDatastore(ImagesFolderName, ...
            'IncludeSubfolders',true, ...
            'LabelSource','foldernames');
        
        numberOfImages = length(image.Files);
        TempImDirName = [ImagesFolderName, filesep, 'TempIm'];
        TempImDir = mkdir(TempImDirName);
        
        for k = 1 : numberOfImages
          % Get the input filename.  It already has the folder prepended so we don't need to worry about that.
          
          inputFileName = image.Files{k};
          fprintf('%s\n', inputFileName);
          I = imread(inputFileName);
          I = im2gray(I); 
          if c == 1
            I = cat(3, I, I, I);
            pause(0.1);
          end
            %resize the image 
            I = imresize(I,WantedSize);
            %save images in the new folder
            file = char(inputFileName);
            PositionsPoints = strfind(file, '.');
            PositionLastPoint = PositionsPoints(end);
            InImageType = file(PositionLastPoint:end);
            PositionsSlash = strfind(file, filesep);
            PositionLastSlash = PositionsSlash(end);
            InImageName = file(PositionLastSlash:end);
            NameAndOrigImageType = InImageName;
            NameWoOrigImageType = NameAndOrigImageType(1:end-(length(InImageType)-1));
            NameWithFinalImageType = [NameWoOrigImageType 'tiff'];
            imgName = [TempImDirName, NameWithFinalImageType];
            imwrite(I,imgName);
        end
        done = msgbox('Images correctly processed!');
        if exist('done', 'var')
            if ishandle(done)
                pause(2*eps);
                delete(done)
            end
        end
        
        end
%-------------------------------------------------------------------------------------------------------------------
function TempImDirName = resize_images(ImagesFolderName, WantedSize)
% AUTHOR: Mariachiara Stellato (E-mail: mariachiarastellato@gmail.com) 
% INPUT: 
%       imagesFolderName:  folder path of the images to process (string)
%       WantedSize: size we want the new images to be ([lenght eight])
%       
% OUTPUT:
%        TempImDirName: new folder path where the resized images
%        are stored 
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

image = imageDatastore(ImagesFolderName, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');

numberOfImages = length(image.Files);
TempImDirName = [ImagesFolderName, filesep, 'TempMask'];
TempImDir = mkdir(TempImDirName);

for k = 1 : numberOfImages
  % Get the input filename.  It already has the folder prepended so we don't need to worry about that.
  inputFileName = image.Files{k};
  fprintf('%s\n', inputFileName);
  I = imread(inputFileName);
  if islogical(I)
      I = uint8(I);
  end
    %resize the image 
  I = imresize(I,WantedSize);
 %salvare l'immagine nel nuovo folder 
  file = char(inputFileName);
  PositionsPoints = strfind(file, '.');
  PositionLastPoint = PositionsPoints(end);
  InImageType = file(PositionLastPoint:end);
  PositionsSlash = strfind(file, filesep);
  PositionLastSlash = PositionsSlash(end);
  InImageName = file(PositionLastSlash:end);
  NameAndOrigImageType = InImageName;
  NameWoOrigImageType = NameAndOrigImageType(1:end-(length(InImageType)-1));
  NameWithFinalImageType = [NameWoOrigImageType 'tiff'];
  imgName = [TempImDirName, NameWithFinalImageType];
  imwrite(I,imgName);
end
done = msgbox('Masks correctly processed!');
if exist('done', 'var')
    if ishandle(done)
       pause(2*eps);
        delete(done)
    end
end
end


    end
end