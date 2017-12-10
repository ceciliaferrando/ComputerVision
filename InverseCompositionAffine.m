function M = InverseCompositionAffine(It, It1)

% input - image at time t, image at t+1
% output - M affine transformation matrix
It = im2double(It);
It1 = im2double(It1);

% Initialization
tolerance = 0.1;
p = zeros(6, 1);
dP = ones(size(p));

% Template and meshgrid
[X,Y] = meshgrid(1:size(It,2), 1:size(It,1));
points = [X(:), Y(:)];
points = (cart2hom(points));
points = points';

% Gradient deltaT
[dx_It1,dy_It1] = gradient(It1);

M = [1+p(1),p(2),p(3);
     p(4),1+p(5),p(6);
     0,    0,     1   ];

size(points)
warp0 = M*points;
I = interp2(X, Y, It1, warp0(1, :)', warp0(2, :)');
I = reshape(I,size(It1));
commonRegion = ~isnan(I); 
I(~commonRegion)=0;

%warp gradients for Jacobian
Ix = interp2(X, Y, dx_It1, warp0(1, :)', warp0(2, :)');
Iy = interp2(X, Y, dy_It1, warp0(1, :)', warp0(2, :)');
   
% fixing nan
Ix(~commonRegion) = 0;
Iy(~commonRegion) = 0;

% steepest descent (Jacobian)
SD = [X(:).*Ix(:),Y(:).*Ix(:),Ix(:),X(:).*Iy(:),Y(:).*Iy(:),Iy(:)];
    
% hessian
Hessian = SD'*SD;

warpP = warp0;
i=0;

while norm(dP)>=tolerance
    %warpI
    i = i+1
    warpP = M*points;
    Iloop = interp2(It1, warpP(1,:)', warpP(2,:)');
    Iloop = reshape(Iloop, size(It));
    commonRegion = ~isnan(Iloop);    
    % fixing nan
    Iloop(isnan(Iloop)) = 0;

    error = Iloop-It;
    error = error(:);

    b = SD'*error;
    dp = Hessian\b;
    
    dM = [   1+dp(1),    dp(2),   dp(3);
             dp(4),      1+dp(5), dp(6);
             0,         0,      1    ];
    M = M * inv(dM);
    
    if i>100
        break
    end
    
end
M = M * inv(dM);

end