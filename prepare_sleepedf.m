psg_f = edfread('1-PSG.edf');
[head,ann_f] = edfread('1-Hypnogram.edf');

psg_data = psg_f.("Record Time");
psg_signal = psg_f.EEGFpz_Cz; %get eeg signal

ann_onsets = ann_f.Onset; % get time
ann_durations = ann_f.Duration; % almost 30s
ann_stages = ann_f.Annotations; %get test stages

% Define annotation mapping
ann2label = containers.Map();
ann2label('Sleep stage W') = 0;
ann2label('Sleep stage 1') = 1;
ann2label('Sleep stage 2') = 2;
ann2label('Sleep stage 3') = 3;
ann2label('Sleep stage 4') = 3; % Follow AASM Manual
ann2label('Sleep stage R') = 4;
ann2label('Sleep stage ?') = 6;
ann2label('Movement time') = 5;

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
%disp(['Data before selection: ', num2str(size(x)), ', ', num2str(size(y))]);
x = x(select_idx, :);
y = y(select_idx);
%disp(['Data after selection: ', num2str(size(x)), ', ', num2str(size(y))]);

% Remove movement and unknown stages
move_idx = find(y == 5);
unk_idx = find(y == 6);
if ~isempty(move_idx) || ~isempty(unk_idx)
    remove_idx = union(move_idx, unk_idx);
    %disp(['Remove irrelevant stages']);
    %disp(['  Movement: (', num2str(length(move_idx)), ') ', mat2str(move_idx)]);
    %disp(['  Unknown: (', num2str(length(unk_idx)), ') ', mat2str(unk_idx)]);
    %disp(['  Remove: (', num2str(length(remove_idx)), ') ', mat2str(remove_idx)]);
    %disp(['  Data before removal: ', num2str(size(x)), ', ', num2str(size(y))]);
    select_idx = setdiff(1:length(x), remove_idx);
    x = x(select_idx, :);
    y = y(select_idx);
    %disp(['  Data after removal: ', num2str(size(x)), ', ', num2str(size(y))]);
end
