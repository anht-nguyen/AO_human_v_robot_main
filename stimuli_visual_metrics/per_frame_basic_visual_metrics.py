import cv2
import numpy as np
import os, sys
import csv

this_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.abspath(os.path.join(this_dir, os.pardir))
stimuli_dir = os.path.join(project_root, 'stimuli')

# Prepare output CSV file to save metrics for all videos
output_file = os.path.join(this_dir, "all_videos_basic_visual_metrics.csv")
with open(output_file, 'w', newline='') as f_out:
    writer = csv.writer(f_out)
    # Write header
    writer.writerow(["Video", "Frame rate (fps)", "Mean luminance", "Mean RMS contrast", "Mean flow magnitude"])

    # Loop over all video files in the stimuli directory
    for filename in os.listdir(stimuli_dir):
        if not filename.endswith('.mp4'):
            continue
    
        video_path = os.path.join(stimuli_dir, filename)
        print(f"Processing video: {video_path}")

        cap = cv2.VideoCapture(video_path)
        fps  = cap.get(cv2.CAP_PROP_FPS)

        prev_gray = None
        lums, contrasts, flows = [], [], []

        while True:
            ret, frame = cap.read()
            if not ret: break

            # 1) Luminance
            gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY).astype(np.float32)
            μ = gray.mean()
            lums.append(μ)

            # 2) RMS contrast
            rms = np.sqrt(np.mean((gray - μ)**2))
            contrasts.append(rms)

            # 3) Optical flow (if we have a previous frame)
            if prev_gray is not None:
                flow = cv2.calcOpticalFlowFarneback(prev_gray, gray,
                            None, 0.5, 3, 15, 3, 5, 1.2, 0)
                mag = np.sqrt(flow[...,0]**2 + flow[...,1]**2)
                flows.append(mag.mean())

            prev_gray = gray

        cap.release()

        # Now lums, contrasts, flows are time series; fps is your frame rate
        print(f"Frame rate: {fps:.1f} fps")
        print(f"Mean luminance: {np.mean(lums):.2f}")
        print(f"Mean RMS contrast: {np.mean(contrasts):.2f}")
        print(f"Mean flow magnitude: {np.mean(flows):.2f}")

        # Write results for this video to the CSV file
        writer.writerow([
            filename,
            f"{fps:.1f}",
            f"{np.mean(lums):.2f}",
            f"{np.mean(contrasts):.2f}",
            f"{np.mean(flows):.2f}"
        ])
        print(f"Metrics for {filename} saved to {output_file}")
