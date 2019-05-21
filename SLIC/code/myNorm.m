function distance = myNorm(x,y)
%      distance = myNorm(x,y)
%          INPUT:
%          ---------------------------------------------------
%          x      =  n-dimenional vector 1
%          y      =  n-dimensional vector 2
%          
%          OUTPUT:
%          ----------------------------------------------------
%          output   = Euclidean distance between x and y
%          
%          DESCRIPTION:
%          ----------------------------------------------------
%          Calculates Euclidean distance between two vectors

sum = 0;
n = size(x,2); %n-dimensions of vector x. In case of RGB image, n = 3
for i=1:n
    sum = sum + (x(i)-y(i)).^2;
end

distance = sqrt(sum);

end

