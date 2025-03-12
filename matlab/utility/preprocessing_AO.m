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
filepath = [origin_path '\FloAim6_Data\datasets\'];

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

%% Preprocess EEG data for each trial
for i = 1:length(trials)
    disp(['*** Subject: ' trials{i}]);
    EEG_prep = ALLEEG_prep{i};
    EEG_prep_raw = EEG_prep;

    % Checking total number of trials: 144
    EEG_prep_raw = pop_epoch(EEG_prep_raw, markerVal_string, trial_t_range, 'epochinfo', 'yes');
    disp(['Total number of trials: ', num2str(size(EEG_prep_raw.epoch, 2)) ]);

    % High pass filter at 1 Hz
    EEG_prep = pop_eegfiltnew(EEG_prep, 'locutoff',1);


    % Remove bad channels from visual inspection
    % Instructions for bad channel removal:
        % Run pop_eegplot(EEG_prep) to view the EEG dataset in time series
        % Identify the bad channels, 
        % using the following exclusion criteria: 
        % sudden shifts, excessive high frequency noise, or voltage amplitude > 100 µV
    if ~isnan(bad_channels{i}) 
        EEG_prep = pop_select(EEG_prep, 'rmchannel', bad_channels{i});
    end

    % recompute average reference interpolating missing channels (and removing
    % them again after average reference - STUDY functions handle them automatically)
    EEG_prep = pop_reref( EEG_prep,[],'interpchan',[]);

    %------------------------------------
    % run ICA reducing the dimension by 1 to account for average reference
    plugin_askinstall('picard', 'picard', 1); % install Picard plugin
    EEG_prep = pop_runica(EEG_prep, 'icatype','picard','options',{'pca',-1});

    % run ICLabel and flag artifactual components
    EEG_prep = pop_iclabel(EEG_prep, 'default');
    EEG_prep = pop_icflag( EEG_prep,[NaN NaN;0.75 1;0.75 1;0.75 1;NaN NaN;NaN NaN;NaN NaN]);
    EEG_prep = pop_subcomp( EEG_prep , [], 0); % remove bad components

    %---------------------------------
    % epoching
    EEG_prep = pop_epoch(EEG_prep, markerVal_string, trial_t_range, 'epochinfo', 'yes');

    % Checking numbers of trials remaining after cleaning
    disp(['Number of remained trials: ', num2str(size(EEG_prep.epoch, 2)) ]);
    percent = size(EEG_prep.epoch, 2) / size(EEG_prep_raw.epoch, 2) * 100;
    disp(['Percent of remained trials: ', num2str(percent), '%' ]);

    %-----------------------------------
    % Run second ICA
    EEG_prep = pop_runica(EEG_prep, 'icatype','picard','options',{'pca',-1});

    % run ICLabel and flag artifactual components
    EEG_prep = pop_iclabel(EEG_prep, 'default');
    EEG_prep = pop_icflag( EEG_prep,[NaN NaN;0.75 1;0.75 1;0.75 1;NaN NaN;NaN NaN;NaN NaN]);
    EEG_prep = pop_subcomp( EEG_prep , [], 0); % remove bad components


    % visual inspection to remove epoch with amplitude > 80 uV
    % Using the same exclusion criteria as above
    if ~isnan(bad_epochs{i})
        EEG_prep = pop_rejepoch( EEG_prep, bad_epochs{i}, 0);
    end

    % Checking numbers of trials remaining after cleaning
    disp(['Number of remained trials: ', num2str(size(EEG_prep.epoch, 2)) ]);
    percent = size(EEG_prep.epoch, 2) / size(EEG_prep_raw.epoch, 2) * 100;
    disp(['Percent of remained trials: ', num2str(percent), '%' ]);

    % plot spectra of channels and components
    EEG_roi = pop_select( EEG_prep, 'channel',{'C3','C4'});
    fig = figure;
    pop_spectopo(EEG_roi, 1, [EEG_roi.xmin EEG_roi.xmax]*1000, 'EEG' , 'freqrange',[4 30], ...
        'title', [trials{i} ', Percent of remained trials: ', num2str(percent), '%']);

    % save figure
    saveas(fig, [filepath 'figures\' trials{i} '-preprocessed-PSD-C3C4' '.png']);

    %-----------------------------
    % save cleaned and epoched data
    ALLEEG_prepd{i} = EEG_prep;
    EEG_prep.setname = [trials{i} '-preprocessed'];
    EEG_prep = pop_saveset( EEG_prep, 'filename', [trials{i} '-preprocessed' '.set'], ...
        'filepath', filepath);

end