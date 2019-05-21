clc
clear
close all

%% Problem1: k-means segmentation
orig_image = imread('white-tower.png');
image = im2double(orig_image);
k = 10;
new_img = myKmeans(image,k,1e-3);
%%
figure()
subplot(121); imshow(orig_image); title('Original Image')
subplot(122); imshow(new_img)
title(['K-means segmentation with k = ',num2str(k)])
%% Problem2: SLIC
orig_image = imread('wt_slic.png');
image = 255.*im2double(orig_image);
S = 50; %width and height of each superpixel
[SLIC_image, clustered_points] = mySLIC(image,S,1e-4);

SLIC_image = boundaryColor(SLIC_image, clustered_points);

figure
imshowpair(orig_image,uint8(SLIC_image),'montage')
title('Modified SLIC Algorithm')
