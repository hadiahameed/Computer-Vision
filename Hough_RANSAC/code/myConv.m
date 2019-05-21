function [ h ] = myConv( g,f )
%      h = myConv(g,f) 
%          INPUT:
%          ---------------------------------------------------
%          g      =  Input image
%          f      =  filter
%          
%          OUTPUT:
%          ----------------------------------------------------
%          h      = g*f (convolution)
%          
%          DESCRIPTION:
%          ----------------------------------------------------
%          myConv() gives a 'valid' result for the convolution
%          of image 'g' and filter 'f'. This means the resulting
%          image is smaller than the input image and zero-padding
%          is not applied. The dimension of the resulting
%          image is max([size(g,1)-max(0,size(f,1)-1),0]).
%     

    f = flip(f,1);f = flip(f,2); %flipping filter matrix
    input_dim = size(g,1);    
    filter_dim = size(f,1);
    if (filter_dim > input_dim) %filter size should not be greater than image size
        disp('ERROR: Please give correct input. Arg 1 = image and arg2 = filter.')
        h = 0;
        return
    end
    %'valid' convolution. No zero-padding. 
    %Output image size is smaller than input image size
    output_dim = max([size(g,1)-max(0,size(f,1)-1),0]);
    
    h = zeros(output_dim, output_dim); %output image
    
    %Convolution Formula: h[m,n] = sum_over_k_l (g[k,l]h[m-k,n-l])
    for i = 1:output_dim
        for j = 1: output_dim
            sm = 0;
            for k = 1:filter_dim
                for l = 1:filter_dim
                    sm = sm + g(k+i-1,l+j-1)*f(k,l);                     
                end
            end
            h(i,j) = sm;
        end
    end
end

