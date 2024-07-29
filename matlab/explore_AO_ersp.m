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

        figure(); t = tiledlayout(3,2);
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















% =======================================================================
% % Correlation of ERSP between conditions for each subject and Plot Correlation
% 
% f_c3corr = figure; axgrid = [3 4];
% tclMain = tiledlayout(4, 3, 'TileSpacing', 'loose', 'TileIndexing','columnmajor');
% 
% freqs = 4:1/freqfac:30;
% for trial_N = 1:3
%     % disp("S"+trial_N)
%     ersp_mean_C3 = ersp_mean_C3_subj{trial_N};
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
%         text(0.5,-0.7, "S"+trial_N , 'FontWeight', 'bold')
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






























