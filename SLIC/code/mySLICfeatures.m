function image_5D_features = mySLICfeatures(R_channel,G_channel,B_channel)
% image_5D_features = mySLICfeatures(R_channel,G_channel,B_channel)
%          INPUT:
%          ---------------------------------------------------
%          R_channel  =  R channel of the image
%          G_channel  =  G channel of the image
%          B_channel  =  B channel of the image

%          OUTPUT:
%          ----------------------------------------------------
%          image_5D_features   = 5D features of the input pixels
%
%          DESCRIPTION:
%          ----------------------------------------------------
%          Extract 5 features for each pixel i.e. 
%          1) R intensity value, 
%          2) G intensity value,
%          3) B intensity value,
%          4) x-coordinate
%          5) y-coordinate
%      
%          The last column stores the initial cluster assignments for each
%          pixel which is = -1.
%

[m,n] = size(R_channel);
image_5D_features = zeros(m*n,5);
feature_ind = 1;
for ii = 1:m
    for jj = 1:n
        image_5D_features(feature_ind,1) = R_channel(ii,jj);
        image_5D_features(feature_ind,2) = G_channel(ii,jj);
        image_5D_features(feature_ind,3) = B_channel(ii,jj);
                
        image_5D_features(feature_ind,4) = 0.5*ii;
        image_5D_features(feature_ind,5) = 0.5*jj;
                       
        %initializing cluster label for each pixel as -1
        image_5D_features(feature_ind,6) = -1;
        feature_ind = feature_ind + 1;
    end
end
end

