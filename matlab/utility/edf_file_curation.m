% clear all;
% eeglab; close all;


subject_data_info = readtable("subject_data_info.xlsx");


% Make sure you have the correct directory
origin_path = ['C:\Users\anhtn\OneDrive - PennO365\Documents\GitHub' ...
    '\AO_human_v_robot_main'];

for data_row = 1 : height(subject_data_info)

    filepath_edf = [origin_path subject_data_info.filepath_edf{data_row}];
    protocol = num2str(subject_data_info.protocol(data_row));
    subject_id = num2str(subject_data_info.subject_id(data_row));
    experiment = subject_data_info.experiment{data_row};
    EDF_filename = subject_data_info.EDF_filename{data_row};

    subject_folder = [protocol '_' subject_id];

    if isempty(EDF_filename) == 0
        %=========================================================
        % EDF file import and curation (Do not change)
        % select EEG important data from EDF file and add channel locations
        EEG_curate = pop_biosig([filepath_edf subject_folder '\' EDF_filename]);
        EEG_raw = EEG_curate;
        % Plot CQ and EQ overtime:
        if EEG_raw.nbchan == 113
            CQ_row = 78;
            EQ_row = 80;
        elseif EEG_raw.nbchan == 115
            CQ_row = 80;
            EQ_row = 82;
        end
        CQ_data = EEG_raw.data(CQ_row, :);
        EQ_data = EEG_raw.data(EQ_row, :);
        times = EEG_raw.times;
        win_size = 5000;

        fig = figure('Name', subject_folder); t = tiledlayout(2,1);
        nexttile; hold on
        title(['Subject ' subject_id ', ' experiment])
        plot(times, CQ_data);
        ylim([-10 110]); ylabel('CQ.Overall'); xlim([times(1) times(end)])
        plot(movmean(times, win_size), movmean(CQ_data, win_size), 'r--', 'LineWidth', 2.5)
        hold off
        nexttile;hold on
        plot(times, EQ_data);
        ylim([-10 110]); ylabel('EQ.Overall'); xlabel('times'); xlim([times(1) times(end)])
        plot(movmean(times, win_size), movmean(EQ_data, win_size), 'r--', 'LineWidth', 2.5)
        hold off

        %------------------------------------
        EEG_curate = EEG_curation_func(EEG_curate);

        EEG_curate=pop_chanedit(EEG_curate, 'lookup', ...
            'C:\\Program Files\\MATLAB\\R2023b\\toolbox\\eeglab2023.1\\plugins\\dipfit5.4\\standard_BEM\\elec\\standard_1005.elc', ...
            'load',{'C:\\Users\\anhtn\\OneDrive - PennO365\\Documents\\GitHub\\AO_human_v_robot_pilot\\matlab\\Standard-10-20-Cap32.ced', ...
            'filetype','autodetect'});
        disp(['*** Number of channels: ' num2str(EEG_curate.nbchan)]);

        % Save curated dataset
        filepath = [origin_path '\FloAim6_Data\datasets\'];
        dataset_name = [subject_folder '-' experiment '-curated'];
        EEG_curate = pop_editset(EEG_curate, 'setname', dataset_name);
        pop_saveset(EEG_curate, [dataset_name '.set'], filepath);

        saveas(fig, [filepath dataset_name '.png']);
    end
end