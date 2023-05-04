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


end