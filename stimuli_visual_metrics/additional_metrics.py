import cv2
import numpy as np
import os, sys
import csv
import matplotlib.pyplot as plt

# Paths setup
this_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.abspath(os.path.join(this_dir, os.pardir))
stimuli_dir = os.path.join(project_root, 'stimuli')

# Create output directories
output_dir = os.path.join(this_dir, 'output')
plots_dir = os.path.join(output_dir, 'plots')
data_dir  = os.path.join(output_dir, 'data')
for d in (output_dir, plots_dir, data_dir):
    os.makedirs(d, exist_ok=True)

# Prepare summary CSV for aggregate metrics + percentiles
summary_file = os.path.join(output_dir, 'all_videos_metrics_summary.csv')
with open(summary_file, 'w', newline='') as f_out:
    writer = csv.writer(f_out)
    header = [
        'Video', 'Frame rate (fps)',
        'Mean lumi', 'Lumi 5th', 'Lumi 50th', 'Lumi 95th',
        'Mean contrast', 'Contrast 5th', 'Contrast 50th', 'Contrast 95th',
        'Mean flow', 'Flow 5th', 'Flow 50th', 'Flow 95th',
        'Mean edge_density', 'Edge 5th', 'Edge 50th', 'Edge 95th'
    ]
    writer.writerow(header)

    # Process each .mp4 in stimuli
    for filename in os.listdir(stimuli_dir):
        if not filename.endswith('.mp4'):
            continue

        # # Check if the file has been processed already
        # if os.path.exists(os.path.join(data_dir, f"{filename}_timeseries.csv")):
        #     print(f"Skipping already processed video: {filename}")
        #     continue
        
        video_path = os.path.join(stimuli_dir, filename)
        print(f"Processing video: {video_path}")

        cap = cv2.VideoCapture(video_path)
        fps = cap.get(cv2.CAP_PROP_FPS)

        prev_gray = None
        lums, contrasts, flows, edges = [], [], [], []

        # Read frames
        while True:
            ret, frame = cap.read()
            if not ret:
                break

            # Grayscale luminance
            gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY).astype(np.float32)
            lum = gray.mean()
            lums.append(lum)

            # RMS contrast
            contrast = np.sqrt(np.mean((gray - lum)**2))
            contrasts.append(contrast)

            # Edge density via Canny
            edge_map = cv2.Canny(frame, 100, 200)
            edge_density = np.mean(edge_map > 0)
            edges.append(edge_density)

            # Optical flow magnitude
            if prev_gray is not None:
                flow = cv2.calcOpticalFlowFarneback(
                    prev_gray, gray, None,
                    0.5, 3, 15, 3, 5, 1.2, 0
                )
                mag = np.hypot(flow[...,0], flow[...,1])
                flows.append(mag.mean())
            prev_gray = gray

        cap.release()

        # Percentile helper
        def pct(arr): return np.percentile(arr, [5, 50, 95])

        l5, l50, l95 = pct(lums)
        c5, c50, c95 = pct(contrasts)
        f5, f50, f95 = pct(flows) if flows else (np.nan,)*3
        e5, e50, e95 = pct(edges)

        # Write summary row
        writer.writerow([
            filename,
            f"{fps:.1f}",
            f"{np.mean(lums):.2f}", f"{l5:.2f}", f"{l50:.2f}", f"{l95:.2f}",
            f"{np.mean(contrasts):.2f}", f"{c5:.2f}", f"{c50:.2f}", f"{c95:.2f}",
            f"{np.mean(flows):.2f}" if flows else 'nan',
            f"{f5:.2f}", f"{f50:.2f}", f"{f95:.2f}",
            f"{np.mean(edges):.2f}", f"{e5:.2f}", f"{e50:.2f}", f"{e95:.2f}"
        ])

        # Plot and save histograms + time series for each metric
        metrics = {
            'lumi':    lums,
            'contrast': contrasts,
            'flow':    flows,
            'edge_density': edges
        }
        for name, arr in metrics.items():
            if not arr:
                continue
            # Histogram
            plt.figure()
            plt.hist(arr, bins=50)
            plt.title(f"{name} histogram: {filename}")
            plt.xlabel(name); plt.ylabel('Count')
            plt.savefig(os.path.join(plots_dir, f"{filename}_{name}_hist.png"))
            plt.close()

            # Time series
            plt.figure()
            plt.plot(arr)
            plt.title(f"{name} over time: {filename}")
            plt.xlabel('Frame'); plt.ylabel(name)
            plt.savefig(os.path.join(plots_dir, f"{filename}_{name}_timeseries.png"))
            plt.close()

        # Save raw time-series to CSV
        ts_file = os.path.join(data_dir, f"{filename}_timeseries.csv")
        with open(ts_file, 'w', newline='') as f_ts:
            ts_writer = csv.writer(f_ts)
            ts_writer.writerow(['frame', 'lumi', 'contrast', 'flow', 'edge_density'])
            max_len = max(len(lums), len(contrasts), len(flows), len(edges))
            for i in range(max_len):
                ts_writer.writerow([
                    i,
                    lums[i] if i < len(lums) else '',
                    contrasts[i] if i < len(contrasts) else '',
                    flows[i] if i < len(flows) else '',
                    edges[i] if i < len(edges) else ''
                ])

        print(f"Summary, plots, and time-series for {filename} saved.")

# ===== Additional analyses you might add: =====
# - Color histograms per RGB channel (cv2.calcHist + plt)
# - Optical-flow orientation distribution (use np.arctan2)
# - Autocorrelation of each metric sequence to find periodicities
# - Frame-difference energy for scene-cut detection
# - Spatial contrast maps (local contrast statistics)
# - Sharpness/blurriness via Laplacian variance
# 
# Simply compute and append these into the metrics dict above, then
# reuse the histogram/time-series saving logic.
