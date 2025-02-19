clear all;
eeglab;
close all;

%%
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

trial_idx = 2;
EEG_a = ALLEEG_a{trial_idx};
% plot_folder = ['plot-' trials(trial_idx) '\\' ];
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

setup_AOE


%% =================================================================
ersp_cond_all = cell(length(chan_names), length(trials));
ersp_average_cond = cell(length(chan_names), length(trials));

for chan = 1:length(chan_names)
    disp(['*** Channel: ' chan_names{chan}]);


    for trial_idx = 1:length(trials)
        disp(['*** Subject: ' trials{trial_idx}]);
        EEG_a = ALLEEG_a{trial_idx};
        EEG_chan = pop_select( EEG_a, 'channel', chan_names(chan));

        fig_subj = figure(); t = tiledlayout(3,2);
        title(t, ['Subject ' subject_idx{trial_idx} ', channel ' chan_names{chan}])

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
        ersp_cond_all(chan, trial_idx) = {ersp_cond_cell};

        % averaged ERSP of AO conditions (without control condition)
        EEG_cond = pop_epoch(EEG_chan, markerVal_string(1:20), trial_t_range, ...
            'verbose', 'off');
        nexttile(t); hold on
        title('average across conditions');
        [ersp,~,~,times,freqs] = ...
            pop_newtimef(EEG_cond, 1, 1, tlimits*1000, wavelet_cycles, tf_params{:});
        hold off;
        ersp_average_cond{chan, trial_idx} = ersp;

        % save figure
        saveas(fig_subj, [filepath 'figures\' trials{trial_idx} '-' chan_names{chan} ' - ERSP' '.png']);

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
        for trial_idx = 1:length(trials)
            ersp_cond_cell = ersp_cond_all{chan, trial_idx}{cond_idx};
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
        xline(0, '--m'); xline(1000, '--m'); xline(-1000, '--m')
        yline(8, '--k'); yline(13, '--k')
        hold off;
    end
    saveas(fig, [filepath 'figures\' 'AO - Average across all subjects - channel ' chan_names{chan} '.png']);
end

ersp_average_all = ersp_average_all / count_average_all;


% grand average ERSP plot:
% average ersp during AO across all conditions, subjects, channels
fig = figure(); hold on
title('Average across all subjects, channels, conditions');
imagesc(times, freqs, ersp_average_all)
axis xy; colormap(jet(256)); clim([-2 2])
h = colorbar; title(h, "ERSP (dB)", 'FontSize', 8)
xlabel('Time (ms)'); ylabel('Frequency (Hz)');
xlim([min(times) max(times)]); ylim([min(freqs) max(freqs)])
xline(0, '--m'); xline(1000, '--m'); xline(-1000, '--m')
yline(8, '--k'); yline(13, '--k'); yline(17, '--k'); yline(24, '--k');
hold off

saveas(fig, [filepath 'figures\' 'AO - Average across all subjects channels, conditions' '.png']);

% The grand average show ERD in alpha band (8-13Hz) and beta band (15-22Hz)

% Updated analysis: using baseline during fixation cross to be consistent
% with AE analysis, AO analysis of grand average shows ERD in beta band 17-24 Hz








%% =======================================================================
% % Correlation of ERSP between conditions for each subject and Plot Correlation
%
% f_c3corr = figure; axgrid = [3 4];
% tclMain = tiledlayout(4, 3, 'TileSpacing', 'loose', 'TileIndexing','columnmajor');
%
% freqs = 4:1/freqfac:30;
% for trial_idx = 1:3
%     % disp("S"+trial_idx)
%     ersp_mean_C3 = ersp_mean_C3_subj{trial_idx};
%     pairs = {[1 3], [2 4], [1 2], [3 4]};
%
%     for i=1:4
%         ersp_cond1 = ersp_mean_C3{pairs{i}(1)};
%         ersp_cond2 = ersp_mean_C3{pairs{i}(2)};
%         R_cond = corrcoef(ersp_cond1, ersp_cond2);
%
%         nexttile; %title("r="+num2str(round(R_cond(1,2), 3) ))
%         box on; grid on; hold on
%         for f = 1:3
%             plot(ersp_cond1(freqs >= freq_bands{f}(1) & freqs <= freq_bands{f}(end)), ersp_cond2( freqs >= freq_bands{f}(1) & freqs <= freq_bands{f}(end)), ...
%                 '.', 'Color',band_colors(f),  'MarkerSize', 5,'LineWidth', 0.7, 'DisplayName', band_names(f));
%         end
%         coeffs = polyfit(ersp_cond1,ersp_cond2,1);
%         h = refline(coeffs);
%         set(h, 'HandleVisibility','off')
%
%
%         ylabel(markerLabel(pairs{i}(2)));
%         xlabel(markerLabel(pairs{i}(1)));
%
%
%         text(-0.7,0.7, "r="+num2str(round(R_cond(1,2), 3) ) )
%         text(0.5,-0.7, "S"+trial_idx , 'FontWeight', 'bold')
%
%         xlim([-1 1]); ylim([-1 1]); xticks([-1 0 1]); yticks([-1 0 1]);
%         hold off
%     end
% end
%
%
% nexttile(5); legend('Location','northoutside','Orientation','horizontal')
%
% plotfilename = 'C3_corr';
% matlab2tikz('figurehandle',f_c3corr,'filename', [output_plot_path plotfilename '.tex'], ...
%     'extraAxisOptions',{'ylabel style={yshift=-10pt}','xlabel style={yshift=5pt}'})
%




%% plot ERSP of all available channels

%
%
% for trial_idx = 1 %:length(trials)
%     disp(['*** Subject: ' trials{trial_idx}]);
%     EEG_a = ALLEEG_a{trial_idx};
%     % chan_names = {'C3', 'C4'};
%     chan_names = {EEG_a.chanlocs.labels};
%     chan_all = chan_names;
%
%     % ersp_cond_all = cell(length(chan_names), length(trials));
%     % ersp_average_cond = cell(length(chan_names), length(trials));
%
%     fig_subj = figure(); t_main = tiledlayout(length(chan_names), 1);
%     title(t_main, ['Subject ' subject_idx{trial_idx} ])
%
%     for chan = 1:length(chan_names)
%         disp(['*** Channel: ' chan_names{chan}]);
%
%         EEG_chan = pop_select( EEG_a, 'channel', chan_names(chan));
%
%         t = tiledlayout(t_main, 1, 6);
%         title(t, [ 'channel ' chan_names{chan}])
%
%         t.Layout.Tile = chan;
%         t.Layout.TileSpan = [1 1];
%
%         % ersp_cond_cell = cell(1,length(markerVal_cell));
%
%         for cond_idx = 1:length(markerLabel)
%             disp(['*** Condition: ' char(markerLabel(cond_idx))]);
%
%             EEG_cond = pop_epoch(EEG_chan, markerVal_cell{cond_idx}, trial_t_range, ...
%                 'verbose', 'off');
%             disp(['*** Number of trials in this condition: ', num2str(size(EEG_cond.epoch, 2)) ]);
%
%             ax = nexttile(t); hold on
%             % plot(rand(5,(i)));
%             % title([char(markerLabel(cond_idx)) ' (n=' num2str(size(EEG_cond.epoch, 2)) ')' ]);
%             [ersp,~,~,times,freqs,erspboot] = ...
%                 pop_newtimef(EEG_cond, 1, 1, tlimits*1000, wavelet_cycles, tf_params{:}, ...
%                 'plotersp', 'off', 'plotitc', 'off');
%
%             % Now manually plot the ERSP in the selected axes (tile)
%             imagesc(ax, times, freqs, ersp); % Use imagesc to plot the ERSP data
%             set(ax, 'YDir', 'normal'); % Ensure the y-axis is displayed correctly
%             xlabel(ax, 'Time (ms)');
%             ylabel(ax, 'Frequency (Hz)');
%             title(ax, [char(markerLabel(cond_idx)) ' (n=' num2str(size(EEG_cond.epoch, 2)) ')' ]);
%             colormap(ax, jet);
%             % Set x-axis and y-axis limits to fit times and freqs
%             xlim(ax, [min(times), max(times)]);
%             ylim(ax, [min(freqs), max(freqs)]);
%
%             hold off;
%             %     % ersp_cond_cell{cond_idx} = ersp;
%         end
%         % ersp_cond_all(chan, trial_idx) = {ersp_cond_cell};
%
%         % averaged ERSP of AO conditions (without control condition)
%         EEG_cond = pop_epoch(EEG_chan, markerVal_string(1:20), trial_t_range, ...
%             'verbose', 'off');
%         ax = nexttile(t); hold on
%         % plot(rand(5,(i)));
%         title('average across conditions');
%         [ersp,~,~,times,freqs] = ...
%             pop_newtimef(EEG_cond, 1, 1, tlimits*1000, wavelet_cycles, tf_params{:}, ...
%             'plotersp', 'off', 'plotitc', 'off');
%
%         % Now manually plot the ERSP in the selected axes (tile)
%         imagesc(ax, times, freqs, ersp); % Use imagesc to plot the ERSP data
%         set(ax, 'YDir', 'normal'); % Ensure the y-axis is displayed correctly
%         xlabel(ax, 'Time (ms)');
%         ylabel(ax, 'Frequency (Hz)');
%         title(ax, 'Average ERSP across conditions');
%         colormap(ax, jet);
%         colorbar; % Add color bar to indicate ERSP values
%
%         % Apply the same color scaling (ERSP uses the minimum and maximum of the data)
%         caxis(ax, [-3.5, 3.5]);
%
%         % Set x-axis and y-axis limits to fit times and freqs
%         xlim(ax, [min(times), max(times)]);
%         ylim(ax, [min(freqs), max(freqs)]);
%
%         hold off;
%         % ersp_average_cond{chan, trial_idx} = ersp;
%
%         % save figure
%         % saveas(fig_subj, [filepath 'figures\' trials{trial_idx} '-' chan_names{chan} ' - ERSP' '.png']);
%
%     end
% end




%% plot ERSP of all available channels

% First, import the channel location table from the CSV file
output_file = [origin_path '\matlab\utility\channel_grid_locations.csv'];
channel_location_table = readtable(output_file);

for trial_idx = 1:length(trials)
    disp(['*** Subject: ' trials{trial_idx}]);
    EEG_a = ALLEEG_a{trial_idx};
    % chan_names = {'C3', 'C4'};
    chan_names = {EEG_a.chanlocs.labels};
    chan_all = chan_names;

    % Create the outer layout (size is arbitrary, adjust based on your needs)
    nRows = 7; % Number of rows in the layout
    nCols = 7; % Number of columns in the layout

    fig_subj = figure('Position', get(0, 'Screensize'));
    t_main = tiledlayout(nRows, nCols, 'TileSpacing', 'compact', 'Padding', 'compact');
    title(t_main, ['Subject ' subject_idx{trial_idx} ' - Averaged ERSP across AO conditions' ])

    for chan = 1:length(chan_names)
        disp(['*** Channel: ' chan_names{chan}]);

        EEG_chan = pop_select( EEG_a, 'channel', chan_names(chan));

        % averaged ERSP of AO conditions (without control condition)
        EEG_cond = pop_epoch(EEG_chan, markerVal_string(1:20), trial_t_range, ...
            'verbose', 'off');

        % Get the X and Y values from the channel_location_table based on the current channel
        chan_label = chan_names{chan};
        idx = find(strcmp(channel_location_table.Label, chan_label)); % Find the row corresponding to the current channel

        if isempty(idx)
            disp(['Channel ' chan_label ' not found in channel location table']);
            continue;
        end

        % Get X and Y tile indices for the channel
        row_idx = channel_location_table.Y(idx); % Y corresponds to row in 7x7 grid
        col_idx = channel_location_table.X(idx); % X corresponds to column in 7x7 grid

        % Determine tile index based on row and column
        tile_idx = sub2ind([nCols, nRows], col_idx, row_idx);

        ax = nexttile(tile_idx); hold on
        title(ax, [ 'channel ' chan_names{chan}]);

        [ersp,~,~,times,freqs] = ...
            pop_newtimef(EEG_cond, 1, 1, tlimits*1000, wavelet_cycles, tf_params{:}, ...
            'plotersp', 'off', 'plotitc', 'off');

        % Now manually plot the ERSP in the selected axes (tile)
        imagesc(ax, times, freqs, ersp); % Use imagesc to plot the ERSP data
        set(ax, 'YDir', 'normal'); % Ensure the y-axis is displayed correctly
        xlabel(ax, 'Time (ms)');
        ylabel(ax, 'Frequency (Hz)');

        colormap(ax, jet);
        colorbar; % Add color bar to indicate ERSP values

        % Apply the same color scaling (ERSP uses the minimum and maximum of the data)
        caxis(ax, [-3.5, 3.5]);

        % Set x-axis and y-axis limits to fit times and freqs
        xlim(ax, [min(times), max(times)]);
        ylim(ax, [min(freqs), max(freqs)]);

        hold off;
        % ersp_average_cond{chan, trial_idx} = ersp;


    end

    % save figure
    saveas(fig_subj, [filepath 'figures\' trials{trial_idx} ' - ERSP AO - topography' '.png']);

end


%% tftopo: Plot ERSP on all channels

for trial_idx = 1:length(trials)
    disp(['*** Subject: ' trials{trial_idx}]);
    EEG_a = ALLEEG_a{trial_idx};

    % averaged ERSP of AO conditions (without control condition)
    EEG_cond = pop_epoch(EEG_a, markerVal_string(1:20), trial_t_range, ...
        'verbose', 'off');

    fig_subj = figure('Position', get(0, 'Screensize'));
    nRows = 2; nCols = 1;
    t_main = tiledlayout(nRows, nCols);
    title(t_main, ['Subject ' subject_idx{trial_idx} ' - ERSP on all channels' ])

    for elec = 1:EEG_cond.nbchan
        [ersp,itc,powbase,times,freqs,erspboot,itcboot] = pop_newtimef(EEG_cond, ...
            1, elec, tlimits*1000, wavelet_cycles,  tf_params{:}, ...
            'plotersp', 'off', 'plotitc', 'off', 'plotphase', 'off');

        if elec == 1  % create empty arrays if first electrode
            allersp = zeros([ size(ersp) EEG_cond.nbchan]);
            alltimes = zeros([ size(times) EEG_cond.nbchan]);
            allfreqs = zeros([ size(freqs) EEG_cond.nbchan]);
            allerspboot = zeros([ size(erspboot) EEG_cond.nbchan]);
        end
        allersp (:,:,elec) = ersp;
        alltimes (:,:,elec) = times;
        allfreqs (:,:,elec) = freqs;
        allerspboot (:,:,elec) = erspboot;
    end

    nexttile(t_main);
    title(['Averaged across AO conditions' ])
    tftopo(allersp,alltimes(:,:,1),allfreqs(:,:,1),'mode','ave','limits', ...
        [nan nan nan 35 -1.5 1.5],'signifs', allerspboot, 'sigthresh', [6], 'timefreqs', ...
        [250 10; 500 10; 750 10; 1000 10; 1500 10; 2000 10; 2500 10], 'chanlocs', EEG_cond.chanlocs);

    % ERSP of control conditions
    EEG_cond_ctrl = pop_epoch(EEG_a, markerVal_string(21:end), trial_t_range, ...
        'verbose', 'off');

    for elec = 1:EEG_cond_ctrl.nbchan
        [ersp,itc,powbase,times,freqs,erspboot,itcboot] = pop_newtimef(EEG_cond_ctrl, ...
            1, elec, tlimits*1000, wavelet_cycles,  tf_params{:}, ...
            'plotersp', 'off', 'plotitc', 'off', 'plotphase', 'off');

        if elec == 1  % create empty arrays if first electrode
            allersp = zeros([ size(ersp) EEG_cond_ctrl.nbchan]);
            alltimes = zeros([ size(times) EEG_cond_ctrl.nbchan]);
            allfreqs = zeros([ size(freqs) EEG_cond_ctrl.nbchan]);
            allerspboot = zeros([ size(erspboot) EEG_cond_ctrl.nbchan]);
        end
        allersp (:,:,elec) = ersp;
        alltimes (:,:,elec) = times;
        allfreqs (:,:,elec) = freqs;
        allerspboot (:,:,elec) = erspboot;
    end

    nexttile(t_main);
    title(['Averaged across control conditions' ])
    tftopo(allersp,alltimes(:,:,1),allfreqs(:,:,1),'mode','ave','limits', ...
        [nan nan nan 35 -1.5 1.5],'signifs', allerspboot, 'sigthresh', [6], 'timefreqs', ...
        [250 10; 500 10; 750 10; 1000 10; 1500 10; 2000 10; 2500 10], 'chanlocs', EEG_cond_ctrl.chanlocs);

    % save figure
    saveas(fig_subj, [filepath 'figures\' trials{trial_idx} ' - ERSP AO - all channels' '.png']);
end



%% Compare ERD at central electrodes (mu) and occipital electrodes (alpha)

central_elecs = {'C3', 'C4', 'Cz'};
occip_elecs = {'O1', 'O2', 'Oz'};
group_elecs = {central_elecs, occip_elecs};
group_elec_labels = {'central', 'occipital'};

group_conds = {markerVal_string(1:20), markerVal_string(21:end)};
group_cond_labels = {'experiment', 'control'};

allersp_group = cell(length(trials), 4);



for trial_idx = 1:length(trials)
    disp(['*** Subject: ' trials{trial_idx}]);
    EEG_a = ALLEEG_a{trial_idx};

    fig_subj = figure();
    nRows = 2; nCols = 2;
    t_main = tiledlayout(nRows, nCols);
    title(t_main, ['Subject ' subject_idx{trial_idx} ' - Compare averaged ERSP between 2 regions during AO' ])


    counter = 0;

    for cond_group_i = 1:2
        % averaged ERSP of AO conditions (without control condition)
        EEG_cond = pop_epoch(EEG_a, group_conds{cond_group_i}, trial_t_range, ...
            'verbose', 'off');

        for elec_group_i = 1:2
            counter = counter + 1;
            elec_group = group_elecs{elec_group_i};

            EEG_elec_group = pop_select( EEG_cond, 'channel', elec_group);

            for elec_i = 1:EEG_elec_group.nbchan
                % elec = elec_group{elec_i};

                [ersp,itc,powbase,times,freqs,erspboot,itcboot] = pop_newtimef(EEG_elec_group, ...
                    1, elec_i, tlimits*1000, wavelet_cycles,  tf_params{:}, ...
                    'plotersp', 'off', 'plotitc', 'off', 'plotphase', 'off');

                if elec_i == 1  % create empty arrays if first electrode
                    allersp = zeros([ size(ersp) EEG_elec_group.nbchan]);
                    alltimes = zeros([ size(times) EEG_elec_group.nbchan]);
                    allfreqs = zeros([ size(freqs) EEG_elec_group.nbchan]);
                    allerspboot = zeros([ size(erspboot) EEG_elec_group.nbchan]);
                end
                allersp (:,:,elec_i) = ersp;
                alltimes (:,:,elec_i) = times;
                allfreqs (:,:,elec_i) = freqs;
                allerspboot (:,:,elec_i) = erspboot;
            end
            averaged_ersp = mean(allersp, 3);

            allersp_group{trial_idx, counter} = averaged_ersp;

            nexttile(t_main); hold on
            title([group_elec_labels{elec_group_i} ' region, ' group_cond_labels{cond_group_i} ' stimuli'])

            imagesc(times, freqs, averaged_ersp)
            axis xy; colormap(jet(256)); clim([-3 3])
            h = colorbar; title(h, "ERSP (dB)", 'FontSize', 8)
            xlabel('Time (ms)'); ylabel('Frequency (Hz)');
            xlim([min(times) max(times)]); ylim([min(freqs) max(freqs)])
            xline(0, '--m'); xline(1000, '--m'); xline(-1000, '--m')
            yline(8, '--k'); yline(13, '--k')
            hold off;
        end
    end
    % save figure
    saveas(fig_subj, [filepath 'figures\' trials{trial_idx} ' - ERSP AO - compare regions and conds' '.png']);
end

% Compute the average
fig_subj = figure();
nRows = 2; nCols = 2;
t_main = tiledlayout(nRows, nCols);
title(t_main, ['Compare ERSP averaged across subjects between 2 regions during AO' ])

group_labels = {'central region, experimental stim.', 'occipital region, experimental stim.', 'central region, control stim.', 'occipital region, control stim.'};

averaged_allersp_group = cell(1, 4);
for cond_group_i = 1:4
    % Concatenate the matrices along the 3rd dimension
    mat3D = cat(3, allersp_group{:,cond_group_i});
    % Compute the mean along the 3rd dimension (across the 7 rows)
    averaged_allersp_group{cond_group_i} = mean(mat3D, 3);

    nexttile(t_main); hold on
    title(group_labels{cond_group_i})
    imagesc(times, freqs, averaged_allersp_group{cond_group_i} )
    axis xy; colormap(jet(256)); clim([-3 3])
    h = colorbar; title(h, "ERSP (dB)", 'FontSize', 8)
    xlabel('Time (ms)'); ylabel('Frequency (Hz)');
    xlim([min(times) max(times)]); ylim([min(freqs) max(freqs)])
    xline(0, '--m'); xline(1000, '--m'); xline(-1000, '--m')
    yline(8, '--k'); yline(13, '--k')
    hold off;
end
% save figure
saveas(fig_subj, [filepath 'figures\'  'AO - Averaged ERSP across all subj - compare regions and conds' '.png']);



%% Plot data grouped by 4 experimental conditions (collapsing central electrodes, grouping healthy and stroke subj)

% Plot spectrograms (no baseline substraction)
for trial_group_i = 1:length(trial_groups)

    allersp_group = cell(length(trial_groups{trial_group_i}), length(AO_expCondMarkers));

    for trial_idx = 1:length(trial_groups{trial_group_i})
        disp(['*** Subject: ' trial_groups{trial_group_i}{trial_idx}]);

        filename = [trial_groups{trial_group_i}{trial_idx} '-AO' '-preprocessed.set']; % manually type to select dataset
        EEG_a = pop_loadset('filename', filename, 'filepath', filepath);

        for cond_group_i = 1:length(AO_expCondMarkers)
            EEG_cond = pop_epoch(EEG_a, AO_expCondMarkers{cond_group_i}, trial_t_range, ...
                'verbose', 'off');
            EEG_cond = pop_select( EEG_cond, 'channel', central_elecs);


            for elec_i = 1:EEG_cond.nbchan
                [ersp,itc,powbase,times,freqs,erspboot,itcboot] = pop_newtimef(EEG_cond, ...
                    1, elec_i, tlimits*1000, wavelet_cycles, AO_tf_params_no_bl{:}, ...
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
    title(t_main, [ trial_group_labels{trial_group_i} ' group - Spectrogram (No baseline substraction)' ])

    averaged_allersp_group = cell(1, length(AO_expCondMarkers));
    for cond_group_i = 1:4
        % Concatenate the matrices along the 3rd dimension
        mat3D = cat(3, allersp_group{:,cond_group_i});
        % Compute the mean along the 3rd dimension (across the 7 rows)
        averaged_allersp_group{cond_group_i} = mean(mat3D, 3);

        nexttile(t_main); hold on
        title(AO_expCondLabels{cond_group_i})
        imagesc(times, freqs, averaged_allersp_group{cond_group_i} )
        axis xy; colormap(jet(256)); %clim([-3 3])
        h = colorbar; title(h, "{\mu}V^2", 'FontSize', 8)
        xlabel('Time (ms)'); ylabel('Frequency (Hz)');
        xlim([min(times) max(times)]); ylim([min(freqs) max(freqs)])
        xline(0, '--m'); xline(1000, '--m'); xline(-1000, '--m')
        yline(8, '--k'); yline(13, '--k')
        hold off;
    end
end

%% Plot ERSPs: 

trial_group_erd_tw_mean = zeros([length(trial_groups) length(AO_expCondMarkers) length(AO_window_idx)]);
trial_group_erd_tw_std = zeros([length(trial_groups) length(AO_expCondMarkers) length(AO_window_idx)]);

trial_erd_tw_mean_group = zeros([length(trial_groups) length(AO_expCondMarkers) length(AO_window_idx)]);
trial_erd_tw_std_group = zeros([length(trial_groups) length(AO_expCondMarkers) length(AO_window_idx)]);

for trial_group_i = 1:length(trial_groups)

    allersp_group = cell(length(trial_groups{trial_group_i}), length(AO_expCondMarkers));

    for trial_idx = 1:length(trial_groups{trial_group_i})
        disp(['*** Subject: ' trial_groups{trial_group_i}{trial_idx}]);
        filename = [trial_groups{trial_group_i}{trial_idx} '-AO' '-preprocessed.set']; % manually type to select dataset
        EEG_a = pop_loadset('filename', filename, 'filepath', filepath);

        for cond_group_i = 1:length(AO_expCondMarkers)
            EEG_cond = pop_epoch(EEG_a, AO_expCondMarkers{cond_group_i}, trial_t_range, ...
                'verbose', 'off');
            EEG_cond = pop_select( EEG_cond, 'channel', central_elecs);


            for elec_i = 1:EEG_cond.nbchan
                [ersp,itc,powbase,times,freqs,erspboot,itcboot] = pop_newtimef(EEG_cond, ...
                    1, elec_i, tlimits*1000, wavelet_cycles,  AO_tf_params{:}, ...
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
            % averaging across electrodes
            averaged_ersp = mean(allersp, 3);

            allersp_group{trial_idx, cond_group_i} = averaged_ersp;
        end

    end

    % Compute the average
    fig_subj = figure();
    nRows = 2; nCols = 2;
    t_main = tiledlayout(nRows, nCols);
    title(t_main, [ trial_group_labels{trial_group_i} ' group - ERSP' ])


    averaged_allersp_group = cell(1, length(AO_expCondMarkers));
    for cond_group_i = 1:4
        % Concatenate the matrices along the 3rd dimension
        mat3D = cat(3, allersp_group{:,cond_group_i});
        % Compute the mean along the 3rd dimension (across the 7 rows)
        averaged_allersp_group{cond_group_i} = mean(mat3D, 3);

        nexttile(t_main); hold on
        title(AO_expCondLabels{cond_group_i})
        imagesc(times, freqs, averaged_allersp_group{cond_group_i} )
        axis xy; colormap(jet(256)); clim([-3 3])
        h = colorbar; title(h, "ERSP (dB)", 'FontSize', 8)
        xlabel('Time (ms)'); ylabel('Frequency (Hz)');
        xlim([min(times) max(times)]); ylim([min(freqs) max(freqs)])
        xline(0, '--m'); xline(1000, '--m'); xline(-1000, '--m')
        yline(8, '--k'); yline(13, '--k')
        hold off;
    end


    % plot temporal patterns of mu ERD: compute averaged ERD by time windows
    for cond_group_i = 1:length(AO_expCondMarkers)
        ersp = averaged_allersp_group{cond_group_i};

        for tw = 1:length(AO_window_idx)
            ersp_mu_tw = ersp(freqs >= AO_alpha_band(1) & freqs <= AO_alpha_band(end), AO_window_idx{tw});
            trial_group_erd_tw_mean(trial_group_i, cond_group_i, tw) = mean(ersp_mu_tw, "all") ;
            trial_group_erd_tw_std(trial_group_i, cond_group_i, tw) = std(ersp_mu_tw, 0, "all") ;
        end
    end


    % compute ERD by time windows for each subject (before averaging across subjects)
    trial_erd_tw_mean = zeros([length(trial_groups{trial_group_i}) length(AO_expCondMarkers) length(AO_window_idx)]);
    for trial_idx = 1:length(trial_groups{trial_group_i})
        for cond_group_i = 1:length(AO_expCondMarkers)
            ersp = allersp_group{trial_idx, cond_group_i};
    
            for tw = 1:length(AO_window_idx)
                ersp_mu_tw = ersp(freqs >= AO_alpha_band(1) & freqs <= AO_alpha_band(end), AO_window_idx{tw});
                trial_erd_tw_mean(trial_idx, cond_group_i, tw) = mean(ersp_mu_tw, "all") ;

            end
        end
    end

    trial_erd_tw_mean_group(trial_group_i, :, :) = mean(trial_erd_tw_mean, 1);
    trial_erd_tw_std_group(trial_group_i, :, :) = std(trial_erd_tw_mean, 0, 1);
end

%% Temporal pattern plot: averaged ERD across all subjects in group before computing mean and std
x_shift= [-0.1 0];

markerColor_new = {"b", "r" };
markerCurveStyle_new = ["-", "-", ];
markerSymbol_new = ["o", "*"];

fig_subj = figure();
nRows = 2; nCols = 2;
t_main = tiledlayout(nRows, nCols);
title(t_main, [ 'Temporal patterns' ])


x = 0:numel(AO_window_idx)-1;
lines = [];
for cond_group_i = 1:length(AO_expCondMarkers)

    nexttile(t_main); hold on
    title(AO_expCondLabels{cond_group_i})

    for trial_group_i = 1:length(trial_groups)
        mean_vector = trial_group_erd_tw_mean(trial_group_i, cond_group_i, :);
        std_vector = trial_group_erd_tw_std(trial_group_i, cond_group_i,:);
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
    xlim([x(1)-.5 x(end)+.5]); ylim([-3 3])
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


x = 0:numel(AO_window_idx)-1;
lines = [];
for cond_group_i = 1:length(AO_expCondMarkers)

    nexttile(t_main); hold on
    title(AO_expCondLabels{cond_group_i})

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
    xlim([x(1)-.5 x(end)+.5]); ylim([-4 4])
    xregion(-0.5, 0.5, FaceColor="k", FaceAlpha=0.1); xregion(0.5, x(end)+.5, FaceColor="w", FaceAlpha=0.2)
    xlabel('Time windows (250 ms)');
    ylabel('ERSP (dB)'); yline(0, 'k--', 'Alpha', 0.5)

    hold off
end
% Place the legend at the bottom (south) of the tiledlayout
lgd = legend(lines);  % Only show the legend for the two unique lines
lgd.Layout.Tile = 'south';  % Place the legend at the bottom (south)
lgd.Orientation = 'horizontal';  % Make the legend items appear side by side

