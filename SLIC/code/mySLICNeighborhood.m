function pixels_NB_5D = mySLICNeighborhood(R,G,B, centroid_x,centroid_y, S)
% pixels_NB_5D = mySLICNeighborhood(R,G,B, centroid_x,centroid_y, S)
%          INPUT:
%          ---------------------------------------------------
%          R      =  R channel of the super-pixel
%          G      =  G channel of the super-pixel
%          B      =  B channel of the super-pixel
%          centroid_x = x-location of the centroid
%          centroid_y = y-location of the centroid
%          S          =  height or width of each super-pixel
%
%          OUTPUT:
%          ----------------------------------------------------
%          pixels_NB_5D   = 5D features of every pixel in the 2Sx2S
%                           neighborhood of the super-pixel
%
%          DESCRIPTION:
%          ----------------------------------------------------
%          Getting 2Sx2S neighborhood around a super-pixel
%


    [m,n] = size(R);
    mid = floor(S/2); %e.g. for S = 50, mid = 25
    
    row_start = centroid_x - (mid + mid);
    row_end = centroid_x + ((mid-1) + mid);
    if (row_start < 1)
        row_start = 1;
        row_end = 2*S;
    end
    if (row_end > m)
        row_end = m;
        row_start = centroid_x - mid - S;
    end
    p = row_end - row_start + 1;
    col_start = centroid_y - (mid + mid);
    col_end = centroid_y + ((mid-1) + mid);
    if (col_start < 1)
        col_start = 1;
        col_end = 2*S;
    end
    if (col_end > n)
        col_end = n;
        col_start = centroid_y - mid - S;
    end
    q = col_end - col_start + 1;
    pixels_NB_5D = zeros(p*q,5);
    feature_ind = 1;
    x = row_start;y=col_start;
    while x <= row_end
        while y <= col_end
            R_NB = R(x,y);
            G_NB = G(x,y);
            B_NB = B(x,y);
            
            pixels_NB_5D(feature_ind,1) = R_NB;
            pixels_NB_5D(feature_ind,2) = G_NB;
            pixels_NB_5D(feature_ind,3) = B_NB;
            pixels_NB_5D(feature_ind,4) = 0.5*x;
            pixels_NB_5D(feature_ind,5) = 0.5*y; 
            feature_ind = feature_ind + 1;
            
            y = y + 1;
        end
        y = col_start;
        x = x + 1;
    end
    
    

end

