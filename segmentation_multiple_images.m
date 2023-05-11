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
                    imOut = uint8(im);
                    imIn = uint8(I);
                    Bar = max(imIn(:)).*uint8([ones(a, 5) zeros(a, 5) ones(a, 5)]);
                    finalIm = [imIn Bar imOut];
                    name = char(FilesNames(i));
                    figure('Name',[name,' (press ENTER to go ahead).'],'NumberTitle','off'), imshow(finalIm, [], 'Border', 'Tight');
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


    end



end