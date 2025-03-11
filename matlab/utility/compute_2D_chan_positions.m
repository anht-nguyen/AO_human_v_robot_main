function [x_rot, y_rot] = compute_2D_chan_positions(chanlocs)
% Compute 2D positions of EEG electrodes from EEG.chanlocs
%
% Inputs:
%   chanlocs - EEG.chanlocs structure containing electrode information
%
% Outputs:
%   x, y - Cartesian coordinates for the electrodes

    % Initialize empty arrays for x and y coordinates
    x = zeros(1, length(chanlocs));
    y = zeros(1, length(chanlocs));

    % Loop through all channels to compute 2D positions
    for i = 1:length(chanlocs)
        % Extract theta (in degrees) and radius from the chanlocs structure
        theta = chanlocs(i).theta; % Angular position
        radius = chanlocs(i).radius; % Radial distance
        
        % Convert theta to radians
        theta_rad = deg2rad(theta);

        % Compute Cartesian coordinates
        [x(i), y(i)] = pol2cart(theta_rad, radius);
    end

    % Rotate the layout 90 degrees counterclockwise
    x_rot = -y;
    y_rot = x ;
end
