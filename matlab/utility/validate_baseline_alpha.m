eeglab; close all;

origin_path = pwd() %['C:\Users\anhtn\OneDrive - PennO365\Documents\GitHub\AO_human_v_robot_main'];
filepath = [origin_path '\FloAim6_Data\datasets\'];

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



%% Plot PSD of raw data
ALLEEG_raw = cell(1,length(trials));
for trial_idx=1:length(trials)
    filename = [trials{trial_idx} '-curated.set']; % manually type to select dataset
    ALLEEG_raw{trial_idx} = pop_loadset('filename', filename, 'filepath', filepath);
end

markerVal_string = {'10' '11' '12' '13' '14'...
    '20' '21' '22' '23' '24'...
    '30' '31' '32' '33' '34'...
    '40' '41' '42' '43' '44'...
    '50' '51' '52' };
trial_t_range = [-3 4.5];


baseline_t_range = [-1 0];

fig_PSD = figure();
nRows = 2; nCols = length(trials);
t_main1 = tiledlayout(fig_PSD, nRows, nCols, 'TileSpacing', 'compact', 'Padding', 'compact');
title(t_main1, ['Plot PSD of all subjects'])



for trial_idx = 1:length(trials)
    disp(['*** Subject: ' trials{trial_idx}]);
    EEG_raw = ALLEEG_raw{trial_idx};

    % epoching
    EEG_raw = pop_epoch(EEG_raw, markerVal_string, baseline_t_range, 'epochinfo', 'yes');

    % Compute spectral data manually
    [spectra, freqs] = spectopo(EEG_raw.data, 0, EEG_raw.srate, 'plot', 'off');

    % Plot manually in the specified tile
    ax = nexttile(t_main1);
    plot(ax, freqs, spectra); xlim([1 40]); ylim([-20 40])
    title(ax, [trials{trial_idx} ' - Raw data']);
    xlabel(ax, 'Frequency (Hz)');
    ylabel(ax, 'Power (dB)');

end



%% Plot PSD of preprocessed data
% trials = {'000-2-AO','001-AO', '002-AO' };
%
% filepath = ['C:\Users\anhtn\OneDrive - PennO365\Documents\GitHub\' ...
%     'AO_human_v_robot_main\prelim_EEG\datasets\'];

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


ALLEEG_prep = cell(1,3);
for trial_idx=1:length(trials)
    filename = [trials{trial_idx} '-preprocessed.set']; % manually type to select dataset
    ALLEEG_prep{trial_idx} = pop_loadset('filename', filename, 'filepath', filepath);
end

trial_idx = 2;
EEG_prep = ALLEEG_prep{trial_idx};
% plot_folder = ['plot-' trials(trial_idx) '\\' ];
output_plot_path = [filepath 'output' '\\'];    

for trial_idx = 1:length(trials)
    disp(['*** Subject: ' trials{trial_idx}]);
    EEG_prep = ALLEEG_prep{trial_idx};

    % epoching
    EEG_prep = pop_epoch(EEG_prep, markerVal_string, baseline_t_range, 'epochinfo', 'yes');

    % Compute spectral data manually
    [spectra, freqs] = spectopo(EEG_prep.data, 0, EEG_prep.srate, 'plot', 'off');

    % Plot manually in the specified tile
    ax = nexttile(t_main1);
    plot(ax, freqs, spectra); xlim([1 40]); ylim([-20 40])
    title(ax, [trials{trial_idx} ' - Cleaned data']);
    xlabel(ax, 'Frequency (Hz)');
    ylabel(ax, 'Power (dB)');


end

    % save figure
    saveas(fig_PSD, [filepath 'figures\validate_alpha\'  'PSD of all subjects.png']);

%% Plot topographical PSD


freq_range = [1 40];

for trial_idx = 1:length(trials)
    disp(['*** Subject: ' trials{trial_idx}]);
    EEG_raw = ALLEEG_raw{trial_idx};

    % epoching
    EEG_raw = pop_epoch(EEG_raw, markerVal_string, baseline_t_range, 'epochinfo', 'yes');


    % Plot manually in the specified tile
    plot_psd_on_2Dtopoplot(EEG_raw, freq_range, [trials{trial_idx} '-raw'], ...
        'yes', [filepath 'figures\validate_alpha\' trials{trial_idx} '-raw-topoPSD.png'])
    
end


%%
for trial_idx = 1:length(trials)
    disp(['*** Subject: ' trials{trial_idx}]);
    EEG_prep= ALLEEG_prep{trial_idx};

    % epoching
    EEG_prep = pop_epoch(EEG_prep, markerVal_string, baseline_t_range, 'epochinfo', 'yes');


    % Plot manually in the specified tile
    plot_psd_on_2Dtopoplot(EEG_prep, freq_range, [trials{trial_idx} '-prep-baseline'], ...
        'yes', [filepath 'figures\validate_alpha\' trials{trial_idx} '-prep-baseline-topoPSD.png'])

end




for trial_idx = 1:length(trials)
    disp(['*** Subject: ' trials{trial_idx}]);
    EEG_prep= ALLEEG_prep{trial_idx};

    % epoching
    EEG_prep = pop_epoch(EEG_prep, markerVal_string, [0 4], 'epochinfo', 'yes');


    % Plot manually in the specified tile
    plot_psd_on_2Dtopoplot(EEG_prep, freq_range, [trials{trial_idx} '-prep-AOinterval'], ...
        'yes', [filepath 'figures\validate_alpha\' trials{trial_idx} '-prep-AOinterval-topoPSD.png'])

end











