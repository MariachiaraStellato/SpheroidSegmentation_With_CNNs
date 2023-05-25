function lgraph = ResNet101_Seg(ImageSize,NumClasses)
% AUTHOR: Mariachiara Stellato (E-mail: mariachiarastellato@gmail.com)
% FUNCTION DESCRITPION: 
%   This function will create a segmentation neural network based on the
%   convolution neural network called ResNet101.
%
% INPUTS: 
%   ImageSize:      [a b] numerical array containing the size of the images 
%                   that will be used for the training 
%   NumClasses:     integer that specigy the number of classes for which
%                   the network will be trained. 
% OUTPUT: 
%   lgraph:         lgraph containing the connected layers that form the
%                   segmentation network

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

%initialize an empty layergraph
lgraph = layerGraph();
tempLayers = imageInputLayer(ImageSize,"Name","data");
lgraph = addLayers(lgraph,tempLayers);

%create the downsizing part of the nerwork
tempLayers = [FUNC.ConvBatchRelu([7 7],64,[3 3 3 3],[2 2],"conv1","bn_conv1","conv1_relu",1)
              maxPooling2dLayer([3 3],"Name","pool1","Padding",[0 1 0 1],"Stride",[2 2])];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = FUNC.ConvBatch([1 1],256,0,[1 1],"res2a_branch1","bn2a_branch1",1);
lgraph = addLayers(lgraph,tempLayers);

%Second branch
for i=1:3
    let = ["a","b","c"];
    BatchName = strcat("2",let(i),"_branch");
    tempLayers = FUNC.ICreateBatch([1 1],64,BatchName,1);
    lgraph = addLayers(lgraph,tempLayers);
    tempLayers = FUNC.AdditionRelu(strcat("res2",let(i)));
    lgraph = addLayers(lgraph,tempLayers);
end

tempLayers = FUNC.ICreateBatch([1 1],128,"3a_branch",1);
lgraph = addLayers(lgraph,tempLayers);

layers = convolution2dLayer([1 1],128,"Name","res3a_branch2a","BiasLearnRateFactor",0,"Stride",[2 2]);
lgraph = replaceLayer(lgraph,"res3a_branch2a",layers);

tempLayers = FUNC.ConvBatch([1 1],512,0,[2 2],"res3a_branch1","bn3a_branch1",1);
lgraph = addLayers(lgraph,tempLayers);

tempLayers = FUNC.AdditionRelu("res3a");
lgraph = addLayers(lgraph,tempLayers);

%Third branch

for i=1:3
    let = ["b1","b2","b3"];
    BatchName = strcat("3",let(i),"_branch");
    tempLayers = FUNC.ICreateBatch([1 1],128,BatchName,1);
    lgraph = addLayers(lgraph,tempLayers);
    tempLayers = FUNC.AdditionRelu(strcat("res3",let(i)));
    lgraph = addLayers(lgraph,tempLayers);

end

tempLayers = FUNC.ConvBatchRelu([1 1],256,0,[1 1],"dec_c2","dec_bn2","dec_relu2",10);
lgraph = addLayers(lgraph,tempLayers);

tempLayers = FUNC.ICreateBatch([1 1],256,"4a_branch",1);
lgraph = addLayers(lgraph,tempLayers);

layers = convolution2dLayer([1 1],256,"Name","res4a_branch2a","BiasLearnRateFactor",0,"Stride",[2 2]);
lgraph = replaceLayer(lgraph,"res4a_branch2a",layers);

tempLayers = FUNC.ConvBatch([1 1],1024,0,[2 2],"res4a_branch1","bn4a_branch1",1);
lgraph = addLayers(lgraph,tempLayers);

tempLayers = FUNC.AdditionRelu("res4a");
lgraph = addLayers(lgraph,tempLayers);

%Fourth branch

for i=1:22
    BatchName = strcat("4b",string(i),"_branch");
    tempLayers = FUNC.ICreateBatch([1,1],256,BatchName,1);
    lgraph = addLayers(lgraph,tempLayers);
    tempLayers = FUNC.AdditionRelu(strcat("res4b",string(i)));
    lgraph = addLayers(lgraph,tempLayers);
end

%Fifth branch

