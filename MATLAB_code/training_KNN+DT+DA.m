load("./sleep_stage_output/training_data.mat");

%% shuffle the input and output
% numRows = size(input, 1);
% randomRowIndices = randperm(numRows);
% input = input(randomRowIndices, :);
% output = output(randomRowIndices);

%% training
num = optimizableVariable('n',[10,50],'Type','integer');
dst = optimizableVariable('dst',{'euclidean', 'cityblock', 'minkowski'});
c = cvpartition(numel(output),'Kfold',5);
fun = @(x)kfoldLoss(fitcknn(input,output,'CVPartition',c,'NumNeighbors',x.n,...
    'Distance',char(x.dst),'NSMethod','exhaustive'));
results = bayesopt(fun,[num,dst],'Verbose',0,...
    'AcquisitionFunctionName','expected-improvement-plus');
zbest = bestPoint(results);
knn_model = fitcknn(input,output,'NumNeighbors',zbest.n,'Distance',char(zbest.dst));

% da_model = fitcdiscr(input,output,...
%     'OptimizeHyperparameters','all',...
%     'HyperparameterOptimizationOptions',struct('Holdout',0.3,...
%     'AcquisitionFunctionName','expected-improvement-plus'));
% 
% dt_model= fitctree(input,output,...
%     'OptimizeHyperparameters','all',...
%     'HyperparameterOptimizationOptions',struct('Holdout',0.3,...
%     'AcquisitionFunctionName','expected-improvement-plus'));

% load("./sleep_stage_output/test_data.mat");
% totalSamples = numel(testoutput);
% 
% [knn_predict,knn_score,knn_cost] = predict(knn_model,testinput);
% knncorrectlyPredicted = sum(knn_predict == testoutput);
% knnaccuracy = knncorrectlyPredicted / totalSamples;
% fprintf('KNNaccuracy: %.2f%%\n', knnaccuracy * 100);

% precision = zeros(5, 1);
% for i = 0:4
%     class = i;
%     TP = sum((knn_predict == class) & (testoutput == class));
%     FP = sum((knn_predict == class) & (testoutput ~= class));
%     precision(i+1) = TP / (TP + FP);
% end
% 
% for i = 0:4
%     fprintf('Precision for class %d: %.2f\n', i, precision(i+1));
% end

totalSamples = numel(output);

[knn_predict,knn_score,knn_cost] = predict(knn_model,input);
knncorrectlyPredicted = sum(knn_predict == output);
knnaccuracy = knncorrectlyPredicted / totalSamples;
fprintf('KNNaccuracy: %.2f%%\n', knnaccuracy * 100);

precision = zeros(5, 1);
for i = 0:4
    class = i;
    TP = sum((knn_predict == class) & (output == class));
    FP = sum((knn_predict == class) & (output ~= class));
    precision(i+1) = TP / (TP + FP);
end

for i = 0:4
    fprintf('Precision for class %d: %.2f\n', i, precision(i+1));
end

% [da_predict,da_score,da_cost] = predict(da_model,testinput);
% dacorrectlyPredicted = sum(da_predict == testoutput);
% daaccuracy = dacorrectlyPredicted / totalSamples;
% fprintf('DAaccuracy: %.2f%%\n', daaccuracy * 100);
% 
% precision = zeros(5, 1);
% for i = 0:4
%     class = i;
%     TP = sum((da_predict == class) & (testoutput == class));
%     FP = sum((da_predict == class) & (testoutput ~= class));
%     precision(i+1) = TP / (TP + FP);
% end
% 
% for i = 0:4
%     fprintf('Precision for class %d: %.2f\n', i, precision(i+1));
% end

% [dt_predict,dt_score,dt_cost] = predict(dt_model,testinput);
% dtcorrectlyPredicted = sum(dt_predict == testoutput);
% dtaccuracy = dtcorrectlyPredicted / totalSamples;
% fprintf('DTaccuracy: %.2f%%\n', dtaccuracy * 100);

% precision = zeros(5, 1);
% for i = 0:4
%     class = i;
%     TP = sum((dt_predict == class) & (testoutput == class));
%     FP = sum((dt_predict == class) & (testoutput ~= class));
%     precision(i+1) = TP / (TP + FP);
% end
% 
% for i = 0:4
%     fprintf('Precision for class %d: %.2f\n', i, precision(i+1));
% end

% [dt_predict,dt_score,dt_cost] = predict(dt_model,input);
% dtcorrectlyPredicted = sum(dt_predict == output);
% dtaccuracy = dtcorrectlyPredicted / totalSamples;
% fprintf('DTaccuracy: %.2f%%\n', dtaccuracy * 100);
% 
% precision = zeros(5, 1);
% for i = 0:4
%     class = i;
%     TP = sum((dt_predict == class) & (output == class));
%     FP = sum((dt_predict == class) & (output ~= class));
%     precision(i+1) = TP / (TP + FP);
% end
% 
% for i = 0:4
%     fprintf('Precision for class %d: %.2f\n', i, precision(i+1));
% end


   

