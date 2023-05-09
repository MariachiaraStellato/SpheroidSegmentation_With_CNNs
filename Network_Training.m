function net = Network_Training(ImagesDir, MasksDir)

 

    a = 500; 
    b = 500; 
    TempImDirName = FUNC.process_images(ImagesDir,[a b], 1);
    TempMaskDirName = FUNC.resize_images(MasksDir,[a,b]);
    [dsTrain, dsVal, dsTest] = FUNC.Dataset_processing(TempImDirName,TempMaskDirName);
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
    network = {'resnet18', 'resnet50'};
    network = string(network);
    
    net1 = resnet18();
    net1 = resnet50();
    clear net1
    
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
    network = {'vgg16', 'vgg19'};
    network = string(network);
    lgraph = segnetLayers(imageSize,numClasses,network(NetworkType));
        
    end

end