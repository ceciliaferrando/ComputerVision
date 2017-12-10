load('../data/sylvseq.mat');
bases = load('../data/sylvbases.mat');

bases = bases.bases;

rectList = [];
rectListBase = [];
rect = [102; 62; 156; 108];
rect0 = [102; 62; 156; 108];
rectList = vertcat(rectList, rect');
rectListBase = vertcat(rectListBase, rect0');

for i=1:size(frames,3)-1
    i
    rectList
    fr1 = frames(:,:,i);
    fr2 = frames(:,:,i+1);
    [dp_x,dp_y] = LucasKanadeBasis(fr1, fr2, rect, bases);  
    [dp_xBase,dp_yBase] = LucasKanade(fr1, fr2, rect0); 
    rectBase = [rect0(1)+dp_xBase; rect0(2)+dp_yBase;rect0(3)+dp_xBase;rect0(4)+dp_yBase];
    rect = [rect(1)+dp_x; rect(2)+dp_y; rect(3)+dp_x; rect(4)+dp_y];
    rect = round(rect);
    rectBase = round(rectBase);
    rectList = vertcat(rectList,rect');
    rectListBase = vertcat(rectListBase,rectBase');
end

indexes=[1,200,300,350,400];
rectList
save('sylvseq.mat', 'rectList');

for i = 1:size(indexes,2)
    j = indexes(i);
    frame = frames(:,:,j);
    subplot(1,5,i), imshow(frame);
    title(strcat('Frame ',num2str(j)));
    rect = rectList(j, :);
    rectBase = rectListBase(j, :);
    pos = [rect(1) rect(2), rect(3) - rect(1), rect(4) - rect(2)];
    pos2 = [rectBase(1) rectBase(2), rectBase(3) - rectBase(1), rectBase(4) - rectBase(2)];
    rectangle('Position',pos,'EdgeColor', 'g', 'LineWidth',1);
    rectangle('Position',pos2,'EdgeColor', 'r', 'LineWidth',1);
end