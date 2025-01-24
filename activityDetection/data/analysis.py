import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from scipy.signal import find_peaks  # To detect peaks

# Adjustable parameter: number of entries to average
group_size = 20

# Function to process data and plot the graph
def plot_sensor_data(file_paths, group_size):
    for file_path in file_paths:
        try:
            # Read CSV file
            data = pd.read_csv(file_path)
            
            # Ensure the relevant columns are numeric
            data[['yaw', 'pitch', 'roll']] = data[['yaw', 'pitch', 'roll']].apply(pd.to_numeric, errors='coerce')

            # Calculate RMS for each row
            data['RMS'] = np.sqrt((data['yaw']**2 + data['pitch']**2 + data['roll']**2) / 3)

            # Group data into chunks of `group_size` and calculate the mean
            grouped_means = data['RMS'].groupby(data.index // group_size).mean()

            # Create a flattened version of the RMS data
            flattened_rms = np.repeat(grouped_means.values, group_size)[:len(data)]

            # Calculate the standard deviation (deviation) of the time series
            deviation = np.std(flattened_rms)

            # Calculate the height for peak detection in the time series                    
            height = np.mean(flattened_rms) + (0.5 * deviation)

            # Plot the flattened time series
            plt.figure(figsize=(12, 6))
            plt.plot(flattened_rms, label="Flattened RMS", color="blue", alpha=0.7)

            # Detect peaks in the flattened time series
            time_peaks, _ = find_peaks(flattened_rms, height=height)
            plt.plot(time_peaks, flattened_rms[time_peaks], "rx", label="Peaks")  # Mark peaks

            # Add a horizontal green line for the height
            plt.axhline(y=height, color='green', linestyle='--', linewidth=2, label=f"Height = {height:.2f}")

            # Add labels, legend, and grid
            file_name = file_path.split('/')[-1]  # Extract the file name from the file path
            plt.title(f"Sensor Data from {file_name} with Flattened Groups of Size {group_size}")
            plt.xlabel("Sample Index", fontsize=14)
            plt.ylabel("Amplitude", fontsize=14)
            plt.legend()
            plt.grid(True)

            # Output the number of peaks detected
            print(f"File: {file_path}")
            print("Number of peaks detected in the flattened time series:", len(time_peaks))

            # Show the plot
            plt.tight_layout()
            plt.show()
        except Exception as e:
            print(f"Error processing file {file_path}: {e}")

# Example usage
file_paths = [
    "anishastepdown1.csv",
    "anishastepdown2.csv",
    "anishastepup1.csv",
    # "anishastepup2.csv",
    # "charanstepdown1.csv",
    # "charanstepup1.csv",
    # "liftdown1.csv",
    # "liftdown2.csv",
    # "liftdown3.csv",
    # "liftup1.csv",
    # "liftup2.csv",
    # "liftup3.csv",
    # "nehastepdown1.csv",
    # "nehastepdown2.csv",
    # "nehastepup1.csv",
    # "nehastepup2.csv",
]
plot_sensor_data(file_paths, group_size)
