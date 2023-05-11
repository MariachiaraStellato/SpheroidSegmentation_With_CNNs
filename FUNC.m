classdef FUNC
    methods(Static)

        function Layers = ConvBatchRelu()
                Layers = [convolution2dLayer([7 7],64,"Name","conv1","BiasLearnRateFactor",0,"Padding",[3 3 3 3],"Stride",[2 2])
                          batchNormalizationLayer("Name","bn_conv1")
                          reluLayer("Name","conv1_relu")];
        end
        
% ------------------------------------------------------------------------------------------------
        function ISaveImages(FilesNames,Folder,im)
            file = char(FilesNames);
            PositionsPoints = strfind(file, '.');
            PositionLastPoint = PositionsPoints(end);
            InImageType = file(PositionLastPoint:end);
            PositionsSlash = strfind(file, filesep);
            PositionLastSlash = PositionsSlash(end);
            InImageName = file(PositionLastSlash:end);
            NameAndOrigImageType = InImageName;
            NameWoOrigImageType = NameAndOrigImageType(1:end-(length(InImageType)-1));
            NameWithFinalImageType = [NameWoOrigImageType 'tiff'];
            imgName = [Folder, NameWithFinalImageType]; 
            imwrite(im,imgName); 
        end
%-------------------------------------------------------------------------------------------------
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
        if not(isfolder(ImagesFolderName))
            error('The folder name was not correctly defined')
        end
        image = imageDatastore(ImagesFolderName, ...
            'IncludeSubfolders',true, ...
            'LabelSource','foldernames');
        
        numberOfImages = length(image.Files);
        TempImDirName = [ImagesFolderName, filesep, 'TempIm'];
        
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
            FUNC.ISaveImages(inputFileName,TempImDirName,I);
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
if not(isfolder(ImagesFolderName))
    error('The folder name was not correctly defined')
end
image = imageDatastore(ImagesFolderName, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');

numberOfImages = length(image.Files);
TempImDirName = [ImagesFolderName, filesep, 'TempMask'];

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
 FUNC.ISaveImages(inputFileName,TempImDirName,I);
end
done = msgbox('Masks correctly processed!');
if exist('done', 'var')
    if ishandle(done)
       pause(2*eps);
        delete(done)
    end
end
end
%-----------------------------------------------------------------------------------------------------
function [dsTrain, dsVal, dsTest] = Dataset_processing(ImagesDir,MasksDir)
% AUTHOR: Mariachiara Stellato (E-mail: mariachiarastellato@gmail.com)
% DATE: september 2022, 13
%
% This function divide the image datastore given as input and create the training dataset, validation dataset and testing
% that will be used to train a CNN network by assigning 
% to every image in the dataset the labels specified in "classes"
% INPUT:
% imagesDir:        is a string containing the directory of the images
%                   folders 
% MasksDir:         is a string containing the directory of the masks folders on
%                   which the function will base the labels
% OUTPUT:
% dsTrain: pixel label datastore containing 80% of the input images
% dsTest: pixel label datastore containing 10% of the input images
% dsVal: pixel label datastore containing 10% of the input images
%   
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

% import images
if not(isfolder(ImagesDir))
    error('The folder name was not correctly defined')
end
if not(isfolder(MasksDir))
    error('The folder name was not correctly defined')
end
imagesFolderName = ImagesDir;
maskFolderName = MasksDir;
masks = imageDatastore(maskFolderName, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames'); 
image = imageDatastore(imagesFolderName, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames'); 
num1 = numel(image.Files);
num2 = numel(masks.Files);
if num1~=num2
    error('The image folder and the mask folder must contain the same number of images');
end
if num1<10
    error('The folder must contain at least 10 images to perform the training.');
end
datcre = msgbox('Datastore created');
if exist('datcre', 'var')
     if ishandle(datcre)
           pause(2*eps);
           delete(datcre)
     end
end
% Labels

classes = [
    "Sferoids"
    "Background"
]; %categories i wanto to segment the images into 

labelIDs = {255; 
            0}; %graylevel to refer to the labels 


labcre = msgbox('Label created');
if exist('labcre', 'var')
   if ishandle(labcre)
       pause(2*eps);
      delete(labcre)
   end
end
% split the set in training,test and validation 

% 80% for training, 10% for test, %10 for validation
[imdsTrain,imdsValidation, imdsTest] = splitEachLabel(image,0.8,0.1); %immages 

[maskTrain,maskValidation, maskTest] = splitEachLabel(masks,0.8,0.1); %masks

pxdsTrain = pixelLabelDatastore(maskTrain.Files, classes, labelIDs);
pxdsValidation = pixelLabelDatastore(maskValidation.Files, classes, labelIDs);
pxdsTest = pixelLabelDatastore(maskTest.Files, classes, labelIDs);
%create label dataset for training


%combine the dataset of the images and the masks to associate the label to the images we need for the trining  
dsVal = combine(imdsValidation,pxdsValidation);
dsTrain = combine(imdsTrain, pxdsTrain);
dsTest = combine(imdsTest,pxdsTest);

datdiv = msgbox('Datastore divided');
if exist('datdiv', 'var')
    if ishandle(datdiv)
        pause(2*eps);
        delete(datdiv)
    end
end
end
%-------------------------------------------------------------------------------------------------
function I = seg_and_fill(im, net)
% AUTHOR: Mariachiara Stellato (E-mail: mariachiarastellato@gmail.com)
%
%this function segments and than check and fills any holes in the 
%segmentation for the single image given as an input by using the
%network given as an input.
%im:        image we want to segment
%net:       DAGNetwork file tipe containing the trained network to use for
%           the segmentation

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

cmap = [
    0 0 0  %background
    1 1 1  %Sferoids
];
segmented = semanticseg(im, net);
B = labeloverlay(im,segmented,'Colormap',cmap,'Transparency',0);
Bi = rgb2gray(B);
Bi = imcomplement(Bi);
[Bi, n] = bwlabel(Bi);
se = strel('disk',12);
Bi = imclose(Bi,se);
if n>1
obj = zeros(1,n-1);
for i=1:n-1
    [a,~] = find(Bi == i);
    obj(i) = size(a,1);
end
[~,idx] = max(obj);
dim = size(Bi);
for i=1:dim(1)
    for j=1:dim(2)
        if Bi(i,j) == idx
            Bi(i,j) = 1;
        else
            Bi(i,j) = 0;
        end

    end
end
end

I = imfill(Bi,4,'holes'); 
I = imbinarize(I);
I = I*255;
end
%-------------------------------------------------------------------------------------------------

    end
end