# EEG Data Curation Process `edf_file_curation.m`

## Why this is needed?
The curation of EEG data is an essential step to ensure accurate analysis and interpretation. When importing raw EEG data from **EDF files**, several preprocessing steps are required to:
- Extract relevant EEG channels while discarding unnecessary ones.
- Assign standard **10-20 system channel locations** for accurate electrode mapping.
- Identify and visualize EEG quality metrics, such as **Cognitive Quality (CQ)** and **Emotional Quality (EQ)**.
- Save the cleaned and structured dataset for further preprocessing.

This MATLAB script automates these steps for consistency across subjects.

## Curation Process in MATLAB

1. Loading Subject Information
The script reads `subject_data_info.xlsx`, extracting subject details such as ID, protocol, experiment type, and EDF file paths.

2. Importing EEG Data
For each subject, EEG data is imported using **pop_biosig**, and the raw dataset (`EEG_raw`) is stored before modifications.

3. Assessing EEG Quality (CQ & EQ)
- CQ and EQ channels are identified based on dataset size.
- Signal quality trends are visualized using a moving average (window size = 5000).

4. EEG Data Curation
The **EEG_curation_func** function removes irrelevant channels, filters noise, and applies necessary preprocessing steps.

5. Assigning Standardized Channel Locations
A **10-20 system** configuration is applied using `pop_chanedit`, ensuring consistent electrode mapping.

6. Saving the Curated EEG Dataset
The cleaned dataset is:
- Renamed (`subjectID-experiment-curated.set`).
- Saved in the dataset folder.
- Accompanied by a CQ/EQ visualization figure.

---

# Semi-automatic EEG Data Preprocessing Pipeline

## Pipeline description: `preprocessing_AO.m` and `preprocessing_AOE.m`

1. Load Subject Data Information
The script reads subject information from an Excel file (`subject_data_info.xlsx`).
It extracts key details such as protocol, subject ID, experiment type, and filenames.
Subjects participating in the AO experiment with available EEG data are selected for preprocessing.

2. Load EEG Datasets
EEG datasets (.set files) corresponding to each selected subject are loaded from the specified directory.

3. Apply Filtering
A high-pass filter at 1 Hz is applied to remove slow drifts.
A low-pass filter at 40 Hz is applied to remove high-frequency noise.

4. Remove Bad Channels
Bad channels are identified using visual inspection and removed.
The exclusion criteria include sudden shifts, excessive high-frequency noise, or amplitudes exceeding 100 µV.

5. Re-Reference the Data
The EEG data is re-referenced to the average reference.
Interpolated channels are temporarily included during re-referencing and removed afterward.

6. Run ICA (Independent Component Analysis)
ICA is applied using the Picard algorithm to decompose EEG signals into independent components.
Components representing artifacts (e.g., eye movements, muscle activity) are flagged and removed using ICLabel.

7. Epoching
The EEG data is segmented into epochs based on predefined event markers.
The epoch time range is set to [-3, 4.5] seconds relative to event onset.

8. Second ICA Run
ICA is applied a second time to refine artifact removal.
Additional artifactual components are removed using ICLabel.


9. Reject Bad Epochs
Epochs with amplitude greater than 100 µV are visually identified and removed.

10. Power Spectral Density (PSD) Analysis
PSD plots for selected electrodes (C3, C4) are generated.
The plots are saved for quality assessment.

11. Save Preprocessed Data
The cleaned and epoched EEG datasets are saved in `.set` format.
The preprocessing pipeline retains a percentage of trials, which is displayed for reference.

## Output Files

Preprocessed EEG datasets: `subjectID-preprocessed.set`

Power spectral density figures: `subjectID-preprocessed-PSD-C3C4.png`

## Dependencies
EEGLAB toolbox
Picard ICA plugin

## How to Use: Step-by-Step

Follow these steps to conduct a semi-automatic preprocessing of EEG data efficiently.

### 1. Prepare Subject Data
- Ensure that the `subject_data_info.xlsx` file is correctly formatted before running the script.
- The Excel file should contain `bad_channel` and `bad_epoch` columns, which should initially be empty.

### 2. Identify and Log Bad Channels
- Use `pop_eegplot(EEG_prep)` to inspect the raw continuous EEG data for each subject and each experiment.
- Identify bad channels based on the exclusion criteria below.
- Log the identified bad channel numbers in the `bad_channel` column of the Excel file.

### 3. Run the Preprocessing Script
- Once bad channels are logged, execute the preprocessing script to generate `-preprocessed.set` datasets.
- Open each preprocessed dataset and inspect the epoched EEG data using `pop_eegplot(<EEG>)`.

### 4. Identify and Log Bad Epochs
- Visually inspect the epoched EEG data and identify bad epochs using the same exclusion criteria.
- Log the identified bad epoch numbers in the `bad_epoch` column for each subject and each experiment.

### 5. Final Preprocessing and Data Cleaning
- Rerun the preprocessing script after logging bad epochs.
- The final `-preprocessed.set` datasets will contain cleaned and fully preprocessed EEG data, ready for further analysis.

## Exclusion Criteria for Visual Inspection
Bad channels and epochs should be removed based on the following criteria:
- Sudden shifts in signal
- Excessive high-frequency noise
- Voltage amplitude exceeding 100 µV


---

## Extra: Clean data using the clean_rawdata plugin
```
    % % Source: https://github.com/sccn/clean_rawdata/blob/master/clean_artifacts.m
    % % BurstRejection : 'on' or 'off'. If 'on' reject portions of data containing burst instead of
    % %                    correcting them using ASR. Default is 'off'.
    % EEG_prep = pop_clean_rawdata(EEG_prep, 'FlatlineCriterion', 5, ...
    %     'ChannelCriterion', 0.85, 'LineNoiseCriterion', 4,'Highpass','off',...
    %     'BurstCriterion',100,'WindowCriterion',0.8,'BurstRejection','off', ...
    %     'Distance','Euclidian','WindowCriterionTolerances',[-Inf 7], ...
    %     'channels_ignore',{'C3','C4'});
```
This step (clean_rawdata) was removed as it seems unnecessary (results were not different with and with out clean_rawdata)