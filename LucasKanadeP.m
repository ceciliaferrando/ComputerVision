function [dp_x,dp_y] = LucasKanadeP(It, It1, rect, p)

% input - image at time t, image at t+1, rectangle (top left, bot right coordinates)
% output - movement vector, [dp_x, dp_y] in the x- and y-directions.

%initializing 
epsilon = 0.1;
dP = 2*[epsilon epsilon]';
It = double(It);
It1 = double(It1);

%constructing template grid
[Tx, Ty] = meshgrid(rect(1):rect(3),rect(2):rect(4));
T = interp2(It, Tx, Ty);
[dTx,dTy] = gradient(T);

%Jacobian matrix
DeltaWarp = double([dTx(:) dTy(:)]);
%Hessian
Hessian = DeltaWarp' * DeltaWarp;

% from Matlab tutorial
Ix_m = conv2(It,[1 2 1; 0 0 0; -1 -2 -1], 'valid'); % gradient in the x direction
Iy_m = conv2(It, [-1 0 1; -2 0 2; -1 0 1], 'valid'); % gradient in the x direction
It_m = conv2(It, ones(3), 'valid') + conv2(It1, -ones(3), 'valid'); % partial der on t

threshold = 0.01;
stop = false;

while stop == false

    % sliding the window
    x = (rect(1):rect(3))+p(1);
    y = (rect(2):rect(4))+p(2);
    
    [X, Y] = meshgrid(x,y);
    
    warpI = interp2(It1, X, Y);   %warping the image
   
    e = warpI-T;
    e = e(:);

    dP = Hessian \ (DeltaWarp'*e);

    %updates
    p = p - dP;
    
    if norm(dP) <= threshold
        stop = true;
    end
dp_x = p(1);
dp_y = p(2);
end
