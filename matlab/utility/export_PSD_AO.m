clear all;
eeglab;
close all;

%%
% trials = {'000-2-AO','001-AO', '002-AO' };
%
% filepath = ['C:\Users\anhtn\OneDrive - PennO365\Documents\GitHub\' ...
%     'AO_human_v_robot_main\prelim_EEG\datasets\'];

projectDir = pwd; % "AO_human_v_robot_main"
run( [projectDir  '\matlab\utility\setup_AOE.m'])

subject_data_info = readtable("subject_data_info.xlsx");
trials = {};
subject_idx = {};
for data_row = 1 : height(subject_data_info)
    protocol = num2str(subject_data_info.protocol(data_row));
    subject_id = num2str(subject_data_info.subject_id(data_row));
    experiment = subject_data_info.experiment{data_row};
    EDF_filename = subject_data_info.EDF_filename{data_row};

    subject_folder = [protocol '_' subject_id '-AO'];

    if strcmp(experiment, 'AO') == 1 & isempty(EDF_filename) == 0
        trials{end+1} = subject_folder ;
        subject_idx{end+1} = subject_id;
    end
end

origin_path = ['C:\Users\anhtn\OneDrive - PennO365\Documents\GitHub' ...
    '\AO_human_v_robot_main'];
filepath = [origin_path '\FloAim6_Data\datasets\'];


ALLEEG_a = cell(1,3);
for i=1:length(trials)
    filename = [trials{i} '-preprocessed.set']; % manually type to select dataset
    ALLEEG_a{i} = pop_loadset('filename', filename, 'filepath', filepath);
end

trial_idx = 2;
EEG_a = ALLEEG_a{trial_idx};
% plot_folder = ['plot-' trials(trial_idx) '\\' ];
output_plot_path = [filepath 'output' '\\'];

%========================================================
% Parameters
trial_t_range = [-3 4.5];

markerVal_string = {'10' '11' '12' '13' '14'...
    '20' '21' '22' '23' '24'...
    '30' '31' '32' '33' '34'...
    '40' '41' '42' '43' '44'...
    '50' '51' '52' };
markerVal_cell = {{'10' '11' '12' '13' '14'}...
    {'20' '21' '22' '23' '24'}...
    {'30' '31' '32' '33' '34'}...
    {'40' '41' '42' '43' '44'}...
    {'50' '51' '52'} };
markerVal_num = [10  11  12  13  14 ...
    20  21  22  23  24  ...
    30  31  32  33  34  ...
    40  41  42  43  44  ...
    50 51 52];
markerLabel = ["human-left", "human-right", "robot-left", "robot-right", "control"];
markerColor = ["b", "b", "r","r", "k" ];
markerCurveStyle = ["-", "--", "-","--", "-" ];

actor_pair = {[1 2], [3 4]};
side_pair = {[1 3], [2 4]};
actor_pair_names = cell(1,2);
for i = 1:2
    actor_pair_names{i} = [markerLabel(actor_pair{i})];
end
side_pair_names = cell(1,2);
for i = 1:2
    side_pair_names{i} = [markerLabel(side_pair{i})];
end

chan_names = {'C3', 'C4'};
theta_band = {4:8};
alpha_l_band = {8:10};
alpha_h_band = {10:13};
alpha_band = {8:13};
beta_band = {13:30};

freq_bands = [theta_band, alpha_band, beta_band];
band_names = ["theta" "alpha" "beta"];
band_colors = ["b","r","g"];
freq_bands_bl = [theta_band,  alpha_band, beta_band];

freqfac = 2;
freqrange = [4 30];
wavelet_cycles = [4 1-15.36/freqrange(2)]; % cite Angelini et al 2018
timesout = 800;
tlimits = [-2 4.5];
% baseline = [-1.4 -1];
baseline = [-1 0];

tf_params = {'timesout', timesout, 'baseline', baseline * 1000, 'scale', 'log',...
    'nfreqs', length(freqrange(1):1/freqfac:freqrange(2)), ...
    'freqs', freqrange, 'freqscale', 'linear',...
    'alpha', 0.05, 'erspmax', 2.5, 'vert', [-1000 0 1000], ...
    'plotitc', 'off', 'plotersp', 'on', 'trialbase', 'off',...
    'verbose', 'off', 'newfig', 'off'};



%% Export PSDs - only healthy subjects
% 
% ROIs_FC = {'Cz' , 'FC1', 'C3', 'FC5', 'CP5', 'CP1', 'CP6', 'FC6', 'C4', 'FC2'};
% freqRange = 4:1:30;
% 
% conditions = {{'1000'} {'10' '11' '12' '13' '14'}...
%     {'20' '21' '22' '23' '24'}...
%     {'30' '31' '32' '33' '34'}...
%     {'40' '41' '42' '43' '44'}...
%     {'10' '11' '12' '13' '14'...
%     '20' '21' '22' '23' '24'...
%     '30' '31' '32' '33' '34'...
%     '40' '41' '42' '43' '44'}
%     {'50' '51' '52'}};
% 
% conditions_t_range = {[0 1], [1 4], [1 4] [1 4], [1 4], [0 1], [1 4]};
% 
% conditions_label = {"baseline", "human_left", "human_right", "robot_left", "robot_right", "still", "landscape"};
% 
% data_out_folder = [projectDir '\matlab\output\PSDdata'];
% 
% ALLEEG_a = cell(1,3);
% for i=1:length(healthy_group)
%     filename = [healthy_group{i} '-AO-preprocessed.set']; % manually type to select dataset
%     ALLEEG_a{i} = pop_loadset('filename', filename, 'filepath', filepath);
% end
% 
% for trial_idx = 1:length(healthy_group)
%     disp(healthy_group{trial_idx})
%     EEG_a = ALLEEG_a{trial_idx};
% 
%     for cond_idx = 1:length(conditions)
%         disp(conditions_label{cond_idx})
%         EEG_cond = pop_epoch(EEG_a, conditions{cond_idx}, conditions_t_range{cond_idx});
% 
%         PSD_mat = zeros(length(ROIs_FC), length(freqRange)); % 65 if all frequencies
%         % PSD_mat = zeros(length(ROIs_FC), length(freqRange(1):1:freqRange(2)));
% 
%         for chan = 1:length(ROIs_FC)
%             disp(ROIs_FC{chan})    
%             if  ismember(ROIs_FC(chan), {EEG_cond.chanlocs.labels})
%                 EEG_chan = pop_select( EEG_cond, 'channel', ROIs_FC(chan));
%                 [PSD_chan,freqs,~,~,~] = spectopo(EEG_chan.data, 0, EEG_chan.srate, 'plot', 'off');
%                 PSD_chan = PSD_chan((freqs >= freqRange(1)) & (freqs <= freqRange(end)));
%             end
%         PSD_mat(chan,:) = PSD_chan;
% 
%         end
%         % Define the output directory
%         outputDir = fullfile(projectDir, 'matlab', 'output', 'PSDdata', char(conditions_label{cond_idx}));
% 
%         % Check if the directory exists; if not, create it
%         if ~exist(outputDir, 'dir')
%             mkdir(outputDir);
%         end
% 
%         % Define the output file path
%         outputFile = fullfile(outputDir, [char(healthy_group{trial_idx}) '-' char(conditions_label{cond_idx}) '-PSD.mat']);
% 
%         % Save the file
%         save(outputFile, 'PSD_mat');
% 
%     end
% end

%% Export PSDs for each epoch

ROIs_FC = {'Cz' , 'FC1', 'C3', 'FC5', 'CP5', 'CP1', 'CP6', 'FC6', 'C4', 'FC2'};
freqRange = 4:1:30;

conditions = {{'1000'} {'10' '11' '12' '13' '14'}...
    {'20' '21' '22' '23' '24'}...
    {'30' '31' '32' '33' '34'}...
    {'40' '41' '42' '43' '44'}...
    {'10' '11' '12' '13' '14'...
    '20' '21' '22' '23' '24'...
    '30' '31' '32' '33' '34'...
    '40' '41' '42' '43' '44'}...
    {'50' '51' '52'}};

conditions_t_range = {[0 1], [1 4], [1 4] [1 4], [1 4], [0 1], [1 4]};

conditions_label = {"baseline", "human_left", "human_right", "robot_left", "robot_right", "still", "landscape"};

data_out_folder = [projectDir '\matlab\output\PSDdata'];

ALLEEG_a = cell(1,3);
for i=1:length(healthy_group)
    filename = [healthy_group{i} '-AO-preprocessed.set']; % manually type to select dataset
    ALLEEG_a{i} = pop_loadset('filename', filename, 'filepath', filepath);
end

for trial_idx = 1:length(healthy_group)
    disp(healthy_group{trial_idx})
    EEG_a = ALLEEG_a{trial_idx};

    for cond_idx = 1:length(conditions)
        disp(conditions_label{cond_idx})
        EEG_cond = pop_epoch(EEG_a, conditions{cond_idx}, conditions_t_range{cond_idx});

        PSD_mat = zeros(length(ROIs_FC), length(freqRange)); % 65 if all frequencies

        for epoch = 1:EEG_cond.trials

            for chan = 1:length(ROIs_FC)
                disp(ROIs_FC{chan})    
                if  ismember(ROIs_FC(chan), {EEG_cond.chanlocs.labels})
                    EEG_chan = pop_select( EEG_cond, 'channel', ROIs_FC(chan));
                    
                    [PSD_chan,freqs,~,~,~] = spectopo(EEG_chan.data(:,:,epoch), 0, EEG_chan.srate, 'plot', 'off');
                    
    
                    PSD_chan = PSD_chan((freqs >= freqRange(1)) & (freqs <= freqRange(end)));
                end
            PSD_mat(chan,:) = PSD_chan;
    
            end


            % Define the output directory
            outputDir = fullfile(projectDir, 'matlab', 'output', 'PSD_epoched_data', char(conditions_label{cond_idx}));
            
            % Check if the directory exists; if not, create it
            if ~exist(outputDir, 'dir')
                mkdir(outputDir);
            end
            
            % Define the output file path
            outputFile = fullfile(outputDir, [char(healthy_group{trial_idx}) '-' char(conditions_label{cond_idx}) '-epoch_' num2str(epoch) '-PSD.mat']);
            
            % Save the file
            save(outputFile, 'PSD_mat');
        end

    end
end

%% Export PSDs for each epoch - include markervalues when exporting PSD files

ROIs_FC = {'Cz' , 'FC1', 'C3', 'FC5', 'CP5', 'CP1', 'CP6', 'FC6', 'C4', 'FC2'};
freqRange = 4:1:30;


action_types = {{'10' '20' '30' '40'} ...
    {'11' '21' '31' '41' }...
    {'12' '22' '32' '42'}...
    {'13' '23' '33' '43'}...
    {'14' '24' '34' '44'}};

action_types_t_range = { [1 4], [1 4], [1 4], [1 4], [1 4]};

action_types_label = {"action_0", "action_1", "action_2", "action_3", "action_4"};

data_out_folder = [projectDir '\matlab\output\PSDdata'];

ALLEEG_a = cell(1,3);
for i=1:length(healthy_group)
    filename = [healthy_group{i} '-AO-preprocessed.set']; % manually type to select dataset
    ALLEEG_a{i} = pop_loadset('filename', filename, 'filepath', filepath);
end

for trial_idx = 1:length(healthy_group)
    disp(healthy_group{trial_idx})
    EEG_a = ALLEEG_a{trial_idx};

    for cond_idx = 1:length(action_types)
        disp(action_types_label{cond_idx})
        EEG_cond = pop_epoch(EEG_a, action_types{cond_idx}, action_types_t_range{cond_idx});

        PSD_mat = zeros(length(ROIs_FC), length(freqRange)); % 65 if all frequencies

        for epoch = 1:EEG_cond.trials

            for chan = 1:length(ROIs_FC)
                disp(ROIs_FC{chan})    
                if  ismember(ROIs_FC(chan), {EEG_cond.chanlocs.labels})
                    EEG_chan = pop_select( EEG_cond, 'channel', ROIs_FC(chan));
                    
                    [PSD_chan,freqs,~,~,~] = spectopo(EEG_chan.data(:,:,epoch), 0, EEG_chan.srate, 'plot', 'off');
                    
    
                    PSD_chan = PSD_chan((freqs >= freqRange(1)) & (freqs <= freqRange(end)));
                end
            PSD_mat(chan,:) = PSD_chan;
    
            end


            % Define the output directory
            outputDir = fullfile(projectDir, 'matlab', 'output', 'PSD_epoched_data_by_action_types', char(action_types_label{cond_idx}));
            
            % Check if the directory exists; if not, create it
            if ~exist(outputDir, 'dir')
                mkdir(outputDir);
            end
            
            % Define the output file path
            outputFile = fullfile(outputDir, [char(healthy_group{trial_idx}) '-' char(action_types_label{cond_idx}) '-epoch_' num2str(epoch) '-PSD.mat']);
            
            % Save the file
            save(outputFile, 'PSD_mat');
        end

    end
end