for i=1:3
    let = ["a","b","c"];
    BatchName = strcat("5",let(i),"_branch");
    tempLayers = FUNC.ICreateBatch([1 1],512,BatchName,1);
    lgraph = addLayers(lgraph,tempLayers);
    tempLayers = FUNC.AdditionRelu(strcat("res5",let(i)));
    lgraph = addLayers(lgraph,tempLayers);
end

layers = convolution2dLayer([1 1],512,"Name","res5a_branch2a","BiasLearnRateFactor",0,"Stride",[2 2]);
lgraph = replaceLayer(lgraph,"res5a_branch2a",layers);

tempLayers = FUNC.ConvBatch([1 1],2048,0,[2 2],"res5a_branch1","bn5a_branch1",1);
lgraph = addLayers(lgraph,tempLayers);

%initialization of the deconvolution part of the network 
for i=1:4
    if i == 1
        filterSize = [1 1];
        DilatationFactor = [1 1];
    else
        filterSize = [3 3];
        DilatationFactor = [(i-1)*6,(i-1)*6];
    end
    tempLayers = FUNC.ConvBatchReluWDil(filterSize,256,"same",[1 1],strcat("aspp_Conv_",string(i)),strcat("aspp_BatchNorm_",string(i)),strcat("aspp_Relu_",string(i)),10,DilatationFactor);
    lgraph = addLayers(lgraph,tempLayers);

end

tempLayers = [
    FUNC.DepthConvBatchRelu(4,[1 1],256,0,[1 1],"dec_c1","dec_bn1","dec_relu1","catAspp",10)
    transposedConv2dLayer([8 8],256,"Name","dec_upsample1","BiasLearnRateFactor",0,"Cropping",[2 2 2 2],"Stride",[4 4],"WeightLearnRateFactor",0)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = crop2dLayer("centercrop","Name","dec_crop1");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    FUNC.DepthConvBatchRelu(2,[3 3],256,"same",[1 1],"dec_c3","dec_bn3","dec_relu3","dec_cat1",10)
    FUNC.ConvBatchRelu([3 3],256,"same",[1 1],"dec_c4","dec_bn4","dec_relu4",10);
    convolution2dLayer([1 1],NumClasses,"Name","scorer","BiasLearnRateFactor",0,"WeightLearnRateFactor",10)
    transposedConv2dLayer([8 8],NumClasses,"Name","dec_upsample2_1","BiasLearnRateFactor",0,"Cropping",[2 2 2 2],"Stride",[4 4],"WeightLearnRateFactor",0)
    transposedConv2dLayer([8 8],NumClasses,"Name","dec_upsample2_2","BiasLearnRateFactor",0,"Cropping",[2 2 2 2],"Stride",[2 2],"WeightLearnRateFactor",0)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    crop2dLayer("centercrop","Name","dec_crop2")
    softmaxLayer("Name","softmax-out")
    pixelClassificationLayer("Name","pixel-class")];
lgraph = addLayers(lgraph,tempLayers);

% clean up helper variable
clear tempLayers;

