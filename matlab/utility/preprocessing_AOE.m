clear all;
eeglab; close all;
% trials = {'000-2-AOE','001-AOE', '002-AOE' };
% % trials = {'000-2-AOE'};
% 
% filepath = ['C:\Users\anhtn\OneDrive - PennO365\Documents\GitHub' ...
%     '\AO_human_v_robot_main\prelim_EEG\datasets\'];

subject_data_info = readtable("subject_data_info.xlsx");
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

    if strcmp(experiment, 'AOE') == 1 & isempty(EDF_filename) == 0
        trials{end+1} = [subject_folder '-' experiment];
        subject_idx{end+1} = subject_id;
        bad_channels{end+1} = bad_channel;
        bad_epochs{end+1} = bad_epoch;
    end
end

origin_path = ['C:\Users\anhtn\OneDrive - PennO365\Documents\GitHub' ...
    '\AO_human_v_robot_main'];
filepath = [origin_path '\FloAim6_Data\datasets\'];


ALLEEG_prep = cell(1,length(trials));
for i=1:length(trials)
    filename = [trials{i} '-curated.set']; % manually type to select dataset
    ALLEEG_prep{i} = pop_loadset('filename', filename, 'filepath', filepath);
end

markerVal_string = {'110' '111' '112' '113' '114'...
    '120' '121' '122' '123' '124'...
    '130' '131' '132' '133' '134'...
    '140' '141' '142' '143' '144' };
trial_t_range = [-1 4];

ALLEEG_prepd = [];

%-----------------------
for i = 1:length(trials)
    disp(['*** Subject: ' trials{i}]);
    EEG_prep = ALLEEG_prep{i};
    EEG_prep_raw = EEG_prep;

    % Checking total number of trials: 144
    EEG_prep_raw = pop_epoch(EEG_prep_raw, markerVal_string, trial_t_range, 'epochinfo', 'yes');
    disp(['Total number of trials: ', num2str(size(EEG_prep_raw.epoch, 2)) ]);

    %-------------------------------
    % Due to error in markerVal from PsychoPy experiment: 830126_602 (prelim ID: 001-AOE)
    % marker value of each AE are not match with marker value of each AO preceding it
    % This step is needed to fix the events
    if strcmpi(subject_idx{i}, '602')        %strcmpi(trials{i}, '001-AOE')        
        urevent_org = [EEG_prep.event.type];
        urevent_new = urevent_org;
        
        for idx = 4:4:floor(length(urevent_org)/4)*4
            urevent_new(idx) = urevent_new(idx-2) + 100;
        end
        
        % update new event list to EEG_prep then save the dataset
        EEG_prep = pop_importevent(EEG_prep, 'event', urevent_new, 'fields', {'type'}, ...
            'append', 'no');
    end
    %-----------------------------------

    %%%%%%%%%%%% Start preprocessing
    
    % High pass filter at 1 Hz
    EEG_prep = pop_eegfiltnew(EEG_prep, 'locutoff',1);

    % Remove bad channels from visual inspection
    % if strcomp(subject_idx{i}, '603') == 1
    %     EEG_prep = pop_select(EEG_prep, 'rmchannel', {'T8', 'O1'});
    % end
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
    EEG_prep = pop_icflag( EEG_prep,[NaN NaN;0.75 1;0.75 1;0.75 1;NaN NaN;0.75 1;NaN NaN]);
    EEG_prep = pop_subcomp( EEG_prep , [], 0); % remove bad components

    %---------------------------------
    % epoching
    EEG_prep = pop_epoch(EEG_prep, markerVal_string, trial_t_range, 'epochinfo', 'yes');

    
    %-----------------------------------
    % Run second ICA
    EEG_prep = pop_runica(EEG_prep, 'icatype','picard','options',{'pca',-1});
    
    % run ICLabel and flag artifactual components
    EEG_prep = pop_iclabel(EEG_prep, 'default');
    EEG_prep = pop_icflag( EEG_prep,[NaN NaN;0.75 1;0.75 1;0.75 1;NaN NaN;0.75 1;NaN NaN]);
    EEG_prep = pop_subcomp( EEG_prep , [], 0); % remove bad components

    
    % visual inspection to remove epoch with amplitude > 80 uV
    % if strcomp(subject_idx{i}, '602') == 1 %i == 2
    %     EEG_prep = pop_rejepoch( EEG_prep, [39 73 76 81 87 89 109 112 113 114 117 118] ,0);
    % end
    % if strcomp(subject_idx{i}, '601') == 1 %i == 3
    %     EEG_prep = pop_rejepoch( EEG_prep, [8 16 18 24 29 50 62 66 70 71 75 76:78 83 85 87 88 90 91 93:2:97 98 100 101 103 105 106 108 109:119] ,0);
    % end

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
    ALLEEG_prep{i} = EEG_prep;
    EEG_prep.setname = [trials{i} '-preprocessed'];
    EEG_prep = pop_saveset( EEG_prep, 'filename', [trials{i} '-preprocessed' '.set'], ...
        'filepath', filepath);

end