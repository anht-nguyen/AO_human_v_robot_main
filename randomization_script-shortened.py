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
num_stim_rep = 6           # Each condition-action pair is repeated 8 times
num_blocks = 8     # The number of blocks
block_size = 15     # The number of stimuli in each block (without controls)
num_controls = 3    # The number of control stim_table_initial in each block
num_control_rep = 8 # The number of times each control is repeated
total_trials = num_Conditions * num_Actions * num_stim_rep  # Total should be 160
num_rep_ct_obj = 10 # Number of times each object manipulation catchtrial video is repeated
num_rep_ct_stim = 10 # Number of times each experimental catchtrial video is repeated
num_rep_total_ct = num_rep_ct_obj + num_rep_ct_stim # Total number of catch trials

# Ensure we have the correct number of stim_table_initial
print(f"Total stim_table_initial read from the Excel file: {len(stim_table_initial)}")

# Generate the full list of trials by repeating the existing ones


    # Have number of controls be 10 repetitions per control (3)
    # 25 catch trials
# Should not be repeated by 8, total of 160 trials


#for first 20 rows repeat 8 times, next 3 rows repeat 10 times, 
#last row can create catch trial later

first20rows = stim_table_initial[:20]

next10rows = stim_table_initial[20:30]

df_experimental_trials_human = pd.concat([first20rows] * int(num_stim_rep/2), ignore_index=True)
df_experimental_trials_robot = pd.concat([next10rows] * num_stim_rep, ignore_index=True)
df_experimental_trials = pd.concat([df_experimental_trials_human, df_experimental_trials_robot], ignore_index=True)

df_experimental_trials['blockNumber'] = df_experimental_trials['blockNumber']. astype(int)
df_experimental_trials['markerVal'] = df_experimental_trials['markerVal']. astype(int)



# Shuffle the trials to ensure no consecutive stimuli
df_experimental_trials_shuffled = df_experimental_trials.sample(frac=1).reset_index(drop=True)

# Adding  the block number to experimental trials

for i in range(num_blocks):
    df_experimental_trials_shuffled.loc[i*block_size:(i+1)*block_size, 'blockNumber'] = i

print(df_experimental_trials)



next3rows = stim_table_initial[30:30+num_controls]

df_control_trials = pd.concat([next3rows] * num_control_rep, ignore_index=True)

# Shuffle the control trials 
df_control_trials_shuffled = df_control_trials.sample(frac=1).reset_index(drop=True)

# Adding the block number to control trials

for i in range(num_blocks):
    df_control_trials_shuffled.loc[i*3:(i+1)*3, 'blockNumber'] = i



# shuffle not all together, shuffle before allocating to the blocks, shuffle each group of stimuli before allocating to blocks

#25 catch trials with videos of object manipulation, all catch trials have "yes" in catchQ
#13 object manipulation videos & 12 catch trials from experimnetal videos

object_manipulation = ["./stimuli/obj_0.mp4","./stimuli/obj_1.mp4","./stimuli/obj_2.mp4","./stimuli/obj_3.mp4", "./stimuli/obj_4.mp4"]

# Randomly select 13 trials to be catch trials from object manipulation list

import random

catch_trials_object_dir = [random.choice(object_manipulation) for _ in range(num_rep_ct_obj)]
catch_trials_objects = [s[10:15] for s in catch_trials_object_dir]
print(catch_trials_object_dir)


# select 12 experimental videos to be catch trials, randomly from human videos

stimDir_path = []

for i in stim_table_initial[0:20]["stimDir"]:
    stimDir_path.append(i)

# stimDir_12 = stimDir_path[:num_rep_ct_stim]
stimDir_12 = [random.choice(stimDir_path) for _ in range(num_rep_ct_stim)]
print(stimDir_12)


total_catch = stimDir_12 + catch_trials_object_dir

blockNum_catch = [0] * num_rep_total_ct
condition_catch = ["catch"] * num_rep_total_ct
marker_catch = [100] * num_rep_total_ct
question_catch = ["none"]*num_rep_ct_stim + catch_trials_objects
stimulus_catch = [""] * num_rep_total_ct
stimVal_catch = [""] * num_rep_total_ct
stimLabel_catch = [""] * num_rep_total_ct


df_catch = pd.DataFrame({"blockNumber": blockNum_catch, "condition": condition_catch, "stimulus": stimulus_catch, "stimValue": stimVal_catch, "stimLabel": stimLabel_catch, "stimDir": total_catch, "markerVal" : marker_catch, "catchtrialObj" : question_catch})

# Shuffle the catch trials 
df_catch_shuffled = df_catch.sample(frac=1).reset_index(drop=True)

# Adding the block number to control trials (add 2-3):
# Generate list of 25 items; 2 0s 3 1s 2 3s etc, append to block Number in df_catch 

blockNum_catch = list(range(num_blocks)) * 2
## order these so that 0,0, 1,1, etc

# randomize 5 numbers from 0 to 9

fiverandomNum = [random.randint(0, num_blocks-1) for _ in range(4)]
print(fiverandomNum)

total_blockNum = fiverandomNum + blockNum_catch

total_blockNum = sorted(total_blockNum)

print(total_blockNum)



# Assign to block number

df_catch_shuffled['blockNumber'] = total_blockNum

print(df_catch_shuffled)


randomize_trials_df = pd.DataFrame()
filtered_dfs = pd.DataFrame()

for i in range(num_blocks): 
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
output_file_path = 'AO_final_randomized_trials.xlsx'
final_trial_list.to_excel(output_file_path, index=False)


print(f"The script has completed. The final trials have been saved to '{output_file_path}'.")



# Export randomized trails for AOE
output_file_path = 'AOE_final_randomized_trials.xlsx'
df_experimental_trials_shuffled.to_excel(output_file_path, index=False)



# # Export random 10 experimental trails and 10 catch trials for training phase
# training_experimental_stim = df_experimental_trials_shuffled.sample(n=10)
# training_catch_stim = df_catch_shuffled.sample(n=10)

# df_training = pd.concat([training_experimental_stim, training_catch_stim], ignore_index=True)

# output_file_path = 'training_randomized_trials.xlsx'
# df_training.to_excel(output_file_path, index=False)


















