clear all;
eeglab;
close all;

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


ALLEEG_a = cell(1,3);
for i=1:length(trials)
    filename = [trials{i} '-preprocessed.set']; % manually type to select dataset
    ALLEEG_a{i} = pop_loadset('filename', filename, 'filepath', filepath);
end

trial_N = 2;
EEG_a = ALLEEG_a{trial_N};
% plot_folder = ['plot-' trials(trial_N) '\\' ];
output_plot_path = [filepath 'output' '\\'];

%========================================================
% Parameters
trial_t_range = [-3 4.5];

markerVal_string = {'10' '11' '12' '13' '14'...
    '20' '21' '22' '23' '24'...
    '30' '31' '32' '33' '34'...
    '40' '41' '42' '43' '44'...
    '50' '51' '52' };
markerVal_cell = {{'10' '11' '12' '13' '14'}...
    {'20' '21' '22' '23' '24'}...
    {'30' '31' '32' '33' '34'}...
    {'40' '41' '42' '43' '44'}...
    {'50' '51' '52'} };
markerVal_num = [10  11  12  13  14 ...
    20  21  22  23  24  ...
    30  31  32  33  34  ...
    40  41  42  43  44  ...
    50 51 52];
markerLabel = ["human-left", "human-right", "robot-left", "robot-right", "control"];
markerColor = ["b", "b", "r","r", "k" ];
markerCurveStyle = ["-", "--", "-","--", "-" ];



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
theta_band = {4:8};
alpha_l_band = {8:10};
alpha_h_band = {10:13};
alpha_band = {8:13};
beta_band = {13:30};

freq_bands = [theta_band, alpha_band, beta_band];
band_names = ["theta" "alpha" "beta"];
band_colors = ["b","r","g"];
freq_bands_bl = [theta_band,  alpha_band, beta_band];

freqfac = 2;
freqrange = [4 30];
wavelet_cycles = [4 1-15.36/freqrange(2)]; % cite Angelini et al 2018
timesout = 800;
tlimits = [-2 4.5];
% baseline = [-1.4 -1];
baseline = [-1 0];

tf_params = {'timesout', timesout, 'baseline', baseline * 1000, 'scale', 'log',...
    'nfreqs', length(freqrange(1):1/freqfac:freqrange(2)), ...
    'freqs', freqrange, 'freqscale', 'linear',...
    'alpha', 0.05, 'erspmax', 2.5, 'vert', [-1000 0 1000], ...
    'plotitc', 'off', 'plotersp', 'on', 'trialbase', 'off',...
    'verbose', 'off', 'newfig', 'off'};

%=================================================================
ersp_cond_all = cell(length(chan_names), length(trials));
ersp_average_cond = cell(length(chan_names), length(trials));

