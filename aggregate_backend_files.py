import os

# Correct paths relative to where the script is executed
backend_file_paths = [
    "Backend/controllers/",
    "Backend/routes/",
    "Backend/config/",
    "Backend/middleware/",
    "Backend/models/",
    "Backend/server.js"
]

# Output file name
output_file = "backend_aggregated.txt"

def aggregate_files(file_paths, output_file):
    """
    Aggregates the contents of all backend files into a single output file.
    Annotates each section with the corresponding file name or path.
    """
    print(f"Starting aggregation. Output will be saved to {output_file}.")
    try:
        with open(output_file, "w", encoding="utf-8") as outfile:
            for path in file_paths:
                if os.path.isdir(path):
                    # Process all files in the directory
                    print(f"Processing directory: {path}")
                    for root, _, files in os.walk(path):
                        for file in files:
                            file_path = os.path.join(root, file)
                            try:
                                with open(file_path, "r", encoding="utf-8") as infile:
                                    outfile.write(f"\n\n--- {file_path} ---\n\n")
                                    outfile.write(infile.read())
                            except Exception as e:
                                print(f"Error reading file {file_path}: {e}")
                elif os.path.isfile(path):
                    # Process individual files
                    print(f"Processing file: {path}")
                    try:
                        with open(path, "r", encoding="utf-8") as infile:
                            outfile.write(f"\n\n--- {path} ---\n\n")
                            outfile.write(infile.read())
                    except Exception as e:
                        print(f"Error reading file {path}: {e}")
                else:
                    print(f"Path does not exist: {path}")
        print(f"Aggregation complete! Contents saved to {output_file}.")
    except Exception as e:
        print(f"Error writing to output file {output_file}: {e}")

# Run the aggregation
if __name__ == "__main__":
    aggregate_files(backend_file_paths, output_file)