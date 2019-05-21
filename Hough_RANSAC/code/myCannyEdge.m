function edges = myCannyEdge(img,high_threshold,low_threshold)
%  edges = myCannyEdge(img,high_threshold,low_threshold)
%          INPUT:
%          ---------------------------------------------------
%          img    =  input image
%          high_threshold =  High threshold factor for Hysteresis thresholding
%          low_threshold  =  Low threshold factor for Hysteresis thresholding
%          
%          OUTPUT:
%          ----------------------------------------------------
%          edges = Binary image with edges marked
%          
%          DESCRIPTION:
%          ----------------------------------------------------
%          Canny Edge Detection with non-maxima suppression and 
%          Hysteresis Thresholding.
%

g = myFilter('gaussian',5,1);
im_g = myConv(img,g);

sobel = myFilter('sobel');%3x3 sobel filter
sobel_fx = sobel.x;
sobel_fy = sobel.y;

Ix = myConv(im_g,sobel_fx);%gradient of image in x-direction
Iy = myConv(im_g,sobel_fy);%gradient of image in y-direction

mag = sqrt(Ix.^2 + Iy.^2);%gradient magnitude
phase = atan2(Iy,Ix)*(180/pi);%angle in degrees

gradient_rows = size(phase,1);
gradient_cols = size(phase,2);

%% Angle Discretization
%Changing angles in clockwise direction (negative) to angles in anti-clockwise
%direction (positive)
%Discretizing angles to 0, 45, 90, 135
discrete_phase = zeros(gradient_rows,gradient_cols);
for i=1:gradient_rows
    for j=1:gradient_cols
        if (phase(i,j)<0)
            phase(i,j) = 360+phase(i,j);            
        end
        if ((phase(i, j) >= 0 ) && (phase(i, j) < 22.5) || (phase(i, j) >= 157.5) && (phase(i, j) < 202.5) || (phase(i, j) >= 337.5) && (phase(i, j) <= 360))
            discrete_phase(i, j) = 0;
        elseif ((phase(i, j) >= 22.5) && (phase(i, j) < 67.5) || (phase(i, j) >= 202.5) && (phase(i, j) < 247.5))
            discrete_phase(i, j) = 45;
        elseif ((phase(i, j) >= 67.5 && phase(i, j) < 112.5) || (phase(i, j) >= 247.5 && phase(i, j) < 292.5))
            discrete_phase(i, j) = 90;
        elseif ((phase(i, j) >= 112.5 && phase(i, j) < 157.5) || (phase(i, j) >= 292.5 && phase(i, j) < 337.5))
            discrete_phase(i, j) = 135;
        end
    end
end

%% Non-maxima suppression
edge_pixels = zeros(gradient_rows,gradient_cols);
for i = 2:gradient_rows-1
    for j = 2:gradient_cols-1
        switch discrete_phase(i,j)
            case 0
                edge_pixels(i,j) = (mag(i,j) == max([mag(i,j), mag(i,j+1), mag(i,j-1)]));
            
            case 45
                edge_pixels(i,j) = (mag(i,j) == max([mag(i,j), mag(i+1,j-1), mag(i-1,j+1)]));
            case 90
                edge_pixels(i,j) = (mag(i,j) == max([mag(i,j), mag(i+1,j), mag(i-1,j)]));
            case 135
                edge_pixels(i,j) = (mag(i,j) == max([mag(i,j), mag(i+1,j+1), mag(i-1,j-1)]));
        end
        edge_pixels(i,j) = edge_pixels(i,j)*mag(i,j);
    end
end
     
%% Hysteresis Thresholding

high_threshold = high_threshold*(max(max(edge_pixels)));
low_threshold = low_threshold*(max(max(edge_pixels)));

edges = zeros(gradient_rows,gradient_cols);

for i = 1:gradient_rows
    for j = 1:gradient_cols
        if(edge_pixels(i,j) < low_threshold)
            edges(i,j) = 0; %suppress weak edge pixels
        elseif(edge_pixels(i,j) > high_threshold)
            edges(i,j) = 1;
         elseif ( edge_pixels(i+1,j)>high_threshold || edge_pixels(i-1,j)>high_threshold || edge_pixels(i,j+1)>high_threshold || edge_pixels(i,j-1)>high_threshold || edge_pixels(i-1, j-1)>high_threshold || edge_pixels(i-1, j+1)>high_threshold || edge_pixels(i+1, j+1)>high_threshold || edge_pixels(i+1, j-1)>high_threshold) 
            edges(i,j) = 1;
        end       
    end
end






