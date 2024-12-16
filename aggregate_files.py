import os

# Define file paths
file_paths = [
    "NEW_START/Backend/controllers/",
    "NEW_START/Backend/routes/",
    "NEW_START/Backend/config/",
    "NEW_START/Backend/middleware/",
    "NEW_START/Backend/models/",
    "NEW_START/Backend/server.js",
    "NEW_START/frontend/src/components/",
    "NEW_START/frontend/src/pages/",
    "NEW_START/frontend/src/context/",
    "NEW_START/frontend/src/app.js",
    "NEW_START/frontend/src/styles.css",
    "NEW_START/frontend/src/index.js"
]

# Output file name
output_file = "aggregated_file.txt"

def aggregate_files(file_paths, output_file):
    with open(output_file, "w", encoding="utf-8") as outfile:
        for path in file_paths:
            if os.path.isdir(path):
                # If the path is a directory, process all files inside it
                for root, _, files in os.walk(path):
                    for file in files:
                        file_path = os.path.join(root, file)
                        try:
                            with open(file_path, "r", encoding="utf-8") as infile:
                                outfile.write(f"\n\n--- {file_path} ---\n\n")
                                outfile.write(infile.read())
                        except Exception as e:
                            print(f"Error reading {file_path}: {e}")
            elif os.path.isfile(path):
                # If the path is a single file, process it directly
                try:
                    with open(path, "r", encoding="utf-8") as infile:
                        outfile.write(f"\n\n--- {path} ---\n\n")
                        outfile.write(infile.read())
                except Exception as e:
                    print(f"Error reading {path}: {e}")
            else:
                print(f"Path does not exist: {path}")

# Run the aggregator
aggregate_files(file_paths, output_file)
print(f"Aggregation complete! Contents saved to {output_file}")