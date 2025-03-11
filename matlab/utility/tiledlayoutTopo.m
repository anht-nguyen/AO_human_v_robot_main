% Channel labels in the order based on visual inspection of the provided image
chan_labels_ordered = { ...
    '','','FP1', '', 'FP2', '', '';  % Row 1 (top)
    '', 'F7', 'F3', 'FZ', 'F4', 'F8', '';  % Row 2
    'FT9', 'FC5', 'FC1', '', 'FC2', 'FC6', 'FT10';  % Row 3
    'T7','', 'C3', 'Cz', 'C4','', 'T8';  % Row 4 (middle)
    '','CP5', 'CP1', '', 'CP2', 'CP6', '';  % Row 5
    '','P7', 'P3', 'PZ', 'P4', 'P8', '';  % Row 6
    '','PO9', 'O1', 'Oz', 'O2', 'PO10', ''};  % Row 7 (bottom)

% Create an empty 7x7 grid
grid_size = [7, 7];
channel_grid = cell(grid_size);

% Fill the grid with the channel labels
for row = 1:grid_size(1)
    for col = 1:grid_size(2)
        if ~isempty(chan_labels_ordered{row, col})
            channel_grid{row, col} = chan_labels_ordered{row, col};
        end
    end
end

% Display the 7x7 grid of channels
disp('Channel Grid:');
disp(channel_grid);

% Visualize the 7x7 grid layout
fig = figure;
tiledlayout(7, 7, 'TileSpacing', 'compact', 'Padding', 'compact');
for row = 1:grid_size(1)
    for col = 1:grid_size(2)
        nexttile;
        if ~isempty(channel_grid{row, col})
            text(0.5, 0.5, channel_grid{row, col}, 'HorizontalAlignment', 'center', 'FontSize', 12);
        end
        axis off;
    end
end
title('7x7 Channel Layout');

% Initialize arrays to store labels and their grid locations
labels = {};
X_tile = [];
Y_tile = [];

% Extract labels and their grid locations from channel_grid
for row = 1:grid_size(1)
    for col = 1:grid_size(2)
        if ~isempty(channel_grid{row, col})
            labels{end+1} = channel_grid{row, col};  % Add label
            X_tile(end+1) = col;  % Add X location (column)
            Y_tile(end+1) = row;  % Add Y location (row)
        end
    end
end

% Create a table with 3 columns: labels, X (column), Y (row)
channel_location_table = table(labels', X_tile', Y_tile', 'VariableNames', {'Label', 'X', 'Y'});

% Save the table to a CSV file
output_file = [origin_path '\matlab\utility\channel_grid_locations.csv'];
writetable(channel_location_table, output_file);

% Display the table in the MATLAB console
disp(channel_location_table);
