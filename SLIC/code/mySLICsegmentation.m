function image_5D = mySLICsegmentation(image,image_5D,dist,centroid, S, thresh)
% image5D = mySLICsegmentation(image,image_5D,dist,centroid, S, thresh)
%          INPUT:
%          ---------------------------------------------------
%          image      =  Original RGB image
%          image_5D   =  5D features of each pixel in the image
%          dist       =  distance vector initialized to Infinity
%          centroid   =  initial centroids
%          S          =  height or width of each super-pixel
%          thresh     =  change in the centroid location 
%
%          OUTPUT:
%          ----------------------------------------------------
%          image_5D   = 5D features of every pixel along with 
%                       assigned cluster label
%
%          DESCRIPTION:
%          ----------------------------------------------------
%          Modified k-means segmentation for SLIC Algorithm
%

%%
m = size(image,1);n = size(image,2);
R = image(:,:,1);G = image(:,:,2);B = image(:,:,3);

%no. of centroids
k = size(centroid,1);
%mu = L2-norm of the distances between old and new centroids
mu = 1000;
%% k-means Clustering
while (mu > thresh)
    for i = 1:floor(m/S)
        for j = 1:floor(n/S)
            ii = floor(n/S)*i - (floor(n/S)-j);
            %iith centroid
            current_centroid = cell2mat(centroid(ii,:));
            
            %x-location and y-location of super-pixel centroid
            centroid_x = ceil(2*current_centroid(1,4));
            centroid_y = ceil(2*current_centroid(1,5));
            
            %get 2Sx2S neighborhood of each centroid
            pixels_NB = mySLICNeighborhood(R,G,B, centroid_x,centroid_y, S);
            
            rows = size(pixels_NB,1);
            D = zeros(rows,1);
            for iter = 1 : rows
                %D = distance between current centroid and each pixel in its
                %neighborhood
                D(iter,1) = myNorm(pixels_NB(iter,1:5),current_centroid);
                x_loc = floor(2*pixels_NB(iter,4));
                y_loc = floor(2*pixels_NB(iter,5));
                linear_index = n*x_loc - (n - y_loc);
                %if distance is smaller than previously stored distance
                if (D(iter,1) < dist(linear_index))
                    dist(linear_index) = D(iter,1);
                    image_5D(linear_index,end) = ii;
                end
            end           
        end
    end
    
    %calculating change in the position of the centroids
    for i = 1:k       
        new_centroids{i,1} = mean(image_5D(image_5D(:,6) == i,1:5));
        centroid_dist(i) = myNorm(cell2mat(new_centroids(i,:)),cell2mat(centroid(i,:)));
    end
    centroid = new_centroids;
    mu = centroid_dist*centroid_dist';
    
end
end

