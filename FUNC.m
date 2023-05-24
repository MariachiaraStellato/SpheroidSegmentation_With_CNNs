classdef FUNC
    methods(Static)
% ------------------------------------------------------------------------------------------------
        function Layers = ConvBatch(FilterSize,FilterNumber,Padding,stride,ConvName,BatchName,w)
            % AUTHOR: Mariachiara Stellato (E-mail: mariachiarastellato@gmail.com)
            % FUNCTION DESCRITPION: 
            %   This function will create a convolutional Layer and a Batch
            %   Normalization Layer with the given inputs as paramenters
            %
            % INPUTS: 
            %   FilterSize: [a b] numeric array of two integer elements.
            %               Determines the filter size of the convolutional layer
            %   FilterNumber: integer containing the filter number of the
            %                 convolutional layer. 
            %   Padding:        integer or numeric array containing the padding
            %                   size of the convolutional layer. 
            %   stride:         integer containing the stride of the convolutional
            %                   layer.
            %   ConvName:       string containing the name that will be given to
            %                   the convolutional layer. 
            %   BatchName:      string containing the name that will be given to
            %                   the Batch Normalization layer. 
            %   w:              integer number containing the weight used
            %                   to initialize the convolutional layer. 
            % OUTPUT: 
            %   Layers:         array containing a convolutional layer and
            %                   a batch normalization layer. 

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
                Layers = [convolution2dLayer(FilterSize,FilterNumber,"Name",ConvName,"BiasLearnRateFactor",0,"Padding",Padding,"Stride",stride,"WeightLearnRateFactor",w)
                          batchNormalizationLayer("Name",BatchName)
                          ];
        end
        
% ------------------------------------------------------------------------------------------------

        function Layers = ConvBatchRelu(FilterSize,FilterNumber,Padding,stride,ConvName,BatchName,ReluName,w)
            % AUTHOR: Mariachiara Stellato (E-mail: mariachiarastellato@gmail.com)
            % FUNCTION DESCRITPION: 
            %   This function will create a convolutional Layer, a Batch
            %   Normalization Layer and a ReLU layer with the given inputs as paramenters
            %
            % INPUTS: 
            %   FilterSize: [a b] numeric array of two integer elements.
            %               Determines the filter size of the convolutional layer
            %   FilterNumber: integer containing the filter number of the
            %                 convolutional layer. 
            %   Padding:        integer or numeric array containing the padding
            %                   size of the convolutional layer. 
            %   stride:         integer containing the stride of the convolutional
            %                   layer.
            %   ConvName:       string containing the name that will be given to
            %                   the convolutional layer. 
            %   BatchName:      string containing the name that will be given to
            %                   the Batch Normalization layer. 
            %   ReluName:      string containing the name that will be given to
            %                   the ReLU layer. 
            %   w:              integer number containing the weight used
            %                   to initialize the convolutional layer. 
            % OUTPUT: 
            %   Layers:         array containing a convolutional layer,
            %                   a batch normalization and a ReLu layer. 

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
                TempLayers1 = FUNC.ConvBatch(FilterSize,FilterNumber,Padding,stride,ConvName,BatchName,w);
                TempLayer2 = reluLayer("Name",ReluName);
                Layers = [TempLayers1
                          TempLayer2];
        end
% ------------------------------------------------------------------------------------------------
        function Layers = DepthConvBatchRelu(NumInput, FilterSize,FilterNumber,Padding,stride,ConvName,BatchName,ReluName,DepthName,w)
            % AUTHOR: Mariachiara Stellato (E-mail: mariachiarastellato@gmail.com)
            % FUNCTION DESCRITPION: 
            %   This function will create a depth concatenation layer, a convolutional Layer, a Batch
            %   Normalization Layer and a ReLU layer with the given inputs as paramenters
            %
            % INPUTS: 
            %   NumInput:   integer defining the number of inputs in the
            %               Depth convatenation layer. 
            %   FilterSize: [a b] numeric array of two integer elements.
            %               Determines the filter size of the convolutional layer
            %   FilterNumber: integer containing the filter number of the
            %                 convolutional layer. 
            %   Padding:        integer or numeric array containing the padding
            %                   size of the convolutional layer. 
            %   stride:         integer containing the stride of the convolutional
            %                   layer.
            %   ConvName:       string containing the name that will be given to
            %                   the convolutional layer. 
            %   BatchName:      string containing the name that will be given to
            %                   the Batch Normalization layer. 
            %   ReluName:      string containing the name that will be given to
            %                   the ReLU layer. 
            %   DepthName:      string containing the name that will be given to
            %                   the Depth concatenation layer.
            %   w:              integer number containing the weight used
            %                   to initialize the convolutional layer. 
            % OUTPUT: 
            %   Layers:         array containing a convolutional layer,
            %                   a batch normalization, a ReLu and 
            %                   a depth concatenation layer. 

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
                Layers = [depthConcatenationLayer(NumInput,"Name",DepthName)
                          FUNC.ConvBatchRelu(FilterSize,FilterNumber,Padding,stride,ConvName,BatchName,ReluName,w)
                          reluLayer("Name",ReluName)];
        end
%-------------------------------------------------------------------------------------------------
        function Layers = ConvBatchWdil(FilterSize,FilterNumber,Padding,stride,ConvName,BatchName,w,dil)
                Layers = [convolution2dLayer(FilterSize,FilterNumber,"Name",ConvName,"BiasLearnRateFactor",0,"Padding",Padding,"Stride",stride,"WeightLearnRateFactor",w,"DilationFactor",dil)
                          batchNormalizationLayer("Name",BatchName)
                          ];
        end
