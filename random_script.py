
import pandas as pd
import numpy as np




# Ask the user for the file path to the Excel file
file_path = input("Please enter the path to your Excel file: ")

# Read the Excel file
try:
    trials = pd.read_excel(file_path)
except Exception as e:
    print(f"An error occurred while reading the Excel file: {e}")
    exit()

# Parameters for the experiment setup
Num_Conditions = 4  # Assuming there are 4 unique conditions
Num_Actions = 5     # Assuming there are 5 unique actions
N_rep = 8         # Each condition-action pair is repeated 8 times
num_blocks = 10     # The number of blocks
block_size = 16     # The number of stimuli in each block (without controls)
num_controls = 3    # The number of control trials in each block
total_trials = Num_Conditions * Num_Actions * N_rep  # Total should be 160

# Ensure we have the correct number of trials

# Generate the full list of trials by repeating the existing ones
full_trials = pd.concat([trials] * N_rep, ignore_index=True)

# Shuffle the trials to ensure no consecutive stimuli
full_trials_shuffled = full_trials.sample(frac=1).reset_index(drop=True)

# Randomly select 20 trials to be catch trials and mark half as blocked
catch_trial_indices = np.random.choice(full_trials_shuffled.index, size=20, replace=False)
full_trials_shuffled['blocked'] = 'no'
full_trials_shuffled.loc[catch_trial_indices[:10], 'blocked'] = 'yes'

# Add a question mark column for all trials
full_trials_shuffled['question?'] = np.random.choice(['yes', 'no'], size=len(full_trials_shuffled), p=[0.5, 0.5])

# Create blocks with controls and randomized catch trials
blocks = []
for b in range(num_blocks):
    block_trials = full_trials_shuffled.iloc[b * block_size:(b + 1) * block_size]

    # Randomly select 1 to 3 control trials for this block
    num_control_to_add = np.random.randint(1, 4)
    control_trials = pd.DataFrame({
        'condition': ['control'] * num_control_to_add,
        'stimulus': [f'control_{i}' for i in range(num_control_to_add)],
        'stimValue': list(range(num_control_to_add)),
        'stimLabel': [f'Landscape {i+1}' for i in range(num_control_to_add)],
        'stimDir': [f'/stimuli/control_{i}.mp4' for i in range(num_control_to_add)],
        'blocked': 'no',
        'question?': 'no'  # Assuming controls don't have a question
    })

    block_trials = pd.concat([block_trials, control_trials], ignore_index=True)

    # Randomly add 1 to 3 catch trials to the block (not including those already marked as blocked)
    num_catch_to_add = np.random.randint(1, 4)
    catch_trials_to_add = full_trials_shuffled.loc[catch_trial_indices].sample(n=num_catch_to_add)
    block_trials = pd.concat([block_trials, catch_trials_to_add], ignore_index=True)

    # Shuffle the block
    block_trials = block_trials.sample(frac=1).reset_index(drop=True)

    # Append the block to the blocks list
    blocks.append(block_trials)

    # Remove the used catch trials from the selection pool
    catch_trial_indices = np.setdiff1d(catch_trial_indices, catch_trials_to_add.index)

# Concatenate all blocks to get the final trial list
final_trial_list = pd.concat(blocks, ignore_index=True)

# Output the final trial list to a new Excel file
output_file_path = 'final_trials.xlsx'
final_trial_list.to_excel(output_file_path, index=False)

print(f"The script has completed. The final trials have been saved to '{output_file_path}'.")