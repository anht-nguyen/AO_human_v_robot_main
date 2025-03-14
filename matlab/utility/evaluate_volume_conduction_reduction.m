% Clear workspace and close all figures
clear all;
eeglab; close all;

% Load subject data information from Excel file
subject_data_info = readtable("subject_data_info.xlsx");

% Initialize empty cell arrays to store data
trials = {};
subject_idx = {};
bad_channels = {};
bad_epochs = {};

% Loop through each subject in the data table
for data_row = 1 : height(subject_data_info)
    % Extract relevant information for each subject
    protocol = num2str(subject_data_info.protocol(data_row));
    subject_id = num2str(subject_data_info.subject_id(data_row));
    experiment = subject_data_info.experiment{data_row};
    EDF_filename = subject_data_info.EDF_filename{data_row};
    
    % Convert bad channel and bad epoch strings into numerical arrays
    bad_channel = cellfun(@str2double, strsplit(subject_data_info.bad_channel{data_row}, ','));
    bad_epoch = cellfun(@str2double, strsplit(subject_data_info.bad_epoch{data_row}, ','));
    
    % Construct subject folder name
    subject_folder = [protocol '_' subject_id];
    
    % Store subject details if experiment is 'AO' and EDF filename is not empty
    if strcmp(experiment, 'AO') == 1 & isempty(EDF_filename) == 0
        trials{end+1} = [subject_folder '-' experiment];
        subject_idx{end+1} = subject_id;
        bad_channels{end+1} = bad_channel;
        bad_epochs{end+1} = bad_epoch;
    end
end

% Define file paths for dataset
origin_path = ['C:\Users\anhtn\OneDrive - PennO365\Documents\GitHub' ...
    '\AO_human_v_robot_main'];