%-------------------------------------------------------------------------------------------------
        function Layers = ConvBatchReluWDil(FilterSize,FilterNumber,Padding,stride,ConvName,BatchName,ReluName,w,dil)
                TempLayers1 = FUNC.ConvBatchWdill(FilterSize,FilterNumber,Padding,stride,ConvName,BatchName,w,dil);
                TempLayer2 = reluLayer("Name",ReluName);
                Layers = [TempLayers1
                          TempLayer2];
        end
%-------------------------------------------------------------------------------------------------
        function Layers = ICreateBatch(FilterSize,FilterNumber,BatchName,w)
            % AUTHOR: Mariachiara Stellato (E-mail: mariachiarastellato@gmail.com)
            % FUNCTION DESCRITPION: 
            %   This function will create a Layers batch containing three
            %   batch normalization layers, three convolutional layers and
            %   two ReLU layers. 
            %
            % INPUTS: 
            %   FilterSize: [a b] numeric array of two integer elements.
            %               Determines the filter size of the convolutional layer
            %   FilterNumber:   integer containing the filter number of the
            %                   first convolutional layer. 
            %   BatchName:      string containing the name that will be
            %                   given to every layer in the batch alongside
            %                   the identification numbers for every
            %                   particular layer. 
            %   w:              integer number containing the weight used
            %                   to initialize the convolutional layers. 
            % OUTPUT: 
            %   Layers:         array containing the created batch 

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
                 Layers = [FUNC.ConvBatchRelu(FilterSize,FilterNumber,0,[1 1],strcat("res",BatchName,"2a"),strcat("bn",BatchName,"2a"),strcat("res",BatchName,"2a_relu"),w)
                              FUNC.ConvBatchRelu([3 3],FilterNumber,[1 1 1 1],[1 1],strcat("res",BatchName,"2b"),strcat("bn",BatchName,"2b"),strcat("res",BatchName,"2b_relu"),w)
                              FUNC.ConvBatch([1 1],4*FilterNumber,0,[1 1],strcat("res",BatchName,"2c"),strcat("bn",BatchName,"2c"),w)];
        end

%-------------------------------------------------------------------------------------------------
        function Layers = AdditionRelu(AdditionName)
            % AUTHOR: Mariachiara Stellato (E-mail: mariachiarastellato@gmail.com)
            % FUNCTION DESCRITPION: 
            %   This function will create an addition layer and a ReLu
            %   layer
            %
            % INPUTS:
            %   AdditionName:   string containing the name of the addition
            %                   and reLU layer
            % OUTPUT: 
            %   Layers:         array containing the created layers 

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
                 Layers = [additionLayer(2,"Name",AdditionName)
                              reluLayer("Name",strcat(AdditionName,"_relu"))];
        end
% ------------------------------------------------------------------------------------------------
        function ISaveImages(FilesNames,Folder,im)
            % AUTHOR: Mariachiara Stellato (E-mail: mariachiarastellato@gmail.com)
            % FUNCTION DESCRITPION: 
            %   This function will save the selected image into the
            %   selected folder with the name given as FilesNames input
            %
            % INPUTS:
            %   FilesNames: string containing the name that will be given
            %               to the saved image
            %   Folder:     string containing the name of the folder in
            %               which the image will be saved. 
            %   im:         images to be saved

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
        function IPlotImagesAndMasks(im,I,FileName)
            % AUTHOR: Mariachiara Stellato (E-mail: mariachiarastellato@gmail.com)
            % FUNCTION DESCRITPION: 
            %   This function will plot in the same figure the image and
            %   the mask given as input. The figure will have as title the
            %   FileName variable
            %
            % INPUTS:
            %   im:         images to be plotted
            %   I:          masks to be plotted
            %   FileName:   string containing the name that will be used as
            %               the figure title
            
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
            imOut = uint8(im);
            imIn = uint8(I);
            Bar = max(imIn(:)).*uint8([ones(a, 5) zeros(a, 5) ones(a, 5)]);
            finalIm = [imIn Bar imOut];
            name = char(FileName);
            figure('Name',[name,' (press ENTER to go ahead).'],'NumberTitle','off'), imshow(finalIm, [], 'Border', 'Tight');
        end
%-------------------------------------------------------------------------------------------------
        function file_name = IGetFileName(ImFolder,specificImageName)
            % AUTHOR: Mariachiara Stellato (E-mail: mariachiarastellato@gmail.com)
            % FUNCTION DESCRITPION: 
            %   This function will get the string that identifies the
            %   computer path containing the image specified by the
            %   specificImageName variable contained in the ImFolder
            %
            % INPUTS:
            %   ImFolder:           string containing the folder in which the
            %                       the image is stored
            %   specificImageName:  string containing the specific name of 
            %                       the image you want the name of             
            
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
            dir_struct = dir(ImFolder);
            N = length(dir_struct);
            dir_struct = dir_struct(N);
            name = dir_struct.name;
            PositionsPoints = strfind(name, '.');
            PositionLastPoint = PositionsPoints(end);
            InImageType = name(PositionLastPoint:end);
            file_name = [ImFolder,filesep,specificImageName,InImageType];
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