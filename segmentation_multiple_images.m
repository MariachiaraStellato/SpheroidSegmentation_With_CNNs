function segmentation_multiple_images(ImFolder, SegFolder, network, specificImageName,flag_showmask)
    load(network, net);

    if isempty(specificImageName)
        image = imageDatastore(ImFolder, ...
        'IncludeSubfolders',true, ...
        'LabelSource','foldernames');
        FilesNames = image.Files;

        num = numel(FilesNames);
        for i=1:num
            BarWaitWindows = msgbox(['Please wait... ' ,'Folder analysed: ', ImFolder, ', Completed: ', num2str(round(100*(i/num))), '%.']);
            pause(2*eps);
            I = readimage(image,i);
            [a,b,c] = size(I);
            I = imresize(I,[500,500]); 
            if c~=1 && c~=3
                ImInpN = I(:,:,1);
                I= ImInpN;
                clear ImInpN
            end
            if size(I,3) == 3
                I = rgb2gray(I);
            end

        end

    else


    end



end