filepath = [origin_path '\FloAim6_Data\datasets\' ];

output_filepath = [filepath 'newprep\'];

% Load EEG datasets
ALLEEG_prep = cell(1,length(trials));
for i=1:length(trials)
    filename = [trials{i} '-curated.set']; % Load dataset file for each trial
    ALLEEG_prep{i} = pop_loadset('filename', filename, 'filepath', filepath);
end

% Define marker values and epoch time range
markerVal_string = {'10' '11' '12' '13' '14'...
    '20' '21' '22' '23' '24'...
    '30' '31' '32' '33' '34'...
    '40' '41' '42' '43' '44'...
    '50' '51' '52' };
trial_t_range = [-3 4.5];
ALLEEG_prepd = [];


% Define Save Directory
save_dir = fullfile(output_filepath, 'evaluate_CV_reduction');
if ~exist(save_dir, 'dir')
    mkdir(save_dir);
end

% Define Log File Path
log_file = fullfile(save_dir, 'results_log.txt');
fid = fopen(log_file, 'w'); % Open log file for writing
fprintf(fid, 'Volume Conduction Reduction Assessment Log\n');
fprintf(fid, '========================================\n\n');

%% Assess Volume Conduction Reduction from Applying CSD Re-Referencing
% This script evaluates the impact of Laplacian re-referencing (CSD) by 
% comparing spatial correlations between Raw EEG, Common Average Reference (CAR) EEG,
% and CSD-transformed EEG (Laplacian EEG).

% Expected Results:
% Raw EEG: High correlation between channels (due to volume conduction).
% CAR EEG: Moderate correlation reduction.
% Laplacian EEG: Lowest correlation, indicating reduced volume conduction.

% Loop through each trial to compute correlation matrices
for i = 1:length(trials)
    
    % ------------------ Load and Epoch Raw EEG ------------------ %
    EEG_raw = ALLEEG_prep{i};
    EEG_raw = pop_epoch(EEG_raw, markerVal_string, trial_t_range, 'epochinfo', 'yes');
    raw_corr = corrcoef(mean(EEG_raw.data, 3)');

    % ------------------ Load CAR EEG ------------------ %
    car_file = fullfile(filepath, [trials{i} '-preprocessed.set']);
    if exist(car_file, 'file')
        EEG_CAR = pop_loadset('filename', [trials{i} '-preprocessed.set'], 'filepath', filepath);
        car_corr = corrcoef(mean(EEG_CAR.data, 3)');
    else
        warning('CAR EEG file not found: %s', car_file);
        car_corr = NaN;
    end

    % ------------------ Load CSD EEG ------------------ %
    csd_file = fullfile(output_filepath, [trials{i} '-preprocessed.set']);
    if exist(csd_file, 'file')
        EEG_CSD = pop_loadset('filename', [trials{i} '-preprocessed.set'], 'filepath', output_filepath);
        csd_corr = corrcoef(mean(EEG_CSD.data, 3)');
    else
        warning('CSD EEG file not found: %s', csd_file);
        csd_corr = NaN;
    end

    % ------------------ Plot and Save Correlation Matrices ------------------ %
    figure;
    subplot(1,3,1); imagesc(raw_corr); colorbar; title('Raw EEG Correlation');
    subplot(1,3,2); imagesc(car_corr); colorbar; title('CAR EEG Correlation');
    subplot(1,3,3); imagesc(csd_corr); colorbar; title('CSD EEG Correlation');
    
    saveas(gcf, fullfile(save_dir, ['Correlation_' trials{i} '.png']));
    close(gcf); % Close figure after saving

    % ------------------ Compute Mean Correlations ------------------ %
    mean_corr_raw = nanmean(abs(raw_corr(:)));
    mean_corr_car = nanmean(abs(car_corr(:)));
    mean_corr_csd = nanmean(abs(csd_corr(:)));

    % ------------------ Print and Save Correlation Results ------------------ %
    fprintf(fid, 'Trial: %s\n', trials{i});
    fprintf(fid, 'Mean Correlation (Raw EEG): %.3f\n', mean_corr_raw);
    fprintf(fid, 'Mean Correlation (CAR EEG): %.3f\n', mean_corr_car);
    fprintf(fid, 'Mean Correlation (CSD EEG): %.3f\n\n', mean_corr_csd);
    
end

%% Assess Volume Conduction Reduction from Applying CSD Re-Referencing
% This script evaluates the impact of Laplacian re-referencing (CSD) by 
% comparing Global Field Power (GFP) between Raw EEG, Common Average Reference (CAR) EEG,
% and CSD-transformed EEG (Laplacian EEG).

% Expected Results:
% Raw EEG: Lower GFP due to widespread signals.
% CAR EEG: Slightly increased GFP.
% Laplacian EEG: Higher GFP (indicating more localized, independent signals).

for i = 1:length(trials)
    
    % ------------------ Load and Epoch Raw EEG ------------------ %
    EEG_raw = ALLEEG_prep{i};
    EEG_raw = pop_epoch(EEG_raw, markerVal_string, trial_t_range, 'epochinfo', 'yes');
    GFP_raw = squeeze(std(mean(EEG_raw.data, 3), 0, 1));

    % ------------------ Load CAR EEG ------------------ %
    car_file = fullfile(filepath, [trials{i} '-preprocessed.set']);
    if exist(car_file, 'file')
        EEG_CAR = pop_loadset('filename', [trials{i} '-preprocessed.set'], 'filepath', filepath);
        GFP_CAR = squeeze(std(mean(EEG_CAR.data, 3), 0, 1));
    else
        warning('CAR EEG file not found: %s', car_file);
        GFP_CAR = NaN(size(GFP_raw));
    end

    % ------------------ Load CSD EEG ------------------ %
    csd_file = fullfile(output_filepath, [trials{i} '-preprocessed.set']);
    if exist(csd_file, 'file')
        EEG_CSD = pop_loadset('filename', [trials{i} '-preprocessed.set'], 'filepath', output_filepath);
        GFP_CSD = squeeze(std(mean(EEG_CSD.data, 3), 0, 1));
    else
        warning('CSD EEG file not found: %s', csd_file);
        GFP_CSD = NaN(size(GFP_raw));
    end

    % ------------------ Plot and Save GFP Comparison ------------------ %
    figure;
    plot(EEG_raw.times, GFP_raw, 'k', 'LineWidth', 1.5); hold on;
    plot(EEG_CAR.times, GFP_CAR, 'b', 'LineWidth', 1.5);
    plot(EEG_CSD.times, GFP_CSD, 'r', 'LineWidth', 1.5);
    legend({'Raw EEG', 'CAR EEG', 'CSD EEG'}, 'Location', 'Best');
    xlabel('Time (ms)'); ylabel('Global Field Power (μV)');
    title(['GFP Comparison for Trial: ' trials{i}]);

    saveas(gcf, fullfile(save_dir, ['GFP_' trials{i} '.png']));
    close(gcf);
    
    % ------------------ Compute Mean GFP ------------------ %
    mean_GFP_raw = nanmean(GFP_raw(:));
    mean_GFP_car = nanmean(GFP_CAR(:));
    mean_GFP_csd = nanmean(GFP_CSD(:));

    % ------------------ Print and Save GFP Results ------------------ %
    fprintf(fid, 'Trial: %s\n', trials{i});
    fprintf(fid, 'Mean GFP (Raw EEG): %.3f μV\n', mean_GFP_raw);
    fprintf(fid, 'Mean GFP (CAR EEG): %.3f μV\n', mean_GFP_car);
    fprintf(fid, 'Mean GFP (CSD EEG): %.3f μV\n\n', mean_GFP_csd);

end

%% Assess Volume Conduction Reduction from Applying CSD Re-Referencing
% This script evaluates the impact of Laplacian re-referencing (CSD) by 
% computing **coherence across all channel pairs** for Raw, CAR, and CSD EEG.

for i = 1:length(trials)
    
    % ------------------ Load and Epoch Raw EEG ------------------ %
    EEG_raw = ALLEEG_prep{i};
    EEG_raw = pop_epoch(EEG_raw, markerVal_string, trial_t_range, 'epochinfo', 'yes');
    
    n_channels = size(EEG_raw.data, 1);
    coh_raw = zeros(n_channels, n_channels);

    % Compute coherence for Raw EEG
    for ch1 = 1:n_channels
        for ch2 = ch1+1:n_channels
            [coh_raw_val, ~] = mscohere(mean(EEG_raw.data(ch1,:,:), 3), mean(EEG_raw.data(ch2,:,:), 3), [], [], [], EEG_raw.srate);
            coh_raw(ch1, ch2) = nanmean(coh_raw_val);
            coh_raw(ch2, ch1) = coh_raw(ch1, ch2);
        end
    end

    % ------------------ Load CAR EEG ------------------ %
    car_file = fullfile(filepath, [trials{i} '-preprocessed.set']);
    if exist(car_file, 'file')
        EEG_CAR = pop_loadset('filename', [trials{i} '-preprocessed.set'], 'filepath', filepath);
        coh_car = zeros(n_channels, n_channels);
        
        for ch1 = 1:n_channels
            for ch2 = ch1+1:n_channels
                [coh_car_val, ~] = mscohere(mean(EEG_CAR.data(ch1,:,:), 3), mean(EEG_CAR.data(ch2,:,:), 3), [], [], [], EEG_CAR.srate);
                coh_car(ch1, ch2) = nanmean(coh_car_val);
                coh_car(ch2, ch1) = coh_car(ch1, ch2);
            end
        end
    else
        warning('CAR EEG file not found: %s', car_file);
        coh_car = NaN(n_channels, n_channels);
    end

    % ------------------ Load CSD EEG ------------------ %
    csd_file = fullfile(output_filepath, [trials{i} '-preprocessed.set']);
    if exist(csd_file, 'file')
        EEG_CSD = pop_loadset('filename', [trials{i} '-preprocessed.set'], 'filepath', output_filepath);
        coh_csd = zeros(n_channels, n_channels);
        
        for ch1 = 1:n_channels
            for ch2 = ch1+1:n_channels
                [coh_csd_val, ~] = mscohere(mean(EEG_CSD.data(ch1,:,:), 3), mean(EEG_CSD.data(ch2,:,:), 3), [], [], [], EEG_CSD.srate);
                coh_csd(ch1, ch2) = nanmean(coh_csd_val);
                coh_csd(ch2, ch1) = coh_csd(ch1, ch2);
            end
        end
    else
        warning('CSD EEG file not found: %s', csd_file);
        coh_csd = NaN(n_channels, n_channels);
    end

    % ------------------ Set Common Color Limits ------------------ %
    min_coh = min([coh_raw(:); coh_car(:); coh_csd(:)], [], 'omitnan');
    max_coh = max([coh_raw(:); coh_car(:); coh_csd(:)], [], 'omitnan');

    % ------------------ Plot and Save Coherence Matrices ------------------ %
    figure;
    
    subplot(1,3,1); imagesc(coh_raw, [min_coh max_coh]); colorbar;
    title('Raw EEG Coherence'); xlabel('Channels'); ylabel('Channels');

    subplot(1,3,2); imagesc(coh_car, [min_coh max_coh]); colorbar;
    title('CAR EEG Coherence'); xlabel('Channels'); ylabel('Channels');

    subplot(1,3,3); imagesc(coh_csd, [min_coh max_coh]); colorbar;
    title('CSD EEG Coherence'); xlabel('Channels'); ylabel('Channels');

    saveas(gcf, fullfile(save_dir, ['Coherence_' trials{i} '.png']));
    close(gcf);

    % ------------------ Compute Mean Coherence ------------------ %
    mean_coh_raw = nanmean(coh_raw(:));
    mean_coh_car = nanmean(coh_car(:));
    mean_coh_csd = nanmean(coh_csd(:));

    % ------------------ Print and Save Coherence Results ------------------ %
    fprintf(fid, 'Trial: %s\n', trials{i});
    fprintf(fid, 'Mean Coherence (Raw EEG): %.3f\n', mean_coh_raw);
    fprintf(fid, 'Mean Coherence (CAR EEG): %.3f\n', mean_coh_car);
    fprintf(fid, 'Mean Coherence (CSD EEG): %.3f\n\n', mean_coh_csd);
    
end


% Close log file
fclose(fid);
fprintf('Results saved in %s\n', log_file);
