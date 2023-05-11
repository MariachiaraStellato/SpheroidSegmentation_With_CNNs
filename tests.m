classdef tests<matlab.unittest.TestCase

    methods (Test)
        %tests for the process_images function--------------------------------------------------
        function testTempImDirName(testCase)
            ImagesFolderName = 'my_images_folder';
            WantedSize = [256, 256];
            c = 1;
            TempImDirName = FUNC.process_images(ImagesFolderName, WantedSize, c);
            testCase.verifyEqual(exist(TempImDirName, 'dir'), 7);
            rmdir(TempImDirName,'s');
        end

        function testImageSize(testCase)
            ImagesFolderName = 'my_images_folder';
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

        %tests for the Resize_images function-------------------------------

        function testResizeImages(testCase)
        % Test the resize_images function with different input arguments

        % Test case 1: Input folder contains no images
        ImagesFolderName = 'non_existing_folder';
        WantedSize = [256, 256];
        assert(~exist(ImagesFolderName, 'dir'), 'Test folder already exists')
        TempImDirName = FUNC.resize_images(ImagesFolderName, WantedSize);
        assert(~exist(TempImDirName, 'dir'), 'Temp folder created despite invalid input folder')
        
        % Test case 2: Input folder contains valid images
        ImagesFolderName = 'my_images_folder';
        images = imageDatastore(ImagesFolderName, ...
            'IncludeSubfolders',true, ...
            'LabelSource','foldernames');
        num = numel(images.Files);
        WantedSize = [500, 500];
        assert(exist(ImagesFolderName, 'dir'), 'Test folder does not exist')
        TempImDirName = FUNC.resize_images(ImagesFolderName, WantedSize);
        assert(exist(TempImDirName, 'dir'), 'Temp folder not created')
        assert(numel(dir(fullfile(TempImDirName, '*.tiff'))) == num, 'Unexpected number of output images')

        %test case 3: The images are correctly resized
        
        outputFiles = dir([TempImDirName '/*.tiff']);
        numImages = length(outputFiles);
        
        % Loop over all images in the output directory and check their size
        for i = 1:numImages
            % Load the image and get its size
            im = imread(fullfile(TempImDirName, outputFiles(i).name));
            [h, w, ~] = size(im);
            
            % Check if the size matches the target size
            verifyEqual(testCase, [h, w], WantedSize, 'AbsTol', 1, ...
                ['Size of image ' outputFiles(i).name ' does not match the target size']);
        end
        rmdir(TempImDirName, 's');
        end
        %tests for the Dataset_processing function-------------------------------

        function testOutputDatastoresSize(testCase)
            % Test that the output datastores have the expected sizes
            
            % Generate example data
            imDir = fullfile(pwd, 'test_images');
            maskDir = fullfile(pwd, 'test_masks');
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
            actualSizeTrain = numel(dsTrain.Files);
            actualSizeVal = numel(dsVal.Files);
            actualSizeTest = numel(dsTest.Files);
            testCase.verifyEqual(actualSizeTrain, expectedSizeTrain, 'Output datastores have unexpected size');
            testCase.verifyEqual(actualSizeVal, expectedSizeVal, 'Output datastores have unexpected size');
            testCase.verifyEqual(actualSizeTest, expectedSizeTest, 'Output datastores have unexpected size');
        end
        
        function testInvalidInputFolder(testCase)
            % Test that an error is thrown when an invalid images directory is given
            
            % Call the function with an invalid directory
            invalidDir = 'invalid_dir';
            maskDir = fullfile(pwd, 'test_masks');
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
        
        function testInvalidMaskFolder(testCase)
            % Test that an error is thrown when an invalid masks directory is given
            
            % Call the function with an invalid directory
            imDir = fullfile(pwd, 'test_images');
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
            im = imread('exampleImage.png');
            Folder = 'testFolder';
            if ~exist(Folder, 'dir')
                mkdir(Folder);
            end
            FilesNames = 'testFolder/testImage.png';
            ISaveImages(FilesNames, Folder, im);
            savedImage = imread('testFolder/testImage.tiff');
            rmdir(Folder,'s');
            testCase.verifyEqual(im, savedImage, 'The saved image is not equal to the original image.');
        end



    end
end