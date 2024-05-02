clear all;
eeglab; close all;
trials = {'000-2-AO','001-AO', '002-AO' };
% trials = {'000-2-AO'};

filepath = ['C:\Users\anhtn\OneDrive - PennO365\Documents\GitHub' ...
    '\AO_human_v_robot_main\prelim_EEG\datasets\'];

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
    
    % compute average reference
    if i ~= 3
        EEG_prep = pop_reref( EEG_prep,[]);
    end

    %------------------------------------------------------------
    % clean data using the clean_rawdata plugin
    % Source: https://github.com/sccn/clean_rawdata/blob/master/clean_artifacts.m
    % BurstRejection : 'on' or 'off'. If 'on' reject portions of data containing burst instead of 
    %                    correcting them using ASR. Default is 'off'.
    EEG_prep = pop_clean_rawdata(EEG_prep, 'FlatlineCriterion', 5, ...
        'ChannelCriterion', 0.85, 'LineNoiseCriterion', 4,'Highpass','off',...
        'BurstCriterion',100,'WindowCriterion',0.8,'BurstRejection','off', ...
        'Distance','Euclidian','WindowCriterionTolerances',[-Inf 7], ...
        'channels_ignore',{'C3','C4'});
    
    if i == 1 || i == 3
        EEG_prep = pop_select(EEG_prep, 'rmchannel', {'FP1', 'FP2'});
    end
    if i == 1
        EEG_prep = pop_select(EEG_prep, 'rmchannel', {'T8'});
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


    % plot spectra of channels and components
    EEG_roi = pop_select( EEG_prep, 'channel',{'C3','C4'});
    figure;
    pop_spectopo(EEG_roi, 1, [EEG_roi.xmin EEG_roi.xmax]*1000, 'EEG' , 'freqrange',[4 30], ...
        'title', [trials{i} ', Percent of remained trials: ', num2str(percent), '%']);
    

    %-----------------------------
    % save cleaned and epoched data
    ALLEEG_prepd{i} = EEG_prep;
    EEG_prep.setname = [trials{i} '-preprocessed'];
    EEG_prep = pop_saveset( EEG_prep, 'filename', [trials{i} '-preprocessed' '.set'], ...
        'filepath', filepath);

end