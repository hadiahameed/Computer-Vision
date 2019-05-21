function output = myKmeans(img, k, thresh)
%      output = myKmeans(img,k) 
%          INPUT:
%          ---------------------------------------------------
%          img      =  Input image
%          k        =  number of clusters
%          thresh   = threshold for convergence (default = 1e-3)
%          
%          OUTPUT:
%          ----------------------------------------------------
%          output   = segmented image
%          
%          DESCRIPTION:
%          ----------------------------------------------------
%          

if nargin == 2   % if thresh is not provided
  thresh = 1e-3;
end

%% Linearizing matrix
[m,n] = size(img(:,:,1));
im = reshape(img,m*n,3); %linearize matrix for each channel
m = size(im,1);
%% Initializing clusters
indices = randperm(m,k);%randomly generate indices of initial clusters
initial_centroids = im(indices,:);
dist = zeros(m,k+1);
mu = 1000;
%% k-means Clustering
while (mu > thresh)
    for i = 1 : m
            for j = 1:k
                dist(i,j) = myNorm(im(i,:),initial_centroids(j,:));
            end
            %find cluster for which distance of that point from the cluster
            %center is minimum
            [~,clst] = min(dist(i,1:k));
            %assign that cluster to the particular point for which the
            %distance is minimum
            dist(i,end) = clst;
    end
    for i = 1: k
        %points belonging to ith cluster
        clusters = (dist(:,end)==i);
        %new cluster centroids
        new_centroids(i,:) = mean(im(clusters,:)); 
        centroid_dist(i) = myNorm(initial_centroids(i,:),new_centroids(i,:));
    end
    initial_centroids = new_centroids;
    mu = centroid_dist*centroid_dist';
    
end
new_img = zeros(m,3);
for i = 1:k    
    idx = find(dist(:,k+1) == i);
    new_img(idx,:) = repmat(initial_centroids(i,:),size(idx,1),1);
end

output = reshape(new_img,size(img,1),size(img,2),3);
end

