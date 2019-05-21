function [ o ] = myImageDilation(I,filt)
%    o   = myImageDilation(I,filt)
%          INPUT:
%          ---------------------------------------------------
%          I     =  Input image
%          filt  =  filter for image dilation
%          
%          OUTPUT:
%          ----------------------------------------------------
%          o     = Dilated image
%          
%          DESCRIPTION:
%          ----------------------------------------------------
%          "Dilation is an operation that grows or thickens objects 
%          in a binary image. The specific manner and the extent of 
%          this thickening is controlled by a shape referred to as a 
%          structuring element (filt). Dilation is a process that  
%          translates the origin of the struc- turing element throughout 
%          the domain of the image and checks to see whether it overlaps 
%          with 1-valued pixels. The output image is 1 at each location 
%          of the origin of the structuring element if the structuring 
%          element overlaps at least one 1-valued pixel in the input 
%          image." - Morphological Image Processing by Ranga Rodrigo
%          http://www.ent.mrt.ac.lk/~ranga/courses/en4551_2010/L03_Article.pdf
%
[p,q]=size(filt);
[m,n]=size(I);
kk =  zeros(m+2,n+2);
kk(2:end-1,2:end-1) = I;
I = kk;

temp= zeros(m,n);
for i=1:m
    for j=1:n  
        subset_g = I(j:j+p-1,i:i+q-1).*filt;       
        for k=1:p
            for l=1:q
                if(filt(k,l)==1&&subset_g(k,l)>0)
                    temp(j,i)=max(max(subset_g));
                end
            end
        end
        
        
    end
end
o = temp;
end

