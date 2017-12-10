load(fullfile('..','data','aerialseq.mat'));

Nframes = size(frames, 3);
plotFrames = [30, 60, 90, 120];
% Detect the moving objects in the frame

for i=1:Nframes-1
    img = frames(:,:,i);
    img2 = frames(:,:,i+1);
    mask = Copy_of_SubtractDominantMotion(img,img2);
    mask = uint8(mask);
    rects(:,:,i) = mask(:,:);
    maskColor(:,:,1) = mask(:,:)*255;
    maskColor(:,:,2) = zeros(size(mask(:,:,1)));
    maskColor(:,:,3) = zeros(size(mask(:,:,1)));
    fuseI = imfuse(img,maskColor,'blend','Scaling','joint');
    imshow(fuseI);
    %imshow(maskColor);
    pause(0.01);
    if any(i==plotFrames)
        saveas(gcf,sprintf('CopyAerialFrame%d.jpg',i));
    end
end