function [test_labels,accuracy] = myKNN(test_data,train_data, nk)
%[test_labels,accuracy] = myKNN(test_data,train_data, nk)
%          INPUT:
%          ---------------------------------------------------
%          test_data  =  Input test data with features and 
%                        true labels.
%          train_data =  Input train data with features and labels.
%          nk         =  number of neighbors to consider
%                        for assigning clusters.
%
%          OUTPUT:
%          ----------------------------------------------------
%          test_labels = a vector with 2 columns with true labels and
%                        predicted labels in first and second column
%                        respectively.
%          accuracy    = kMeans clustering accuracy.
%
%          DESCRIPTION:
%          ----------------------------------------------------
%          k-Nearest Neighbor Algorithm

%% Linearizing matrices
train_features = train_data(:,1:end-1);
test_features = test_data(:,1:end-1);
train_labels = train_data(:,end);
test_labels = test_data(:,end);
tr_m = size(train_features,1);
ts_m = size(test_features,1);
test_labels(:,end+1) = zeros(ts_m,1);
%% Euclidean distance calculation
dist = zeros(tr_m,1);
%for each point i in test data
for i = 1:ts_m
    %for each point j in tain data
    for j = 1:tr_m
         x = train_features(i,:);
         y = test_features(j,:);
         %calculate distance between ith and jth point
         dist(j,1) = myNorm(x,y);
    end
    
    d = dist;
    clst = zeros(nk,1);
    %choose nk number of nearest neighbors
    for ii=1:nk
        [~,idx] = min(d);
        clst(ii,1) = train_labels(idx);
        d(idx) = Inf;
    end
    
    %use majority voting to assign cluster
    test_labels(i,end) = mode(clst);
end

%indices for which true label != predicted label
false_labels = find(test_labels(:,1)~=test_labels(:,2));

%Percentage Accuracy
accuracy = 100*(1 - length(false_labels)/ts_m);
end

