import pandas as pd
import os

# Read the .csv file
def process_csv(file_path):
    df = pd.read_csv(file_path)
    df['adjusted_value'] = df['altitude'] - df['pressure']
    return df

# Compute rate of change and trend based on derivative
def compute_rate_of_change(df):
    # Compute the first derivative of adjusted_value
    df['rate_of_change'] = df['adjusted_value'].diff() / df.index.to_series().diff().fillna(1)

    # Identify the trend based on the derivative
    df['trend'] = df['rate_of_change'].apply(lambda x: 'UP' if x > 0 else ('DOWN' if x < 0 else 'STABLE'))
    return df

# Determine the most probable outcome ignoring STABLE values and handle all UP or DOWN cases
def get_most_probable_outcome(df):
    # Filter out STABLE values
    filtered_df = df[df['trend'].isin(['UP', 'DOWN'])].copy()

    if filtered_df.empty:
        return "neither"  # No UP or DOWN values

    # Map trends to numeric values
    trend_mapping = {'UP': 1, 'DOWN': -1}
    filtered_df.loc[:, 'numeric_trend'] = filtered_df['trend'].map(trend_mapping)

    # Check if all trends are UP or DOWN
    unique_trends = filtered_df['numeric_trend'].unique()
    if len(unique_trends) == 1:
        # Compute product of all values and return the mean
        product_of_values = filtered_df['rate_of_change'].prod()
        mean_value = filtered_df['rate_of_change'].mean()
        print(f"All values are {filtered_df['trend'].iloc[0]}. Product: {product_of_values}, Mean: {mean_value}")
        return filtered_df['trend'].iloc[0]

    # Calculate frequencies of each trend
    trend_counts = filtered_df['numeric_trend'].value_counts()

    # Determine the most probable trend
    max_count = trend_counts.max()
    probable_trends = trend_counts[trend_counts == max_count].index.tolist()

    # If there's a tie, return "neither"
    if len(probable_trends) > 1:
        return "neither"
    # Otherwise, return the most probable trend
    else:
        trend_reverse_mapping = {1: 'UP', -1: 'DOWN'}
        return trend_reverse_mapping[probable_trends[0]]

# Main function to process multiple files
def main():
    input_files = ["nehastepup1.csv", "nehastepdown2.csv", "liftdown2.csv","liftup2.csv","liftdown3.csv" , "anishastepdown1.csv","anishastepup1.csv", "anishastepdown2.csv"]  # Replace with your actual file paths

    for input_file in input_files:
        try:
            # Process CSV and compute rate of change
            df = process_csv(input_file)
            df = compute_rate_of_change(df)

            # Determine the most probable outcome ignoring STABLE values
            most_probable_outcome = get_most_probable_outcome(df)
            
            # Compute product and mean of the rate of change
            product_of_values = df['rate_of_change'].prod()
            mean_value = df['rate_of_change'].mean()

            # Output the results
            print(f"Results for {input_file}:")
            print(f"Mean of rate of change: {mean_value}")
            print(f"Product of rate of change: {product_of_values}")
            print(f"Most probable outcome: {most_probable_outcome}")
            print('-' * 50)

        except Exception as e:
            print(f"Error processing {input_file}: {e}")

if __name__ == "__main__":
    main()
