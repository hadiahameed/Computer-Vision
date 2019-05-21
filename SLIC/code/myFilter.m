function [ filter ] = myFilter(filter_name,size,sigma)
% filter = myFilter(A) 
%          INPUT:
%          ---------------------------------------------------
%          filter_name = 'gaussian' or 'sobel' or 'gradient'
%          size        =  size of filter (default = 3)
%          sigma       =  standard deviation of gaussian filter 
%                         (default = 1)
%          
%          OUTPUT:
%          ----------------------------------------------------
%          filter      = size x size filter matrix
%          
%          DESCRIPTION:
%          ----------------------------------------------------
%          myFilter() gives a 'gaussian' or 'sobel' or 'gradient'
%          filter as an output as mentioned by the input argument 
%          'filter_name' Default size is 3x3 and default sigma 
%          for gaussian filter is 1.
%          
%           
 

    if ~exist('sigma','var')
      sigma = 1;%in case of sobel filter, sigma won't be needed
    end
    
    if ~exist('size','var')
      size = 3;%default 3x3 filter
    end
    
    if(strcmp(filter_name,'sobel'))
        filter = struct;
        filter.x = [-1,0,1; %gradient filter for x-direction
                    -2,0,2;
                    -1,0,1];
        filter.y = [1,2,1; %gradient filter for x-direction
                    0,0,0;
                    -1,-2,-1];
    end
    
    if(strcmp(filter_name,'gradient')) %center difference
        filter = struct;
        filter.x = [-1,0,1; %gradient filter for x-direction
                    -1,0,1;
                    -1,0,1];
        filter.y = [-1,-1,-1; %gradient filter for x-direction
                    0,0,0;
                    1,1,1];
    end

    if(strcmp(filter_name,'gaussian'))
        m=size; n=size;
        %standard gaussian matrix
        [g1,g2] = meshgrid(-(m-1)/2:(m-1)/2, -(n-1)/2:(n-1)/2);
        g= exp(-(g1.^2+g2.^2)/(2*sigma^2)); %Gaussian function
        filter = g ./sum(g(:));
    end
end

 