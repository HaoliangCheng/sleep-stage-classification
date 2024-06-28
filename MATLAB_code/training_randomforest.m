load("./sleep_stage_output/trainging_data.mat");

rng('default'); % For reproducibility
% t = templateTree('NumVariablesToSample','all',...
%    'PredictorSelection','interaction-curvature','Surrogate','on');
% rf = fitcensemble(input,output,'Method','Bag','NumLearningCycles',58, 'Learners',t);
% rf = fitcensemble(input,output,'Method','Bag','OptimizeHyperparameters', ...
%     {'NumLearningCycles','MinLeafSize','MaxNumSplits'},'Learners',t);
% rf = fitcensemble(input,output,...
%     'OptimizeHyperparameters','all',...
%     'HyperparameterOptimizationOptions',struct('Holdout',0.3,...
%     'AcquisitionFunctionName','expected-improvement-plus'));

% numTree = optimizableVariable('minLS',[1,30],'Type','integer');
% numPTS = optimizableVariable('numPTS',[1,100],'Type','integer');
% hyperparametersRF = [minLS];
% results = bayesopt(@(params)oobErrRF(params,input,output),hyperparametersRF,...
%     'AcquisitionFunctionName','expected-improvement-plus','Verbose',0);
% bestOOBErr = results.MinObjective;
% bestHyperparameters = results.XAtMinObjective;
% rf = TreeBagger(40,input,output,'Method','classification',...
%     'MinLeafSize',bestHyperparameters.minLS,...
%     'NumPredictorstoSample',1);

rf = TreeBagger(58,input,output,'Method','classification',...
    'MinLeafSize',25,...
    'NumPredictorstoSample',1);

% load("./sleep_stage_output/test_data.mat");
% totalSamples = numel(testoutput);
% 
% rf_predict = predict(rf,testinput);
% rf_predict=cell2mat(rf_predict);
% for i = 1:length(rf_predict)
%    rf_predict(i) = str2double(rf_predict(i)); 
% end
% rfcorrectlyPredicted = sum(rf_predict == testoutput);
% rfaccuracy = rfcorrectlyPredicted / totalSamples;
% fprintf('RFaccuracy: %.2f%%\n', rfaccuracy * 100);
% 
% precision = zeros(5, 1);
% for i = 0:4
%     class = i;
%     TP = sum((rf_predict == class) & (testoutput == class));
%     FP = sum((rf_predict == class) & (testoutput ~= class));
%     precision(i+1) = TP / (TP + FP);
% end
% 
% for i = 0:4
%     fprintf('Precision for class %d: %.2f\n', i, precision(i+1));
% end

totalSamples = numel(output);

rf_predict = predict(rf,input);
rf_predict=cell2mat(rf_predict);
for i = 1:length(rf_predict)
   rf_predict(i) = str2double(rf_predict(i)); 
end
rfcorrectlyPredicted = sum(rf_predict == output);
rfaccuracy = rfcorrectlyPredicted / totalSamples;
fprintf('RFaccuracy: %.2f%%\n', rfaccuracy * 100);

precision = zeros(5, 1);
for i = 0:4
    class = i;
    TP = sum((rf_predict == class) & (output == class));
    FP = sum((rf_predict == class) & (output ~= class));
    precision(i+1) = TP / (TP + FP);
end

for i = 0:4
    fprintf('Precision for class %d: %.2f\n', i, precision(i+1));
end

% function oobErr = oobErrRF(params,input,output)
% randomForest = TreeBagger(params.numTree,input,output,'Method','regression',...
%     'OOBPrediction','on','MinLeafSize',params.minLS,...
%     'NumPredictorstoSample',1);
% oobErr = oobQuantileError(randomForest);
% end
