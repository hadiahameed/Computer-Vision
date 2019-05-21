function [ peaks ] = myHoughPeaks(img,numpeaks)
    terminate = 0;
    thresh = 1;
    [x,y] = size(img);
    wndw = max(2*ceil([x,y]/100) + 1, 1);
    h_prime = img;
    peaks_x = [];
    peaks_y = [];
    while (terminate == 0)
        max_peaks = max(h_prime(:));
        [m,n] = find(h_prime == max_peaks);
        m = m(1);n = n(1);
        peaks_x(end+1) = m; peaks_y(end+1) = n;
        if h_prime(m,n) >= thresh
            m_1 = m - 0.5.*(wndw(1)-1);
            m_2 = m + 0.5*(wndw(1)-1);
            
            n_1 = n - 0.5.*(wndw(2)-1);
            n_2 = n + 0.5.*(wndw(2)-1);
            
            mm = (m_1:1:m_2)'.*ones(1,wndw(2));mm = mm(:);
            nn = ones(wndw(1),1).*(n_1:1:n_2); nn = nn(:);
            
            exclude_rho = find((mm < 1) | (mm > x));
            mm(exclude_rho) = []; nn(exclude_rho) = [];
            
            exclude_theta = find(nn < 1);
            nn(exclude_theta) = y + nn(exclude_theta);
            mm(exclude_theta) = 1 + x - mm(exclude_theta);
            exclude_theta = find(nn > y);
            nn(exclude_theta) = nn(exclude_theta) - y;
            mm(exclude_theta) = 1 + x - mm(exclude_theta);
            
            subscripts = x.*nn - (x.*ones(size(mm,1),1) - mm);
            h_prime(subscripts) = 0;
         
            if (length(peaks_x) == numpeaks)
                terminate = 1;
            end  
        end
        
    end
    peaks = [peaks_x',peaks_y'];
end

