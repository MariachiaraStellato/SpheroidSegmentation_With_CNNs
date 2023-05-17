function lgraph = ResNet101_Seg(ImageSize)

    lgraph = layerGraph();
tempLayers = imageInputLayer(ImageSize,"Name","data");
lgraph = addLayers(lgraph,tempLayers);


tempLayers = [FUNC.ConvBatchRelu([7 7],64,[3 3 3 3],[2 2],"conv1","bn_conv1","conv1_relu",1)
              maxPooling2dLayer([3 3],"Name","pool1","Padding",[0 1 0 1],"Stride",[2 2])];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = FUNC.ConvBatch([1 1],256,0,[1 1],"res2a_branch1","bn2a_branch1",1);
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],64,0,[1 1],"res2a_branch2a","bn2a_branch2a","res2a_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],64,[1 1 1 1],[1 1],"res2a_branch2b","bn2a_branch2b","res2a_branch2b_relu",1)
              FUNC.ConvBatch([1 1],256,0,[1 1],"res2a_branch2c","bn2a_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res2a")
    reluLayer("Name","res2a_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],64,0,[1 1],"res2b_branch2a","bn2b_branch2a","res2b_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],64,[1 1 1 1],[1 1],"res2b_branch2b","bn2b_branch2b","res2b_branch2b_relu",1)
              FUNC.ConvBatch([1 1],256,0,[1 1],"res2b_branch2c","bn2b_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res2b")
    reluLayer("Name","res2b_relu")];
lgraph = addLayers(lgraph,tempLayers);


