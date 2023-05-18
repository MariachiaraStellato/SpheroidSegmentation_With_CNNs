function metrics = metric_evaluation(TestMasksDir, SegmentedMaskDir)

classes = [
    "Sferoids"
    "Background"
    ]; %categories i wanto to segment the images into

labelIDs = {0; 
            255}; %graylevel to refer to the labels 

segmented = pixelLabelDatastore(SegmentedMaskDir,classes,labelIDs);

expected = pixelLabelDatastore(TestMasksDir,classes,labelIDs);

metrics = evaluateSemanticSegmentation(segmented,expected,'Verbose',false);

end