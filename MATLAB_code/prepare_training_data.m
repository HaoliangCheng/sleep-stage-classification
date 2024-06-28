% Define annotation mapping
ann2label = containers.Map();
ann2label('Sleep stage W') = 0; % state wakeness
ann2label('Sleep stage 1') = 1;
ann2label('Sleep stage 2') = 2; % 2
ann2label('Sleep stage 3') = 3; % 3
ann2label('Sleep stage 4') = 3; % Follow AASM Manual 3
ann2label('Sleep stage R') = 4; % 4 stage REM
ann2label('Sleep stage ?') = 6;
ann2label('Movement time') = 5;

data_dir= './sleep_stage_training_data'; % get data from this directory 
output_dir= './sleep_stage_output'; % store output in this directory 
psg_fnames = dir(fullfile(data_dir, '*PSG.edf'));
ann_fnames = dir(fullfile(data_dir, '*Hypnogram.edf'));
input=[];
output=[];

%% filter
delta_low = 1;
delta_high = 4;
theta_low = 4;
theta_high = 8;
alpha_low = 8;
alpha_high = 12;
beta_low = 12;
beta_high = 30;

fs=100;
[dl, dh] = butter(4, [delta_low, delta_high]/(fs/2), 'bandpass');
[tl, th] = butter(4, [theta_low, theta_high]/(fs/2), 'bandpass');
[al, ah] = butter(4, [alpha_low, alpha_high]/(fs/2), 'bandpass');
[bl, bh] = butter(4, [beta_low, beta_high]/(fs/2), 'bandpass');

%% Load PSG and annotation
for i = 1:length(psg_fnames)
   psg_f = edfread(fullfile(data_dir,psg_fnames(i).name));
   [head,ann_f] = edfread(fullfile(data_dir, ann_fnames(i).name));

   psg_data = psg_f.("Record Time");
   psg_signal = psg_f.EEGFpz_Cz; %get eeg signal

   ann_onsets = ann_f.Onset; % get time
   ann_durations = ann_f.Duration; % almost 30s
   ann_stages = ann_f.Annotations; %get test stages

   labels = [];
   total_duration = 0;
   for a = 1:length(ann_stages)
       onset_sec = ann_onsets(a);
       duration_sec = ann_durations(a);
       ann_str = ann_stages{a};

       % Sanity check
       assert(onset_sec == total_duration);

       % Get label value
       label = ann2label(ann_str);

       % Compute number of epochs for this stage
       duration_epoch = duration_sec / 30;

       % Generate sleep stage labels
       label_epoch = ones(1, time2num(duration_epoch)) * label;
       labels = [labels, label_epoch];

       total_duration = total_duration + duration_sec;
   end

   labels = labels';

   % Remove annotations that are longer than the recorded signals
   labels = labels(1:length(psg_signal));

   % Get epochs and their corresponding labels
   x = psg_signal;
   y = labels;
   % Select only sleep periods
   w_edge_mins = 30;
   nw_idx = find(y ~= 0);
   start_idx = nw_idx(1) - (w_edge_mins * 2);
   end_idx = nw_idx(end) + (w_edge_mins * 2);
   start_idx = max(start_idx, 1);
   end_idx = min(end_idx, length(y));
   select_idx = start_idx:end_idx;
   x = x(select_idx, :);
   y = y(select_idx);

   % Remove movement and unknown stages
   move_idx = find(y == 5);
   unk_idx = find(y == 6);
   if ~isempty(move_idx) || ~isempty(unk_idx)
      remove_idx = union(move_idx, unk_idx);
      select_idx = setdiff(1:length(x), remove_idx);
      x = x(select_idx, :);
      y = y(select_idx);
   end



   for j = 1:numel(x)
     delta_singal = filter(dl, dh, x{j});
     theta_singal = filter(tl, th, x{j});
     alpha_singal = filter(al, ah, x{j});
     beta_singal = filter(bl, bh, x{j});

     delta_singal_energy = sum(delta_singal.^2);
     theta_singal_energy = sum(theta_singal.^2);
     alpha_singal_energy = sum(alpha_singal.^2);
     beta_singal_energy = sum(beta_singal.^2);
     append= [delta_singal_energy theta_singal_energy alpha_singal_energy beta_singal_energy];
     input = [input;append];
   end
   output = [output; y];
