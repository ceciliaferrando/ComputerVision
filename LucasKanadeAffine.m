function M = LucasKanadeAffine(It, It1)
% Finds transformation M to warp It to It1

It = im2double(It);
It1 = im2double(It1);

% Initialization
tolerance = 0.1;
p = zeros(6, 1);
dP = 2*ones(size(p));

% Template and meshgrid
[X,Y] = meshgrid(1:size(It,2), 1:size(It,1));
points = [X(:)'; Y(:)'; ones(size(X(:)'))];

% Gradient
[dx_It1,dy_It1] = gradient(It1);


while norm(dP)>=tolerance
    %define transformation matrix
    M = [1+p(1),p(2),p(3);
         p(4),1+p(5),p(6);
         0,    0,     1   ];
    %warp image
    warp = M*points;
    I = interp2(X, Y, It1, warp(1, :)', warp(2, :)');
    I = reshape(I,size(It1));

    commonRegion = ~isnan(I);    
    % fixing nan
    I(isnan(I)) = 0;

    error = It-I;
    error = error(:);
    
    %warp gradients
    Ix = interp2(X, Y, dx_It1, warp(1, :)', warp(2, :)');
    Iy = interp2(X, Y, dy_It1, warp(1, :)', warp(2, :)');
    
    Ix(~commonRegion) = 0;
    Iy(~commonRegion) = 0;
    
    % steepest descent (Jacobian)
    SD = [X(:).*Ix(:),Y(:).*Ix(:),Ix(:),X(:).*Iy(:),Y(:).*Iy(:),Iy(:)];
    
    % hessian
    Hessian = SD'*SD;
    
    % solving the system
    b = SD'*error;
    dP = Hessian\b;

    p = p + dP;

end

end

