% Angelini:
% Step 1: Single-subject values were averaged across 2 electrodes,
% separately for each perspective and frequency band
% Testing whether all conditions elicited a significant central visuomotor reactivity during AO

% NOTE: Update 5/3/24, there are only 3 subjects, sample too small for
% ttest
% Come back to this testing when we have larger sample

% clear all;
eeglab;
% close all;

setup_AOE

%======================================
% Results from explore_AO_ersp and explore_AE_ersp
band_names = {'alpha', 'beta'};
alpha_band = 8:0.5:13;
AO_beta_band = 15:0.5:22;
AO_bands = {alpha_band, AO_beta_band};

AE_beta_band = 19:0.5:24;
AE_bands = {alpha_band, AE_beta_band};

AO_onset_times = 1000; % onset of action in video stimuli
AE_onset_times = 0;

% ----------------------------------
% times_exp_cell = load([filepath '\times_exp.mat'], '-mat');
% AO_times = times_exp_cell{1};

%=================================================
% Angelini:
% Step 1: Single-subject values were averaged across 2 electrodes,
% separately for each perspective and frequency band
% Testing whether all conditions elicited a significant central visuomotor reactivity during AO

ersp_all_mean_chan = cell(length(trials), length(experiments));

for trial_idx = 1:length(trials)

    disp(['*** Subject: ' trials{trial_idx}]);

    ALLEEG_exp = {};

    for exp=1:length(experiments)
        filename = [trials{trial_idx} '-' experiments{exp} '-preprocessed.set'];
        ALLEEG_exp{exp} = pop_loadset('filename', filename, 'filepath', filepath);
    end

    exp = 1;
    EEG_exp = ALLEEG_exp{exp};

    ersp_exp_all = cell(length(chan_names), length(experiments));

    for chan = 1:length(chan_names)
        disp(['*** Channel: ' chan_names{chan}]);

        EEG_chan = pop_select( EEG_exp, 'channel', chan_names(chan));

        ersp_cond_cell = cell(1,length(AO_markerVal_cell));

        for cond_idx = 1:length(AO_markerVal_cell)
            disp(['*** Condition: ' char(markerLabel(cond_idx))]);

            EEG_cond = pop_epoch(EEG_chan, AO_markerVal_cell{cond_idx}, AO_trial_t_range, ...
                'verbose', 'off');
            disp(['*** Number of trials in this condition: ', num2str(size(EEG_cond.epoch, 2)) ]);

            [ersp,~,~,AO_times,~] = ...
                pop_newtimef(EEG_cond, 1, 1, AO_tlimits*1000, wavelet_cycles, AO_tf_params{:});
            ersp_cond_cell{cond_idx} = ersp;
        end
        ersp_exp_all(chan, exp) = {ersp_cond_cell};

    end

    ersp_cond_cell = cell(length(AO_bands),length(AO_markerVal_cell));
    for cond_idx = 1:length(AO_markerVal_cell)
        for band = 1:length(AO_bands)
            ersp_C3 = ersp_exp_all{1, exp}{cond_idx};
            ersp_C3 = ersp_C3(freqs >= AO_bands{band}(1) & freqs <= AO_bands{band}(end), :);

            ersp_C4 = ersp_exp_all{2, exp}{cond_idx};
            ersp_C4 = ersp_C4(freqs >= AO_bands{band}(1) & freqs <= AO_bands{band}(end), :);

            ersp_mean_chan = (ersp_C3 + ersp_C4)/2;

            ersp_cond_cell{band, cond_idx} = ersp_mean_chan;

        end
    end
    ersp_all_mean_chan{trial_idx, exp} = ersp_cond_cell;


    %---------------- AE
    exp = 2;
    EEG_exp = ALLEEG_exp{exp};

    ersp_exp_all = cell(length(chan_names), length(experiments));

    for chan = 1:length(chan_names)
        disp(['*** Channel: ' chan_names{chan}]);

        EEG_chan = pop_select( EEG_exp, 'channel', chan_names(chan));

        ersp_cond_cell = cell(1,length(AE_markerVal_cell));

        for cond_idx = 1:length(AE_markerVal_cell)
            disp(['*** Condition: ' char(markerLabel(cond_idx))]);

            EEG_cond = pop_epoch(EEG_chan, AE_markerVal_cell{cond_idx}, AE_trial_t_range, ...
                'verbose', 'off');
            disp(['*** Number of trials in this condition: ', num2str(size(EEG_cond.epoch, 2)) ]);

            [ersp,~,~,AE_times,~] = ...
                pop_newtimef(EEG_cond, 1, 1, AE_tlimits*1000, wavelet_cycles, AE_tf_params{:});
            ersp_cond_cell{cond_idx} = ersp;
        end
        ersp_exp_all(chan, exp) = {ersp_cond_cell};
    end

    ersp_cond_cell = cell(length(AE_bands),length(AE_markerVal_cell));
    for cond_idx = 1:length(AE_markerVal_cell)
        for band = 1:length(AE_bands)
            ersp_C3 = ersp_exp_all{1, exp}{cond_idx};
            ersp_C3 = ersp_C3(freqs >= AE_bands{band}(1) & freqs <= AE_bands{band}(end), :);

            ersp_C4 = ersp_exp_all{2, exp}{cond_idx};
            ersp_C4 = ersp_C4(freqs >= AE_bands{band}(1) & freqs <= AE_bands{band}(end), :);

            ersp_mean_chan = (ersp_C3 + ersp_C4)/2;

            ersp_cond_cell{band, cond_idx} = ersp_mean_chan;
        end
    end
    ersp_all_mean_chan{trial_idx, exp} = ersp_cond_cell;
end


AO_onset_idx = find(AO_times >= AO_onset_times);
AE_onset_idx = find(AE_times >= AE_onset_times);


% % one tailed single sample t test: test ERSP data against 0
mu = 0;
for band = 1:length(band_names)
    for cond_idx = 1:length(AE_markerVal_cell)
        disp(['cond: ' markerLabel{cond_idx} ', band: ' band_names{band}])

        exp = 1;
        ersp_mean_subj = [];
        for trial_idx = 1:length(trials)
            data = ersp_all_mean_chan{trial_idx, exp}{band, cond_idx};
            data = data(:, AO_onset_idx);
            ersp_mean_subj(trial_idx) = mean(data, 'all');
        end
        ersp_mean_subj
        
        [h, p, ci, stats] = ttest(ersp_mean_subj, mu, 'Tail', 'left')
        
        exp =2;
        ersp_mean_subj = [];
        for trial_idx = 1:length(trials)
            data = ersp_all_mean_chan{trial_idx, exp}{band, cond_idx};
            data = data(:, AE_onset_idx);
            ersp_mean_subj(trial_idx) = mean(data, 'all');

        end
        ersp_mean_subj
        [h, p, ci, stats] = ttest(ersp_mean_subj, mu, 'Tail', 'left')
    end
end