end

save(fullfile(output_dir,"training_data.mat"),"input","output") %% the data after preprocessing will be stored in "output_dir/trainging_data.mat"

%% check the number of each class
% load("./sleep_stage_output/trainging_data.mat");
% a=sum(output==0);
% b=sum(output==1);
% c=sum(output==2);
% d=sum(output==3);
% e=sum(output==4);
% fprintf('stage 0 %.2f%%\n', a);
% fprintf('stage 1 %.2f%%\n', b);
% fprintf('stage 2 %.2f%%\n', c);
% fprintf('stage 3 %.2f%%\n', d);
% fprintf('stage r %.2f%%\n', e);
% fprintf('Total %.2f%%\n', a+b+c+d+e);

%% delete some data to deal with class inbalanced
% idx0 = find(output == 0);
% numToDelete=numel(idx0)-20000;
% indices_to_remove = randperm(numel(idx0), numToDelete);
% output(idx0(indices_to_remove)) = [];
% input(idx0(indices_to_remove), :) = [];
% 
% % idx1 = find(output == 1);
% % numToDelete=numel(idx1)-10000;
% % indices_to_remove = randperm(numel(idx1), numToDelete);
% % output(idx1(indices_to_remove)) = [];
% % input(idx1(indices_to_remove), :) = [];
% 
% idx2 = find(output == 2);
% numToDelete=numel(idx2)-20000;
% indices_to_remove = randperm(numel(idx2), numToDelete);
% output(idx2(indices_to_remove)) = [];
% input(idx2(indices_to_remove), :) = [];
% 
% idx4 = find(output == 4);
% numToDelete=numel(idx4)-20000;
% indices_to_remove = randperm(numel(idx4), numToDelete);
% output(idx4(indices_to_remove)) = [];
% input(idx4(indices_to_remove), :) = [];
% 
% save(fullfile(output_dir,"trainging_data.mat"),"input","output")

%% add some data to deal with class inbalanced
% 
% % idx0 = find(output == 0);
% % numToAdd=50000-numel(idx0);
% % indices_to_remove = randperm(numel(idx0), numToDelete);
% % output(idx0(indices_to_remove)) = [];
% % input(idx0(indices_to_remove), :) = [];
% 
% idx1 = find(output == 1);
% numToAdd=50000-numel(idx1);
% indices_to_remove = randi(numel(idx1), 1,numToAdd);
% duplicatedElements = output(idx1(indices_to_remove));
% output = [output;duplicatedElements];
% duplicatedElements = input(idx1(indices_to_remove),:);
% input = [input;duplicatedElements];
% 
% % idx2 = find(output == 2);
% % numToAdd=50000-numel(idx2);
% % indices_to_remove = randperm(numel(idx2), numToDelete);
% % output(idx2(indices_to_remove)) = [];
% % input(idx2(indices_to_remove), :) = [];
% 
% idx3 = find(output == 3);
% numToAdd=50000-numel(idx3);
% indices_to_remove = randi(numel(idx3), 1,numToAdd);
% duplicatedElements = output(idx3(indices_to_remove));
% output = [output;duplicatedElements];
% duplicatedElements = input(idx3(indices_to_remove),:);
% input = [input;duplicatedElements];
% 
% idx4 = find(output == 4);
% numToAdd=50000-numel(idx4);
% indices_to_remove = randi(numel(idx1), 1,numToAdd);
% duplicatedElements = output(idx4(indices_to_remove));
% output = [output;duplicatedElements];
% duplicatedElements = input(idx4(indices_to_remove),:);
% input = [input;duplicatedElements];
% 
% save(fullfile(output_dir,"trainging_data.mat"),"input","output")
% 
% a=sum(output==0);
% b=sum(output==1);
% c=sum(output==2);
% d=sum(output==3);
% e=sum(output==4);
% fprintf('stage 0 %.2f%%\n', a);
% fprintf('stage 1 %.2f%%\n', b);
% fprintf('stage 2 %.2f%%\n', c);
% fprintf('stage 3 %.2f%%\n', d);
% fprintf('stage r %.2f%%\n', e);
% fprintf('Total %.2f%%\n', a+b+c+d+e);
