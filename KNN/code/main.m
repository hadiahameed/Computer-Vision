clc
clear
close all
%% Parameters
bins_list = [4,8,16,32];
nk_list = [1,3];
counter = 1;
accuracies = {0,0};
iterations = 100; %no. of iterations to calculate average accuracy
for nb = 1:length(nk_list)
    for bn = 1:length(bins_list)
        nbins = bins_list(bn);
        classes = {'coast';'forest';'insidecity'};
        nk = nk_list(nb);
        %% Training
        path = '../train_set/*train*.jpg';
        train_data = dataCreation(path,classes,nbins);
        %% Testing
        path = '../test_set/*test*.jpg';
        test_data = dataCreation(path,classes,nbins);
        %% Displaying results
        [labels,~] = myKNN(test_data,train_data, nk);
        for j = 1:length(labels)
            message = ['>> Test image ',num2str(j),' of class ', num2str(labels(j,1)),' has been assigned to class ', num2str(labels(j,2))];
            disp(message);
        end
        disp('.........................................................')
        pause(2)
        %% Average accuracy
        average_accuracy = 0;

        for i = 1:iterations
            [~,a] = myKNN(test_data,train_data, nk);
            average_accuracy = average_accuracy + a;
        end
        accuracies{nb,counter} = average_accuracy/iterations;
        disp(['Average accuracy: ',num2str( accuracies{nb,counter}),'%',' with nbins = ',num2str(nbins),' using ',num2str(nk),'-nearest neighbor classifier.'])
        disp('--------------------------------------------------------')
        counter = counter + 1;
    end
    counter = 1;
end
%% Displaying results
close all
figure()
bar(categorical(bins_list), cell2mat(accuracies)');
xlabel('number of bins')
ylabel('Average percentage accuracy')
legend('k = 1','k = 3','Location','northwest')
title('Results for kNN for different values of k and number of bins')
grid on
