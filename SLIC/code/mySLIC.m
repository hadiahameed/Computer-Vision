function [image,clustered_points] = mySLIC(image, S, thresh)
% [image,clustered_points] = mySLIC(image, thresh)
%          INPUT:
%          ---------------------------------------------------
%          image      =  Original RGB image
%          S          =  width and height of each superpixel
%          thresh     =  change in the centroid location
%
%          OUTPUT:
%          ----------------------------------------------------
%          image   = SLIC output image with each super-pixel represented by
%                    mean RGB value
%          clustered_points = cluster assignments of each pixel in the
%                             original image
%
%          DESCRIPTION:
%          ----------------------------------------------------
%          SLIC Algorithm
%

if nargin == 2  % if thresh is not provided
    thresh = 1e-2;
end
%% Pre-processing and intitializations
%separating three channels
m = size(image,1);n = size(image,2);
R = image(:,:,1);G = image(:,:,2);B = image(:,:,3);

%linearize 500x750 channels into 375000x1 channels
R_subset = R';R_subset = R_subset(:);
G_subset = G';G_subset = G_subset(:);
B_subset = B';B_subset = B_subset(:);

N = m*n;   %total number of pixels
K = N/S^2; %number of superpixels

centroid = {K,5}; %initial cluster centers
cent_idx = 1;

%% Initializing cluster centers
%Initialize cluster centers Ck by sampling pixels at regular grid steps S
%e.g. m/S = 500/50 = 10 superpixels along the rows
%e.g. n/S = 750/50 = 15 superpixels along the columns
for i = 1:floor(m/S)
    for j = 1:floor(n/S)
        %e.g for first super-pixel, i = 1,j = 1, centroid position is
        %[25,25]. For second superpixel, i = 1, j = 2, centroid position is
        %[25,75] and so on.
        x = ((i-1)*S + floor(S/2)); 
        y = ((j-1)*S + floor(S/2));
        
        %subindex to linear index. 
        %e.g [25,25] becomes (750*25 - (750-25)) = 18025
        mid = (n*x)-(n-y);
        
        centroid{cent_idx,1} = R_subset(mid);
        centroid{cent_idx,2} = G_subset(mid);
        centroid{cent_idx,3} = B_subset(mid);
        
        %coordinates are divided by 2 so they don't outweigh the intensity
        %values in the Euclidean distance calculation
        centroid{cent_idx,4} = 0.5*x; 
        centroid{cent_idx,5} = 0.5*y;
        cent_idx = cent_idx + 1;
        
    end
end

%% Move cluster centers to the lowest gradient position in a 3 x 3 neighborhood.
cent_idx = 1;

%Representing the pixels in the image as 5D features. 5D features include:
% R-channel, G-channel, B-channel intensities, x, y coordinates
image_5D = mySLICfeatures(R,G,B);

%Initializing distances to infinity
dist = Inf.*(ones(size(image_5D,1),1));

%e.g. m/S = 500/50 = 10 superpixels along the rows
%e.g. n/S = 750/50 = 15 superpixels along the columns
for i = 1:floor(m/S)
    for j = 1:floor(n/S)
        
        %getting each SxS super-pixel
        %e.g. for first super-pixel j = 1 --> 1+S*(j-1):j*S = 1:50
        %e.g. for second super-pixel j = 2 --> 1+S*(j-1):j*S = 51:100
        R_channel = R(1+S*(i-1):i*S,1+S*(j-1):j*S);
        G_channel = G(1+S*(i-1):i*S,1+S*(j-1):j*S);
        B_channel = B(1+S*(i-1):i*S,1+S*(j-1):j*S);
        
        % 5x5 padded window for 3x3 neighborhood of the center of each superpixel 
        R_wndw = R_channel(floor(S/2)-2:floor(S/2)+2,floor(S/2)-2:floor(S/2)+2);
        G_wndw = G_channel(floor(S/2)-2:floor(S/2)+2,floor(S/2)-2:floor(S/2)+2);
        B_wndw = B_channel(floor(S/2)-2:floor(S/2)+2,floor(S/2)-2:floor(S/2)+2);
        
        %gradient of the 3x3 neighborhood
        R_prime = myDerivative(R_wndw);
        G_prime = myDerivative(G_wndw);
        B_prime = myDerivative(B_wndw);
        
        %combining the gradient magnitudes of the three channels
        RGB_prime = sqrt(R_prime.^2+G_prime.^2+B_prime.^2);
        
        %moving the centroid towards the minimum gradient
        minimum = min(min(RGB_prime));
        [min_x,min_y]=find(RGB_prime==minimum);
        
        %e.g. if for first superpixel with i = 1
        %for min_y = 24, min_y = 26
        % x = 0 + 25 - ((3 - 1) - 24) = 47
        % y = 0 + 25 - ((3 - 1) - 26) = 49
       
        x= (i-1)*50 + floor(S/2)-((3-1)-min_x(1));
        y= (j-1)*50 + floor(S/2)-((3-1)-min_y(1));
        
        %subindex to linear index
        %e.g. ind = 750*47 - (750-49) = 34549
        ind = (x*n)-(n-y);
        
        %5D features of each centroid
        centroid{cent_idx,1} = R_subset(ind);
        centroid{cent_idx,2} = G_subset(ind);
        centroid{cent_idx,3} = B_subset(ind);
        centroid{cent_idx,4} = 0.5*x;
        centroid{cent_idx,5} = 0.5*y;     
        cent_idx = cent_idx + 1;
    end
end


%%
clustered_points = mySLICsegmentation(image,image_5D,dist, centroid, S, thresh);

end

