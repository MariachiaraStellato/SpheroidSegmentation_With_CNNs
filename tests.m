classdef tests<matlab.unittest.TestCase

    methods (Test)
        %tests for the process_images function--------------------------------------------------
        function testTempImDirName(testCase)
            ImagesFolderName = 'my_images_folder';
            WantedSize = [256, 256];
            c = 1;
            TempImDirName = process_images(ImagesFolderName, WantedSize, c);
            testCase.verifyEqual(exist(TempImDirName, 'dir'), 7);
        end
    end
end