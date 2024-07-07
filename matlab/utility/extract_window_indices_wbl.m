function window_indices = extract_window_indices_wbl(times, window_start, window_size, baseline)
%%% extract indices in 250 ms time windows after AO/AE onset, including baseline epoch
%%% window_start, window_size, and baseline are in milliseconds

    % Define time window parameters
    num_windows = ceil((max(times) - window_start) / window_size); % Calculate the number of windows
    
    % Initialize cell array to store indices for each window
    window_indices = cell(1, num_windows+1);
    
    window_indices{1} = find(times >= baseline(1) & times < baseline(end));

    % Iterate through windows
    for i = 1:num_windows
        % Define window boundaries
        window_end = window_start + window_size;
    
        % Find indices of time points within the current window
        indices = find(times >= window_start & times < window_end);
    
        % Store indices for the current window
        window_indices{i+1} = indices;
    
        % Update window start for the next iteration
        window_start = window_end;
    end

    % Display the indices for each window
    % for i = 1:num_windows
    %     fprintf('Indices for Window %d: %s\n', i, mat2str(window_indices{i}));
    % end
end