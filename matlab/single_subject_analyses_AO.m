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
conditions_label = {"baseline", "human_left", "human_right", "robot_left", "robot_right", "landscape"};
numConds   = numel(conditions);

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

ALLEEG_prep = cell(1,3);
for trial_idx=1:length(trials)
    filename = [trials{trial_idx} '-preprocessed.set']; % manually type to select dataset
    ALLEEG_prep{trial_idx} = pop_loadset('filename', filename, 'filepath', filepath);
end


output_plot_path = [filepath 'figure\single_subject\' ];    


%% Within-Subject Statistical Test


%% Wilcoxon signed-rank test:
% assess if there is a systematic decrease in mu power from baseline to each AO (within a single subject)

freqRange = 4:0.5:30;

for trial_idx = 1:length(trials)
    disp(['===================================='])
    disp(['*** Subject: ' trials{trial_idx}]);
    EEG_prep= ALLEEG_prep{trial_idx};

    for elec = 1:EEG_prep.nbchan
        all_chan_labels = {EEG_prep.chanlocs.labels};
        disp(['*** Channel: ' all_chan_labels{elec}]);
        EEG_chan = pop_select( EEG_prep, 'channel', elec);

        PSD_all_cond = {};
        for cond_idx = 1:length(conditions)
            disp(["*** Conditions: " conditions_label{cond_idx}])
            EEG_cond = pop_epoch(EEG_chan, conditions{cond_idx}, conditions_t_range{cond_idx}, ...
            'verbose', 'off');

            % baseline has ~5 times the number of trials as the other conditions,
            % reduce it (random sampling) to match the AO condition count for a more balanced comparison
            if conditions_label{cond_idx} == "baseline" 
                numBaselineTrials = EEG_cond.trials;
                numSample = 30;

                % Generate a random permutation of trial indices
                randomIndices = randperm(numBaselineTrials);

                % Keep only the first 24 indices
                selectedIndices = randomIndices(1:numSample);
    
                EEG_cond = pop_select(EEG_cond, 'trial', selectedIndices);

            end
            
            PSD_array = zeros(1, EEG_cond.trials);
            for epoch_idx = 1:EEG_cond.trials       
                [PSD_trial,freqs,~,~,~] = spectopo(EEG_cond.data(:,:,epoch_idx), 0, EEG_chan.srate, 'plot', 'off', 'freqfac', 2, 'verbose', 'off');

                PSD_trial = PSD_trial((freqs >= AO_bands{1}(1)) & (freqs <= AO_bands{1}(end))); %only looking at alpha band for now
                PSD_array(1, epoch_idx) = mean(PSD_trial);
            end
            disp(length(PSD_array))
            PSD_all_cond{cond_idx} = PSD_array;

        end
    
        % Find lengths of each condition
        lens = cellfun(@length, PSD_all_cond);
        % Find the smallest (minimum) number of trials across conditions
        minLen = min(lens);

        % Randomly sub-sample each condition down to minLen trials
        rng('shuffle')  % (Optional) seed the random generator
        for c = 1:numConds
            idx = randperm(lens(c), minLen);     % pick minLen unique indices
            PSD_all_cond{c} = PSD_all_cond{c}(idx);  % keep only those trials
        end
        
        % Now build the data matrix for Friedman test
        % Rows = trial #, Cols = condition
        X = zeros(minLen, numConds);
        for c = 1:numConds
            X(:, c) = PSD_all_cond{c};
        end

        % Run Friedman test
        [p, tbl, stats] = friedman(X, 1, "off");
        % If p < 0.05, do multiple comparisons to see which conditions differ
        results = multcompare(stats);


        % loop over all unique condition pairs and run Wilcoxon signed-rank tests.
        pairwiseP = nan(numConds, numConds); % preallocate matrix for p-values
        
        for i = 1:numConds-1
            for j = i+1:numConds
                % signrank performs a Wilcoxon signed-rank test on paired samples
                [p_val, h, stats_signed] = signrank(X(:,i), X(:,j));
                pairwiseP(i,j) = p_val;
                fprintf('Wilcoxon signed-rank test for %s vs %s: p = %.4f\n', ...
                    conditions_label{i}, conditions_label{j}, p_val);
            end
        end
        
        % Optionally, you can correct for multiple comparisons here (e.g., using Bonferroni)
        numComparisons = nchoosek(numConds,2);
        bonferroniThreshold = 0.05 / numComparisons;
        fprintf('Bonferroni corrected threshold: %.4f\n', bonferroniThreshold);
        
        % Display which comparisons are significant after correction
        for i = 1:numConds-1
            for j = i+1:numConds
                if pairwiseP(i,j) < bonferroniThreshold
                    fprintf('Significant difference between %s and %s after Bonferroni correction (p = %.4f).\n', ...
                        conditions_label{i}, conditions_label{j}, pairwiseP(i,j));
                end
            end
        end

    end
end