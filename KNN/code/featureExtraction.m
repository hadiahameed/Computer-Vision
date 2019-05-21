function features = featureExtraction(img,dim)
% features = featureExtraction(img)
%          INPUT:
%          ---------------------------------------------------
%          img     = input image
%          dim     = dimensions of features
%
%          OUTPUT:
%          ----------------------------------------------------
%          features   = Features based on RGB Histograms
%
%          DESCRIPTION:
%          ----------------------------------------------------
%          Extracting features from the input image based on RGB
%          histogram
%
    R = img(:,:,1);
    G = img(:,:,2);
    B = img(:,:,3);
    nbins = floor(dim/3);
    hR = histcounts(R,nbins);
    hG = histcounts(G,nbins);
    hB = histcounts(B,nbins);
    features = [hR,hG,hB];
end

