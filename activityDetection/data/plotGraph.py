import pandas as pd
import matplotlib.pyplot as plt

# Load the CSV file
file_path = "sensor_data.csv"  # Replace with the path to your CSV file
data = pd.read_csv(file_path)

# Columns to plot
columns_to_plot = ['yaw', 'pitch', 'roll', 'pressure', 'altitude', 'frameId']

# Create a figure for each column
for column in columns_to_plot:
    fig, ax = plt.subplots(figsize=(12, 8))  # Create a figure and axis
    ax.plot(data['timestamp'], data[column], label=column, linewidth=1)
    ax.set_title(f"{column.capitalize()} vs Timestamp", fontsize=16)
    ax.set_xlabel("Timestamp", fontsize=14)
    ax.set_ylabel(column.capitalize(), fontsize=14)
    ax.tick_params(axis='x', rotation=45, labelsize=12)  # Rotate x-axis labels
    ax.grid(True)
    ax.legend(fontsize=12)

# Show all figures and keep windows open
plt.show(block=True)
