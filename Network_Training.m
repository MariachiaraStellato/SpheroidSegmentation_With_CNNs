function net = Network_Training(ImagesDir, MasksDir, NetworkType)
% AUTHOR: Mariachiara Stellato (E-mail: mariachiarastellato@gmail.com)
% FUNCTION DESCRITPION: 
%   This function will take a selected dataset of images with the associated binary masks
%   and train it with the chosen neural network.
%   The implemented networks are VGG16, VGG19, ResNet18, ResNet50 and
%   ResNet101.
%   To use this function you must install the deep learning matlab tool and the
%   pre-trained networks Vgg16, Vgg19, ResNet18, ResNet50
%
% INPUTS: 
%   imagesDir:      a string containing the directory of the images
%                   folder 
%   MasksDir:       a string containing the directory of the masks folders on
%                   which the function will base the labels
%   NetworkType:    integer number used to select the neural network to be used for the training
%                   1 == ResNet18
%                   2 == ResNet50
%                   3 == Vgg16
%                   4 == Vgg19
%                   5 == ResNet101
% OUTPUT: 
%   net:            DAGNetwork file containing the trained network

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

%--------------------------images and masks preprocessing-------------------
    %images resize dimension
    a = 500; 
    b = 500; 

    %create temporary directory to store the modifyed images. They will be
    %deleated at the end of the training.
    TempImDirName = FUNC.process_images(ImagesDir,[a b], 1);
    TempMaskDirName = FUNC.resize_images(MasksDir,[a,b]);
    
    %Divide the dataset into training and validation subsets
    [dsTrain, dsVal, ~] = FUNC.Dataset_processing(TempImDirName,TempMaskDirName);

    %classes for which the network will be trained
    classes = [
    "Sferoids"
    "Background"
    ];
    
    %size of the images we are training
    I = readimage(dsTrain.UnderlyingDatastores{1,1},1);
    [w, h, c] = size(I);
    imageSize = [w, h, c];  
    
    %number of classes I want to train for the segmentation
    numClasses = numel(classes);  
    
    %number of images used for the training
    numTrainingImages = numel(dsTrain.UnderlyingDatastores{1,1}.Files);
    
%-----------------------network selection----------------------------------
    % ResNet18 and ResNet50 initialization
    if NetworkType == 3 || NetworkType == 4
    NetworkType = NetworkType - 2; 
    network = ["resnet18", "resnet50"];
    %network = string(network);
    
    lgraph = deeplabv3plusLayers(imageSize, numClasses, network(NetworkType)); 
    
    tbl = countEachLabel(dsTrain.UnderlyingDatastores{1,2});
    imageFreq = tbl.PixelCount ./ tbl.ImagePixelCount;
    imageFreq(isnan(imageFreq)) = min(imageFreq) * 0.00001;
    classWeights = median(imageFreq) ./ imageFreq;
    
    pxLayer = pixelClassificationLayer('Name','labels','Classes',tbl.Name,'ClassWeights',classWeights);
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
%------------------------set training options------------------------------
    batchsize = round(numTrainingImages/10);
    if isdeployed
        op = 'none';
        constant = 1; 
    else
        op = 'training-progress';
        constant = 0; 
    end
    options = trainingOptions('sgdm', ...
    'LearnRateSchedule','piecewise',...
    'LearnRateDropPeriod',2,...
    'LearnRateDropFactor',0.5,...
    'Momentum',0.9, ...
    'InitialLearnRate',1e-3, ...
    'L2Regularization',0.001, ...
    'ValidationData',dsVal,...
    'MaxEpochs',7, ...  
    'MiniBatchSize',batchsize, ...
    'Shuffle','every-epoch', ...
    'CheckpointPath', tempdir, ...
    'VerboseFrequency',2,...
    'ExecutionEnvironment','cpu',...
    'Plots',op,...
    'ValidationFrequency', numTrainingImages,...
    'ValidationPatience', 4);

    netprep = msgbox('Network prepared');
    if exist('netprep', 'var')
        if ishandle(netprep)
            pause(2*eps);
            delete(netprep)
        end
    end

%---------------------------training---------------------------------------

%this window appear only if the function is used in a deployed app
if constant == 1
fig = uifigure;
fig.Position = [500 500 400 75];
d = uiprogressdlg(fig, 'Title','Training (it can take hours)...','Indeterminate','on');
end

%network training
[net, ~] = trainNetwork(dsTrain,lgraph,options);

%deleting the window that appears if the function is in a deployed app
if exist('d','var')
close(d)
close(fig)
end
%remove the temporary directory and the processed images
rmdir(TempImDirName,'s');
rmdir(TempMaskDirName,'s');


end