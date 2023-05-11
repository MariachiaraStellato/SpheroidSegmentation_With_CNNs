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
            test = [I(1,1), I(500,500), I(1,500), I(500,1)];
            if test(1) < 200 && test(2) < 200 && test(3) < 200 && test(4) < 200 
                errordlg('The images must have white background and dark spheroid to be correctly segmented');
                break; 
            end
            im = FUNC.seg_and_fill(I,net);   
            I = imresize(I,[a b]);
            im = imresize(im,[a,b]);
            FUNC.ISaveImages(FilesNames(i),SegFolder,im);
            if flag_showmask == 1
                try
                    FUNC.IPlotImagesAndMasks(im,I,FilesNames(i))
                    hFinalFigure = gcf;
                    pause(2*eps);
                    waitforbuttonpress
                    pause(2*eps);
                    close(hFinalFigure);
                    pause(2*eps);
                catch 
                end

                
            end

        end

    else

    file_name = FUNC.IGetFileName(ImFolder,specificImageName);
    im = imread(file_name);
    [a,b,c] = size(im);
    im = imresize(im,[500,500]);
    if c~=1 && c~=3
        ImInpN = im(:,:,1);
        im= ImInpN;
        clear ImInpN
    end
    if size(im,3) == 3
        im = rgb2gray(im);
    end
        test = [im(1,1), im(500,500), im(1,500), im(500,1)];
    if test(1) < 200 && test(2) < 200 && test(3) < 200 && test(4) < 200 
       
        errordlg('The images must have white background and dark spheroid to be correctly segmented');
                    
    end
    I = seg_and_fill(im,net);
    I = imresize(I,[a b]);
    im = imresize(im,[a,b]);
    imgName = [SegFolder, filesep , specificImageName, '.tiff'];


end