load('../data/carseq.mat');
imshow(frames(:,:,2));

rectList = [];
rect = [60; 117; 146; 152];
rectList = vertcat(rectList, rect');

for i=1:size(frames,3)-1
    fr1 = frames(:,:,i);
    fr2 = frames(:,:,i+1);
    [dp_x,dp_y] = LucasKanade(fr1, fr2, rect);  
    rect = [rect(1)+dp_x; rect(2)+dp_y; rect(3)+dp_x; rect(4)+dp_y];
    rectList = vertcat(rectList,rect');
end

save('carseqrects.mat', 'rectList');

indexes=[1,100,200,300,400];

for i = 1:size(indexes,2)
    j = indexes(i);
    frame = frames(:,:,j);
    subplot(1,5,i), imshow(frame);
    title(strcat('Frame ',num2str(j)));
    rect = rectList(j, :);
    pos = [rect(1) rect(2), rect(3) - rect(1), rect(4) - rect(2)];
    rectangle('Position',pos,'EdgeColor', 'r', 'LineWidth',1)
end
