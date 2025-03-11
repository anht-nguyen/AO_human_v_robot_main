% clear all;
eeglab; 
% close all;

% trials = {'000-2-AOE','001-AOE', '002-AOE' };
% 
% filepath = ['C:\Users\anhtn\OneDrive - PennO365\Documents\GitHub\' ...
%     'AO_human_v_robot_main\prelim_EEG\datasets\'];

%%

subject_data_info = readtable("subject_data_info.xlsx");
trials = {};
subject_idx = {};
for data_row = 1 : height(subject_data_info)
    protocol = num2str(subject_data_info.protocol(data_row));
    subject_id = num2str(subject_data_info.subject_id(data_row));
    experiment = subject_data_info.experiment{data_row};
    EDF_filename = subject_data_info.EDF_filename{data_row};

    subject_folder = [protocol '_' subject_id '-AOE'];

    if strcmp(experiment, 'AOE') == 1 & isempty(EDF_filename) == 0
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


% ========================================================
% Parameters

markerVal_string = {'110' '111' '112' '113' '114'...
    '120' '121' '122' '123' '124'...
    '130' '131' '132' '133' '134'...
    '140' '141' '142' '143' '144' };
trial_t_range = [-1 4];

markerVal_cell = {{'110' '111' '112' '113' '114'}...
    {'120' '121' '122' '123' '124'}...
    {'130' '131' '132' '133' '134'}...
    {'140' '141' '142' '143' '144'} };

markerVal_num = [110  111  112  113  114 ...
   120  121  122  123  124  ...
   130  131  132  133  134  ...
   140  141  142  143  144 ];

markerLabel = ["human-left", "human-right", "robot-left", "robot-right"];
markerColor = ["b", "b", "r","r" ];
markerCurveStyle = ["-", "--", "-","--" ];

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
tlimits = [-1 4];
baseline = [-1 0];

tf_params = {'timesout', timesout, 'baseline', baseline * 1000, 'scale', 'log',...
                'nfreqs', length(freqrange(1):1/freqfac:freqrange(2)), ...
                'freqs', freqrange, 'freqscale', 'linear',...
                'alpha', 0.05, 'erspmax', 2.5, 'vert', [-1000 0], ...
                'plotitc', 'off', 'plotersp', 'on', 'trialbase', 'off',...
                'verbose', 'off', 'newfig', 'off'};

setup_AOE

%% =================================================
ersp_cond_all = cell(length(chan_names), length(trials));
ersp_average_cond = cell(length(chan_names), length(trials));

for chan = 1:length(chan_names)
    disp(['*** Channel: ' chan_names{chan}]);
    
    
    for trial_N = 4 %1:length(trials)
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
            % title([char(markerLabel(cond_idx)) ' (n=' num2str(size(EEG_cond.epoch, 2)) ')' ]);
            title(AE_expCondLabels{cond_idx})
            [ersp,~,~,times,freqs] = ...
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
        saveas(fig_subj, [filepath 'figures\' trials{trial_N} '-' chan_names{chan} ' - ERSP' '.png']);
    end
end

%================================================================
% Average ersp across all subjects, for each channel and each condition

ersp_average_all = zeros(size(ersp_cond_all{1,1}{1}));
count_average_all = 0;
for chan = 1:length(chan_names)
    fig = figure(); t = tiledlayout(3,2);
    title(t, ['Average across all subjects, channel ' chan_names{chan}]);

    for cond_idx = 1:length(markerLabel)
        nexttile(t); hold on
        title([markerLabel{cond_idx}]);
        
        ersp_average_subj = zeros(size(ersp_cond_all{1,1}{1}));
        for trial_N = 1:length(trials)
            ersp_cond_cell = ersp_cond_all{chan, trial_N}{cond_idx};
            ersp_average_subj = ersp_average_subj + ersp_cond_cell; 

            if cond_idx ~= 5
                ersp_average_all = ersp_average_all + ersp_cond_cell;
                count_average_all = count_average_all + 1;
            end
        end

        ersp_average_subj = ersp_average_subj / length(trials);
        imagesc(times, freqs, ersp_average_subj)
        axis xy; colormap(jet(256)); clim([-2 2])
        h = colorbar; title(h, "ERSP (dB)", 'FontSize', 8)
        xlabel('Time (ms)'); ylabel('Frequency (Hz)');
        xlim([min(times) max(times)]); ylim([min(freqs) max(freqs)])
        xline(0, '--m'); xline(-1000, '--m')
        yline(8, '--k'); yline(13, '--k')
        hold off;
    end
    saveas(fig, [filepath 'figures\' 'AOE - Average across all subjects - channel ' chan_names{chan} '.png']);
end

ersp_average_all = ersp_average_all / count_average_all;

%------------------------------------------------
% grand average ERSP plot: 
% average ersp during AOE across all conditions, subjects, channels

fig = figure(); hold on
title('Average across all subjects, channels, conditions');
imagesc(times, freqs, ersp_average_all)
axis xy; colormap(jet(256)); clim([-2 2])
h = colorbar; title(h, "ERSP (dB)", 'FontSize', 8)
xlabel('Time (ms)'); ylabel('Frequency (Hz)');
xlim([min(times) max(times)]); ylim([min(freqs) max(freqs)])
xline(0, '--m'); xline(-1000, '--m')
yline(9, '--k'); yline(13, '--k'); yline(19, '--k'); yline(24, '--k');
hold off

% saveas(fig, [filepath 'figures\' 'AOE - Average across all subjects channels, conditions' '.png']);

% The grand average show ERD in alpha band (8-13Hz) and beta band (19-24Hz)

%==================================================


%% Plot data grouped by 4 experimental conditions (collapsing central electrodes, grouping healthy and stroke subj)
% Plot ERSPs

trial_group_erd_tw_mean = zeros([length(trial_groups) length(AE_expCondMarkers) length(AE_window_idx)]);
trial_group_erd_tw_std = zeros([length(trial_groups) length(AE_expCondMarkers) length(AE_window_idx)]);

trial_erd_tw_mean_group = zeros([length(trial_groups) length(AE_expCondMarkers) length(AE_window_idx)]);
trial_erd_tw_std_group = zeros([length(trial_groups) length(AE_expCondMarkers) length(AE_window_idx)]);

for trial_group_i = 1:length(trial_groups)

    allersp_group = cell(length(trial_groups{trial_group_i}), length(AE_expCondMarkers));

    for trial_idx = 1:length(trial_groups{trial_group_i})
        disp(['*** Subject: ' trial_groups{trial_group_i}{trial_idx}])
        
        filename = [trial_groups{trial_group_i}{trial_idx} '-AOE' '-preprocessed.set']; % manually type to select dataset
        EEG_a = pop_loadset('filename', filename, 'filepath', filepath);

        for cond_group_i = 1:length(AE_expCondMarkers)
            EEG_cond = pop_epoch(EEG_a, AE_expCondMarkers{cond_group_i}, trial_t_range, ...
                'verbose', 'off');
            EEG_cond = pop_select( EEG_cond, 'channel', central_elecs);


            for elec_i = 1:EEG_cond.nbchan
                disp(['*** Electrod: ' central_elecs{elec_i}])
                % figure();
                [ersp,itc,powbase,times,freqs,erspboot,itcboot] = pop_newtimef(EEG_cond, ...
                    1, elec_i, tlimits*1000, wavelet_cycles,  tf_params{:}, ...
                    'plotersp', 'off', 'plotitc', 'off', 'plotphase', 'off');

                if elec_i == 1  % create empty arrays if first electrode
                    allersp = zeros([ size(ersp) EEG_cond.nbchan]);
                    alltimes = zeros([ size(times) EEG_cond.nbchan]);
                    allfreqs = zeros([ size(freqs) EEG_cond.nbchan]);
                    allerspboot = zeros([ size(erspboot) EEG_cond.nbchan]);
                end
                allersp (:,:,elec_i) = ersp;
                alltimes (:,:,elec_i) = times;
                allfreqs (:,:,elec_i) = freqs;
                allerspboot (:,:,elec_i) = erspboot;
            end
            averaged_ersp = mean(allersp, 3);

            allersp_group{trial_idx, cond_group_i} = averaged_ersp;
        end

    end

    % Compute the average
    fig_subj = figure();
    nRows = 2; nCols = 2;
    t_main = tiledlayout(nRows, nCols);
    title(t_main, [ trial_group_labels{trial_group_i} ' group - ERSP' ])


    averaged_allersp_group = cell(1, length(AE_expCondMarkers));
    for col = 1:4
        % Concatenate the matrices along the 3rd dimension
        mat3D = cat(3, allersp_group{:,col});
        % Compute the mean along the 3rd dimension (across the 7 rows)
        averaged_allersp_group{col} = mean(mat3D, 3);

        nexttile(t_main); hold on
        title(AE_expCondLabels{col})
        imagesc(times, freqs, averaged_allersp_group{col} )
        axis xy; colormap(jet(256)); clim([-3 3])
        h = colorbar; title(h, "ERSP (dB)", 'FontSize', 8)
        xlabel('Time (ms)'); ylabel('Frequency (Hz)');
        xlim([min(times) max(times)]); ylim([min(freqs) max(freqs)])
        xline(0, '--m'); xline(-1000, '--m')
        yline(8, '--k'); yline(13, '--k')
        hold off;
    end


    % plot temporal patterns of mu ERD
    % mean_erd_cell = cell(length(AE_expCondMarkers), length(AE_window_idx) );
    % std_erd_cell = cell(length(AE_expCondMarkers), length(AE_window_idx) );
    for cond_group_i = 1:length(AE_expCondMarkers)
        ersp = averaged_allersp_group{cond_group_i};

        for tw = 1:length(AE_window_idx)
            ersp_mu_tw = ersp(freqs >= AE_alpha_band(1) & freqs <= AE_alpha_band(end), AE_window_idx{tw});
            trial_group_erd_tw_mean(trial_group_i, cond_group_i, tw) = mean(ersp_mu_tw, "all") ;
            trial_group_erd_tw_std(trial_group_i, cond_group_i, tw) = std(ersp_mu_tw, 0, "all") ;
        end


    end


    % compute ERD by time windows for each subject (before averaging across subjects)
    trial_erd_tw_mean = zeros([length(trial_groups{trial_group_i}) length(AE_expCondMarkers) length(AE_window_idx)]);
    for trial_idx = 1:length(trial_groups{trial_group_i})
        for cond_group_i = 1:length(AE_expCondMarkers)
            ersp = allersp_group{trial_idx, cond_group_i};
    
            for tw = 1:length(AE_window_idx)
                ersp_mu_tw = ersp(freqs >= AE_alpha_band(1) & freqs <= AE_alpha_band(end), AE_window_idx{tw});
                trial_erd_tw_mean(trial_idx, cond_group_i, tw) = mean(ersp_mu_tw, "all") ;

            end
        end
    end

    trial_erd_tw_mean_group(trial_group_i, :, :) = mean(trial_erd_tw_mean, 1);
    trial_erd_tw_std_group(trial_group_i, :, :) = std(trial_erd_tw_mean, 0, 1);
end

%%
x_shift= [-0.1 0];

markerColor_new = {"b", "r" };
markerCurveStyle_new = ["-", "-", ];
markerSymbol_new = ["o", "*"];

fig_subj = figure();
nRows = 2; nCols = 2;
t_main = tiledlayout(nRows, nCols);
title(t_main, [ 'Temporal patterns' ])


x = 0:numel(AE_window_idx)-1;
lines = [];
for cond_group_i = 1:length(AE_expCondMarkers)

    nexttile(t_main); hold on
    title(AE_expCondLabels{cond_group_i})

    for trial_group_i = 1:length(trial_groups)
        mean_vector = trial_group_erd_tw_mean(trial_group_i, cond_group_i, :);
        std_vector = trial_group_erd_tw_std(trial_group_i, cond_group_i,:);
        mean_vector = mean_vector(:); std_vector = std_vector(:);

        % p = errorbar(x+x_shift(trial_group_i), mean_vector, std_vector, ...
        %     "Marker", markerSymbol_new(trial_group_i), 'Color',markerColor_new{trial_group_i}, ...
        %     "LineStyle", markerCurveStyle_new(trial_group_i),"MarkerSize", markerSize, ...
        %     "DisplayName", trial_group_labels{trial_group_i});

         % Compute the shaded region (mean ± std)
        x_fill = [x, fliplr(x)];
        y_fill = [mean_vector + std_vector; flipud(mean_vector - std_vector)];

        % Plot the shaded area
        fill(x_fill, y_fill, markerColor_new{trial_group_i}, 'FaceAlpha', 0.3, 'EdgeColor', 'none');

        % Plot the mean line
        p = plot(x, mean_vector, "LineStyle", markerCurveStyle_new(trial_group_i), ...
            "Marker", markerSymbol_new(trial_group_i), 'Color', markerColor_new{trial_group_i}, ...
            "MarkerSize", markerSize, "DisplayName", trial_group_labels{trial_group_i});
        if cond_group_i == 1
            lines = [lines p];
        end
    end
    xticks(x);
    xlim([x(1)-.5 x(end)+.5]); ylim([-4.5 4.5])
    xregion(-0.5, 0.5, FaceColor="k", FaceAlpha=0.1); xregion(0.5, x(end)+.5, FaceColor="w", FaceAlpha=0.2)
    xlabel('Time windows (250 ms)');
    ylabel('ERSP (dB)'); yline(0, 'k--', 'Alpha', 0.5)

    hold off
end
% Place the legend at the bottom (south) of the tiledlayout
lgd = legend(lines);  % Only show the legend for the two unique lines
lgd.Layout.Tile = 'south';  % Place the legend at the bottom (south)
lgd.Orientation = 'horizontal';  % Make the legend items appear side by side


%% %% Temporal pattern plot: mean and std of ERDs across subjects
x_shift= [-0.1 0];

markerColor_new = {"b", "r" };
markerCurveStyle_new = ["-", "-", ];
markerSymbol_new = ["o", "*"];

fig_subj = figure();
nRows = 2; nCols = 2;
t_main = tiledlayout(nRows, nCols);
title(t_main, [ 'Temporal patterns' ])


x = 0:numel(AE_window_idx)-1;
lines = [];
for cond_group_i = 1:length(AE_expCondMarkers)

    nexttile(t_main); hold on
    title(AE_expCondLabels{cond_group_i})

    for trial_group_i = 1:length(trial_groups)
        mean_vector = trial_erd_tw_mean_group(trial_group_i, cond_group_i, :);
        std_vector = trial_erd_tw_std_group(trial_group_i, cond_group_i,:);
        mean_vector = mean_vector(:); std_vector = std_vector(:);

         % Compute the shaded region (mean ± std)
        x_fill = [x, fliplr(x)];
        y_fill = [mean_vector + std_vector; flipud(mean_vector - std_vector)];

        % Plot the shaded area
        fill(x_fill, y_fill, markerColor_new{trial_group_i}, 'FaceAlpha', 0.3, 'EdgeColor', 'none');

        % Plot the mean line
        p = plot(x, mean_vector, "LineStyle", markerCurveStyle_new(trial_group_i), ...
            "Marker", markerSymbol_new(trial_group_i), 'Color', markerColor_new{trial_group_i}, ...
            "MarkerSize", markerSize, "DisplayName", trial_group_labels{trial_group_i});
        if cond_group_i == 1
            lines = [lines p];
        end
    end
    xticks(x);
    xlim([x(1)-.5 x(end)+.5]); ylim([-6 6])
    xregion(-0.5, 0.5, FaceColor="k", FaceAlpha=0.1); xregion(0.5, x(end)+.5, FaceColor="w", FaceAlpha=0.2)
    xlabel('Time windows (250 ms)');
    ylabel('ERSP (dB)'); yline(0, 'k--', 'Alpha', 0.5)

    hold off
end
% Place the legend at the bottom (south) of the tiledlayout
lgd = legend(lines);  % Only show the legend for the two unique lines
lgd.Layout.Tile = 'south';  % Place the legend at the bottom (south)
lgd.Orientation = 'horizontal';  % Make the legend items appear side by side

