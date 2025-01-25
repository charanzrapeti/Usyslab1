import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from scipy.signal import find_peaks  # To detect peaks

# Adjustable parameter: number of entries to average
group_size = 100

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
            grouped_data = data['RMS'].groupby(data.index // group_size).mean()

            # Extract the time-series data
            time_series = data['RMS'].dropna().values

            # Calculate the standard deviation (deviation) of the time series
            deviation = np.std(time_series)

            # Calculate the height for peak detection in the time series                    
            height = np.mean(time_series) + (0.5 * deviation)
            
            # Plot the time series with grouping
            plt.figure(figsize=(12, 6))
            plt.plot(time_series, label="Time Series", color="blue", alpha=0.7)
            
            # Shade the area for the first group
            plt.axvspan(0, group_size, color='lightblue', alpha=0.5, label=f"First {group_size} entries")

            # Detect peaks in the time series
            time_peaks, _ = find_peaks(time_series, height=height)
            plt.plot(time_peaks, time_series[time_peaks], "rx", label="Peaks")  # Mark peaks

            # Add a horizontal green line for the height
            plt.axhline(y=height, color='green', linestyle='--', linewidth=2, label=f"Height = {height:.2f}")

            # Output the number of sine waves detected
            print(f"File: {file_path}")
            print("Number of sine waves detected in the time series:", len(time_peaks))
            
            # Add labels, legend, and grid
            file_name = file_path.split('/')[-1]  # Extract the file name from the file path
            plt.title(f"Sensor Data from {file_name} Averaged Over {group_size} Entries")
            plt.xlabel("Sample Index", fontsize=14)
            plt.ylabel("Amplitude", fontsize=14)
            plt.legend()
            plt.grid(True)
            
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
    "anishastepup2.csv",
    "charanstepdown1.csv",
    "charanstepup1.csv",
    "liftdown1.csv",
    "liftdown2.csv",
    "liftdown3.csv",
    "liftup1.csv",
    "liftup2.csv",
    "liftup3.csv",
    "nehastepdown1.csv",
    "nehastepdown2.csv",
    "nehastepup1.csv",
    "nehastepup2.csv",
]
plot_sensor_data(file_paths, group_size)