for chan = 1:length(chan_names)
    disp(['*** Channel: ' chan_names{chan}]);


    for trial_N = 1:length(trials)
        disp(['*** Subject: ' trials{trial_N}]);
        EEG_a = ALLEEG_a{trial_N};
        EEG_chan = pop_select( EEG_a, 'channel', chan_names(chan));

        fig_subj = figure(); t = tiledlayout(3,2);
        title(t, ['Subject ' subject_idx{trial_N} ', channel ' chan_names{chan}])

        ersp_cond_cell = cell(1,length(markerVal_cell));

        for cond_idx = 1:length(markerLabel)
            disp(['*** Condition: ' char(markerLabel(cond_idx))]);

            EEG_cond = pop_epoch(EEG_chan, markerVal_cell{cond_idx}, trial_t_range, ...
                'verbose', 'off');
            disp(['*** Number of trials in this condition: ', num2str(size(EEG_cond.epoch, 2)) ]);

            nexttile(t); hold on
            title([char(markerLabel(cond_idx)) ' (n=' num2str(size(EEG_cond.epoch, 2)) ')' ]);
            [ersp,~,~,times,freqs,erspboot] = ...
                pop_newtimef(EEG_cond, 1, 1, tlimits*1000, wavelet_cycles, tf_params{:});
            hold off
            ersp_cond_cell{cond_idx} = ersp;
        end
        ersp_cond_all(chan, trial_N) = {ersp_cond_cell};

        EEG_cond = pop_epoch(EEG_chan, markerVal_string(1:20), trial_t_range, ...
            'verbose', 'off');
        nexttile(t); hold on
        title('average across conditions');
        [ersp,~,~,times,freqs] = ...
            pop_newtimef(EEG_cond, 1, 1, tlimits*1000, wavelet_cycles, tf_params{:});
        hold off;
        ersp_average_cond{chan, trial_N} = ersp;

        % save figure
        % saveas(fig_subj, [filepath 'figures\' trials{trial_N} '-' chan_names{chan} ' - ERSP' '.png']);

    end
end

%=======================================================
% 4 subgroups: motor function - cog/language function
% low motor - high speech-language | high motor - high speech-language
%----------------------------------|-----------------------------------
% low motor - low speech-language  | high motor - low speech-language

% LM-HS | HM-HS
%-------|------
% LM-LS | HM-LS

% Collected sample Aug 28, 2024: N = 6
% LM-HS (n=1) | HM-HS (n=5)
%-------------|------------
% LM-LS (n=0) | HM-LS (n=0)

lmhs_trial_N = {4};
hmhs_trial_N = {};

for i = 1:length(trials)
    for j = 1:length(lmhs_trial_N)
        if ~strcmp(trials{i}, trials{lmhs_trial_N{j}})
            hmhs_trial_N{end+1} = i;
        end
    end
end

%================================================================
% For HM-HS group: n=5 (update Aug 28, 2024)
% Average ersp across all subjects, for each channel and each condition

ersp_average_all = zeros(size(ersp_cond_all{1,1}{1}));
count_average_all = 0;
for chan = 1:length(chan_names)
    fig = figure(); t = tiledlayout(3,2);
    title(t, ['Average across healthy subjects, channel ' chan_names{chan}]);

    for cond_idx = 1:length(markerLabel)
        nexttile(t); hold on
        title([markerLabel{cond_idx}]);

        ersp_average_subj = zeros(size(ersp_cond_all{1,1}{1}));
        for i = 1:length(hmhs_trial_N)
            ersp_cond_cell = ersp_cond_all{chan, hmhs_trial_N{i}}{cond_idx};
            ersp_average_subj = ersp_average_subj + ersp_cond_cell;

            if cond_idx ~= 5
                ersp_average_all = ersp_average_all + ersp_cond_cell;
                count_average_all = count_average_all + 1;
            end
        end

        ersp_average_subj = ersp_average_subj / length(hmhs_trial_N);
        imagesc(times, freqs, ersp_average_subj)
        axis xy; colormap(jet(256)); clim([-2 2])
        h = colorbar; title(h, "ERSP (dB)", 'FontSize', 8)
        xlabel('Time (ms)'); ylabel('Frequency (Hz)');
        xlim([min(times) max(times)]); ylim([min(freqs) max(freqs)])
        xline(0, '--m'); xline(1000, '--m'); xline(-1000, '--m')
        yline(8, '--k'); yline(13, '--k')
        hold off;
    end
    saveas(fig, [filepath 'figures\' 'AO - Average across HMHS subjects - channel ' chan_names{chan} '.png']);
end

ersp_average_all = ersp_average_all / count_average_all;


% grand average ERSP plot:
% average ersp during AO across all conditions, subjects, channels
fig = figure(); hold on
title('Average across healthy subjects, channels, conditions');
imagesc(times, freqs, ersp_average_all)
axis xy; colormap(jet(256)); clim([-2 2])
h = colorbar; title(h, "ERSP (dB)", 'FontSize', 8)
xlabel('Time (ms)'); ylabel('Frequency (Hz)');
xlim([min(times) max(times)]); ylim([min(freqs) max(freqs)])
xline(0, '--m'); xline(1000, '--m'); xline(-1000, '--m')
yline(8, '--k'); yline(13, '--k'); yline(17, '--k'); yline(24, '--k');
hold off

saveas(fig, [filepath 'figures\' 'AO - Average across HMHS subjects channels, conditions' '.png']);






% ==================================================
%================================================================
% For LM-HS group: n=1
% Average ersp across all subjects, for each channel and each condition

ersp_average_all = zeros(size(ersp_cond_all{1,1}{1}));
count_average_all = 0;
for chan = 1:length(chan_names)
    fig = figure(); t = tiledlayout(3,2);
    % title(t, ['Average across LMHS subjects, channel ' chan_names{chan}]);

    title(t, ['Stroke subject, channel ' chan_names{chan}]);

    for cond_idx = 1:length(markerLabel)
        nexttile(t); hold on
        title([markerLabel{cond_idx}]);

        ersp_average_subj = zeros(size(ersp_cond_all{1,1}{1}));
        for i = 1:length(lmhs_trial_N)
            ersp_cond_cell = ersp_cond_all{chan, lmhs_trial_N{i}}{cond_idx};
            ersp_average_subj = ersp_average_subj + ersp_cond_cell;

            if cond_idx ~= 5
                ersp_average_all = ersp_average_all + ersp_cond_cell;
                count_average_all = count_average_all + 1;
            end
        end

        ersp_average_subj = ersp_average_subj / length(lmhs_trial_N);
        imagesc(times, freqs, ersp_average_subj)
        axis xy; colormap(jet(256)); clim([-2 2])
        h = colorbar; title(h, "ERSP (dB)", 'FontSize', 8)
        xlabel('Time (ms)'); ylabel('Frequency (Hz)');
        xlim([min(times) max(times)]); ylim([min(freqs) max(freqs)])
        xline(0, '--m'); xline(1000, '--m'); xline(-1000, '--m')
        yline(8, '--k'); yline(13, '--k')
        hold off;
    end
    saveas(fig, [filepath 'figures\' 'AO - stroke subject, Average across channels ' chan_names{chan} '.png']);
end

ersp_average_all = ersp_average_all / count_average_all;


% grand average ERSP plot:
% average ersp during AO across all conditions, subjects, channels
fig = figure(); hold on
title('Stroke subject, averaged across channels, conditions');
imagesc(times, freqs, ersp_average_all)
axis xy; colormap(jet(256)); clim([-2 2])
h = colorbar; title(h, "ERSP (dB)", 'FontSize', 8)
xlabel('Time (ms)'); ylabel('Frequency (Hz)');
xlim([min(times) max(times)]); ylim([min(freqs) max(freqs)])
xline(0, '--m'); xline(1000, '--m'); xline(-1000, '--m')
yline(8, '--k'); yline(13, '--k'); yline(17, '--k'); yline(24, '--k');
hold off

saveas(fig, [filepath 'figures\' 'AO - stroke subject, average across channels, conditions' '.png']);



%==================================================
% Calculate mean ERD/S over time for each freq band for each subgroup


setup_AOE

AO_alpha_band = 7.5:0.5:13.5;
AO_beta_band = 17:0.5:24;
AO_bands = {AO_alpha_band, AO_beta_band};

AE_alpha_band = 9:0.5:13;
AE_beta_band = 19:0.5:24;
AE_bands = {AE_alpha_band, AE_beta_band};

AO_onset_times = 1000;
AE_onset_times = 0;

% For HMHS group:
hmhs_fig = figure; t0 = tiledlayout(2,5);
title(t0, ['Healthy group - C3(top row) & C4(bottom row)'])


for chan = 1:length(chan_names)
    exp = 1;
    AO_times = times_exp_cell{exp};

    
    for cond = 1:length(AO_markerVal_cell)
        nexttile(t0);
        group_mean_ersp = [0; 0];

        all_mean_ersp = [];
        for i = 1:length(hmhs_trial_N)
            ersp_exp_all = ALL_ERSP_trial{hmhs_trial_N{i}};
            ersp = ersp_exp_all{chan, exp}{cond};

            AO_onset_idx = find(AO_times >= AO_onset_times);



            AO_ersp_mean_band = zeros(length(AO_bands), length(AO_onset_idx));
            for band = 1:length(AO_bands)
                AO_ersp_mean_band(band, :) = mean(ersp(freqs >= AO_bands{band}(1) & freqs <= AO_bands{band}(end), AO_onset_idx) );

            end

            mean_ersp = mean(AO_ersp_mean_band, 2);
            group_mean_ersp = group_mean_ersp + mean_ersp;
            % std_ersp = std(AO_ersp_mean_band, 0, 2);

            all_mean_ersp = [all_mean_ersp mean_ersp];


        end
        group_mean_ersp = group_mean_ersp / length(hmhs_trial_N);
        std_group_mean_ersp = std(all_mean_ersp,0, 2);
        % plot
        bar(group_mean_ersp, 'w');
        hold on
        errorbar(1:numel(group_mean_ersp), group_mean_ersp', std_group_mean_ersp', 'k', 'LineWidth', 1.5, 'linestyle', 'none');
        % hold off
        ylim([-3 1.5])
        xticks(1:numel(group_mean_ersp)); % Set the tick locations
        xticklabels(band_names); % Set the tick labels
        % xlabel('Frequency bands');
        ylabel('Grand mean ERD/S (dB)');
        title([ markerLabel{cond}]);
    end
end
saveas(hmhs_fig, [filepath 'figures\' 'AO - Mean ERD-S across healthy subjects for each channel, condition, band' '.png']);

%-------------------------------------------------------
% For LMHS group:
lmhs_fig = figure; t0 = tiledlayout(2,5);
% title(t0, ['LMHS subjects - C3(top row) & C4(bottom row)'])
title(t0, ['Stroke subject - C3(top row) & C4(bottom row)'])

for chan = 1:length(chan_names)
    exp = 1;
    AO_times = times_exp_cell{exp};

    
    for cond = 1:length(AO_markerVal_cell)
        nexttile(t0);
        group_mean_ersp = [0; 0];
        all_mean_ersp = [];

        for i = 1:length(lmhs_trial_N)
            ersp_exp_all = ALL_ERSP_trial{lmhs_trial_N{i}};
            ersp = ersp_exp_all{chan, exp}{cond};

            AO_onset_idx = find(AO_times >= AO_onset_times);



            AO_ersp_mean_band = zeros(length(AO_bands), length(AO_onset_idx));
            for band = 1:length(AO_bands)
                AO_ersp_mean_band(band, :) = mean(ersp(freqs >= AO_bands{band}(1) & freqs <= AO_bands{band}(end), AO_onset_idx) );

            end

            mean_ersp = mean(AO_ersp_mean_band, 2);
            group_mean_ersp = group_mean_ersp + mean_ersp;
            % std_ersp = std(AO_ersp_mean_band, 0, 2);

            all_mean_ersp = [all_mean_ersp mean_ersp];


        end
        group_mean_ersp = group_mean_ersp / length(lmhs_trial_N);
        std_group_mean_ersp = std(all_mean_ersp,0, 2);
        % plot
        bar(group_mean_ersp, 'w');
        hold on
        errorbar(1:numel(group_mean_ersp), group_mean_ersp', std_group_mean_ersp', 'k', 'LineWidth', 1.5, 'linestyle', 'none');
        % hold off
        ylim([-3 1.5])
        xticks(1:numel(group_mean_ersp)); % Set the tick locations
        xticklabels(band_names); % Set the tick labels
        % xlabel('Frequency bands');
        ylabel('Grand mean ERD/S (dB)');
        title([ markerLabel{cond}]);
    end
end

saveas(lmhs_fig, [filepath 'figures\' 'AO - Mean ERD-S across stroke subjects for each channel, condition, band' '.png']);





