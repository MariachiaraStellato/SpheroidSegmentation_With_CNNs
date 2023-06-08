classdef tests<matlab.unittest.TestCase

    methods (Test)

        %tests for the process_images function--------------------------------------------------

        function testTempImDirName(testCase)
        % ---------------------------------------------------------------------------------------------
        % This test asserts that the function "process_images" with default values returns correct output:
        % the name of the directory created that contains the resized and
        % processed images 
        % 
        % GIVEN: the name of the folder containing the images we want to
        % resize, the choosen size and the index corresponding to the
        % number of colour channels 
        % WHEN: I apply "process_images" function with default values
        % THEN: the function returns a string containing the name of the
        % newly created folder inside the original folder containing the
        % resized images
        % ---------------------------------------------------------------------------------------------
            ImagesFolderName = 'ExampleImages';
            WantedSize = [256, 256];
            c = 1;
            TempImDirName = FUNC.process_images(ImagesFolderName, WantedSize, c);
            testCase.verifyEqual(exist(TempImDirName, 'dir'), 7);
            rmdir(TempImDirName,'s');
        end

        %-------------------------------------------------------------------------------------------------

        function testImageSize(testCase)
        % ---------------------------------------------------------------------------------------------
        % This test asserts that the function "process_images" with
        % default values produces modified images with the right size
        % given as input
        % 
        % GIVEN: the name of the folder containing the images we want to
        % resize, the choosen size and the index corresponding to the
        % number of colour channels 
        % WHEN: I apply "process_images" function with default values
        % THEN: the function returns a string containing the name of the
        % newly created folder inside the original folder containing the
        % resized images
        % ---------------------------------------------------------------------------------------------
            ImagesFolderName = 'ExampleImages';
            WantedSize = [256, 256];
            c = 1;
            TempImDirName = FUNC.process_images(ImagesFolderName, WantedSize, c);
            imageFiles = dir(fullfile(TempImDirName, '*.tiff'));
    
            % Verify image size for each resized image
            for i = 1:numel(imageFiles)
                I = imread(fullfile(TempImDirName, imageFiles(i).name));
                imageSize = size(I);
                expectedSize = [WantedSize, size(I, 3)]; % Add 3rd dimension for color images
                testCase.verifyEqual(imageSize, expectedSize);
            end
            rmdir(TempImDirName,'s');
        end

        %-------------------------------------------------------------------------------------------------

        function testOutputDatastoresSize(testCase)
        % ---------------------------------------------------------------------------------------------
        % This test asserts that the function "Dataset_processing" with
        % default values produces as output three combined datastores
        % with the right size. 
        % 
        % GIVEN: the name of the folder containing the images we want to
        % resize and the one containing the respective masks
        % WHEN: I apply "process_images" function with default values
        % THEN: the function returns three combined datasores called
        % respectively dsTrain, dsVal and dsTest that are ready to use
        % to train a deep learning network
        % ---------------------------------------------------------------------------------------------
            
            
            % Generate example data
            TestImages = 'testImages';
            if ~exist(TestImages, 'dir')
                mkdir(TestImages);
            end
            TestMasks = 'testMasks';
            if ~exist(TestMasks, 'dir')
                mkdir(TestMasks);
            end
            imDir = fullfile(pwd, TestImages);
            maskDir = fullfile(pwd, TestMasks);
            img = ones(100,100,3);
            mask = ones(100,100);
            for i=1:10
                imwrite(img, fullfile(imDir, sprintf('img_%d.jpg', i)));
                imwrite(mask, fullfile(maskDir, sprintf('mask_%d.jpg', i)));
            end
    
            % Call the function
            [dsTrain, dsVal, dsTest] = FUNC.Dataset_processing(imDir, maskDir);
    
            % Check sizes
            expectedSizeTrain = 8;
            expectedSizeVal = 1;
            expectedSizeTest = 1;
            actualSizeTrain = numel(dsTrain.UnderlyingDatastores{1,1}.Files);
            actualSizeVal = numel(dsVal.UnderlyingDatastores{1,1}.Files);
            actualSizeTest = numel(dsTest.UnderlyingDatastores{1,1}.Files);
            testCase.verifyEqual(actualSizeTrain, expectedSizeTrain, 'Output datastores have unexpected size');
            testCase.verifyEqual(actualSizeVal, expectedSizeVal, 'Output datastores have unexpected size');
            testCase.verifyEqual(actualSizeTest, expectedSizeTest, 'Output datastores have unexpected size');
            rmdir(TestImages, 's');
            rmdir(TestMasks, 's');
        end
        
        %-------------------------------------------------------------------------------------------------

        function testInvalidInputFolder(testCase)
        % ---------------------------------------------------------------------------------------------
        % This test asserts that the function "Dataset_processing" with
        % default values produces an error if the folder given as input
        % does not exist. 
        % 
        % GIVEN: the name of the folder containing the images we want to
        % resize and the one containing the respective masks
        % WHEN: I apply "process_images" function with default values
        % THEN: the function returns three combined datasores called
        % respectively dsTrain, dsVal and dsTest that are ready to use
        % to train a deep learning network
        % ---------------------------------------------------------------------------------------------
        
            % Call the function with an invalid directory
            invalidDir = 'invalid_dir';
            maskDir = fullfile(pwd, 'ExampleMasks');
            try
                [~, ~, ~] = FUNC.Dataset_processing(invalidDir, maskDir);
            catch ME
                expectedError = 'The folder name was not correctly defined';
                actualError = ME.message;
                testCase.verifyEqual(actualError, expectedError, 'Unexpected error message');
                return;
            end
            testCase.verifyFail('No error was thrown when an invalid images directory was given');
        end
        
        %-------------------------------------------------------------------------------------------------

        function testInvalidMaskFolder(testCase)
        % ---------------------------------------------------------------------------------------------
        % This test asserts that the function "Dataset_processing" with
        % default values produces an error if the folder given as input
        % does not exist. 
        % 
        % GIVEN: the name of the folder containing the images we want to
        % resize and the one containing the respective masks
        % WHEN: I apply "process_images" function with default values
        % THEN: the function returns three combined datasores called
        % respectively dsTrain, dsVal and dsTest that are ready to use
        % to train a deep learning network
        % ---------------------------------------------------------------------------------------------
            
            % Call the function with an invalid directory
            imDir = fullfile(pwd, 'ExampleImages');
            invalidDir = 'invalid_dir';
            try
                [~, ~, ~] = FUNC.Dataset_processing(imDir, invalidDir);
            catch ME
                expectedError = 'The folder name was not correctly defined';
                actualError = ME.message;
                testCase.verifyEqual(actualError, expectedError, 'Unexpected error message');
                return;
            end
            testCase.verifyFail('No error was thrown when an invalid masks directory was given');
        end

        %tests for the ISaveImages function-------------------------------

        function TestISaveImagesCorrectly(testCase)
        % ---------------------------------------------------------------------------------------------
        % This test asserts that the function "ISaveImages" with
        % default values saves the correct image with the expected name
        % 
        % GIVEN: the name you want the saved image to have,
        % the name of the folder where we want to save the images and
        % the image to be saved
        % WHEN: I apply "ISaveImages" function with default values
        % THEN: the function save the image in the correct folder with
        % the correct name
        % ---------------------------------------------------------------------------------------------

            im = imread('ImagesForTesting\gatto.jpg');
            Folder = 'testFolder';
            if ~exist(Folder, 'dir')
                mkdir(Folder);
            end
            FilesNames = 'testFolder\testImage.png';
            FUNC.ISaveImages(FilesNames, Folder, im);
            savedImage = imread('testFolder\testImage.tiff');
            rmdir(Folder,'s');
            testCase.verifyEqual(im, savedImage, 'The saved image is not equal to the original image.');
            
        end
        
        %-------------------------------------------------------------------------------------------------

        function testLayersSize(testCase)
        % ---------------------------------------------------------------------------------------------
        % This test asserts that the function "ConvBatch" with
        % default values creates the correct number of layers
        % 
        % GIVEN: the parameters you want to use to define the layers
        % WHEN: I apply "ConvBatch" function with default values
        % THEN: the function gives as output the a convolutional layer
        % and a batch normalization layer
        % ---------------------------------------------------------------------------------------------
        
            FilterSize = [3 3];
            FilterNumber = 64;
    
            BatchName = 'batchnorm1';
            w = 1;
    
            Layers = FUNC.ICreateBatch(FilterSize, FilterNumber, BatchName, w);
    
            expectedNumLayers = 8;
            actualNumLayers = numel(Layers);
            testCase.verifyEqual(actualNumLayers, expectedNumLayers, 'The number of layers returned is incorrect.');
        end
        
        %-------------------------------------------------------------------------------------------------

        function testConvolutionLayer(testCase)
        % ---------------------------------------------------------------------------------------------
        % This test asserts that the function "ConvBatch" with
        % default values correctly inizialize the parameters of the
        % convolutional layer
        % 
        % GIVEN: the parameters you want to use to define the layers
        % WHEN: I apply "ConvBatch" function with default values
        % THEN: the function gives as output the a convolutional layer
        % and a batch normalization layer
        % ---------------------------------------------------------------------------------------------

            FilterSize = [3 3];
            FilterNumber = 64;
            Padding = 'same';
            Stride = [1 1];
            ConvName = 'conv1';
            BatchName = 'batchnorm1';
            w = 1;
    
            Layers = FUNC.ConvBatch(FilterSize, FilterNumber, Padding, Stride, ConvName, BatchName, w, [1 1]);
    
            expectedConvLayerName = 'conv1';
            actualConvLayerName = Layers(1).Name;
            testCase.verifyEqual(actualConvLayerName, expectedConvLayerName, 'The convolution layer has the wrong name.');
    
            expectedConvLayerBiasLearnRateFactor = 0;
            actualConvLayerBiasLearnRateFactor = Layers(1).BiasLearnRateFactor;
            testCase.verifyEqual(actualConvLayerBiasLearnRateFactor, expectedConvLayerBiasLearnRateFactor, 'The convolution layer has the wrong bias learn rate factor.');
    
            expectedConvLayerPadding = [];
            actualConvLayerPadding = Layers(1).PaddingSize;
            testCase.verifyEqual(actualConvLayerPadding, expectedConvLayerPadding, 'The convolution layer has the wrong padding.');
    
            expectedConvLayerStride = [1 1];
            actualConvLayerStride = Layers(1).Stride;
            testCase.verifyEqual(actualConvLayerStride, expectedConvLayerStride, 'The convolution layer has the wrong stride.');
    
            expectedConvLayerWeightLearnRateFactor = 1;
            actualConvLayerWeightLearnRateFactor = Layers(1).WeightLearnRateFactor;
            testCase.verifyEqual(actualConvLayerWeightLearnRateFactor, expectedConvLayerWeightLearnRateFactor, 'The convolution layer has the wrong weight learn rate factor.');
        end
        
        %-------------------------------------------------------------------------------------------------

        function testSegmentedMaskPixelValues(testCase)
        % ---------------------------------------------------------------------------------------------
        % This test asserts that the function "seg_and_fill" with
        % default values the output image has pixel with values that
        % are either 0 or 255. 
        % 
        % GIVEN: the image and the network you want to use for the
        % segmentation
        % WHEN: I apply "seg_and_fill" function with default values
        % THEN: the function gives as output the segmented image
        % ---------------------------------------------------------------------------------------------
            ImFolder = "ExampleImages";
            image = imageDatastore(ImFolder, ...
                'IncludeSubfolders',true, ...
                'LabelSource','foldernames');
    
            im = readimage(image,1);
            load('TrainedNetworks\segRes18Net.mat','net');
    
            I = FUNC.seg_and_fill(im, net);
    
            testCase.verifyTrue(all(ismember(I(:), [0, 255])), 'The values of the segmented mask are incorrect.');
        end
        
        %-------------------------------------------------------------------------------------------------

        function testSegmentedMaskSize(testCase)
        % ---------------------------------------------------------------------------------------------
        % This test asserts that the function "segmentation_multiple_images" with
        % default values the output images have the same size of the
        % input images
        % 
        % GIVEN: the image folder, the folder were the masks will be saved, 
        % and the network you want to use for the segmentation
        % WHEN: I apply "segmentation_multiple_images" function with default values
        % THEN: the function gives as output the segmented image
        % ---------------------------------------------------------------------------------------------
            
            PathImageFolderIn = "ExampleImages";
            PathImageFolderOut = "testFolder";
    
            if ~exist(PathImageFolderOut, 'dir')
                mkdir(PathImageFolderOut);
            end
            PathNetworkFolderInp = "TrainedNetworks\segRes18Net.mat";
            SpecificImageName = char.empty;
            flag_ShowMask = 0;
            segmentation_multiple_images(PathImageFolderIn,PathImageFolderOut,PathNetworkFolderInp,SpecificImageName,flag_ShowMask);
    
            image = imageDatastore(PathImageFolderIn, ...
                'IncludeSubfolders',true, ...
                'LabelSource','foldernames');
            mask = imageDatastore(PathImageFolderOut, ...
                'IncludeSubfolders',true, ...
                'LabelSource','foldernames');
    
            im = readimage(image,1);
            I = readimage(mask,1);
            expectedSize = size(im);
            expectedSize = [expectedSize(1) expectedSize(2)];
            actualSize = size(I);
            testCase.verifyEqual(actualSize, expectedSize, 'The size of the segmented mask is incorrect.');
    
            rmdir(PathImageFolderOut, 's');
        end
        
        %-------------------------------------------------------------------------------------------------

        function testMetricsFields(testCase)
        % ---------------------------------------------------------------------------------------------
        % This test asserts that the function "metric_evaluation" with
        % default values gives as output the correct structure
        % containing the correct fields
        % 
        % GIVEN: the image folder, the folder were the masks will be saved, 
        % and the network you want to use for the segmentation
        % WHEN: I apply "segmentation_multiple_images" function with default values
        % THEN: the function gives as output the segmented image
        % ---------------------------------------------------------------------------------------------

            % Test that the metrics structure contains the expected fields
            TestImagesDir = 'ExampleImages';
            TestMasksDir = 'ExampleMasks';
            SegmentedMaskDir = "testFolder";
    
            if ~exist(SegmentedMaskDir, 'dir')
                mkdir(SegmentedMaskDir);
            end
            PathNetworkFolderInp = "TrainedNetworks\segRes18Net.mat";
            SpecificImageName = char.empty;
            flag_ShowMask = 0;
            segmentation_multiple_images(TestImagesDir,SegmentedMaskDir,PathNetworkFolderInp,SpecificImageName,flag_ShowMask);
    
            metrics = metric_evaluation(TestMasksDir, SegmentedMaskDir);
            cl = class(metrics);
    
            rmdir(SegmentedMaskDir, 's');
    
    
            testCase.assertTrue(isequal(cl,'semanticSegmentationMetrics'));
        end

        %-------------------------------------------------------------------------------------------------

        function testResizeImageWithOneChannel(testCase)
        % ---------------------------------------------------------------------------------------------
        % This test asserts that the function "process_single_image" with
        % default values gives as output the image correctly processed
        % 
        % GIVEN: the name of the image to resize, the new size and the
        % parameter for the colour channels
        % WHEN: I apply "process_single_image" function with default values
        % THEN: the function gives as output the resized image
        % ---------------------------------------------------------------------------------------------

            % Test resizing an image with one color channel
            
            % Set up
            inputFileName = 'ImagesForTesting\gatto.jpg';
            WantedSize = [512, 512];
            c = 2;
            
            % Call the function
            I = FUNC.process_single_image(WantedSize, inputFileName, c);
            
            % Check the output
            
            testCase.assertSize(I, WantedSize);
            
        end

        %-------------------------------------------------------------------------------------------------

        function testNetworkInitialization(testCase)
        % ---------------------------------------------------------------------------------------------
        % This test asserts that the function "Define_network" with
        % default values gives as output a layer graph variable 
        % 
        % GIVEN: the network type and the initialization parameters
        % WHEN: I apply "Define_network" function with default values
        % THEN: the function gives as output the correct layer graph
        % ---------------------------------------------------------------------------------------------

            % Test initialization of the network using ResNet18
            
            % Set up
            NetworkType = 1;
            imageSize = [224, 224, 3];
            numClasses = 2;
            tbl_Name = [3.3, 4.2];
            classWeights = [1, 2];
            
            % Call the function
            lgraph = FUNC.Define_network(NetworkType, imageSize, numClasses, tbl_Name, classWeights);
            
            % Check the output
            testCase.assertInstanceOf(lgraph, 'nnet.cnn.LayerGraph');
        end

         %-------------------------------------------------------------------------------------------------

         function testRGBImageSegmentation(testCase)

            % Test segmentation of an RGB image
            
            % Set up
            I = imread('ExampleImages\P2_08_A06_04x_001.tif');
            ref = imread('ExampleMasks\P2_08_A06_04x_001.tiff');
            load('TrainedNetworks\segRes18Net.mat','net');
            
            I = rgb2gray(I);

            % Call the function
            im = FUNC.segmentation_single_image(I, net);
            c = ssim(im,ref);

            % Check the output
            testCase.assertInstanceOf(im, 'uint8');
            testCase.assertEqual(size(im), size(I));
            testCase.assertGreaterThanOrEqual(c,0.9);
        end
    end
end