function [ inliers,b] = RANSAC(x,y,d,thresh)
%[inliers,b] = RANSAC(x,y,d,thresh)
%          INPUT:
%          ---------------------------------------------------
%          x      =  x-coordinates of points
%          y      =  y-coordinates of points
%          d      =  minimum no. of points that need to be  
%                    inliers for a particular model to be selected.
%          thresh =  minimum distance of a point from the line for 
%                    it to be considered as an inlier. 
%          
%          OUTPUT:
%          ----------------------------------------------------
%          inliers = Points satisfying the final model
%          b       = selected parameter configuration 
%                    i.e. slope and intercept.
%          
%          DESCRIPTION:
%          ----------------------------------------------------
%          RANSAC Algorithm for line-fitting
%

if(size(x,2)<size(x,1))
    x = x';
end
if(size(y,2)<size(y,1))
    y = y';
end

no_of_inliers = 0;
N = 0;%Maximum number of iterations 
neighborhood_threshold = 150;%only points close to initial points are selected as inliers.
while(no_of_inliers < d && N < 1000)
    
    %% Step I: randomly choose 2 samples from the data
    N = N + 1;
    
    samples = randi([1,length(x)],[1,2]);
    xx = x(samples);
    yy = y(samples);
    
    %% Step II: Fit a line
    [~,b] = myLinearRegression(xx,yy);
    %% Step III: Calculate closeness othe the rest of the
    %points from the line
    
    inliers = zeros(length(x),1);
    i = 1;
    while( i <= length(x))
        %all points except the ones used for tuning
        if(i~=samples(1,1) && i~=samples(1,2))
            y_pred = [x(1,i) 1]*b;
            delta = abs(y_pred-y(1,i));
            delta1 = pdist([x(1,i),y(1,i);xx(1),yy(1)]);
            delta2 = pdist([x(1,i),y(1,i);xx(2),yy(2)]);
            
            if (delta < thresh && (delta1 && neighborhood_threshold && delta2 < neighborhood_threshold) )
                inliers(i,1) = 1;%index of datapoint
                no_of_inliers = length(inliers(inliers>0));
                
                %%In order to visually see RANSAC being
                %%performed on the corner points uncomment the following
%                 if(no_of_inliers >= d)
%                      plottingRANSACtrials(x,y,xx,yy,inliers,b);                
%                 end
                
            end
        end
        i = i + 1;
    end
    inliers(samples,1) = 1;
end
end

