load('../data/carseq.mat');
imshow(frames(:,:,2));

rectList = [];
baseRectList = [];
rect0 = [60; 117; 146; 152];
rectList = vertcat(rectList, rect0');
baseRectList = vertcat(baseRectList, rect0');
rect = [60; 117; 146; 152];
fr0 = frames(:,:,1);

epsilon = 4;

for i=1:size(frames,3)-1
    
    fr1 = frames(:,:,i);
    fr2 = frames(:,:,i+1);
    
    [dp_x,dp_y] = LucasKanade(fr1, fr2, rect);
    newRect = [rect(1)+dp_x;rect(2)+dp_y;rect(3)+dp_x;rect(4)+dp_y];
    
    diff = (newRect(1:2)-rect0(1:2))';

    [dp_xStar,dp_yStar] = LucasKanadeP(fr0, fr2, rect0, diff');
    refRect = [rect(1)+dp_xStar,rect(2)+dp_yStar,rect(3)+dp_xStar,rect(4)+dp_yStar];
    
    dp_xStar = dp_xStar-(rect(1)-rect0(1));
    dp_yStar = dp_yStar-(rect(2)-rect0(2));
    
    diff = norm([dp_xStar,dp_yStar]-[dp_x,dp_y]);
    
    if diff <= epsilon 
        incrementX = dp_xStar;
        incrementY = dp_yStar;
    else
        incrementX = dp_x;
        incrementY = dp_y;
    end
    rect2 = [rect(1)+dp_x,rect(2)+dp_y,rect(3)+dp_x,rect(4)+dp_y]    
    rect = [rect(1)+incrementX,rect(2)+incrementY,rect(3)+incrementX,rect(4)+incrementY];
    
    rectList = vertcat(rectList, rect);
    baseRectList = vertcat(baseRectList, rect2);
end

save('carseqrects-wcrt.mat', 'rectList');

indexes=[1,100,200,300,400];

for i = 1:size(indexes,2)
    j = indexes(i);
    frame = frames(:,:,j);
    subplot(1,5,i), imshow(frame);
    title(strcat('Frame ',num2str(j)));
    rect = rectList(j, :);
    rect2 = baseRectList(j, :);
    pos = [rect(1) rect(2), rect(3) - rect(1), rect(4) - rect(2)];
    pos2 = [rect2(1) rect2(2), rect2(3) - rect2(1), rect2(4) - rect2(2)];
    rectangle('Position',pos,'EdgeColor', 'g', 'LineWidth',1);
    %rectangle('Position',pos2,'EdgeColor', 'r', 'LineWidth',1);
end
