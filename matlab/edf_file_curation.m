clear all;
eeglab; close all;

% Make sure you have the correct directory
filepath = ['C:\Users\anhtn\OneDrive - PennO365\Documents\GitHub' ...
    '\AO_human_v_robot_main\prelim_EEG\raw_EDF\'];

%=========================================================
% Change these
subject_folder = '000-2';
EDF_filename = 'Psychopy_000_2024-04-15T184734.590471_EPOCFLEX_126268_2024.04.15T18.47.34.04.00.edf';

%=========================================================
% EDF file import and curation (Do not change)
% select EEG important data from EDF file and add channel locations 
EEG = pop_biosig([filepath subject_folder '\' EDF_filename]);
if EEG.nbchan == 113
    EEG_curate_113;
elseif EEG.nbchan == 115
    EEG_curate_115;
end

EEG=pop_chanedit(EEG, 'lookup', ...
    'C:\\Program Files\\MATLAB\\R2023b\\toolbox\\eeglab2023.1\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc', ...
    'load',{'C:\\Users\\anhtn\\OneDrive - PennO365\\Documents\\GitHub\\AO_human_v_robot_pilot\\matlab\\Standard-10-20-Cap32.ced', ...
    'filetype','autodetect'});
disp(['*** Number of channels: ' num2str(EEG.nbchan)]);