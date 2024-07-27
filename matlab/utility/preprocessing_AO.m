clear all;
eeglab; close all;


subject_data_info = readtable("subject_data_info.xlsx");
trials = {};

for data_row = 1 : height(subject_data_info)
    protocol = num2str(subject_data_info.protocol(data_row));
    subject_id = num2str(subject_data_info.subject_id(data_row));
    experiment = subject_data_info.experiment{data_row};
    EDF_filename = subject_data_info.EDF_filename{data_row};

    subject_folder = [protocol '_' subject_id];

    if strcmp(experiment, 'AO') == 1 & isempty(EDF_filename) == 0
        trials{end+1} = [subject_folder '-' experiment];
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

markerVal_string = {'10' '11' '12' '13' '14'...
    '20' '21' '22' '23' '24'...
    '30' '31' '32' '33' '34'...
    '40' '41' '42' '43' '44'...
    '50' '51' '52' };
trial_t_range = [-3 4.5];
ALLEEG_prepd = [];

for i = 1:length(trials)
    disp(['*** Subject: ' trials{i}]);
    EEG_prep = ALLEEG_prep{i};
    EEG_prep_raw = EEG_prep;

    % Checking total number of trials: 144
    EEG_prep_raw = pop_epoch(EEG_prep_raw, markerVal_string, trial_t_range, 'epochinfo', 'yes');
    disp(['Total number of trials: ', num2str(size(EEG_prep_raw.epoch, 2)) ]);

    % High pass filter at 1 Hz
    EEG_prep = pop_eegfiltnew(EEG_prep, 'locutoff',1);

    % % compute average reference
    % if i ~= 3
    %     EEG_prep = pop_reref( EEG_prep,[]);
    % end
    %
    % %------------------------------------------------------------
    % % clean data using the clean_rawdata plugin
    % % Source: https://github.com/sccn/clean_rawdata/blob/master/clean_artifacts.m
    % % BurstRejection : 'on' or 'off'. If 'on' reject portions of data containing burst instead of
    % %                    correcting them using ASR. Default is 'off'.
    % EEG_prep = pop_clean_rawdata(EEG_prep, 'FlatlineCriterion', 5, ...
    %     'ChannelCriterion', 0.85, 'LineNoiseCriterion', 4,'Highpass','off',...
    %     'BurstCriterion',100,'WindowCriterion',0.8,'BurstRejection','off', ...
    %     'Distance','Euclidian','WindowCriterionTolerances',[-Inf 7], ...
    %     'channels_ignore',{'C3','C4'});

    % The above step (clean_rawdata) was removed as it seems unnecessary
    % (results were not different with and with out clean_rawdata)


    % Remove bad channels from visual inspection
    if i == 1 || i == 3
        EEG_prep = pop_select(EEG_prep, 'rmchannel', {'FP1', 'FP2'});
    end
    if i == 1
        EEG_prep = pop_select(EEG_prep, 'rmchannel', {'T8'});
    end

    if i == 2
        EEG_prep = pop_select(EEG_prep, 'rmchannel', {'F4', 'Oz'});
    end
    if i == 3
        EEG_prep = pop_select(EEG_prep, 'rmchannel', {'CP2'});
    end

    % recompute average reference interpolating missing channels (and removing
    % them again after average reference - STUDY functions handle them automatically)
    EEG_prep = pop_reref( EEG_prep,[],'interpchan',[]); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CONSIDERING REREF TO MASTOID ELECTRODES

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
    if i == 1
        EEG_prep = pop_rejepoch( EEG_prep, [131] ,0);
    end
    if i == 2
        EEG_prep = pop_rejepoch( EEG_prep, [33 39 55 56:66 68 69 74 105 120] ,0);
    end
    if i == 3
        EEG_prep = pop_rejepoch( EEG_prep, [5 8 9 16 18 20 21 50 53 58 65 66 73 80 82 90 103 113 116 117 124 128 129 139 140] ,0);
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