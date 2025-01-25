import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

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

            # Select only the numeric columns for processing
            numeric_data = data[['yaw', 'pitch', 'roll']]
            
            # Group data into chunks of `group_size` and calculate the mean
            grouped_data = numeric_data.groupby(data.index // group_size).mean()
            
            # Calculate RMS for each group
            grouped_data['RMS'] = np.sqrt((grouped_data['yaw']**2 + grouped_data['pitch']**2 + grouped_data['roll']**2) / 3)
            
            # Plot the line graph
            plt.figure(figsize=(10, 6))
            plt.plot(grouped_data.index, grouped_data['yaw'], label='Yaw', color='blue')
            plt.plot(grouped_data.index, grouped_data['pitch'], label='Pitch', color='green')
            plt.plot(grouped_data.index, grouped_data['roll'], label='Roll', color='red')
            plt.plot(grouped_data.index, grouped_data['RMS'], label='RMS', color='purple', linestyle='--')
            
            # Add labels, legend, and grid
            file_name = file_path.split('/')[-1]  # Extract the file name from the file path
            plt.title(f"Sensor Data from {file_name} Averaged Over {group_size} Entries")
            plt.xlabel(f"Group Index (each group averages {group_size} entries)")
            plt.ylabel("Values")
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
    "hand_test.csv",
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
    "sensor_data.csv"
]
plot_sensor_data(file_paths, group_size)
