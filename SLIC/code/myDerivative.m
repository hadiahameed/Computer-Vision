function im_prime = myDerivative(img)
back_diff = myFilter('gradient');%3x3 sobel filter
back_diff_x = back_diff.x;
back_diff_y = back_diff.y;

Ix = myConv(img,back_diff_x);%gradient of image in x-direction
Iy = myConv(img,back_diff_y);%gradient of image in y-direction
im_prime = sqrt(Ix.^2 + Iy.^2);%gradient magnitude

end

