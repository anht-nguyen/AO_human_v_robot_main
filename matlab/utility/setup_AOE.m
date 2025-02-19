
subject_data_info = readtable("subject_data_info.xlsx");
trials = {}; healthy_group = {}; stroke_group = {};
subject_idx = {};
for data_row = 1 : height(subject_data_info)
    protocol = num2str(subject_data_info.protocol(data_row));
    subject_id = num2str(subject_data_info.subject_id(data_row));
    med_cond = subject_data_info.med_cond{data_row};
    experiment = subject_data_info.experiment{data_row};
    EDF_filename = subject_data_info.EDF_filename{data_row};

    subject_folder = [protocol '_' subject_id];     

    if strcmp(experiment, 'AO') == 1 & isempty(EDF_filename) == 0
        trials{end+1} = subject_folder ;
        if strcmp(med_cond, 'stroke') == 1
            stroke_group{end+1} = subject_folder;
        else
            healthy_group{end+1} = subject_folder;
        end
        subject_idx{end+1} = subject_id;
    end
end

origin_path = ['C:\Users\anhtn\OneDrive - PennO365\Documents\GitHub' ...
    '\AO_human_v_robot_main'];
filepath = [origin_path '\FloAim6_Data\datasets\'];

trial_groups = {healthy_group, stroke_group};
trial_group_labels = {'Healthy', 'Stroke'};

% trials = {'000-2','001', '002'};
% filepath = ['C:\Users\anhtn\OneDrive - PennO365\Documents\GitHub\' ...
%     'AO_human_v_robot_main\prelim_EEG\datasets\'];

output_plot_path = [filepath 'output' '\\'];

experiments = {'AO', 'AOE'};

markerLabel = ["human-left", "human-right", "robot-left", "robot-right", "control"];
markerColor = ["b", "#0072BD", "r",	"#A2142F", "#77AC30" ];
markerCurveStyle = ["-", "--", "-","--", "--" ];
markerSymbol = ["o", 'square', "diamond", "^", "."];
markerSize = 5;

actor_pair = {[1 2], [3 4]};
side_pair = {[1 3], [2 4]};
actor_pair_names = cell(1,2);
for i = 1:2
    actor_pair_names{i} = [markerLabel(actor_pair{i})];
end
side_pair_names = cell(1,2);
for i = 1:2
    side_pair_names{i} = [markerLabel(side_pair{i})];
end

chan_names = {'C3', 'C4'};

% central_elecs = {'C3', 'C4', 'Cz'};
central_elecs = {'C3', 'C4'};
occip_elecs = {'O1', 'O2', 'Oz'};
group_elecs = {central_elecs, occip_elecs};
group_elec_labels = {'central', 'occipital'};

% theta_band = {4:8};
% alpha_l_band = {8:10};
% alpha_h_band = {10:13};
% alpha_band = {8:13};
% beta_band = {13:30};
% freq_bands = [theta_band, alpha_band, beta_band];
% band_names = ["theta" "alpha" "beta"];
% band_colors = ["b","r","g"];
% freq_bands_bl = [theta_band,  alpha_band, beta_band];

band_names = ["mu" "beta"];

freqfac = 2;
freqrange = [4 30];
wavelet_cycles = [4 1-15.36/freqrange(2)]; % cite Angelini et al 2018
timesout = 800;

freqs = freqrange(1):1/freqfac:freqrange(2);

%========================================================
% AO params
AO_markerVal_string = {'10' '11' '12' '13' '14'...
    '20' '21' '22' '23' '24'...
    '30' '31' '32' '33' '34'...
    '40' '41' '42' '43' '44'...
    '50' '51' '52' };
AO_markerVal_cell = {{'10' '11' '12' '13' '14'}...
    {'20' '21' '22' '23' '24'}...
    {'30' '31' '32' '33' '34'}...
    {'40' '41' '42' '43' '44'}...
    {'50' '51' '52'} };
AO_markerVal_num = [10  11  12  13  14 ...
    20  21  22  23  24  ...
    30  31  32  33  34  ...
    40  41  42  43  44  ...
    50 51 52];

AO_expCondLabels = ["human-left", "human-right", "robot-left", "robot-right"];
AO_expCondMarkers = {{'10' '11' '12' '13' '14'},...
    {'20' '21' '22' '23' '24'},...
    {'30' '31' '32' '33' '34'},...
    {'40' '41' '42' '43' '44'}};

AO_trial_t_range = [-3 4.5];
AO_tlimits = [-2 4.5];
AO_baseline = [-1 0];
% AO_baseline = [-1.4 -1];

AO_tf_params = {'timesout', timesout, 'baseline', AO_baseline * 1000, 'scale', 'log',...
    'nfreqs', length(freqrange(1):1/freqfac:freqrange(2)), ...
    'freqs', freqrange, 'freqscale', 'linear',...
    'alpha', 0.05, 'erspmax', 2.5, 'vert', [-1000 0 1000], ...
    'plotitc', 'off', 'plotersp', 'off', 'trialbase', 'off',...
    'verbose', 'off', 'newfig', 'off'};

AO_tf_params_no_bl = {'timesout', timesout, 'baseline', NaN, 'scale', 'log',...
    'nfreqs', length(freqrange(1):1/freqfac:freqrange(2)), ...
    'freqs', freqrange, 'freqscale', 'linear',...
    'erspmax', 2.5, 'vert', [-1000 0 1000], 'plotphase', 'off', ...
    'plotitc', 'off', 'plotersp', 'on', 'trialbase', 'off',...
    'verbose', 'off', 'newfig', 'off'};

%========================================================
% AE params
AE_markerVal_string = {'110' '111' '112' '113' '114'...
    '120' '121' '122' '123' '124'...
    '130' '131' '132' '133' '134'...
    '140' '141' '142' '143' '144' };


AE_markerVal_cell = {{'110' '111' '112' '113' '114'}...
    {'120' '121' '122' '123' '124'}...
    {'130' '131' '132' '133' '134'}...
    {'140' '141' '142' '143' '144'} };

AE_markerVal_num = [110  111  112  113  114 ...
    120  121  122  123  124  ...
    130  131  132  133  134  ...
    140  141  142  143  144 ];

AE_expCondLabels = ["human-right", "human-left", "robot-right", "robot-left"];
AE_expCondMarkers = {{'110' '111' '112' '113' '114'},...
    {'120' '121' '122' '123' '124'},...
    {'130' '131' '132' '133' '134'},...
    {'140' '141' '142' '143' '144'}};

AE_trial_t_range = [-1 3.5];
AE_tlimits = [-1 3.5];
AE_baseline = [-1 0];

AE_tf_params = {'timesout', timesout, 'baseline', AE_baseline * 1000, 'scale', 'log',...
    'nfreqs', length(freqrange(1):1/freqfac:freqrange(2)), ...
    'freqs', freqrange, 'freqscale', 'linear',...
    'alpha', 0.05, 'erspmax', 2.5, 'vert', [-1000 0], ...
    'plotitc', 'off', 'plotersp', 'off', 'trialbase', 'off',...
    'verbose', 'off', 'newfig', 'off'};


%=================================================
% Create cells contain all EEG and ERSP for each subject, each experiment (AO/AE), each channel
% Save these cells 
% Or Load them if they exist already

if exist([filepath '\ALLEEG_trial.mat'], 'file') ~= 2
    ALLEEG_trial = {};
    ALL_ERSP_trial = {};
    times_exp_cell = {};

    for trial_N = 1:length(trials)
        disp(['*** Subject: ' trials{trial_N}]);

        ersp_exp_all = cell(length(chan_names), length(experiments));
        ALLEEG_exp = {};

        for exp=1:length(experiments)
            filename = [trials{trial_N} '-' experiments{exp} '-preprocessed.set'];
            ALLEEG_exp{exp} = pop_loadset('filename', filename, 'filepath', filepath);
        end

        %-------------------------------
        % AO
        exp = 1;
        EEG_exp = ALLEEG_exp{exp};
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
        %-------------------------------
        % AE
        exp = 2;
        EEG_exp = ALLEEG_exp{exp};
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
        ALLEEG_trial{trial_N} = ALLEEG_exp;
        ALL_ERSP_trial{trial_N} = ersp_exp_all;      
    end

    times_exp_cell{1} = AO_times;
    times_exp_cell{2} = AE_times;
    
    % save to .mat file
    save([filepath '\ALLEEG_trial.mat'], "ALLEEG_trial")
    save([filepath '\ALL_ERSP_trial.mat'], "ALL_ERSP_trial")
    save([filepath '\times_exp.mat'], "times_exp_cell")

else
    ALLEEG_trial = load([filepath '\ALLEEG_trial.mat'], '-mat');
    ALL_ERSP_trial = load([filepath '\ALL_ERSP_trial.mat'], '-mat');
    times_exp_cell = load([filepath '\times_exp.mat'], '-mat');

    ALLEEG_trial = ALLEEG_trial.ALLEEG_trial;
    ALL_ERSP_trial = ALL_ERSP_trial.ALL_ERSP_trial;
    times_exp_cell = times_exp_cell.times_exp_cell;
end



% ALL_ERSP_trial is a 1xN cell (N subjects)
% each cell element is a 2x2 cell (columns are AO and AE, rows are C3 and C4)
% each smaller cell has n double matrices of ERSP (n = # of conditions, n=5 for AO and n=4 for AE)
% for each ERSP matrix, row is frequency and column is times



%--------------------------------------------------------------------------
exp = 1;
AO_times = times_exp_cell{exp};
exp = 2;
AE_times = times_exp_cell{exp};

AO_onset_times = 1000;
AE_onset_times = 0;
window_size = 250;
% find the indices of time points lying within consecutive time windows of 250 seconds  
AO_window_idx = extract_window_indices_wbl(AO_times, AO_onset_times, window_size, AO_baseline*1000);
AE_window_idx = extract_window_indices_wbl(AE_times, AE_onset_times, window_size, AE_baseline*1000);

%--------------------------------------
AO_alpha_band = 7.5:0.5:13.5;
AO_beta_band = 17:0.5:24;
AO_bands = {AO_alpha_band, AO_beta_band};

AE_alpha_band = 9:0.5:13;
AE_beta_band = 19:0.5:24;
AE_bands = {AE_alpha_band, AE_beta_band};