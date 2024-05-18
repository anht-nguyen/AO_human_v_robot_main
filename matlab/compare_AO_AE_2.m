% clear all;
eeglab;
close all;

setup_AOE

%% Analysis:
alpha_band = 8:0.5:13;
AO_beta_band = 15:0.5:22;
AO_bands = {alpha_band, AO_beta_band};
AE_beta_band = 15:0.5:22;
AE_bands = {alpha_band, AE_beta_band};

AO_onset_times = 1000;
AE_onset_times = 0;

% trial_idx = 1;
% ersp_exp_all = ALL_ERSP_trial{1};
% AO_times = times_exp_cell{1};
% 
% chan = 1;
% exp = 1;
% cond = 1;
% ersp = ersp_exp_all{chan, exp}{cond};


%% Compute mean and std ERD values over time for each frequency band, each condition, each channel, during AO and AE

for trial_idx = 1:length(trials)
    ersp_exp_all = ALL_ERSP_trial{trial_idx};

    for chan = 1:length(chan_names)
        exp = 1;
        AO_times = times_exp_cell{exp};
        figure; t0 = tiledlayout(2,5);
        title(t0, ['Subject ' trials{trial_idx} ', channel ' chan_names{chan} ', AO(top row) & AE(bottom row)'])
        for cond = 1:length(AO_markerVal_cell)
            ersp = ersp_exp_all{chan, exp}{cond};

            AO_onset_idx = find(AO_times >= AO_onset_times);

            nexttile(t0);

            AO_ersp_mean_band = zeros(length(AO_bands), length(AO_onset_idx));
            for band = 1:length(AO_bands)
                AO_ersp_mean_band(band, :) = mean(ersp(freqs >= AO_bands{band}(1) & freqs <= AO_bands{band}(end), AO_onset_idx) );

            end

            mean_ersp = mean(AO_ersp_mean_band, 2);
            std_ersp = std(AO_ersp_mean_band, 0, 2);

            % plot
            bar(mean_ersp, 'w');
            hold on
            errorbar(1:numel(mean_ersp), mean_ersp', std_ersp', 'k', 'LineWidth', 1.5, 'linestyle', 'none');
            hold off

            xticks(1:numel(mean_ersp)); % Set the tick locations
            xticklabels(band_names); % Set the tick labels
            xlabel('Frequency bands');
            ylabel('Mean ERSP (dB)');
            title(['condition: ' markerLabel{cond}]);

        end

        exp = 2;
        AE_times = times_exp_cell{exp};
        % figure; t2 = tiledlayout(2,2);
        % title(t2, ['Subject ' trials{trial_idx} ', channel ' chan_names{chan} ', AE'])

        for cond = 1:length(AE_markerVal_cell)
            ersp = ersp_exp_all{chan, exp}{cond};

            AE_onset_idx = find(AE_times >= AE_onset_times);

            nexttile(t0);

            AE_ersp_mean_band = zeros(length(AE_bands), length(AE_onset_idx));
            for band = 1:length(AE_bands)
                AE_ersp_mean_band(band, :) = mean(ersp(freqs >= AE_bands{band}(1) & freqs <= AE_bands{band}(end), AE_onset_idx) );

            end

            mean_ersp = mean(AE_ersp_mean_band, 2);
            std_ersp = std(AE_ersp_mean_band, 0, 2);

            % plot
            bar(mean_ersp, 'w');
            hold on
            errorbar(1:numel(mean_ersp), mean_ersp', std_ersp', 'k', 'LineWidth', 1.5, 'linestyle', 'none');
            hold off

            xticks(1:numel(mean_ersp)); % Set the tick locations
            xticklabels(band_names); % Set the tick labels
            xlabel('Frequency bands');
            ylabel('Mean ERSP (dB)');
            title(['condition: ' markerLabel{cond}]);

        end

    end
end

% Note: Some figures show very high variability, implying the fluctuation
% in power over time. Further analysis should check this temporal dynamics

%% try collapsing data from C3 and C4

