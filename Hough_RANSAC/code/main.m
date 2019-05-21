clc
clear
close all
%% Load Image
filename='road.png';
I = imread(filename);
im = im2double(I);
%% Gaussian Smoothing
g = myFilter('gaussian',3,1);
im_g = myConv(im,g); %smoothed image
% figure; imshowpair(im,im_g,'montage');
% title('Smoothed image using Gaussian Filtering')
%% Derivative using Sobel filter
sobel = myFilter('sobel');%3x3 sobel filter
sobel_fx = sobel.x;
sobel_fy = sobel.y;

Ix = myConv(im_g,sobel_fx);%gradient of image in x-direction
Iy = myConv(im_g,sobel_fy);%gradient of image in y-direction
% figure;
% subplot(1,2,1)
% imshow(Ix)
% title('Sobel Filtering giving Ix')
% subplot(1,2,2)
% imshow(Iy)
% title('Sobel Filtering giving Iy')

%% Harris Corner Detection
harris_threshold = 0.005;
[rows,cols,s] = myHarrisDetector(Ix,Iy,harris_threshold);
new_img = imresize(im_g, s);

figure
subplot(1,2,1)
imshow(0.*new_img)
hold on
plot(cols,rows,'w.','MarkerSize',2);
title(['Technique 1: Hessian Threshold = ',num2str(harris_threshold)])

%Removing dense clusters in the corners
cluster_threshold = 10; %all points less than 10 units apart are removed
new_data = removeClusters(cols,rows,cluster_threshold);
cols2 = new_data(:,1);
rows2 = new_data(:,2);

subplot(1,2,2)
imshow(new_img); axis image; colormap(gray); hold on; plot(cols2,rows2,'c.','MarkerSize',2)
title(['Technique 2: Cluster theshold = ',num2str(cluster_threshold)])

rng('default');
rng(9);
%% RANSAC for line fitting using corners obtained from Techique 1
figure
subplot(1,2,1)
imshow(new_img)
hold on
plot(cols,rows,'c.','MarkerSize',2);
title('RANSAC using Technique 1 corners')

%d_factor = % d_factor*NumberOfDataPoints
%minimum no. of points that need to be  
%inliers for a particular model to be selected.     
d_factor = 0.1; 
% 
%thresh = minimum distance of a point from the 
%line for it to be considered as an inlier.
thresh = 8; 
for k = 1:4
    if (k == 1)
        data_x = cols;
        data_y = rows;
    else
        data_x = data_x(setdiff(1:end,find(inliers>0)),:);
        data_y = data_y(setdiff(1:end,find(inliers>0)),:);
    end
    [inliers,b] = RANSAC(data_x,data_y,ceil(d_factor*length(data_x)),thresh);
    new_cols = data_x(inliers>0);
    new_rows = data_y(inliers>0);
    XX = [new_cols ones(length(new_cols),1)];
    YY = new_rows;
    [sortedX, sortIndex] = sort(XX(:,1));
    sortedY = YY(sortIndex);
    extrema1_x = sortedX(1);extrema2_x=sortedX(end);
    extrema1_y = sortedY(1);extrema2_y=sortedY(end);
    
    plot([extrema1_x;extrema2_x],[extrema1_y;extrema2_y],'r','LineWidth',1.5)
    plot([extrema1_x;extrema2_x],[extrema1_y;extrema2_y],'gx','MarkerSize',10)
    plot(new_cols,new_rows,'rs')
end
legend('Corner points','Lines','Extreme points','Inliers','Location','southeast')

%% RANSAC for line fitting using corners obtained from Techique 2
subplot(1,2,2)
imshow(new_img)
hold on
plot(cols2,rows2,'c.','MarkerSize',2);
title('RANSAC using Technique 2 corners')

%d_factor = % d_factor*NumberOfDataPoints
%minimum no. of points that need to be  
%inliers for a particular model to be selected.     
d_factor = 0.1; 

%thresh = minimum distance of a point from the 
%line for it to be considered as an inlier.
thresh = 8;
for k = 1:4
    if (k == 1)
        data_x = cols2;
        data_y = rows2;
    else
        data_x = data_x(setdiff(1:end,find(inliers>0)),:);
        data_y = data_y(setdiff(1:end,find(inliers>0)),:);
    end
    [inliers,b] = RANSAC(data_x,data_y,ceil(d_factor*length(data_x)),thresh);
    new_cols = data_x(inliers>0);
    new_rows = data_y(inliers>0);
    XX = [new_cols ones(length(new_cols),1)];
    YY = new_rows;
    [sortedX, sortIndex] = sort(XX(:,1));
    sortedY = YY(sortIndex);
    extrema1_x = sortedX(1);extrema2_x=sortedX(end);
    extrema1_y = sortedY(1);extrema2_y=sortedY(end);
    
    plot([extrema1_x;extrema2_x],[extrema1_y;extrema2_y],'r','LineWidth',1.5)
    plot([extrema1_x;extrema2_x],[extrema1_y;extrema2_y],'gx','MarkerSize',10)
    plot(new_cols,new_rows,'rs')
end
legend('Corner points','Lines','Extreme points','Inliers','Location','southeast')



%% Canny Edge Detection
HighThresh = 0.1;
LowThresh = 0.08;

BW = myCannyEdge(im_g,HighThresh,LowThresh);
%BW1 = edge(im_g,'canny',0.1); %standard edge detection for comparison
% figure
% imshow(BW1)
% title('Using standard MATLAB Canny Edge Detector')
figure
imshow(BW)
title('Implementing Canny Edge Detector from the scratch')
%% Hought Transform
%Standard Hough Transform
figure
[HH,TT,RR] = hough(BW); %standard hough transform for comparison
subplot(1,2,1)
imshow(HH,[],'XData',TT,'YData',RR,...
'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
PP  = houghpeaks(HH,4);
x = TT(PP(:,2)); y = RR(PP(:,1));
plot(x,y,'s','color','white');
title('Using standard function')

%implementing Hough Transform from the scratch
hough_resolution = 1;
[H,T,R,X] = myHoughTransform(BW,hough_resolution);
subplot(1,2,2)
imshow(H,[],'XData',T,'YData',R,...
    'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
P  = myHoughPeaks(H,4);
x = T(P(:,2)); y = R(P(:,1));
x_indices = {4,1};

for k = 1:size(P,1)
    x_points = squeeze(X(P(k,1),P(k,2),:));
    x_indices{k} = find(x_points);
end

plot(x,y,'s','color','white');
title('Implementing Hough transform')


myHoughLines(new_img,x_indices,T,R,P);

%Standard Hough Line plot for comparison
% lines = houghlines(new_img,TT,RR,PP,'FillGap',5,'MinLength',7);
% figure, 
% subplot(1,2,1)
% imshow(BW)
% subplot(1,2,2)
% imshow(new_img), hold on
% max_len = 0;
% for k = 1:length(lines)
%     xy = [lines(k).point1; lines(k).point2];
%     plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
%     
%     % plot beginnings and ends of lines
%     plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%     plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
%     
%     % determine the endpoints of the longest line segment
%     len = norm(lines(k).point1 - lines(k).point2);
%     if ( len > max_len)
%         max_len = len;
%         xy_long = xy;
%     end
% end
