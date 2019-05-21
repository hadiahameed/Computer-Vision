function [rows,cols,s] = myHarrisDetector(Ix,Iy,thresh)
%[rows,cols,output]   = myHarrisDetector(Ix,Iy,thresh) 
%          INPUT:
%          ---------------------------------------------------
%          Ix     =  derivative of input image in x-direction
%          Iy     =  derivative of input image in y-direction
%          thresh =  threshold for corner response R
%          
%          OUTPUT:
%          ----------------------------------------------------
%          [rows,cols] = x,y coordinates of corner points in image
%          output      = containing the corner response values after
%                        non-maxima suppression
%          
%          DESCRIPTION:
%          ----------------------------------------------------
%          myHarrisDetector() gives the x,y coordinates of important
%          keypoints in the image such as corners. The corner response
%          value R is < 0 for edges, small for flat regions and high
%          for corner points. So those image points are selected for 
%          which R > thresh. 
% 

g = myFilter('gaussian',3,1);
Ixx = myConv(Ix.^2,g); 
Iyy = myConv(Iy.^2,g);
Ixy = myConv(Ix.*Iy,g);

im1 = zeros(size(Ixx,1), size(Ixx,2)); %to contain points for which R>thresh
for x=1:size(Ixx,1)
   for y=1:size(Ixx,2)
       % 1) Define at each pixel(x, y) the matrix H
       H = [Ixx(x, y) Ixy(x, y); Ixy(x, y) Iyy(x, y)];
       
       % 2) Compute the response of the detector at each pixel
       R = det(H);
       
       % 3) Threshold on value of R
       if (R > thresh)
          im1(x, y) = R; 
       end
   end
end
%3x3 neighborhood
filt = ones(3);
filt(2,2) = 0;
s = size(im1);
%non-maxima suppression
output = im1 > myImageDilation(im1,filt);

[rows,cols] = find(output);
end

