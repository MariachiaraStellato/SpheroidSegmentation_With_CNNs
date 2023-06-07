function metrics = metric_evaluation(TestMasksDir, SegmentedMaskDir)
% AUTHOR: Mariachiara Stellato (E-mail: mariachiarastellato@gmail.com)
% FUNCTION DESCRIPTION: 
%   this function takes as inputs a folder containing the mask you consider your ground truth and 
%   another folder containing the masks segmented with one semantic segmentation network. 
%   It gives as an output a structure containing various computed
%   metrics that evaluate the quality of the semantic segmentation. 
% INPUTS:
%   TestMaskDir:                 string containing the directory of the
%                                folder containing the ground truth masks. 
%   SegmentedMaskDir:            string containing the directory of the
%                                folder containing the mask segmented with the semantic segmentation network.
% OUTPUTS:
%   metrics:                     structure containing the computed
%                                metrics for evaluating the quality of the network. 

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
    classes = [
                "Sferoids"
                "Background"
               ]; %categories i wanto to segment the images into
    
    labelIDs = {
                 0;
                 255
                }; %graylevel to refer to the labels
    
    segmented = pixelLabelDatastore(SegmentedMaskDir,classes,labelIDs);
    
    expected = pixelLabelDatastore(TestMasksDir,classes,labelIDs);
    
    metrics = evaluateSemanticSegmentation(segmented,expected,'Verbose',false);

end