clear all;
eeglab; close all;

% Make sure you have the correct directory
filepath = ['C:\Users\anhtn\OneDrive - PennO365\Documents\GitHub' ...
    '\AO_human_v_robot_main\prelim_EEG\raw_EDF\'];

%=========================================================
% Change these
subject_folder = '000-2';
experiment = 'AO'; % choose between 'AO' and 'AOE', depending on the file to be imported
EDF_filename = 'Psychopy_000_2024-04-15T184734.590471_EPOCFLEX_126268_2024.04.15T18.47.34.04.00.edf';

%=========================================================
% EDF file import and curation (Do not change)
% select EEG important data from EDF file and add channel locations 
EEG_curate = pop_biosig([filepath subject_folder '\' EDF_filename]);
EEG_curate = EEG_curation_func(EEG_curate);

EEG_curate=pop_chanedit(EEG_curate, 'lookup', ...
    'C:\\Program Files\\MATLAB\\R2023b\\toolbox\\eeglab2023.1\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc', ...
    'load',{'C:\\Users\\anhtn\\OneDrive - PennO365\\Documents\\GitHub\\AO_human_v_robot_pilot\\matlab\\Standard-10-20-Cap32.ced', ...
    'filetype','autodetect'});
disp(['*** Number of channels: ' num2str(EEG_curate.nbchan)]);

% Save curated dataset 
filepath = ['C:\Users\anhtn\OneDrive - PennO365\Documents\GitHub' ...
    '\AO_human_v_robot_main\prelim_EEG\datasets\'];
dataset_name = [subject_folder '-' experiment '-curated'];
EEG_curate = pop_editset(EEG_curate, 'setname', dataset_name);
pop_saveset(EEG_curate, [dataset_name '.set'], filepath);