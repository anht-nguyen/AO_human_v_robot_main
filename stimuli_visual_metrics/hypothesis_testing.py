import os
import sys
import pandas as pd
from scipy.stats import f_oneway, kruskal, ttest_ind
from itertools import combinations
import numpy as np
import matplotlib.pyplot as plt

# Paths
ROOT_DIR = os.path.abspath(os.path.dirname(__file__))
summary_file = os.path.join(ROOT_DIR, 'output', 'all_videos_metrics_summary.csv')
tests_dir = os.path.join(ROOT_DIR, 'output', 'hypothesis_tests')

# Ensure summary exists
if not os.path.exists(summary_file):
    print(f"Summary file not found at {summary_file}. Please run the extended metrics script first.")
    sys.exit(1)

# Create tests output directory
os.makedirs(tests_dir, exist_ok=True)

# Load data
df = pd.read_csv(summary_file)
df['Condition'] = df['Video'].str.extract(r'^(control|human_left|human_right|robot_left|robot_right)')

# Metrics to test
metrics = ['Mean lumi', 'Mean contrast', 'Mean flow', 'Mean edge_density']

# Containers
anova_results = []
kruskal_results = []
pairwise_results = []

conditions = df['Condition'].unique().tolist()
# Remove NaN conditions
conditions = [c for c in conditions if pd.notna(c)]
n_pairs = len(conditions) * (len(conditions) - 1) / 2

# Perform tests
for m in metrics:
    groups = [df[df['Condition'] == c][m].dropna() for c in conditions]
    F, p_anova = f_oneway(*groups)
    anova_results.append({'Metric': m, 'F-statistic': F, 'p-value': p_anova})

    H, p_kw = kruskal(*groups)
    kruskal_results.append({'Metric': m, 'H-statistic': H, 'p-value': p_kw})

    for c1, c2 in combinations(conditions, 2):
        d1 = df[df['Condition'] == c1][m].dropna()
        d2 = df[df['Condition'] == c2][m].dropna()
        t_stat, p_val = ttest_ind(d1, d2, equal_var=False)
        p_adj = min(p_val * n_pairs, 1.0)
        pairwise_results.append({
            'Metric': m,
            'Group1': c1,
            'Group2': c2,
            't-stat': t_stat,
            'p-value': p_val,
            'p-adj': p_adj
        })

# Convert to DataFrames
df_anova = pd.DataFrame(anova_results)
df_kw = pd.DataFrame(kruskal_results)
df_pair = pd.DataFrame(pairwise_results)

# Save results as CSV
df_anova.to_csv(os.path.join(tests_dir, 'anova_results.csv'), index=False)
df_kw.to_csv(os.path.join(tests_dir, 'kruskal_results.csv'), index=False)
df_pair.to_csv(os.path.join(tests_dir, 'pairwise_ttests.csv'), index=False)

# Also save as JSON
with open(os.path.join(tests_dir, 'anova_results.json'), 'w') as f:
    f.write(df_anova.to_json(orient='records', indent=2))
with open(os.path.join(tests_dir, 'kruskal_results.json'), 'w') as f:
    f.write(df_kw.to_json(orient='records', indent=2))
with open(os.path.join(tests_dir, 'pairwise_ttests.json'), 'w') as f:
    f.write(df_pair.to_json(orient='records', indent=2))

# Generate and save boxplots
def save_boxplot(metric):
    plt.figure()
    df.boxplot(column=metric, by='Condition')
    plt.title(f"{metric} by Condition")
    plt.suptitle('')
    plt.xlabel('Condition')
    plt.ylabel(metric)
    plt.tight_layout()
    out_path = os.path.join(tests_dir, f"{metric.replace(' ', '_').lower()}_boxplot.png")
    plt.savefig(out_path)
    plt.close()

for metric in metrics:
    save_boxplot(metric)

print(f"Hypothesis test results and plots saved to {tests_dir}")
