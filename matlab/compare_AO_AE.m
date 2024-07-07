% clear all;
eeglab;
close all;

setup_AOE

%============================================
% Analysis:
alpha_band = 8:0.5:13;
AO_beta_band = 15:0.5:22;
AO_bands = {alpha_band, AO_beta_band};
AE_beta_band = 15:0.5:22;
AE_bands = {alpha_band, AE_beta_band};

AO_onset_times = 1000;
AE_onset_times = 0;

trial_N = 1;
ersp_exp_all = ALL_ERSP_trial{1};
AO_times = times_exp_cell{1};

chan = 1;
exp = 1;
cond = 1;
ersp = ersp_exp_all{chan, exp}{cond};

figure(); hold on
imagesc(AO_times, freqs, ersp)
axis xy; colormap(jet(256)); clim([-2 2])
h = colorbar; title(h, "ERSP (dB)", 'FontSize', 8)
xlabel('Time (ms)'); ylabel('Frequency (Hz)');
xlim([min(AO_times) max(AO_times)]); ylim([min(freqs) max(freqs)])
xline(0, '--m'); xline(-1000, '--m')
yline(8, '--k'); yline(13, '--k'); yline(15, '--k'); yline(22, '--k');
hold off

%% Check the dynamic of ERSP: temporal pattern such as the onset latency

for trial_N = 1:length(trials)
for chan = 1:length(chan_names)
    exp = 1;
    AO_times = times_exp_cell{exp};
    figure; t1 = tiledlayout(3,2);
    for cond = 1:length(AO_markerVal_cell)
        ersp = ersp_exp_all{chan, exp}{cond};

        AO_onset_idx = find(AO_times >= AO_onset_times);

        AO_ersp_mean_band = {};
        for band = 1:length(AO_bands)
            AO_ersp_mean_band{band} = mean(ersp(freqs >= AO_bands{band}(1) & freqs <= AO_bands{band}(end), AO_onset_idx) );

        end

        nexttile(t1); hold on
        plot(AO_times(AO_onset_idx:end), AO_ersp_mean_band{1}, 'b')
        plot(AO_times(AO_onset_idx:end), AO_ersp_mean_band{2}, 'r')
        yline(mean(AO_ersp_mean_band{1}), '--b')
        yline(mean(AO_ersp_mean_band{2}), '--r')
        hold off

    end

    exp = 2;
    AE_times = times_exp_cell{exp};
    figure; t2 = tiledlayout(2,2);
    for cond = 1:length(AE_markerVal_cell)
        ersp = ersp_exp_all{chan, exp}{cond};

        AE_onset_idx = find(AE_times >= AE_onset_times);

        AE_ersp_mean_band = {};
        for band = 1:length(AE_bands)
            AE_ersp_mean_band{band} = mean(ersp(freqs >= AE_bands{band}(1) & freqs <= AE_bands{band}(end), AE_onset_idx) );

        end

        nexttile(t2); hold on
        plot(AE_times(AE_onset_idx:end), AE_ersp_mean_band{1}, 'b')
        plot(AE_times(AE_onset_idx:end), AE_ersp_mean_band{2}, 'r')
        yline(mean(AE_ersp_mean_band{1}), '--b')
        yline(mean(AE_ersp_mean_band{2}), '--r')
        hold off

    end

end
end


% Angelini 2018: time window 250ms




























