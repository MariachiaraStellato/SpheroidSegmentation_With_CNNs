classdef FUNC
    methods(Static)
% ------------------------------------------------------------------------------------------------
        function Layers = ConvBatch(FilterSize,FilterNumber,Padding,stride,ConvName,BatchName,w,dil)
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
                Layers = [convolution2dLayer(FilterSize,FilterNumber,"Name",ConvName,"BiasLearnRateFactor",0,"Padding",Padding,"Stride",stride,"WeightLearnRateFactor",w,"DilationFactor",dil)
                          batchNormalizationLayer("Name",BatchName)
                          ];
        end
        
% ------------------------------------------------------------------------------------------------

        function Layers = ConvBatchRelu(FilterSize,FilterNumber,Padding,stride,ConvName,BatchName,ReluName,w,dil)
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
                TempLayers1 = FUNC.ConvBatch(FilterSize,FilterNumber,Padding,stride,ConvName,BatchName,w,dil);
                TempLayer2 = reluLayer("Name",ReluName);
                Layers = [TempLayers1
                          TempLayer2];
        end
% ------------------------------------------------------------------------------------------------
        function Layers = DepthConvBatchRelu(NumInput, FilterSize,FilterNumber,Padding,stride,ConvName,BatchName,ReluName,DepthName,w,dil)
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
                          FUNC.ConvBatchRelu(FilterSize,FilterNumber,Padding,stride,ConvName,BatchName,ReluName,w,dil)
                          ];
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
                 Layers = [FUNC.ConvBatchRelu(FilterSize,FilterNumber,0,[1 1],strcat("res",BatchName,"2a"),strcat("bn",BatchName,"2a"),strcat("res",BatchName,"2a_relu"),w,[1 1])
                              FUNC.ConvBatchRelu([3 3],FilterNumber,[1 1 1 1],[1 1],strcat("res",BatchName,"2b"),strcat("bn",BatchName,"2b"),strcat("res",BatchName,"2b_relu"),w, [1 1])
                              FUNC.ConvBatch([1 1],4*FilterNumber,0,[1 1],strcat("res",BatchName,"2c"),strcat("bn",BatchName,"2c"),w, [1 1])];
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
            imgName = append(Folder, NameWithFinalImageType); 
            imwrite(im,imgName); 
        end
%-------------------------------------------------------------------------------------------------
        function IPlotImagesAndMasks(size, im,I,FileName)
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
            Bar = max(imIn(:)).*uint8([ones(size, 5) zeros(size, 5) ones(size, 5)]);
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
            file_name = append(ImFolder,filesep,specificImageName,InImageType);
        end
%-------------------------------------------------------------------------------------------------
        function TempImDirName = process_images(ImagesFolderName, WantedSize, c)
            % AUTHOR: Mariachiara Stellato (E-mail: mariachiarastellato@gmail.com)
            % FUNCTION DESCRITPION: 
            %   This function will get the images contained into the
            %   ImagesFolderName folder, resize them to the wanted size and
            %   save them in a newly created folder
            %
            % INPUT: 
            %       imagesFolderName:   string containing the folder path of
            %                           the images to processed
            %       WantedSize:         [a b] numerical array containing
            %                           the size we want the images to be resized to
            %       c:                  integer number.
            %                           c == 1      output images with 3 color channels. 
            %                           c == 2      output image with 1 colour channel. 
            %                           else        output has the same
            %                                       number of colour channels as the
            %                                       input
            % OUTPUT:
            %        TempImDirName: string containing the created folder path where the 
            %                       resized and modified images are stored 
     
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

        %check to see if the folder was correctly defined
        if not(isfolder(ImagesFolderName))
            error('The folder name was not correctly defined')
        end

        %load images
        image = imageDatastore(ImagesFolderName, ...
            'IncludeSubfolders',true, ...
            'LabelSource','foldernames');
        
        numberOfImages = length(image.Files);
        TempImDirName = append(ImagesFolderName, filesep, 'TempIm');
        mkdir(TempImDirName);
        % Get the file name of the images inside the folder.
        for k = 1 : numberOfImages
          
          inputFileName = image.Files{k};
          fprintf('%s\n', inputFileName);
          I = imread(inputFileName);
          if islogical(I)
              I = uint8(I);
          end
          if c == 1
            I = im2gray(I);
            I = cat(3, I, I, I);
            pause(0.1);
          elseif c == 2
            I = im2gray(I);
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
        
        function [dsTrain, dsVal, dsTest] = Dataset_processing(ImagesDir,MasksDir)
            % AUTHOR: Mariachiara Stellato (E-mail: mariachiarastellato@gmail.com)
            % DATE: september 2022, 13
            % FUNCTION DESCRITPION: 
            %   This function will prepare the images for the network
            %   training by labelling them and dividing them into a tran, a
            %   validation and a test dataset.
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

        %check if the folder was correctly defined and the images contained
        %are the correct ones to be used for the training
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
        [imdsTrain,imdsValidation, imdsTest] = splitEachLabel(image,0.8,0.1); %images 
        
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
            % FUNCTION DESCRIPTION: 
            %       this function segments and than check and fills any holes in the 
            %       segmentation for the single image given as an input by using the
            %       network given as an input.
            % INPUTS: 
            %           im:        image we want to segment
            %           net:       DAGNetwork file tipe containing the trained network to use for
            %                      the segmentation
            % OUTPUT: 
            %           I:          segmented mask
            
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
        
        %label map
        cmap = [
            0 0 0  %background
            1 1 1  %Sferoids
        ];
        
        %Image segmentation
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
        function lgraph = Define_network(NetworkType,imageSize,numClasses,tbl_Name,classWeights)
            % AUTHOR: Mariachiara Stellato (E-mail: mariachiarastellato@gmail.com)
            % DATE: september 2022, 13
            % FUNCTION DESCRITPION: 
            %   This function will create the lgraph for the segmentation network corresponding to the
            %   deep learning network choosen as input.
            %
            % INPUT:
            %   NetworkType:    integer number used to select the neural network to be used for the training
            %                   1 == ResNet18
            %                   2 == ResNet50
            %                   3 == Vgg16
            %                   4 == Vgg19
            %                   5 == ResNet101 
            %   imagedSize:         [a b] numerical array containing
            %                       the image size the user need to
            %                       initialize the network
            %   NumClasses:     integer number defining the number of
            %                   classes that the network will be able to identify
            %   tbl_Name:       array containing character strings with the
            %                   classes names
            %   ClassWeights:   Double type containing the weights relative
            %                   to the pixelclassificationLayer
            % OUTPUT:
            %   lgraph:         layer graph containing the initialized
            %                   network ready to be trained. 
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

            % ResNet18 and ResNet50 initialization
            if NetworkType == 3 || NetworkType == 4
            NetworkType = NetworkType - 2; 
            network = ["resnet18", "resnet50"];
            %network = string(network);
            
            lgraph = deeplabv3plusLayers(imageSize, numClasses, network(NetworkType)); 
            
            pxLayer = pixelClassificationLayer('Name','labels','Classes',tbl_Name,'ClassWeights',classWeights);
            lgraph = replaceLayer(lgraph,"classification",pxLayer);
              
        
            % ResNet101 initialization
            elseif NetworkType == 5         
                lgraph = ResNet101_Seg(imageSize,numClasses);
            else
            % VGG16 and VGG19 initialization
                if NetworkType == 1 || NetworkType == 2
                network = ["vgg16", "vgg19"];
                %network = string(network);
                lgraph = segnetLayers(imageSize,numClasses,network(NetworkType));    
                end
            end
        end
    end
end