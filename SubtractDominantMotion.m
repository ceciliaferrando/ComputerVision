function mask = SubtractDominantMotion(image1, image2)

image1 = im2double(image1);
image2 = im2double(image2);

% Transformation matrix
M = LucasKanadeAffine(image1, image2);
%M = InverseCompositionAffine(image1, image2);

warpedI = warpH(image1, M, [size(image2, 1), size(image2, 2)], NaN);
commonRegion = ~isnan(warpedI);
warpedI(~commonRegion) = 0;
mask = abs(image2-warpedI).*commonRegion;

thresholded = graythresh(mask);
mask = im2bw(mask, thresholded);   %black and white conversion
mask = medfilt2(mask);             
end


