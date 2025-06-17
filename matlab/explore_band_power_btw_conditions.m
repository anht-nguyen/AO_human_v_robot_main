eeglab; close all;

origin_path = pwd() %['C:\Users\anhtn\OneDrive - PennO365\Documents\GitHub\AO_human_v_robot_main'];

%% Import params
run([origin_path '\matlab\utility\setup_AOE.m'])


%% create extra params
conditions = {{'1000'} {'10' '11' '12' '13' '14'}...
    {'20' '21' '22' '23' '24'}...
    {'30' '31' '32' '33' '34'}...
    {'40' '41' '42' '43' '44'}...
    {'50' '51' '52'}};
conditions_t_range = {[0 1], [1 4], [1 4] [1 4], [1 4], [1 4]};
conditions_label = {"baseline", "human-left", "human-right", "robot-left", "robot-right", "landscape"};
numConds   = numel(conditions);

bands = {[4 8], [8 13], [13 30]};
band_names = {"theta", "alpha", "beta"};

freqRange = 4:30;

%% Import datasets
subject_data_info = readtable([origin_path '\matlab\subject_data_info.xlsx']);
trials = {};
subject_idx = {};
bad_channels = {};
bad_epochs = {};
for data_row = 1 : height(subject_data_info)
    protocol = num2str(subject_data_info.protocol(data_row));
    subject_id = num2str(subject_data_info.subject_id(data_row));
    experiment = subject_data_info.experiment{data_row};
    EDF_filename = subject_data_info.EDF_filename{data_row};
    bad_channel = cellfun(@str2double, strsplit(subject_data_info.bad_channel{data_row}, ','));
    bad_epoch = cellfun(@str2double, strsplit(subject_data_info.bad_epoch{data_row}, ','));

    subject_folder = [protocol '_' subject_id];

    if strcmp(experiment, 'AO') == 1 & isempty(EDF_filename) == 0
        trials{end+1} = [subject_folder '-' experiment];
        subject_idx{end+1} = subject_id;
        bad_channels{end+1} = bad_channel;
        bad_epochs{end+1} = bad_epoch;
    end
end

