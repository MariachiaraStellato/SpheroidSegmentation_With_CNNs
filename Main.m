%% script to perform the training 
possible_net = ["VGG-16", "VGG-19", "ResNet-18","ResNet-50","ResNet101"];
ImagesDir = "ExampleImages";
MasksDir = "ExampleMasks";
PathTrainedNet = "TrainedNetworks"; %The directory where the trained network will be saved 
NetworkType = 5; %This correspond to the ResNet101 network
Choosen_Net = possible_net(NetworkType);
net = Network_Training(ImagesDir, MasksDir, NetworkType);
T = datestr(now,'dd-mm-yy-HH-MM-SS');       
netname = [char(Choosen_Net),'_',T]; 
netdir = fullfile(PathTrainedNet,netname);
save(netdir,'net');
msgbox('TRAINING: THE END.', 'Message');

%% segmentation
PathImageFolder = "ExampleImages";
PathImageFolderOut = "SegmentedMasks";
PathNetworkFolderInp = "TrainedNetworks\segRes18Net.mat";
SpecificImageName ='none';
flag_ShowMask = 1;
segmentation_multiple_images(PathImageFolder,PathImageFolderOut,PathNetworkFolderInp,SpecificImageName,flag_ShowMask);

%% metric evaluation
TestMaskDir = "ExampleMasks";
SegmentedMaskDir = "SegmentedMasks";
metrics = metric_evaluation(TestMaskDir, SegmentedMaskDir);
