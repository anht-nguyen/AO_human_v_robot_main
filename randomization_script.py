import pandas as pd
import numpy as np

stim_table_initial = pd.read_excel("stim_table_initial.xlsx")

print(stim_table_initial)



#3 dataframes: 160-experimental trial df (shuffled and will be allocated into 10 blocks, 16 trials per block), 
#30-control trial df, 25-catchtrial df
#Each df has same 8 columns: block, condition, stimulus, stimValue, stimLabel, stimDir, markerval, catchtrialObj


# Parameters for the experiment setup
num_Conditions = 4  # Assuming there are 4 unique conditions
num_Actions = 5     # Assuming there are 5 unique actions
num_stim_rep = 8           # Each condition-action pair is repeated 8 times
num_blocks = 10     # The number of blocks
block_size = 16     # The number of stimuli in each block (without controls)
num_controls = 3    # The number of control stim_table_initial in each block
num_control_rep = 10 # The number of times each control is repeated
total_trials = num_Conditions * num_Actions * num_stim_rep  # Total should be 160


# Ensure we have the correct number of stim_table_initial
print(f"Total stim_table_initial read from the Excel file: {len(stim_table_initial)}")

# Generate the full list of trials by repeating the existing ones


    # Have number of controls be 10 repetitions per control (3)
    # 25 catch trials
# Should not be repeated by 8, total of 160 trials


#for first 20 rows repeat 8 times, next 3 rows repeat 10 times, 
#last row can create catch trial later

only20rows = stim_table_initial[:num_Conditions*num_Actions]

df_experimental_trials = pd.concat([only20rows] * num_stim_rep, ignore_index=True)

df_experimental_trials['blockNumber'] = df_experimental_trials['blockNumber']. astype(int)
df_experimental_trials['markerVal'] = df_experimental_trials['markerVal']. astype(int)



# Shuffle the trials to ensure no consecutive stimuli
df_experimental_trials_shuffled = df_experimental_trials.sample(frac=1).reset_index(drop=True)

# Adding  the block number to experimental trials

for i in range(num_blocks):
    df_experimental_trials_shuffled.loc[i*16:(i+1)*16, 'blockNumber'] = i

print(df_experimental_trials)

next3rows = stim_table_initial[20:23]

df_control_trials = pd.concat([next3rows] * num_control_rep, ignore_index=True)

# Shuffle the control trials 
df_control_trials_shuffled = df_control_trials.sample(frac=1).reset_index(drop=True)

# Adding the block number to control trials

for i in range(10):
    df_control_trials_shuffled.loc[i*3:(i+1)*3, 'blockNumber'] = i



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

blockNum_catch = [0] * 25
condition_catch = ["catch"] * 25
marker_catch = [100] * 25
question_catch = ["yes"] * 25
stimulus_catch = [""] * 25
stimVal_catch = [""] * 25
stimLabel_catch = [""] * 25


df_catch = pd.DataFrame({"blockNumber": blockNum_catch, "condition": condition_catch, "stimulus": stimulus_catch, "stimValue": stimVal_catch, "stimLabel": stimLabel_catch, "stimDir": total_catch, "markerVal" : marker_catch, "catchtrialObj" : question_catch})

# Shuffle the catch trials 
df_catch_shuffled = df_catch.sample(frac=1).reset_index(drop=True)

# Adding the block number to control trials (add 2-3):
# Generate list of 25 items; 2 0s 3 1s 2 3s etc, append to block Number in df_catch 

blockNum_catch = list(range(10)) * 2
## order these so that 0,0, 1,1, etc

# randomize 5 numbers from 0 to 9

fiverandomNum = [random.randint(0, 9) for _ in range(5)]
print(fiverandomNum)

total_blockNum = fiverandomNum + blockNum_catch

total_blockNum = sorted(total_blockNum)

print(total_blockNum)



# Assign to block number

df_catch_shuffled['blockNumber'] = total_blockNum

print(df_catch_shuffled)


randomize_trials_df = pd.DataFrame()
filtered_dfs = pd.DataFrame()

for i in range(10): 
    #extract the block from the three dataframes and bring these together
    filtered_df_exp_shuff = df_experimental_trials_shuffled[df_experimental_trials_shuffled["blockNumber"] == i]
    filtered_df_control_shuff = df_control_trials_shuffled[df_control_trials_shuffled["blockNumber"] == i]
    filtered_df_catch_shuff = df_catch_shuffled[df_catch_shuffled["blockNumber"] == i]

    concat_filtered_df = pd.concat([filtered_dfs, filtered_df_exp_shuff, filtered_df_control_shuff, filtered_df_catch_shuff])
    concat_filtered_df = concat_filtered_df.sample(frac=1).reset_index(drop=True)

    randomize_trials_df = pd.concat([randomize_trials_df, concat_filtered_df])


print(concat_filtered_df)
print()





# Concatenate all blocks to get the final trial list
final_trial_list = randomize_trials_df

# output_file_path = r'C:\Users\andre\PycharmProjects\Robot Code Stuff\final_trials.xlsx'
output_file_path = 'final_randomized_trials.xlsx'
final_trial_list.to_excel(output_file_path, index=False)


print(f"The script has completed. The final trials have been saved to '{output_file_path}'.")

























