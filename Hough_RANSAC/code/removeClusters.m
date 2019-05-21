function [ new_data] = removeClusters(x,y,thresh)
%  new_data = removeClusters(x,y,thresh)
%          INPUT:
%          ---------------------------------------------------
%          x      =  x-coordinates of corner points
%          y      =  y-coordinates of corner points
%          thresh =  corner points less than 'thresh' number
%                    of pixels apart are removed
%
%          OUTPUT:
%          ----------------------------------------------------
%          new_data = new set of corner points 
%          
%          DESCRIPTION:
%          ----------------------------------------------------
%          Removes corner points around non-linear objects like
%          cars and trees to avoid having false positive lines later
%          on during RANSAC
%
    data = [x,y];
    distances = pdist(data);
    
    
    H = zeros(length(x),length(x));
    c = 1;
    for i = 1:length(x)
        for j = 1:length(x)-i
           H(i,i+j) = distances(c);
           c = c + 1;
        end
    end
    [row,col] = find(H>0 & H<thresh);
    k = [row,col];
    C = unique(k(:,2));
    new_data = data(setdiff(1:end,C),:);   
end


