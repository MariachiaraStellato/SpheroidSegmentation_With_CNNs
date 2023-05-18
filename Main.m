%% script to perform the training 
possible_net = ["VGG-16", "VGG-19", "ResNet-18","ResNet-50","ResNet101"];
ImagesDir = "\Your_images_Dir";
MasksDir = "\Your_masks_Dir";
PathTrainedNet = "\Your_network_Dir"; %The directory where the trained network will be saved 
NetworkType = 5; %This correspond to the ResNet101 network
Choosen_Net = possible_net(NetworkType);
net = Network_training(ImagesDir, MasksDir, NetworkType);
T = datestr(now,'dd-mm-yy-HH-MM-SS');       
netname = [char(Choosen_Net),'_',T]; 
netdir = fullfile(PathTrainedNet,netname);
save(netdir,'net');
msgbox('TRAINING: THE END.', 'Message');
%% segmentation
PathImageFolder = "\Your_images_Dir";
PathImageFolderOut = "\Your_masks_Dir";
PathNetworkFolderInp = "\Your_network_Dir";
SpecificImageName ="image_name";
flag_ShowMask = 1;
segmentation_multiple_images(PathImageFolderInp,PathImageFolderOut,PathNetworkFolderInp,SpecificImageName,flag_ShowMask);