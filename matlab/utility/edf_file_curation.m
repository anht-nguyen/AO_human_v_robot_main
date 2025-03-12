% Load subject data information from an Excel file
subject_data_info = readtable("subject_data_info.xlsx");

% Define the origin path to ensure correct file directory
origin_path = ['C:\Users\anhtn\OneDrive - PennO365\Documents\GitHub' ...
    '\AO_human_v_robot_main'];

% Loop through each subject in the dataset
for data_row = 1 : height(subject_data_info)
    
    % Construct the file path for the EDF file
    filepath_edf = [origin_path subject_data_info.filepath_edf{data_row}];
    
    % Extract relevant subject information
    protocol = num2str(subject_data_info.protocol(data_row));
    subject_id = num2str(subject_data_info.subject_id(data_row));
    experiment = subject_data_info.experiment{data_row};
    EDF_filename = subject_data_info.EDF_filename{data_row};
    
    % Define the subject folder name
    subject_folder = [protocol '_' subject_id];
    
    % Proceed only if an EDF filename is available
    if isempty(EDF_filename) == 0
        
        %=========================================================
        % Import EEG data from the EDF file
        % Select relevant EEG data and apply channel locations
        EEG_curate = pop_biosig([filepath_edf subject_folder '\' EDF_filename]);
        EEG_raw = EEG_curate; % Store the raw EEG data before curation
        
        % Determine channel indices for CQ (Cognitive Quality) and EQ (Emotional Quality)
        if EEG_raw.nbchan == 113
            CQ_row = 78;
            EQ_row = 80;
        elseif EEG_raw.nbchan == 115
            CQ_row = 80;
            EQ_row = 82;
        end
        
        % Extract CQ and EQ data for visualization
        CQ_data = EEG_raw.data(CQ_row, :);
        EQ_data = EEG_raw.data(EQ_row, :);
        times = EEG_raw.times;
        win_size = 5000; % Window size for moving average filter
        
        % Create a figure to visualize CQ and EQ over time
        fig = figure('Name', subject_folder); 
        t = tiledlayout(2,1);
        
        % Plot Cognitive Quality (CQ)
        nexttile; hold on
        title(['Subject ' subject_id ', ' experiment])
        plot(times, CQ_data);
        ylim([-10 110]); ylabel('CQ.Overall'); xlim([times(1) times(end)])
        plot(movmean(times, win_size), movmean(CQ_data, win_size), 'r--', 'LineWidth', 2.5)
        hold off
        
        % Plot Emotional Quality (EQ)
        nexttile; hold on
        plot(times, EQ_data);
        ylim([-10 110]); ylabel('EQ.Overall'); xlabel('times'); xlim([times(1) times(end)])
        plot(movmean(times, win_size), movmean(EQ_data, win_size), 'r--', 'LineWidth', 2.5)
        hold off
        
        %------------------------------------
        % Apply custom EEG curation function
        EEG_curate = EEG_curation_func(EEG_curate);
        
        % Load standard channel locations for proper electrode mapping
        EEG_curate = pop_chanedit(EEG_curate, 'lookup', ...
            'C:\Program Files\MATLAB\R2023b\toolbox\eeglab2023.1\plugins\dipfit5.4\standard_BEM\elec\standard_1005.elc', ...
            'load',{'C:\Users\anhtn\OneDrive - PennO365\Documents\GitHub\AO_human_v_robot_pilot\matlab\Standard-10-20-Cap32.ced', ...
            'filetype','autodetect'});
        
        % Display the number of channels in the dataset
        disp(['*** Number of channels: ' num2str(EEG_curate.nbchan)]);
        
        % Define file path for saving curated datasets
        filepath = [origin_path '\FloAim6_Data\datasets\'];
        dataset_name = [subject_folder '-' experiment '-curated'];
        
        % Set the dataset name and save the curated EEG dataset
        EEG_curate = pop_editset(EEG_curate, 'setname', dataset_name);
        pop_saveset(EEG_curate, [dataset_name '.set'], filepath);
        
        % Save the EEG quality visualization figure
        saveas(fig, [filepath 'figures\' dataset_name '.png']);
    end
end
