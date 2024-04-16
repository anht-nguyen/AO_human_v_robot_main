clear all;
eeglab; close all;
trials = {'000-AO','001-AO', '002-AO' };
% trials = {'001-AO'};

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

% i=1
for i = 2:length(trials)
    EEG_prep = ALLEEG_prep{i};
    EEG_prep_raw = EEG_prep;
    
    % Checking total number of trials: 144
    EEG_prep_raw = pop_epoch(EEG_prep_raw, markerVal_string, trial_t_range, 'epochinfo', 'yes');
    disp(['Total number of trials: ', num2str(size(EEG_prep_raw.epoch, 2)) ]);
    
    % compute average reference
    EEG_prep = pop_reref( EEG_prep,[]);

    % eegplot( EEG_prep.data, 'winlength', 15, 'spacing', 100, 'eloc_file', EEG_prep.chaninfo.filename, ...
        % 'events', EEG_prep.event, 'title', ['subject ' num2str(i) 'raw data']);

    %------------------------------------------------------------
    % clean data using the clean_rawdata plugin
    % Source: https://github.com/sccn/clean_rawdata/blob/master/clean_artifacts.m
    % BurstRejection : 'on' or 'off'. If 'on' reject portions of data containing burst instead of 
    %                    correcting them using ASR. Default is 'off'.
    EEG_prep = pop_clean_rawdata(EEG_prep, 'FlatlineCriterion', 5, ...
        'ChannelCriterion', 0.85, 'LineNoiseCriterion', 4,'Highpass','off',...
        'BurstCriterion',100,'WindowCriterion',0.5,'BurstRejection','off', ...
        'Distance','Euclidian','WindowCriterionTolerances',[-Inf 7], ...
        'channels_ignore',{'C3','C4'});
    
    if i == 1 || i == 3
        EEG_prep = pop_select(EEG_prep, 'rmchannel', {'FP1', 'FP2'});
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
    % if i ==3 
    %     EEG_prep = pop_subcomp(EEG_prep, [20 21 24]);
    % end

    %---------------------------------
    % epoching
    EEG_prep = pop_epoch(EEG_prep, markerVal_string, trial_t_range, 'epochinfo', 'yes');

    % Checking numbers of trials remaining after cleaning
    disp(['Number of remained trials: ', num2str(size(EEG_prep.epoch, 2)) ]);
    disp(['Percent of remained trials: ', ...
        num2str(size(EEG_prep.epoch, 2) / size(EEG_prep_raw.epoch, 2) * 100), '%' ]);
    
    %-----------------------------------
    % Run second ICA
    EEG_prep = pop_runica(EEG_prep, 'icatype','picard','options',{'pca',-1});
    
    % run ICLabel and flag artifactual components
    EEG_prep = pop_iclabel(EEG_prep, 'default');
    EEG_prep = pop_icflag( EEG_prep,[NaN NaN;0.75 1;0.75 1;0.75 1;NaN NaN;NaN NaN;NaN NaN]);
    EEG_prep = pop_subcomp( EEG_prep , [], 0); % remove bad components


    %-----------------------------------------------------
    % visually inspected the epoched components to remove epochs contaminated with artifacts
    % eegplot( EEG_prep.icaact, 'winlength', 15, 'spacing', 20, 'events', EEG_prep.event, ...
    %     'title', ['subject ' num2str(i) 'cleaned data - components']);
    % eegplot( EEG_prep.data, 'winlength', 15, 'spacing', 100, 'eloc_file', EEG_prep.chaninfo.filename, ...
    %     'events', EEG_prep.event, 'title', ['subject ' num2str(i) 'cleaned data']);

    % pop_eegplot( EEG_prep, 1, 1, 0);
    % check spectra of channels and components
    % pop_spectopo(EEG_prep, 1);
    % pop_spectopo(EEG_prep, 0);
    % if i == 1
    %     reject_epochs = [2 3 58];
    % elseif i == 2
    %     reject_epochs =  [19 34 36 47 54:60 62 63 71 77 79 80 84 85 100 104];
    % elseif i == 3
    %     reject_epochs = [];
    % end
    % EEG_prep = pop_rejepoch( EEG_prep,  reject_epochs, 0);

    % plot spectra of channels and components
    % figure();  spectopo(EEG_prep.data, EEG_prep.pnts, EEG_prep.srate, ...
    %     'title', ['subject ' num2str(i) ', spectra of channels' ]);
    % figure();  spectopo(EEG_prep.icaact, EEG_prep.pnts, EEG_prep.srate, ...
    %     'title', ['subject ' num2str(i) ', spectra of components' ]);

    %-----------------------------
    % save cleaned and epoched data
    EEG_prep.setname = [trials{i} '-preprocessed'];
    EEG_prep = pop_saveset( EEG_prep, 'filename', [trials{i} '-preprocessed' '.set'], ...
        'filepath', filepath);

end