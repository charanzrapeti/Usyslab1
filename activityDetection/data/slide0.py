import os
import pandas as pd
import matplotlib.pyplot as plt

def plot_and_save(csv_files, columns_to_plot):
    for file_path in csv_files:
        # Extract the base name (without .csv extension) for folder creation
        file_name = os.path.basename(file_path)
        folder_name = file_name.replace('.csv', '')
        
        # Create a folder with the file name in the current directory
        if not os.path.exists(folder_name):
            os.makedirs(folder_name)
        
        # Load the CSV file
        try:
            data = pd.read_csv(file_path)
        except Exception as e:
            print(f"Error reading {file_path}: {e}")
            continue
        
        # Check if required columns are present
        for column in columns_to_plot:
            if column not in data.columns:
                print(f"Column '{column}' not found in {file_path}. Skipping...")
                continue
            
            # Create and save the plot
            fig, ax = plt.subplots(figsize=(12, 8))  # Create a figure and axis
            ax.plot(data['timestamp'], data[column], label=column, linewidth=1)
            ax.set_title(f"{column.capitalize()} vs Timestamp", fontsize=16)
            ax.set_xlabel("Timestamp", fontsize=14)
            ax.set_ylabel(column.capitalize(), fontsize=14)
            ax.tick_params(axis='x', rotation=45, labelsize=12)  # Rotate x-axis labels
            ax.grid(True)
            ax.legend(fontsize=12)
            
            # Save the plot in the folder
            plot_path = os.path.join(folder_name, f"{column}_vs_timestamp.png")
            plt.savefig(plot_path, bbox_inches='tight')
            plt.close(fig)  # Close the figure to free memory

        print(f"Plots for {file_path} saved in folder: {folder_name}")

# Example usage
csv_files = [
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

columns_to_plot = ['yaw', 'pitch', 'roll', 'pressure', 'altitude']

plot_and_save(csv_files, columns_to_plot)
