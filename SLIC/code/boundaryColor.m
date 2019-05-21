function SLIC_image = boundaryColor(SLIC_image, clustered_points)
% SLIC_image = boundaryColor(SLIC_image, clustered_points)
%          INPUT:
%          ---------------------------------------------------
%          SLIC_image        =  Output image from SLIC algorithm
%          clustered_points  =  cluster assignments for each pixel
%
%          OUTPUT:
%          ----------------------------------------------------
%          SLIC_image   = the 
%
%          DESCRIPTION:
%          ----------------------------------------------------
%          Color pixels that touch two different super_pixels black
%

m = size(SLIC_image,1);n = size(SLIC_image,2);

for i = 1:m
    neighbor_up = i - 1;
    neighbor_down = i + 1;
    if i == 1
        neighbor_up = 1;
    elseif i == m
        neighbor_down = m;
    end
    for j = 1:n
        
        neighbor_left = j - 1;
        neighbor_right = j + 1;
        if j == 1
            neighbor_left = 1;
        elseif j == n
            neighbor_right = n;
        end
        linear_index = n*i - (n - j);
        linear_index_left = n*i - (n - neighbor_left);
        linear_index_right = n*i - (n - neighbor_right);
        linear_index_up = n*neighbor_up - (n - j);
        linear_index_down = n*neighbor_down - (n - j);
        
        clstr_val_current = clustered_points(linear_index,end);
        clstr_val_left = clustered_points(linear_index_left,end);
        clstr_val_right = clustered_points(linear_index_right,end);
        clstr_val_up = clustered_points(linear_index_up,end);
        clstr_val_down = clustered_points(linear_index_down,end);
        
        mean_RGB = mean(clustered_points(clustered_points(:,end) == clstr_val_current,1:3));
        if (clstr_val_current~=clstr_val_left||clstr_val_current~=clstr_val_right||clstr_val_current~=clstr_val_up||clstr_val_current~=clstr_val_down)
            SLIC_image(i,j,:) = 0;
        else
            SLIC_image(i,j,:) = mean_RGB;
        end         
    end
end
end