% connect the layers in teh right order
lgraph = connectLayers(lgraph,"data","conv1");
lgraph = connectLayers(lgraph,"data","dec_crop2/ref");
lgraph = connectLayers(lgraph,"pool1","res2a_branch1");
lgraph = connectLayers(lgraph,"pool1","res2a_branch2a");
lgraph = connectLayers(lgraph,"bn2a_branch1","res2a/in2");
lgraph = connectLayers(lgraph,"bn2a_branch2c","res2a/in1");
lgraph = connectLayers(lgraph,"res2a_relu","res2b_branch2a");
lgraph = connectLayers(lgraph,"res2a_relu","res2b/in2");
lgraph = connectLayers(lgraph,"bn2b_branch2c","res2b/in1");
lgraph = connectLayers(lgraph,"res2b_relu","res2c_branch2a");
lgraph = connectLayers(lgraph,"res2b_relu","res2c/in2");
lgraph = connectLayers(lgraph,"bn2c_branch2c","res2c/in1");
lgraph = connectLayers(lgraph,"res2c_relu","res3a_branch2a");
lgraph = connectLayers(lgraph,"res2c_relu","res3a_branch1");
lgraph = connectLayers(lgraph,"bn3a_branch1","res3a/in2");
lgraph = connectLayers(lgraph,"bn3a_branch2c","res3a/in1");
lgraph = connectLayers(lgraph,"res3a_relu","res3b1_branch2a");
lgraph = connectLayers(lgraph,"res3a_relu","dec_c2");
lgraph = connectLayers(lgraph,"res3a_relu","res3b1/in2");
lgraph = connectLayers(lgraph,"dec_relu2","dec_crop1/ref");
lgraph = connectLayers(lgraph,"dec_relu2","dec_cat1/in1");
lgraph = connectLayers(lgraph,"bn3b1_branch2c","res3b1/in1");
lgraph = connectLayers(lgraph,"res3b1_relu","res3b2_branch2a");
lgraph = connectLayers(lgraph,"res3b1_relu","res3b2/in2");
lgraph = connectLayers(lgraph,"bn3b2_branch2c","res3b2/in1");
lgraph = connectLayers(lgraph,"res3b2_relu","res3b3_branch2a");
lgraph = connectLayers(lgraph,"res3b2_relu","res3b3/in2");
lgraph = connectLayers(lgraph,"bn3b3_branch2c","res3b3/in1");
lgraph = connectLayers(lgraph,"res3b3_relu","res4a_branch2a");
lgraph = connectLayers(lgraph,"res3b3_relu","res4a_branch1");
lgraph = connectLayers(lgraph,"bn4a_branch1","res4a/in2");
lgraph = connectLayers(lgraph,"bn4a_branch2c","res4a/in1");
lgraph = connectLayers(lgraph,"res4a_relu","res4b1_branch2a");
lgraph = connectLayers(lgraph,"res4a_relu","res4b1/in2");
lgraph = connectLayers(lgraph,"bn4b1_branch2c","res4b1/in1");
lgraph = connectLayers(lgraph,"res4b1_relu","res4b2_branch2a");
lgraph = connectLayers(lgraph,"res4b1_relu","res4b2/in2");
lgraph = connectLayers(lgraph,"bn4b2_branch2c","res4b2/in1");
lgraph = connectLayers(lgraph,"res4b2_relu","res4b3_branch2a");
lgraph = connectLayers(lgraph,"res4b2_relu","res4b3/in2");
lgraph = connectLayers(lgraph,"bn4b3_branch2c","res4b3/in1");
lgraph = connectLayers(lgraph,"res4b3_relu","res4b4_branch2a");
lgraph = connectLayers(lgraph,"res4b3_relu","res4b4/in2");
lgraph = connectLayers(lgraph,"bn4b4_branch2c","res4b4/in1");
lgraph = connectLayers(lgraph,"res4b4_relu","res4b5_branch2a");
lgraph = connectLayers(lgraph,"res4b4_relu","res4b5/in2");
lgraph = connectLayers(lgraph,"bn4b5_branch2c","res4b5/in1");
lgraph = connectLayers(lgraph,"res4b5_relu","res4b6_branch2a");
lgraph = connectLayers(lgraph,"res4b5_relu","res4b6/in2");
lgraph = connectLayers(lgraph,"bn4b6_branch2c","res4b6/in1");
lgraph = connectLayers(lgraph,"res4b6_relu","res4b7_branch2a");
lgraph = connectLayers(lgraph,"res4b6_relu","res4b7/in2");
lgraph = connectLayers(lgraph,"bn4b7_branch2c","res4b7/in1");
lgraph = connectLayers(lgraph,"res4b7_relu","res4b8_branch2a");
lgraph = connectLayers(lgraph,"res4b7_relu","res4b8/in2");
lgraph = connectLayers(lgraph,"bn4b8_branch2c","res4b8/in1");
lgraph = connectLayers(lgraph,"res4b8_relu","res4b9_branch2a");
lgraph = connectLayers(lgraph,"res4b8_relu","res4b9/in2");
lgraph = connectLayers(lgraph,"bn4b9_branch2c","res4b9/in1");
lgraph = connectLayers(lgraph,"res4b9_relu","res4b10_branch2a");
lgraph = connectLayers(lgraph,"res4b9_relu","res4b10/in2");
lgraph = connectLayers(lgraph,"bn4b10_branch2c","res4b10/in1");
lgraph = connectLayers(lgraph,"res4b10_relu","res4b11_branch2a");
lgraph = connectLayers(lgraph,"res4b10_relu","res4b11/in2");
lgraph = connectLayers(lgraph,"bn4b11_branch2c","res4b11/in1");
lgraph = connectLayers(lgraph,"res4b11_relu","res4b12_branch2a");
lgraph = connectLayers(lgraph,"res4b11_relu","res4b12/in2");
lgraph = connectLayers(lgraph,"bn4b12_branch2c","res4b12/in1");
lgraph = connectLayers(lgraph,"res4b12_relu","res4b13_branch2a");
lgraph = connectLayers(lgraph,"res4b12_relu","res4b13/in2");
lgraph = connectLayers(lgraph,"bn4b13_branch2c","res4b13/in1");
lgraph = connectLayers(lgraph,"res4b13_relu","res4b14_branch2a");
lgraph = connectLayers(lgraph,"res4b13_relu","res4b14/in2");
lgraph = connectLayers(lgraph,"bn4b14_branch2c","res4b14/in1");
lgraph = connectLayers(lgraph,"res4b14_relu","res4b15_branch2a");
lgraph = connectLayers(lgraph,"res4b14_relu","res4b15/in2");
lgraph = connectLayers(lgraph,"bn4b15_branch2c","res4b15/in1");
lgraph = connectLayers(lgraph,"res4b15_relu","res4b16_branch2a");
lgraph = connectLayers(lgraph,"res4b15_relu","res4b16/in2");
lgraph = connectLayers(lgraph,"bn4b16_branch2c","res4b16/in1");
lgraph = connectLayers(lgraph,"res4b16_relu","res4b17_branch2a");
lgraph = connectLayers(lgraph,"res4b16_relu","res4b17/in2");
lgraph = connectLayers(lgraph,"bn4b17_branch2c","res4b17/in1");
lgraph = connectLayers(lgraph,"res4b17_relu","res4b18_branch2a");
lgraph = connectLayers(lgraph,"res4b17_relu","res4b18/in2");
lgraph = connectLayers(lgraph,"bn4b18_branch2c","res4b18/in1");
lgraph = connectLayers(lgraph,"res4b18_relu","res4b19_branch2a");
lgraph = connectLayers(lgraph,"res4b18_relu","res4b19/in2");
lgraph = connectLayers(lgraph,"bn4b19_branch2c","res4b19/in1");
lgraph = connectLayers(lgraph,"res4b19_relu","res4b20_branch2a");
lgraph = connectLayers(lgraph,"res4b19_relu","res4b20/in2");
lgraph = connectLayers(lgraph,"bn4b20_branch2c","res4b20/in1");
lgraph = connectLayers(lgraph,"res4b20_relu","res4b21_branch2a");
lgraph = connectLayers(lgraph,"res4b20_relu","res4b21/in2");
lgraph = connectLayers(lgraph,"bn4b21_branch2c","res4b21/in1");
lgraph = connectLayers(lgraph,"res4b21_relu","res4b22_branch2a");
lgraph = connectLayers(lgraph,"res4b21_relu","res4b22/in2");
lgraph = connectLayers(lgraph,"bn4b22_branch2c","res4b22/in1");
lgraph = connectLayers(lgraph,"res4b22_relu","res5a_branch2a");
lgraph = connectLayers(lgraph,"res4b22_relu","res5a_branch1");
lgraph = connectLayers(lgraph,"bn5a_branch2c","res5a/in1");
lgraph = connectLayers(lgraph,"bn5a_branch1","res5a/in2");
lgraph = connectLayers(lgraph,"res5a_relu","res5b_branch2a");
lgraph = connectLayers(lgraph,"res5a_relu","res5b/in2");
lgraph = connectLayers(lgraph,"bn5b_branch2c","res5b/in1");
lgraph = connectLayers(lgraph,"res5b_relu","res5c_branch2a");
lgraph = connectLayers(lgraph,"res5b_relu","res5c/in2");
lgraph = connectLayers(lgraph,"bn5c_branch2c","res5c/in1");
for i=1:4
    lgraph = connectLayers(lgraph,"res5c_relu",strcat("aspp_Conv_",string(i)));
    lgraph = connectLayers(lgraph,strcat("aspp_Relu_",string(i)),strcat("catAspp/in",string(i)));
end
lgraph = connectLayers(lgraph,"dec_upsample1","dec_crop1/in");
lgraph = connectLayers(lgraph,"dec_crop1","dec_cat1/in2");
lgraph = connectLayers(lgraph,"dec_upsample2_2","dec_crop2/in");


end
