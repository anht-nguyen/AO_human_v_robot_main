clear all;
eeglab; close all;
trials = {'000-AO','001-AO', '002-AO' };

filepath = ['C:\Users\anhtn\OneDrive - PennO365\Documents\GitHub\' ...
    'AO_human_v_robot_main\prelim_EEG\datasets\'];

ALLEEG = cell(1,3);
for i=1:length(trials)
    filename = [trials{i} '-preprocessed.set']; % manually type to select dataset
    ALLEEG{i} = pop_loadset('filename', filename, 'filepath', filepath);
end

trial_N = 2;
EEG = ALLEEG{trial_N};
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
timesout = 400;

%=================================================================

for trial_N = 2:3
    EEG = ALLEEG{trial_N};
    for chan = 1:length(chan_names)
        disp(['*** Channel: ' chan_names{chan}]);
        EEG_chan = pop_select( EEG, 'channel', chan_names(chan));
        
        EEG_cond = pop_epoch(EEG_chan, markerVal_string(1:20), trial_t_range, ...
                'verbose', 'off');
        
        figure(); t = tiledlayout(3,2);
        nexttile(t); hold on
        title(['subject ' num2str(trial_N) ', all conditions, ' chan_names{chan}]);
            % [ersp,itc,powbase,times,freqs,erspboot,itcboot,tfdata] = ...
                pop_newtimef(EEG_cond, 1, 1, [-1.5 4.5]*1000, wavelet_cycles, ...
                'timesout', timesout, 'baseline', [-1000 0], 'scale', 'log',...
                'nfreqs', length(freqrange(1):1/freqfac:freqrange(2)), 'freqscale', 'log',...
                'plotitc', 'off', 'plotersp', 'on', 'trialbase', 'off',...
                'verbose', 'off', 'newfig', 'off');
        hold off;
        for cond_idx = 1:length(markerLabel)
            disp(['*** Condition: ' char(markerLabel(cond_idx))]);

            EEG_cond = pop_epoch(EEG_chan, markerVal_cell{cond_idx}, trial_t_range, ...
                'verbose', 'off');
            disp(['*** Number of trials in this condition: ', num2str(size(EEG_cond.epoch, 2)) ]);

            nexttile(t); hold on
            title(['subject ' num2str(trial_N) ', ' ...
                char(markerLabel(cond_idx)) ', ' chan_names{chan}]);
            % [ersp,itc,powbase,times,freqs,erspboot,itcboot,tfdata] = ...
                pop_newtimef(EEG_cond, 1, 1, [-1.5 4.5]*1000, wavelet_cycles, ...
                'baseline', [-700 -300], 'timesout', timesout, ...
                'nfreqs', length(freqrange(1):1/freqfac:freqrange(2)), 'freqscale', 'log',...
                'plotitc', 'off', 'plotersp', 'on', 'trialbase', 'off', ...
                'scale', 'log', 'verbose', 'off', 'newfig', 'off'); %%%%%%%%%%%%%%%%%%%%%% CHECK params - consistency
            hold off
        end

    end
end

%================================================================

ersp_C3_subj = cell(1, 3);
ersp_mean_C3_subj = cell(1,3);

for chan = 1:length(chan_names)
    for trial_N = 2:3
        EEG = ALLEEG{trial_N};
        disp(['*** Channel: ' chan_names{chan}]);
        EEG_chan = pop_select( EEG, 'channel', chan_names(chan));
        
        EEG_cond = pop_epoch(EEG_chan, markerVal_string(1:20), trial_t_range, ...
                'verbose', 'off');
        
        [ersp,itc,powbase,times,freqs,erspboot,itcboot,tfdata] = ...
            pop_newtimef(EEG_cond, 1, 1, [-1.5 4.5]*1000, wavelet_cycles, ...
            'timesout', timesout, 'baseline', [-1000 0], 'scale', 'log',...
            'nfreqs', length(freqrange(1):1/freqfac:freqrange(2)), 'freqscale', 'log',...
            'plotitc', 'off', 'plotersp', 'off', 'trialbase', 'off',...
            'verbose', 'off', 'newfig', 'off');
        
        for cond_idx = 1:length(markerLabel)
            disp(['*** Condition: ' char(markerLabel(cond_idx))]);

            EEG_cond = pop_epoch(EEG_chan, markerVal_cell{cond_idx}, trial_t_range, ...
                'verbose', 'off');
            disp(['*** Number of trials in this condition: ', num2str(size(EEG_cond.epoch, 2)) ]);

            [ersp,itc,powbase,times,freqs,erspboot,itcboot,tfdata] = ...
                pop_newtimef(EEG_cond, 1, 1, [-1.5 4.5]*1000, wavelet_cycles, ...
                'baseline', [-700 -300], 'timesout', timesout, ...
                'nfreqs', length(freqrange(1):1/freqfac:freqrange(2)), 'freqscale', 'log',...
                'plotitc', 'off', 'plotersp', 'off', 'trialbase', 'off', ...
                'scale', 'log', 'verbose', 'off', 'newfig', 'off');
            hold off
        end

    end
end




% Correlation of ERSP between conditions for each subject and Plot Correlation

f_c3corr = figure; axgrid = [3 4];
tclMain = tiledlayout(4, 3, 'TileSpacing', 'loose', 'TileIndexing','columnmajor');

freqs = 4:1/freqfac:30;
for trial_N = 1:3
    % disp("S"+trial_N)
    ersp_mean_C3 = ersp_mean_C3_subj{trial_N};
    pairs = {[1 3], [2 4], [1 2], [3 4]};

    for i=1:4
        ersp_cond1 = ersp_mean_C3{pairs{i}(1)};
        ersp_cond2 = ersp_mean_C3{pairs{i}(2)};
        R_cond = corrcoef(ersp_cond1, ersp_cond2);

        nexttile; %title("r="+num2str(round(R_cond(1,2), 3) ))
        box on; grid on; hold on
        for f = 1:3
            plot(ersp_cond1(freqs >= freq_bands{f}(1) & freqs <= freq_bands{f}(end)), ersp_cond2( freqs >= freq_bands{f}(1) & freqs <= freq_bands{f}(end)), ...
                '.', 'Color',band_colors(f),  'MarkerSize', 5,'LineWidth', 0.7, 'DisplayName', band_names(f));
        end
        coeffs = polyfit(ersp_cond1,ersp_cond2,1);
        h = refline(coeffs);
        set(h, 'HandleVisibility','off')


        ylabel(markerLabel(pairs{i}(2)));
        xlabel(markerLabel(pairs{i}(1)));


        text(-0.7,0.7, "r="+num2str(round(R_cond(1,2), 3) ) )
        text(0.5,-0.7, "S"+trial_N , 'FontWeight', 'bold')

        xlim([-1 1]); ylim([-1 1]); xticks([-1 0 1]); yticks([-1 0 1]);
        hold off
    end
end


nexttile(5); legend('Location','northoutside','Orientation','horizontal')

plotfilename = 'C3_corr';
matlab2tikz('figurehandle',f_c3corr,'filename', [output_plot_path plotfilename '.tex'], ...
    'extraAxisOptions',{'ylabel style={yshift=-10pt}','xlabel style={yshift=5pt}'})































