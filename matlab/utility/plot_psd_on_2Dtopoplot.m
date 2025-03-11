function plot_psd_on_2Dtopoplot(EEG, freq_range, trial_idx, isSaved, filepath)
% Function to overlay PSD plots for each electrode on a 2D layout
% 
% Inputs:
%   EEG         - EEG structure (requires EEG.data and EEG.chanlocs)
%   freq_range  - Frequency range [low, high] for PSD calculation (optional)
%
% Usage:
%   plot_psd_on_2Dlayout(EEG);
%   plot_psd_on_2Dlayout(EEG, [8, 12]); % For Alpha band PSD

    % Default frequency range (if not specified)
    if nargin < 2
        freq_range = [0, EEG.srate / 2]; % Default range is full spectrum
    end


    % Step 1: Compute PSD for Each Electrode
    [spectra, freqs] = spectopo(EEG.data, 0, EEG.srate, 'plot', 'off');
    
    % Limit spectra to the desired frequency range
    freq_idx = freqs >= freq_range(1) & freqs <= freq_range(2);
    freqs = freqs(freq_idx);
    spectra = spectra(:, freq_idx);

    % Step 2: Get Electrode Locations and Labels
    chanlocs = EEG.chanlocs; % Channel locations structure

    [x, y] = compute_2D_chan_positions(chanlocs);

    % Scale up the Cartesian coordinates for the electrodes
    scale = 1.4;
    x_rot = x * scale;
    y_rot = y * scale;

    labels = {chanlocs.labels}; % Electrode labels

    % Step 3: Initialize the 2D Layout
    fig = figure; 
    hold on;
    % axis equal; 
    set(gca, 'XTick', [], 'YTick', [], 'Color', 'none'); % Remove ticks and background
    axis off;
    % Add the title
    title(sprintf('Subject %s - Topograpgical PSD Plots (%.1f-%.1f Hz)', trial_idx, freq_range(1), freq_range(2)), ...
        'Units', 'normalized', 'Position', [0.5, 1.02, 0]);
    
    % % Adjust the position of the title
    % title_handle.Position(2) = title_handle.Position(2) + 0.05; % Move title upwards

    % Plot the scaled head outline (unit circle scaled by factor)
    theta = linspace(0, 2*pi, 100);
    plot( cos(theta) ,  sin(theta) , 'k', 'LineWidth', 1.5); % Scaled circular head outline

    labels = {chanlocs.labels}; % Electrode labels

    % Step 4: Overlay PSD Plots at Each Electrode
    n_channels = length(chanlocs);
    for ch = 1:n_channels
        % Position each small axes centered at the electrode location
        ax = axes('Position', [x_rot(ch)*0.4 + 0.48, y_rot(ch)*0.5 + 0.5, 0.08, 0.08]); % Adjust position
        plot(ax, freqs, spectra(ch, :), 'k'); % PSD plot
        title(ax, labels{ch}, 'FontWeight', 'bold', 'FontSize', 8)
        axis tight; % Tighten axis
        set(ax, 'XTick', [], 'YTick', [], 'Color', 'none'); % Remove ticks and background
        box on;
    end

    % Create an axis at the bottom-right corner
    ax = axes('Position', [0.85, 0.1, 0.08, 0.08]); % Adjust [x, y, width, height]

    % Add a plot to the axis (example)
    plot(ax, freq_range, zeros(length(freq_range)), 'k'); % Example plot
    set(ax, 'XTick', [freq_range(1) freq_range(2)], 'YTick', [], 'Color', 'none', 'FontSize', 8);
    xlabel(ax, 'Frequency (Hz)', 'FontSize', 8); % X-axis label
    ylabel(ax, 'PSD', 'FontSize', 8); % Y-axis label
    ylim([0 10]), xlim([freq_range(1) freq_range(2)])

    % Final Adjustments
    hold off;

    if isSaved == "yes"
        % save figure
        saveas(fig, filepath);
    end
end
