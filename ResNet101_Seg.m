function lgraph = ResNet101_Seg(ImageSize)

    lgraph = layerGraph();
    tempLayers = imageInputLayer(ImageSize,"Name","data");
    lgraph = addLayers(lgraph,tempLayers);



end