filepath = [origin_path '\FloAim6_Data\datasets\newprep\'];

ALLEEG_a = cell(1,3);
for trial_idx=1:length(trials)
    filename = [trials{trial_idx} '-preprocessed.set']; % manually type to select dataset
    ALLEEG_a{trial_idx} = pop_loadset('filename', filename, 'filepath', filepath);
end


output_plot_path = [filepath 'figure\single_subject\' ];    

%% Check band powers from output/PSD_epoched_data
ROIs_FC = {'Cz' , 'FC1', 'C3', 'FC5', 'CP5', 'CP1', 'CP6', 'FC6', 'C4', 'FC2'};

relative_band_powers_cell = cell(length(healthy_group), length(conditions));

for trial_idx = 1:length(healthy_group)
    disp(healthy_group{trial_idx})

    for cond_idx = 1:length(conditions)
        disp(conditions_label{cond_idx})

        PSD_folder = fullfile(origin_path, '\matlab\output\PSD_epoched_data\', conditions_label{cond_idx});
        PSD_mat_files = dir(PSD_folder);

        % Filter out directories (keep only files)
        PSD_mat_files = PSD_mat_files(~[PSD_mat_files.isdir]);

        PSD_mat_files = PSD_mat_files(startsWith({PSD_mat_files(:).name}, healthy_group{trial_idx}));

        relative_band_powers = zeros(length(ROIs_FC), length(bands));
        for band_idx = 1:length(bands)

            % Display file names
            for i = 1:length(PSD_mat_files)
                disp(PSD_mat_files(i).name);
                PSD_mat = load(fullfile(PSD_folder, PSD_mat_files(i).name));
                PSD_mat = PSD_mat.PSD_mat;

                sum_PSD = sum(PSD_mat, 2);
                relative_delta_power = sum(PSD_mat(:, freqRange >= bands{1}(1) & freqRange <=bands{1}(2)), 2) ./ sum_PSD; 
                relative_alpha_power = sum(PSD_mat(:, freqRange >= bands{2}(1) & freqRange <=bands{2}(2)), 2) ./ sum_PSD;                 
                relative_beta_power = sum(PSD_mat(:, freqRange >= bands{3}(1) & freqRange <=bands{3}(2)), 2) ./ sum_PSD; 

                relative_band_powers(:,1) = relative_band_powers(:,1) + relative_delta_power;
                relative_band_powers(:,2) = relative_band_powers(:,2) + relative_alpha_power;
                relative_band_powers(:,3) = relative_band_powers(:,3) + relative_beta_power;

            end
            relative_band_powers = relative_band_powers /length(PSD_mat_files); 
        end

        relative_band_powers_cell{trial_idx, cond_idx} = relative_band_powers;

    end
end


% Descriptive Stats and Visualization
% Compute Descriptive Metrics
descStats.meanVal = zeros(10, 3, 6); % channels x bands x conditions
descStats.seVal   = zeros(10, 3, 6);

for cond_idx = 1:6
    for chan_idx = 1:10
        for band_idx = 1:3
            % Collect all subjects' values for this ch & band in a vector
            valVec = zeros(1,5);
            for trial_idx = 1:5
                valVec(trial_idx) = relative_band_powers_cell{trial_idx, cond_idx}(chan_idx, band_idx);
            end
            descStats.meanVal(chan_idx, band_idx, cond_idx) = mean(valVec);
            descStats.seVal(chan_idx, band_idx, cond_idx)   = std(valVec) / sqrt(length(valVec));
        end
    end
end


figure();
tiledlayout(3,10);

for band_idx = 1:3
    for chan_idx = 1:10
        nexttile;  hold on;
        
        % Title
        title(sprintf('Channel %s, Band %s', ROIs_FC{chan_idx}, band_names{band_idx}));
        
        % Bar plot
        bar(1:6, squeeze(descStats.meanVal(chan_idx, band_idx, :)));
        
        % Error bars
        errorbar(1:6, ...
            squeeze(descStats.meanVal(chan_idx, band_idx, :)), ...
            squeeze(descStats.seVal(chan_idx, band_idx, :)), ...
            'k', 'LineStyle', 'none');
        
        % Set x-axis ticks to [1 2 3 4 5 6] and label them
        xticks(1:6); 
        xticklabels(conditions_label);
        
        % (Optional) If labels overlap, rotate them slightly for clarity
        % xtickangle(45);  % un-comment if needed
        
        hold off;
    end
end


% -- BOX PLOTS FOR EACH CHANNEL-BAND COMBINATION --

figure();
tiledlayout(3, 10);

for band_idx = 1:3
    for chan_idx = 1:10
        
        % Collect the data for the current channel & band across all subjects + conditions.
        % We’ll end up with a 5x6 matrix: rows=subjects, cols=conditions
        dataMatrix = zeros(5, 6);
        for subj = 1:5
            for cond = 1:6
                dataMatrix(subj, cond) = relative_band_powers_cell{subj, cond}(chan_idx, band_idx);
            end
        end

        % Move to next tile
        nexttile;
        
        % Create a boxplot with one box per condition
        boxplot(dataMatrix);%, 'Labels', conditions_label);
        % Set x-axis ticks to [1 2 3 4 5 6] and label them
        xticks(1:6); 
        xticklabels(conditions_label);
        title(sprintf('Channel %s, Band %s', ROIs_FC{chan_idx}, band_names{band_idx}));
        ylabel('Relative Power');
        
        % Optional: Rotate x-axis labels if overlapping
        % xtickangle(45);
        
        grid on;
    end
end






%% Compute PSD of alpha, theta, beta bands for each channel and each conditions























