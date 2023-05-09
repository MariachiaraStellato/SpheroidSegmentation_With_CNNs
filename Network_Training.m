function net = Network_Training(ImagesDir, MasksDir, NetworkType)

 

    a = 500; 
    b = 500; 
    TempImDirName = FUNC.process_images(ImagesDir,[a b], 1);
    TempMaskDirName = FUNC.resize_images(MasksDir,[a,b]);
    [dsTrain, dsVal, ~] = FUNC.Dataset_processing(TempImDirName,TempMaskDirName);
    classes = [
    "Sferoids"
    "Background"
    ]; %categories i wanto to segment the images into

    I = readimage(dsTrain.UnderlyingDatastores{1,1},1);

    [w, h, c] = size(I);
    imageSize = [w, h, c]; %size of the images we are training 

    numClasses = numel(classes); %number of classes I want to train for the segmentation 

    numTrainingImages = numel(dsTrain.UnderlyingDatastores{1,1}.Files);

    if NetworkType == 3 || NetworkType == 4
    NetworkType = NetworkType - 2; 
    network = ['resnet18', 'resnet50'];
    network = string(network);
    
    lgraph = deeplabv3plusLayers(imageSize, numClasses, network(NetworkType)); 
    
    tbl = countEachLabel(dsTrain.UnderlyingDatastores{1,2});
    imageFreq = tbl.PixelCount ./ tbl.ImagePixelCount;
    imageFreq(isnan(imageFreq)) = min(imageFreq) * 0.00001;
    classWeights = median(imageFreq) ./ imageFreq;
    
    pxLayer = pixelClassificationLayer('Name','labels','Classes',tbl.Name,'ClassWeights',classWeights);
    lgraph = replaceLayer(lgraph,"classification",pxLayer);
    %Change layer to adapt the net to my data
    end  
    if NetworkType == 5
        lgraph = ResNet101_Seg(imageSize);
    end

    if NetworkType == 1 || NetworkType == 2
    network = ['vgg16', 'vgg19'];
    network = string(network);
    lgraph = segnetLayers(imageSize,numClasses,network(NetworkType));
        
    end

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

%% train
if constant == 1
fig = uifigure;
fig.Position = [500 500 400 75];
d = uiprogressdlg(fig, 'Title','Training (it can take hours)...','Indeterminate','on');
end

[net, ~] = trainNetwork(dsTrain,lgraph,options);
if exist('d','var')
close(d)
close(fig)
end
rmdir(TempImDirName,'s');
rmdir(TempMaskDirName,'s');


end