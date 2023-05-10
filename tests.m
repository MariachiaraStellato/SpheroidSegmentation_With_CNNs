classdef tests<matlab.unittest.TestCase

    methods (Test)
        %tests for the process_images function--------------------------------------------------
        function testTempImDirName(testCase)
            ImagesFolderName = 'my_images_folder';
            WantedSize = [256, 256];
            c = 1;
            TempImDirName = process_images(ImagesFolderName, WantedSize, c);
            testCase.verifyEqual(exist(TempImDirName, 'dir'), 7);
            rmdir(TempImDirName,'s');
        end

        function testImageSize(testCase)
            ImagesFolderName = 'my_images_folder';
            WantedSize = [256, 256];
            c = 1;
            TempImDirName = process_images(ImagesFolderName, WantedSize, c);
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
    end
end