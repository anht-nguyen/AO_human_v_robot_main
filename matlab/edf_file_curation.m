% clear all;
% eeglab; close all;

% Make sure you have the correct directory
filepath_edf = ['C:\Users\anhtn\OneDrive - PennO365\Documents\GitHub' ...
    '\AO_human_v_robot_main\prelim_EEG\raw_EDF\'];

%=========================================================
% Change these
% subject_folder = '000';
% EDF_filename = 'Psychopy_000_2024-04-06T133344.666351_EPOCFLEX_126268_2024.04.06T13.33.44.04.00.edf';
% experiment = 'AO'; % choose between 'AO' and 'AOE', depending on the file to be imported

% subject_folder = '000-2';
% EDF_filename = 'Psychopy_000_2024-04-15T184734.590471_EPOCFLEX_126268_2024.04.15T18.47.34.04.00.edf';
% experiment = 'AO'; % choose between 'AO' and 'AOE', depending on the file to be imported

% subject_folder = '001';
% EDF_filename = 'Psychopy_001_2024-04-04T133957.482416_EPOCFLEX_126268_2024.04.04T13.39.57.04.00.edf';
% experiment = 'AO';

% subject_folder = '002';
% EDF_filename = 'Psychopy_002_2024-04-09T153401.208970_EPOCFLEX_126268_2024.04.09T15.34.01.04.00.edf';
% experiment = 'AO';

% subject_folder = '000-2';
% EDF_filename = 'Psychopy_000_2024-04-15T193304.857787_EPOCFLEX_126268_2024.04.15T19.33.04.04.00.edf';
% experiment = 'AOE';
% 
% subject_folder = '001';
% EDF_filename = 'Psychopy_001_2024-04-04T141812.094965_EPOCFLEX_126268_2024.04.04T14.18.12.04.00.edf';
% experiment = 'AOE';

subject_folder = '002';
EDF_filename = 'Psychopy_002_2024-04-09T161522.099149_EPOCFLEX_126268_2024.04.09T16.15.22.04.00.edf';
experiment = 'AOE';

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
title(['Subject ' subject_folder ', ' experiment])
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
filepath = ['C:\Users\anhtn\OneDrive - PennO365\Documents\GitHub' ...
    '\AO_human_v_robot_main\prelim_EEG\datasets\'];
dataset_name = [subject_folder '-' experiment '-curated'];
EEG_curate = pop_editset(EEG_curate, 'setname', dataset_name);
pop_saveset(EEG_curate, [dataset_name '.set'], filepath);

saveas(fig, [filepath dataset_name '.png']);