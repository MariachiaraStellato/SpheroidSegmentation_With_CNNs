%%script to perform the training 

ImagesDir = "\Your_images_Dir";
MasksDir = "Your_masks_Dir";
NetworkType = 5; %This correspond to the ResNet101 network
net = Network_training(ImagesDir, MasksDir, NetworkType);