tempLayers = [FUNC.ConvBatchRelu([1 1],64,0,[1 1],"res2c_branch2a","bn2c_branch2a","res2c_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],64,[1 1 1 1],[1 1],"res2c_branch2b","bn2c_branch2b","res2c_branch2b_relu",1)
              FUNC.ConvBatch([1 1],256,0,[1 1],"res2c_branch2c","bn2c_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res2c")
    reluLayer("Name","res2c_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],128,0,[2 2],"res3a_branch2a","bn3a_branch2a","res3a_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],128,[1 1 1 1],[1 1],"res3a_branch2b","bn3a_branch2b","res3a_branch2b_relu",1)
              FUNC.ConvBatch([1 1],512,0,[1 1],"res3a_branch2c","bn3a_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = FUNC.ConvBatch([1 1],512,0,[2 2],"res3a_branch1","bn3a_branch1",1);
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res3a")
    reluLayer("Name","res3a_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],128,0,[1 1],"res3b1_branch2a","bn3b1_branch2a","res3b1_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],128,[1 1 1 1],[1 1],"res3b1_branch2b","bn3b1_branch2b","res3b1_branch2b_relu",1)
              FUNC.ConvBatch([1 1],512,0,[1 1],"res3b1_branch2c","bn3b1_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = FUNC.ConvBatchRelu([1 1],256,[1 1 1 1],[1 1],"dec_c2","dec_bn2","dec_relu2",10);
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res3b1")
    reluLayer("Name","res3b1_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],128,0,[1 1],"res3b2_branch2a","bn3b2_branch2a","res3b2_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],128,[1 1 1 1],[1 1],"res3b2_branch2b","bn3b2_branch2b","res3b2_branch2b_relu",1)
              FUNC.ConvBatch([1 1],512,0,[1 1],"res3b2_branch2c","bn3b2_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res3b2")
    reluLayer("Name","res3b2_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],128,0,[1 1],"res3b3_branch2a","bn3b3_branch2a","res3b3_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],128,[1 1 1 1],[1 1],"res3b3_branch2b","bn3b3_branch2b","res3b3_branch2b_relu",1)
              FUNC.ConvBatch([1 1],512,0,[1 1],"res3b3_branch2c","bn3b3_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res3b3")
    reluLayer("Name","res3b3_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],256,0,[2 2],"res4a_branch2a","bn4a_branch2a","res4a_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],256,[1 1 1 1],[1 1],"res4a_branch2b","bn4a_branch2b","res4a_branch2b_relu",1)
              FUNC.ConvBatch([1 1],1024,0,[1 1],"res4a_branch2c","bn4a_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);


tempLayers = [
    convolution2dLayer([1 1],1024,"Name","res4a_branch1","BiasLearnRateFactor",0,"Stride",[2 2])
    batchNormalizationLayer("Name","bn4a_branch1")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res4a")
    reluLayer("Name","res4a_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],256,0,[1 1],"res4b1_branch2a","bn4b1_branch2a","res4b1_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],256,[1 1 1 1],[1 1],"res4b1_branch2b","bn4b1_branch2b","res4b1_branch2b_relu",1)
              FUNC.ConvBatch([1 1],1024,0,[1 1],"res4b1_branch2c","bn4b1_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res4b1")
    reluLayer("Name","res4b1_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],256,0,[1 1],"res4b2_branch2a","bn4b2_branch2a","res4b2_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],256,[1 1 1 1],[1 1],"res4b2_branch2b","bn4b2_branch2b","res4b2_branch2b_relu",1)
              FUNC.ConvBatch([1 1],1024,0,[1 1],"res4b2_branch2c","bn4b2_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res4b2")
    reluLayer("Name","res4b2_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],256,0,[1 1],"res4b3_branch2a","bn4b3_branch2a","res4b3_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],256,[1 1 1 1],[1 1],"res4b3_branch2b","bn4b3_branch2b","res4b3_branch2b_relu",1)
              FUNC.ConvBatch([1 1],1024,0,[1 1],"res4b3_branch2c","bn4b3_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res4b3")
    reluLayer("Name","res4b3_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],256,0,[1 1],"res4b4_branch2a","bn4b4_branch2a","res4b4_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],256,[1 1 1 1],[1 1],"res4b4_branch2b","bn4b4_branch2b","res4b4_branch2b_relu",1)
              FUNC.ConvBatch([1 1],1024,0,[1 1],"res4b4_branch2c","bn4b4_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res4b4")
    reluLayer("Name","res4b4_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],256,0,[1 1],"res4b5_branch2a","bn4b5_branch2a","res4b5_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],256,[1 1 1 1],[1 1],"res4b5_branch2b","bn4b5_branch2b","res4b5_branch2b_relu",1)
              FUNC.ConvBatch([1 1],1024,0,[1 1],"res4b5_branch2c","bn4b5_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res4b5")
    reluLayer("Name","res4b5_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],256,0,[1 1],"res4b6_branch2a","bn4b6_branch2a","res4b6_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],256,[1 1 1 1],[1 1],"res4b6_branch2b","bn4b6_branch2b","res4b6_branch2b_relu",1)
              FUNC.ConvBatch([1 1],1024,0,[1 1],"res4b6_branch2c","bn4b6_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res4b6")
    reluLayer("Name","res4b6_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],256,0,[1 1],"res4b7_branch2a","bn4b7_branch2a","res4b7_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],256,[1 1 1 1],[1 1],"res4b7_branch2b","bn4b7_branch2b","res4b7_branch2b_relu",1)
              FUNC.ConvBatch([1 1],1024,0,[1 1],"res4b7_branch2c","bn4b7_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res4b7")
    reluLayer("Name","res4b7_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],256,0,[1 1],"res4b8_branch2a","bn4b8_branch2a","res4b8_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],256,[1 1 1 1],[1 1],"res4b8_branch2b","bn4b8_branch2b","res4b8_branch2b_relu",1)
              FUNC.ConvBatch([1 1],1024,0,[1 1],"res4b8_branch2c","bn4b8_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res4b8")
    reluLayer("Name","res4b8_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],256,0,[1 1],"res4b9_branch2a","bn4b9_branch2a","res4b9_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],256,[1 1 1 1],[1 1],"res4b9_branch2b","bn4b9_branch2b","res4b9_branch2b_relu",1)
              FUNC.ConvBatch([1 1],1024,0,[1 1],"res4b9_branch2c","bn4b9_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res4b9")
    reluLayer("Name","res4b9_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],256,0,[1 1],"res4b10_branch2a","bn4b10_branch2a","res4b10_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],256,[1 1 1 1],[1 1],"res4b10_branch2b","bn4b10_branch2b","res4b10_branch2b_relu",1)
              FUNC.ConvBatch([1 1],1024,0,[1 1],"res4b10_branch2c","bn4b10_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res4b10")
    reluLayer("Name","res4b10_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],256,0,[1 1],"res4b11_branch2a","bn4b11_branch2a","res4b11_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],256,[1 1 1 1],[1 1],"res4b11_branch2b","bn4b11_branch2b","res4b11_branch2b_relu",1)
              FUNC.ConvBatch([1 1],1024,0,[1 1],"res4b11_branch2c","bn4b11_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res4b11")
    reluLayer("Name","res4b11_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],256,0,[1 1],"res4b12_branch2a","bn4b12_branch2a","res4b12_branch2b_relu",1)
              FUNC.ConvBatchRelu([3 3],256,[1 1 1 1],[1 1],"res4b12_branch2b","bn4b12_branch2b","res4b12_branch2b_relu",1)
              FUNC.ConvBatch([1 1],1024,0,[1 1],"res4b12_branch2c","bn4b12_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res4b12")
    reluLayer("Name","res4b12_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],256,0,[1 1],"res4b13_branch2a","bn4b13_branch2a","res4b13_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],256,[1 1 1 1],[1 1],"res4b13_branch2b","bn4b13_branch2b","res4b13_branch2b_relu",1)
              FUNC.ConvBatch([1 1],1024,0,[1 1],"res4b13_branch2c","bn4b13_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res4b13")
    reluLayer("Name","res4b13_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],256,0,[1 1],"res4b14_branch2a","bn4b14_branch2a","res4b14_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],256,[1 1 1 1],[1 1],"res4b14_branch2b","bn4b14_branch2b","res4b14_branch2b_relu",1)
              FUNC.ConvBatch([1 1],1024,0,[1 1],"res4b14_branch2c","bn4b14_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res4b14")
    reluLayer("Name","res4b14_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],256,0,[1 1],"res4b15_branch2a","bn4b15_branch2a","res4b15_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],256,[1 1 1 1],[1 1],"res4b15_branch2b","bn4b15_branch2b","res4b15_branch2b_relu",1)
              FUNC.ConvBatch([1 1],1024,0,[1 1],"res4b15_branch2c","bn4b15_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res4b15")
    reluLayer("Name","res4b15_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],256,0,[1 1],"res4b16_branch2a","bn4b16_branch2a","res4b16_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],256,[1 1 1 1],[1 1],"res4b16_branch2b","bn4b16_branch2b","res4b16_branch2b_relu",1)
              FUNC.ConvBatch([1 1],1024,0,[1 1],"res4b16_branch2c","bn4b16_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res4b16")
    reluLayer("Name","res4b16_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],256,0,[1 1],"res4b17_branch2a","bn4b17_branch2a","res4b17_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],256,[1 1 1 1],[1 1],"res4b17_branch2b","bn4b17_branch2b","res4b17_branch2b_relu",1)
              FUNC.ConvBatch([1 1],1024,0,[1 1],"res4b17_branch2c","bn4b17_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res4b17")
    reluLayer("Name","res4b17_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],256,0,[1 1],"res4b18_branch2a","bn4b18_branch2a","res4b18_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],256,[1 1 1 1],[1 1],"res4b18_branch2b","bn4b18_branch2b","res4b18_branch2b_relu",1)
              FUNC.ConvBatch([1 1],1024,0,[1 1],"res4b18_branch2c","bn4b18_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res4b18")
    reluLayer("Name","res4b18_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],256,0,[1 1],"res4b19_branch2a","bn4b19_branch2a","res4b19_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],256,[1 1 1 1],[1 1],"res4b19_branch2b","bn4b19_branch2b","res4b19_branch2b_relu",1)
              FUNC.ConvBatch([1 1],1024,0,[1 1],"res4b19_branch2c","bn4b19_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res4b19")
    reluLayer("Name","res4b19_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],256,0,[1 1],"res4b20_branch2a","bn4b20_branch2a","res4b20_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],256,[1 1 1 1],[1 1],"res4b20_branch2b","bn4b20_branch2b","res4b20_branch2b_relu",1)
              FUNC.ConvBatch([1 1],1024,0,[1 1],"res4b20_branch2c","bn4b20_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res4b20")
    reluLayer("Name","res4b20_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],256,0,[1 1],"res4b21_branch2a","bn4b21_branch2a","res4b21_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],256,[1 1 1 1],[1 1],"res4b21_branch2b","bn4b21_branch2b","res4b21_branch2b_relu",1)
              FUNC.ConvBatch([1 1],1024,0,[1 1],"res4b21_branch2c","bn4b21_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res4b21")
    reluLayer("Name","res4b21_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],256,0,[1 1],"res4b22_branch2a","bn4b22_branch2a","res4b22_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],256,[1 1 1 1],[1 1],"res4b22_branch2b","bn4b22_branch2b","res4b22_branch2b_relu",1)
              FUNC.ConvBatch([1 1],1024,0,[1 1],"res4b22_branch2c","bn4b22_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res4b22")
    reluLayer("Name","res4b22_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],512,0,[1 1],"res5a_branch2a","bn5a_branch2a","res5a_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],512,[1 1 1 1],[1 1],"res5a_branch2b","bn5a_branch2b","res5a_branch2b_relu",1)
              FUNC.ConvBatch([1 1],2048,0,[1 1],"res5a_branch2c","bn5a_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = FUNC.ConvBatch([1 1],2048,0,[2 2],"res5a_branch1","bn5a_branch1",1);
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res5a")
    reluLayer("Name","res5a_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],512,0,[1 1],"res5b_branch2a","bn5b_branch2a","res5b_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],512,[1 1 1 1],[1 1],"res5b_branch2b","bn5b_branch2b","res5b_branch2b_relu",1)
              FUNC.ConvBatch([1 1],2048,0,[1 1],"res5b_branch2c","bn5b_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res5b")
    reluLayer("Name","res5b_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [FUNC.ConvBatchRelu([1 1],512,0,[1 1],"res5c_branch2a","bn5c_branch2a","res5c_branch2a_relu",1)
              FUNC.ConvBatchRelu([3 3],512,[1 1 1 1],[1 1],"res5c_branch2b","bn5c_branch2b","res5c_branch2b_relu",1)
              FUNC.ConvBatch([1 1],2048,0,[1 1],"res5c_branch2c","bn5c_branch2c",1)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    additionLayer(2,"Name","res5c")
    reluLayer("Name","res5c_relu")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = FUNC.ConvBatchReluWDil([3 3],256,"same",[1 1],"aspp_Conv_2","aspp_BatchNorm_2","aspp_Relu_2",10,[6 6]);
lgraph = addLayers(lgraph,tempLayers);

tempLayers = FUNC.ConvBatchReluWDil([1 1],256,"same",[1 1],"aspp_Conv_1","aspp_BatchNorm_1","aspp_Relu_1",10,[1 1]);
lgraph = addLayers(lgraph,tempLayers);

tempLayers = FUNC.ConvBatchReluWDil([3 3],256,"same",[1 1],"aspp_Conv_4","aspp_BatchNorm_4","aspp_Relu_1",10,[18 18]);
lgraph = addLayers(lgraph,tempLayers);

tempLayers = FUNC.ConvBatchReluWDil([3 3],256,"same",[1 1],"aspp_Conv_3","aspp_BatchNorm_3","aspp_Relu_3",10,[12 12]);
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    depthConcatenationLayer(4,"Name","catAspp")
    convolution2dLayer([1 1],256,"Name","dec_c1","BiasLearnRateFactor",0,"WeightLearnRateFactor",10)
    batchNormalizationLayer("Name","dec_bn1")
    reluLayer("Name","dec_relu1")
    transposedConv2dLayer([8 8],256,"Name","dec_upsample1","BiasLearnRateFactor",0,"Cropping",[2 2 2 2],"Stride",[4 4],"WeightLearnRateFactor",0)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = crop2dLayer("centercrop","Name","dec_crop1");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    depthConcatenationLayer(2,"Name","dec_cat1")
    convolution2dLayer([3 3],256,"Name","dec_c3","BiasLearnRateFactor",0,"Padding","same","WeightLearnRateFactor",10)
    batchNormalizationLayer("Name","dec_bn3")
    reluLayer("Name","dec_relu3")
    convolution2dLayer([3 3],256,"Name","dec_c4","BiasLearnRateFactor",0,"Padding","same","WeightLearnRateFactor",10)
    batchNormalizationLayer("Name","dec_bn4")
    reluLayer("Name","dec_relu4")
    convolution2dLayer([1 1],2,"Name","scorer","BiasLearnRateFactor",0,"WeightLearnRateFactor",10)
    transposedConv2dLayer([8 8],2,"Name","dec_upsample2_1","BiasLearnRateFactor",0,"Cropping",[2 2 2 2],"Stride",[4 4],"WeightLearnRateFactor",0)
    transposedConv2dLayer([8 8],2,"Name","dec_upsample2_2","BiasLearnRateFactor",0,"Cropping",[2 2 2 2],"Stride",[2 2],"WeightLearnRateFactor",0)];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    crop2dLayer("centercrop","Name","dec_crop2")
    softmaxLayer("Name","softmax-out")
    pixelClassificationLayer("Name","pixel-class")];
lgraph = addLayers(lgraph,tempLayers);

% clean up helper variable
clear tempLayers;
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
lgraph = connectLayers(lgraph,"res5c_relu","aspp_Conv_2");
lgraph = connectLayers(lgraph,"res5c_relu","aspp_Conv_1");
lgraph = connectLayers(lgraph,"res5c_relu","aspp_Conv_4");
lgraph = connectLayers(lgraph,"res5c_relu","aspp_Conv_3");
lgraph = connectLayers(lgraph,"aspp_Relu_4","catAspp/in4");
lgraph = connectLayers(lgraph,"aspp_Relu_2","catAspp/in2");
lgraph = connectLayers(lgraph,"aspp_Relu_1","catAspp/in1");
lgraph = connectLayers(lgraph,"aspp_Relu_3","catAspp/in3");
lgraph = connectLayers(lgraph,"dec_upsample1","dec_crop1/in");
lgraph = connectLayers(lgraph,"dec_crop1","dec_cat1/in2");
lgraph = connectLayers(lgraph,"dec_upsample2_2","dec_crop2/in");


end
