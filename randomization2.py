import pandas as pd
import numpy as np

stim_table_initial = pd.read_excel("stim_table_initial.xlsx")

print(stim_table_initial)


# Parameters for the experiment setup
Num_Conditions = 4  # Assuming there are 4 unique conditions
Num_Actions = 5     # Assuming there are 5 unique actions
N_rep = 8           # Each condition-action pair is repeated 8 times
num_blocks = 10     # The number of blocks
block_size = 16     # The number of stimuli in each block (without controls)
num_controls = 3    # The number of control stim_table_initial in each block
total_trials = Num_Conditions * Num_Actions * N_rep  # Total should be 160


# Ensure we have the correct number of stim_table_initial
print(f"Total stim_table_initial read from the Excel file: {len(stim_table_initial)}")

# Generate the full list of trials by repeating the existing ones


    # Have number of controls be 10 repetitions per control (3)
    # 25 catch trials
# Should not be repeated by 8, total of 160 trials


#for first 20 rows repeat 8 times, next 3 rows repeat 10 times, 
#last row can create catch trial later

only20rows = stim_table_initial[:20]

first20 = pd.concat([only20rows] * N_rep, ignore_index=True)

next3rows = stim_table_initial[20:23]

next3 = pd.concat([next3rows] * 10, ignore_index=True)

full_trials = pd.concat([first20, next3])




# Shuffle the trials to ensure no consecutive stimuli
full_trials_shuffled = full_trials.sample(frac=1).reset_index(drop=True)


# shuffle not all together, shuffle before allocating to the blocks, shuffle each group of stimuli before allocating to blocks

#25 catch trials with videos of object manipulation, all catch trials have "yes" in catchQ
#13 object manipulation videos & 12 catch trials from experimnetal videos

object_manipulation = ["./stimuli/obj_0.mp4","./stimuli/obj_1.mp4","./stimuli/obj_2.mp4","./stimuli/obj_3.mp4",
"./stimuli/obj_4.mp4"]

# Randomly select 13 trials to be catch trials from object manipulation list

import random

catch_trials_object = [random.choice(object_manipulation) for _ in range(13)]

print(catch_trials_object)


# select 12 experimental videos to be catch trials

stimDir_path = []

for i in only20rows["stimDir"]:
    stimDir_path.append(i)

stimDir_12 = stimDir_path[:12]
print(stimDir_12)


total_catch = stimDir_12 + catch_trials_object

condition_catch = ["catch"] * 25
marker_catch = ["100"] * 25
question_catch = ["yes"] * 25
stimulus_catch = [""] * 25
stimVal_catch = [""] * 25
stimLabel_catch = [""] * 25

df_catch = pd.DataFrame({"condition": condition_catch, "stimulus": stimulus_catch, "stimValue": stimVal_catch, "stimLabel": stimLabel_catch, "stimDir": total_catch, "markerVal" : marker_catch, "catchtrialQ" : question_catch})


fulltshuffle_catch = pd.concat[full_trials_shuffled, df_catch]


catch_trial_indices = np.random.choice(full_trials_shuffled.index, size=12, replace=False)






