% ersp_all_mean_chan: a 3x2 cell (3 subjects, 2 experiments)
% each cell element is a 2xn cell (2 freq bands, n = # of conditions)
% each smaller element is a ERSP data (averaged across 2 channels)

ersp_all_mean_chan = cell(length(trials), length(experiments));
for trial_idx = 1:length(trials)
    ersp_exp_all = ALL_ERSP_trial{trial_idx};

    exp = 1;
    ersp_cond_cell = cell(length(AO_bands),length(AO_markerVal_cell));
    for cond = 1:length(AO_markerVal_cell)
        for band = 1:length(AO_bands)
            ersp_C3 = ersp_exp_all{1, exp}{cond};
            ersp_C3 = ersp_C3(freqs >= AO_bands{band}(1) & freqs <= AO_bands{band}(end), :);

            ersp_C4 = ersp_exp_all{2, exp}{cond};
            ersp_C4 = ersp_C4(freqs >= AO_bands{band}(1) & freqs <= AO_bands{band}(end), :);

            ersp_mean_chan = (ersp_C3 + ersp_C4)/2;

            ersp_cond_cell{band, cond} = ersp_mean_chan;

        end
    end
    ersp_all_mean_chan{trial_idx, exp} = ersp_cond_cell;

    exp = 2;
    ersp_cond_cell = cell(length(AE_bands),length(AE_markerVal_cell));
    for cond = 1:length(AE_markerVal_cell)
        for band = 1:length(AE_bands)
            ersp_C3 = ersp_exp_all{1, exp}{cond};
            ersp_C3 = ersp_C3(freqs >= AE_bands{band}(1) & freqs <= AE_bands{band}(end), :);

            ersp_C4 = ersp_exp_all{2, exp}{cond};
            ersp_C4 = ersp_C4(freqs >= AE_bands{band}(1) & freqs <= AE_bands{band}(end), :);

            ersp_mean_chan = (ersp_C3 + ersp_C4)/2;

            ersp_cond_cell{band, cond} = ersp_mean_chan;
        end
    end
    ersp_all_mean_chan{trial_idx, exp} = ersp_cond_cell;

end

% compute mean and std through all times for each subject, experiment, condition
for trial_idx = 1:length(trials)
    exp = 1;
    ersp_cond_cell = ersp_all_mean_chan{trial_idx, exp};

    AO_times = times_exp_cell{exp};
    AO_onset_idx = find(AO_times >= AO_onset_times);

    figure; t0 = tiledlayout(2,5);
    title(t0, ['Subject ' trials{trial_idx} ', averaged by channels, AO (top row) & AE (bottom row)'])

    for cond = 1:length(AO_markerVal_cell)
        nexttile(t0);
        AO_ersp_mean_band = zeros(length(AO_bands), length(AO_onset_idx));
        for band = 1:length(AO_bands)
            ersp = ersp_cond_cell{band, cond};
            AO_ersp_mean_band(band, :) = mean(ersp(:, AO_onset_idx) );
        end

        mean_ersp = mean(AO_ersp_mean_band, 2);
        std_ersp = std(AO_ersp_mean_band, 0, 2);

        % plot
        bar(mean_ersp, 'w');
        hold on
        errorbar(1:numel(mean_ersp), mean_ersp', std_ersp', 'k', 'LineWidth', 1.5, 'linestyle', 'none');
        hold off
        xticks(1:numel(mean_ersp)); % Set the tick locations
        xticklabels(band_names); % Set the tick labels
        % xlabel('Frequency bands');
        ylabel('Mean ERSP (dB)');
        title(['condition: ' markerLabel{cond}]);
    end

    % AE
    exp = 2;
    ersp_cond_cell = ersp_all_mean_chan{trial_idx, exp};

    AE_times = times_exp_cell{exp};
    AE_onset_idx = find(AE_times >= AE_onset_times);

    for cond = 1:length(AE_markerVal_cell)
        nexttile(t0);
        AE_ersp_mean_band = zeros(length(AE_bands), length(AE_onset_idx));
        for band = 1:length(AE_bands)
            ersp = ersp_cond_cell{band, cond};
            AE_ersp_mean_band(band, :) = mean(ersp(:, AE_onset_idx) );
        end

        mean_ersp = mean(AE_ersp_mean_band, 2);
        std_ersp = std(AE_ersp_mean_band, 0, 2);

        % plot
        bar(mean_ersp, 'w');
        hold on
        errorbar(1:numel(mean_ersp), mean_ersp', std_ersp', 'k', 'LineWidth', 1.5, 'linestyle', 'none');
        hold off
        xticks(1:numel(mean_ersp)); % Set the tick locations
        xticklabels(band_names); % Set the tick labels
        xlabel('Frequency bands');
        ylabel('Mean ERSP (dB)');
        title(['condition: ' markerLabel{cond}]);
    end
end

% Note: Collapsing C3 and C4 might not be a good idea due to the
% variability in ERSP between these channels' data


%% Compute and plot mean and std for each 250 ms time window 
% Segment ERSP of each condition, each freq band, each experiment, each
% channel, each subject
% Each plot should shows time dynamics of diff conditions, using errorbar

AO_onset_times = 1000;
AE_onset_times = 0;
window_size = 250;

% trial_idx = 1;
% ersp_exp_all = ALL_ERSP_trial{1};
% AO_times = times_exp_cell{1};
% 
% chan = 1;
% exp = 1;
% cond = 1;
% ersp = ersp_exp_all{chan, exp}{cond};

AO_window_idx = extract_window_indices(AO_times, AO_onset_times, window_size);
AE_window_idx = extract_window_indices(AE_times, AE_onset_times, window_size);

x_shift= [-0.2 -0.1 0 0.1 0.2];

for trial_idx = 1:length(trials)
    ersp_exp_all = ALL_ERSP_trial{trial_idx};
    for chan = 1:length(chan_names)
        
        figure; t0 = tiledlayout(2,2);
        title(t0, ['Subject ' trials{trial_idx} ', channel ' chan_names{chan} ', AO(top row) & AE(bottom row)'])
        
        exp = 1;
        for band = 1:length(band_names)
            
            nexttile(t0); hold on
            for cond = 1:length(AO_markerVal_cell)
                ersp = ersp_exp_all{chan, exp}{cond};
                    
                mean_ersp_tw = zeros(1, length(AO_window_idx));
                std_ersp_tw = zeros(1, length(AO_window_idx));
                for tw = 1:length(AO_window_idx)
                    ersp_tw = mean(ersp(freqs >= AO_bands{band}(1) & freqs <= AO_bands{band}(end), AO_window_idx{tw}) );
                    mean_ersp_tw(tw) = mean(ersp_tw);
                    std_ersp_tw(tw) = std(ersp_tw);
                end
                x = 1:numel(AO_window_idx);
                errorbar(x+x_shift(cond), mean_ersp_tw, std_ersp_tw, 'o-',"MarkerSize",5);

            end
            xticks(1:numel(AO_window_idx));
            xlim([0 numel(AO_window_idx)+1]);
            xlabel('Time windows (250 ms)');
            ylabel('Mean ERSP (dB)'); yline(0, 'k--', 'Alpha', 0.5)
            title([band_names{band} ' band']);
            hold off
        end
        legend(markerLabel, 'Location','eastoutside')


        exp = 2;
        for band = 1:length(band_names)
            
            nexttile(t0); hold on
            for cond = 1:length(AE_markerVal_cell)
                ersp = ersp_exp_all{chan, exp}{cond};
                    
                mean_ersp_tw = zeros(1, length(AE_window_idx));
                std_ersp_tw = zeros(1, length(AE_window_idx));
                for tw = 1:length(AE_window_idx)
                    ersp_tw = mean(ersp(freqs >= AE_bands{band}(1) & freqs <= AE_bands{band}(end), AE_window_idx{tw}) );
                    mean_ersp_tw(tw) = mean(ersp_tw);
                    std_ersp_tw(tw) = std(ersp_tw);
                end
                
                x = 1:numel(AE_window_idx);
                errorbar(x+x_shift(cond), mean_ersp_tw, std_ersp_tw, 'o-',"MarkerSize",5);

            end
            xticks(1:numel(AE_window_idx));
            xlim([0 numel(AE_window_idx)+1]);
            xlabel('Time windows (250 ms)');
            ylabel('Mean ERSP (dB)');
            title([band_names{band} ' band']);
            yline(0, 'k--', 'Alpha', 0.5)
            hold off
        end
        legend(markerLabel(1:end-1), 'Location','eastoutside')

    end
end

% It's hard to interpret this results. 
% S0 AO: ERD present in not only during AO but also with control
% S0 AE: a consistent pattern: ERD peak at 2nd time window

%% Plot temporal dynamics, but averaged across all subjects



% UPDATE 5/15/2024: Continue this piece of analysis in the live script file
% with the same name




