function data = dataCreation(path,classes,nbins)
% data = dataCreation(path,classes)
%          INPUT:
%          ---------------------------------------------------
%          path     = path of the directory containing files 
%          classes  = target classes
%          nbins    = number of bins to divide the RGB histograms
%
%          OUTPUT:
%          ----------------------------------------------------
%          data   = data matrix with features from 1:n-1 columns
%                   and corresponding class in nth column
%
%          DESCRIPTION:
%          ----------------------------------------------------
%          Creating dataset from a set of files
%
files = dir(path);
filenames = extractfield(files,'name')';
features = zeros(length(filenames),3*nbins);
target_labels = zeros(length(filenames),1);
for i = 1:length(filenames)
    filename = filenames{i};
    label_name = split(filename,'_');
    label_name = cell2mat(label_name(1));
    label = 4;
    for j = 1:length(classes)
        if(strcmp(label_name,classes{j}))
            label = j;
        end
    end
    filePath = split(path,'/');
    filePath = cell2mat(filePath(2));
    img = imread(['../',filePath,'/',filename]);
    features(i,:) = featureExtraction(img,3*nbins);
    target_labels(i,1) = label;     
end
data = [features,target_labels];
end

