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
        TempImDirName = resize_images(ImagesFolderName, WantedSize);
        assert(~exist(TempImDirName, 'dir'), 'Temp folder created despite invalid input folder')
        
        % Test case 2: Input folder contains valid images
        ImagesFolderName = 'sample_images';
        WantedSize = [500, 500];
        assert(exist(ImagesFolderName, 'dir'), 'Test folder does not exist')
        TempImDirName = resize_images(ImagesFolderName, WantedSize);
        assert(exist(TempImDirName, 'dir'), 'Temp folder not created')
        assert(numel(dir(fullfile(TempImDirName, '*.tiff'))) == 2, 'Unexpected number of output images')

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
    end
end