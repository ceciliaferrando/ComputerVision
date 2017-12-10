function [dp_x,dp_y] = LucasKanadeBasis(It, It1, rect, bases)

%initializing 
epsilon = 0.1;
dP = 2*[epsilon epsilon]';
p = [1 1]';
It = double(It);
It1 = double(It1);
weights = zeros(1,size(bases,3));

%constructing T grid
[Tx, Ty] = meshgrid(rect(1):rect(3),rect(2):rect(4));
T = interp2(It, Tx, Ty);
[dt_x, dt_y] = gradient(T);
gradientT = [dt_x(:), dt_y(:)];

%gradient of the basis
B = zeros(size(bases,1)*size(bases,2), size(bases,3));
gradientB = zeros(size(B,1), size(B,2)*2);

for i=1:size(bases,3)
    %extracting the base
    base=double(bases(:,:,i));
    B(:, i) = base(:);
    %gradient computing
    [dB_x, dB_y] = gradient(base);
    gradientB(:, 2*i-1) = dB_x(:);
    gradientB(:, 2*i) = dB_y(:);
end

%initial weights
W = [1 0; 0 1];

stop = false;

while stop == false

    % sliding the window
    x = (rect(1):rect(3))+p(1);
    y = (rect(2):rect(4))+p(2);
    
    [X, Y] = meshgrid(x,y);
    
    warpI = interp2(It1, X, Y);   %warping the image
    
    sumB = 0;
    for i=1:size(bases,3)
        sumB = sumB + weights(i) * B(:,i);
    end
    sumB = reshape(sumB, size(T));
    e = T + sumB - warpI;
    e = e(:);
    
    %steepest descent
    sumGradientsB = 0;
    
    for i=1:size(bases,3)
        XY = [gradientB(:, 2*i-1),gradientB(:, 2*i)];
        sumGradientsB = sumGradientsB + weights(i) * XY;
    end
    sumGradientsB = sumGradientsB + gradientT;
    
    SD = [sumGradientsB * W(:,1), sumGradientsB * W(:,2), B];
    
    Hessian = SD'*SD;
    E = SD'*e;
     
    dT = -Hessian \ E;
    dP = dT(1:2);

    %updates
    p = p - dP;
    
    if norm(dP) <= epsilon
        stop = true;
    end

end

dp_x = p(1);
dp_y = p(2);
    
    

% input - image at time t, image at t+1, rectangle (top left, bot right
% coordinates), bases 
% output - movement vector, [dp_x,dp_y] in the x- and y-directions.
