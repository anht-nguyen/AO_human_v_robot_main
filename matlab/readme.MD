EEG preprocessing and analysis pipeline:

1. After exporting EDF files from Emotiv, the first step is curating the EDFs using the edf_file_curation.m

- Add information of eeg data folder to subject_data_info.xlsx


2. Run preprocessing_AO.m to perform preprocessing for AO EEG datasets. Do the same for AOE dataset using preprocessing AOE.m