function myHoughLines(img, x,theta, rho, peaks) 
    figure
    imshow(img);
    hold on;
    %x = 1:1:size(img,1);


    for i = 1:size(peaks,1)
        th = theta(peaks(i,2)).*pi/180;
        rh = rho(peaks(i,1));
        m = -(cos(th)/sin(th));
        b = rh/sin(th);
        xx = x{i};
        plot(xx, m*xx+b,'LineWidth',2);
        hold on;
    end
    legend('Line 1','Line 2', 'Line3', 'Line4')

end

