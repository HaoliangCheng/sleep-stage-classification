load("./sleep_stage_output/trainging_data_ensemble.mat");
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
%      da_model= fitcdiscr(inputperson,outputperson,...
%     'OptimizeHyperparameters','all',...
%     'HyperparameterOptimizationOptions',struct('Holdout',0.3,...
%     'AcquisitionFunctionName','expected-improvement-plus'));
% 
%      eval(sprintf('model%d = da_model', i));
% end
i = 120;
input_person=input(i);
inputperson=input_person{1,1};
inputperson=cell2mat(inputperson);
output_person=output(i);
outputperson=output_person{1,1};
outputperson=outputperson{1,1};


load("./model_result/multimodel_da.mat");
load("./sleep_stage_output/testing_data_ensemble.mat");

correct=0;
total=0;
accuracy=[];
weights=[];
for j = 1
   test_input_person=testinput(j);
   test_input_person=test_input_person{1,1};
   testinputperson=cell2mat(test_input_person);
   test_output_person=testoutput(j);
   test_output_person=test_output_person{1,1};
   testoutputperson=test_output_person{1,1};

     
   %% part 1
   % da_predicts = [];
   % for i = 1:127
   %     model_name = ['model', num2str(i)];
   %     da_predict = predict(eval(model_name), testinputperson);
   %     da_predicts =[da_predicts,da_predict];
   % end
   % da_predict=mode(da_predicts, 2); 
   % correct=correct + sum(da_predict == testoutputperson);
   % total=total + numel(testoutputperson);
   
   %% part 2
   % sum_dtcost = zeros(numel(testoutputperson), 5);
   % for i = 1:127
   %     model_name = ['model', num2str(i)];
   %     [da_predict,da_score,cost] = predict(eval(model_name), testinputperson);
   %     if(size(da_score,2)==4)
   %         da_score = [da_score(:, 1:3), zeros(numel(testoutputperson), 1), da_score(:, 4)];
   %     end
   %     sum_dtcost =sum_dtcost+da_score;
   % end
   % [maxValues, dt_predict] = max(sum_dtcost, [], 2);
   % correct=correct + sum(dt_predict == testoutputperson+1);
   % total=total + numel(testoutputperson);
   % acc=sum(dt_predict == testoutputperson+1)/numel(testoutputperson);
   %accuracy=[accuracy;acc];
   
   %% part 3 plot weight-acc
   for i = 120
       model_name = ['model', num2str(i)];
       [da_predict,da_score,cost] = predict(eval(model_name), testinputperson);

       maxValues= max(da_score, [], 2);
       weight=sum(maxValues)/numel(maxValues);
       weights=[weights;weight];

       acc=sum(da_predict == testoutputperson)/numel(testoutputperson);
       accuracy=[accuracy;acc];
   end
   
   %% part 4 weight
   % da_predicts = [];
   % weights=[];
   % for i = 1:127
   %     model_name = ['model', num2str(i)];
   %     [da_predict,da_score,cost] = predict(eval(model_name), testinputperson);
   %     da_predicts =[da_predicts,da_predict];
   % 
   %     maxValues= max(da_score, [], 2);
   %     weight=sum(maxValues)/numel(maxValues);
   %     weights=[weights;weight];
   % end
   % 
   % weightpredict=zeros(numel(testoutputperson), 5);
   % numRows = size(da_predicts, 1);
   % for i = 1:numRows
   %     row = da_predicts(i, :)';  %% number of model *1
   %     for k= 1:127
   %         weightpredict(i,row(k)+1)= weightpredict(i,row(k)+1)+weights(k);
   %     end    
   % end
   % 
   % [maxValues,final_predict]=max(weightpredict, [], 2); 
   % correct=correct + sum(final_predict == testoutputperson+1);
   % total=total + numel(testoutputperson);
   % acc=sum(da_predict == testoutputperson+1)/numel(testoutputperson);
   % accuracy=[accuracy;acc];
   

   %% part 5 weight
   % weights=[];
   % sum_dacost = zeros(numel(testoutputperson), 5);
   % for i = 1:127
   %     model_name = ['model', num2str(i)];
   %     [da_predict,da_score,cost] = predict(eval(model_name), testinputperson);
   %     if(size(da_score,2)==4)
   %         da_score = [da_score(:, 1:3), zeros(numel(testoutputperson), 1), da_score(:, 4)];
   %     end
   % 
   %     maxValues= max(da_score, [], 2);
   %     weight=sum(maxValues)/numel(maxValues);
   %     weighted_dt_score=weight*da_score;
   %     weights=[weights;weight];
   %     sum_dacost =sum_dacost+weighted_dt_score;
   % end
   % [maxValues, da_predict] = max(sum_dacost, [], 2);
   % correct=correct + sum(da_predict == testoutputperson+1);
   % total=total + numel(testoutputperson);
   % acc=sum(da_predict == testoutputperson+1)/numel(testoutputperson);
   % accuracy=[accuracy;acc];

   %% part 6
   % weights=[];
   % sum_dacost = zeros(numel(testoutputperson), 5);
   % for i = 1:127
   %     model_name = ['model', num2str(i)];
   %     [da_predict,da_score,cost] = predict(eval(model_name), testinputperson);
   %     if(size(da_score,2)==4)
   %         da_score = [da_score(:, 1:3), zeros(numel(testoutputperson), 1), da_score(:, 4)];
   %     end
   % 
   %     maxValues= max(da_score, [], 2);
   %     weight=sum(maxValues)/numel(maxValues);
   %     if weight>0.6
   %       weighted_dt_score=weight*da_score;
   %       weights=[weights;weight];
   %       sum_dacost =sum_dacost+weighted_dt_score;
   %     end
   % end
   % [maxValues, da_predict] = max(sum_dacost, [], 2);
   % correct=correct + sum(da_predict == testoutputperson+1);
   % total=total + numel(testoutputperson);
   % acc=sum(da_predict == testoutputperson+1)/numel(testoutputperson);
   % accuracy=[accuracy;acc];
end

figure(1)
gscatter(testinputperson(:, 1), testinputperson(:, 2),testoutputperson,'rgbcm');
xlabel('delta') ;
xlim([0 3500000]) ;
ylabel('alpha');
ylim([0 600000]);
hold off;

figure(2)
gscatter(inputperson(:, 1), inputperson(:, 2),outputperson,'rgbcm');
xlabel('delta') ;
xlim([0 3500000]) ;
ylabel('alpha');
ylim([0 600000]);
hold off;
 
% figure(3)
% gscatter(testinputperson(:, 3), testinputperson(:, 4),testoutputperson,'rgbcm');
% xlabel('beta') ;
% xlim([0 200000]) ;
% ylabel('theta');
% ylim([0 150000]);
% hold off;
% 
% figure(4)
% gscatter(inputperson(:, 3), inputperson(:, 4),outputperson,'rgbcm');
% xlabel('beta') ;
% xlim([0 200000]) ;
% ylabel('theta');
% ylim([0 150000]);
% hold off;
% 
% figure(5)
% gscatter(weights, accuracy);
% xlabel('weight'); 
% ylabel('accuracy');
% hold off;


% Accuracy = correct / total;
% fprintf('Accuracy: %.2f%%\n', Accuracy * 100);


