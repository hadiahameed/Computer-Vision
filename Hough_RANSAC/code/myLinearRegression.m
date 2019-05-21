function [ X,B ] = myLinearRegression(x,y)
%[ X,B ] = myLinearRegression(x,y)
%          INPUT:
%          ---------------------------------------------------
%          x =  x-coordinates of points
%          y =  y-coordinates of points
%
%          OUTPUT:
%          ----------------------------------------------------
%          X = [x1 1
%               x2 1
%               ...
%               xn 1]
%          B = selected parameter configuration
%                    i.e. slope and intercept.
%
%          DESCRIPTION:
%          ----------------------------------------------------
%          Linear Regression for line-fitting
%
w = warning ('off','all');
warning(w)

if(size(x,2)>size(x,1))
    x = x';
end
if(size(y,2)>size(y,1))
    y = y';
end

X = [x ones(length(x),1)];

B = X\y; %using pseudo inverse
end

