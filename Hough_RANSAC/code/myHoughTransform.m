function [H,theta, rho,X] = myHoughTransform(img,resoultion)
%  edges = myHoughTransform(img)
%          INPUT:
%          ---------------------------------------------------
%          img    =  input image
%          resolution = resolution for discretizing theta and
%                       rho
%
%          OUTPUT:
%          ----------------------------------------------------
%          H = Hough transform matrix
%          theta = discretized theta
%          rho = discretized rho
%          X = x-coordinates of points that voted for the peaks
%          
%          
%          DESCRIPTION:
%          ----------------------------------------------------
%          Hough Transform method for multiple model fitting
%
    [M,N] = size(img);
    theta = -90:resoultion:89;
    rho_max = floor(norm([M-1,N-1]));
    rho = -(rho_max+1):resoultion:(rho_max+1);
    nrho = length(rho); ntheta = length(theta);
    H = zeros(nrho,ntheta);
    X = zeros(nrho,ntheta,N);
    for y = 1 : M
        for x = 1 : N
            if img(y,x) == 1
                for j = 1:ntheta
                    th = theta(j).*pi/180;
                    r = x * cos(th) + y * sin (th);
                    i = floor(r + (nrho-1)/2);
                    H(i,j) = H(i,j) + 1;
                    X(i,j,x) = 1; 
                end
            end
        end
    end
end