% load("./sleep_stage_output/trainging_data_ensemble.mat");
% 
% 
% for i = 1:length(input)
%      input_person=input(i);
%      inputperson=input_person{1,1};
%      inputperson=cell2mat(inputperson);
%      output_person=output(i);
%      outputperson=output_person{1,1};
%      outputperson=outputperson{1,1};
% 
%      dt_model= fitctree(inputperson,outputperson,...
%     'OptimizeHyperparameters','all',...
%     'HyperparameterOptimizationOptions',struct('Holdout',0.3,...
%     'AcquisitionFunctionName','expected-improvement-plus'));
% 
%      eval(sprintf('model%d = dt_model', i));
% end

load("./model_result/multimodel.mat");
load("./sleep_stage_output/testing_data_ensemble.mat");

correct=0;
total=0;
accuracy=[];
weights=[];
for j = 1:length(testinput)
   test_input_person=testinput(j);
   test_input_person=test_input_person{1,1};
   testinputperson=cell2mat(test_input_person);
   test_output_person=testoutput(j);
   test_output_person=test_output_person{1,1};
   testoutputperson=test_output_person{1,1};
   
   %% part 1
   % dt_predicts = [];
   % for i = 1:125
   %     model_name = ['model', num2str(i)];
   %     dt_predict = predict(eval(model_name), testinputperson);
   %     dt_predicts =[dt_predicts,dt_predict];
   % end
   % dt_predict=mode(dt_predicts, 2); 
   % correct=correct + sum(dt_predict == testoutputperson);
   % total=total + numel(testoutputperson);
   
   %% part 2
   % sum_dtcost = zeros(numel(testoutputperson), 5);
   % for i = 1:125
   %     model_name = ['model', num2str(i)];
   %     [dt_predict,dt_score,node,cnum] = predict(eval(model_name), testinputperson);
   %     if(size(dt_score,2)==4)
   %         dt_score = [dt_score(:, 1:3), zeros(numel(testoutputperson), 1), dt_score(:, 4)];
   %     end
   %     sum_dtcost =sum_dtcost+dt_score;
   % end
   % [maxValues, dt_predict] = max(sum_dtcost, [], 2);
   % correct=correct + sum(dt_predict == testoutputperson+1);
   % total=total + numel(testoutputperson);
   % acc=sum(dt_predict == testoutputperson+1)/numel(testoutputperson);
   % accuracy=[accuracy;acc];
   
   %% part 3
   % for i = 1:125
   %     model_name = ['model', num2str(i)];
   %     [dt_predict,dt_score,node,cnum] = predict(eval(model_name), testinputperson);
   % 
   %     maxValues= max(dt_score, [], 2);
   %     weight=sum(maxValues)/numel(maxValues);
   %     weights=[weights;weight];
   % 
   %     acc=sum(dt_predict == testoutputperson)/numel(testoutputperson);
   %     accuracy=[accuracy;acc];
   % end
   
   %% part 4
   % dt_predicts = [];
   % weights=[];
   % for i = 1:125
   %     model_name = ['model', num2str(i)];
   %     [dt_predict,dt_score,node,cnum] = predict(eval(model_name), testinputperson);
   %     dt_predicts =[dt_predicts,dt_predict];
   % 
   %     maxValues= max(dt_score, [], 2);
   %     weight=sum(maxValues)/numel(maxValues);
   %     weights=[weights;weight];
   % end
   % 
   % weightpredict=zeros(numel(testoutputperson), 5);
   % numRows = size(dt_predicts, 1);
   % for i = 1:numRows
   %     row = dt_predicts(i, :)';  %% number of model *1
   % 
   %     for k= 1:125
   %         weightpredict(i,row(k)+1)= weightpredict(i,row(k)+1)+weights(k);
   %     end    
   % end
   % 
   % [maxValues,final_predict]=max(weightpredict, [], 2); 
   % correct=correct + sum(final_predict == testoutputperson+1);
   % total=total + numel(testoutputperson);
   % acc=sum(dt_predict == testoutputperson+1)/numel(testoutputperson);
   % accuracy=[accuracy;acc];

   %% part 5
   % weights=[];
   % sum_dtcost = zeros(numel(testoutputperson), 5);
   % for i = 1:125
   %     model_name = ['model', num2str(i)];
   %     [dt_predict,dt_score,node,cnum] = predict(eval(model_name), testinputperson);
   %     if(size(dt_score,2)==4)
   %         dt_score = [dt_score(:, 1:3), zeros(numel(testoutputperson), 1), dt_score(:, 4)];
   %     end
   % 
   %     maxValues= max(dt_score, [], 2);
   %     weight=sum(maxValues)/numel(maxValues);
   %     weighted_dt_score=weight*dt_score;
   %     weights=[weights;weight];
   %     sum_dtcost =sum_dtcost+weighted_dt_score;
   % 
   % end
   % [maxValues, dt_predict] = max(sum_dtcost, [], 2);
   % correct=correct + sum(dt_predict == testoutputperson+1);
   % total=total + numel(testoutputperson);
   % acc=sum(dt_predict == testoutputperson+1)/numel(testoutputperson);
   % accuracy=[accuracy;acc];
   
   %% part 6
   % weights=[];
   % sum_dtcost = zeros(numel(testoutputperson), 5);
   % for i = 1:125
   %     model_name = ['model', num2str(i)];
   %     [dt_predict,dt_score,node,cnum] = predict(eval(model_name), testinputperson);
   %     if(size(dt_score,2)==4)
   %         dt_score = [dt_score(:, 1:3), zeros(numel(testoutputperson), 1), dt_score(:, 4)];
   %     end
   % 
   %     maxValues= max(dt_score, [], 2);
   %     weight=sum(maxValues)/numel(maxValues);
   %     if weight>0.8
   %     weighted_dt_score=weight*dt_score;
   %     weights=[weights;weight];
   %     sum_dtcost =sum_dtcost+weighted_dt_score;
   %     end
   % 
   % end
   % [maxValues, dt_predict] = max(sum_dtcost, [], 2);
   % correct=correct + sum(dt_predict == testoutputperson+1);
   % total=total + numel(testoutputperson);
   % acc=sum(dt_predict == testoutputperson+1)/numel(testoutputperson);
   % accuracy=[accuracy;acc];
end

%% part 3 plot weight-acc
% gscatter(weights, accuracy);
% xlabel('weight') 
% ylabel('accuracy')

%% part 1, 2, 4, 5, 6 calculate acc
Accuracy = correct / total;
fprintf('Accuracy: %.2f%%\n', Accuracy * 100);


