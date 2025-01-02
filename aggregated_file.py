import os

# Define file paths  /Users/thomasdeane/Project/New_Start
file_paths = [
    "/Users/thomasdeane/Project/New_Start/Backend/controllers/",
    "/Users/thomasdeane/Project/New_Start/Backend/routes/",
    "/Users/thomasdeane/Project/New_Start/Backend/config/",
    "/Users/thomasdeane/Project/New_Start/Backend/middleware/",
    "/Users/thomasdeane/Project/New_Start/Backend/models/",
    "/Users/thomasdeane/Project/New_Start/Backend/server.js",
    "/Users/thomasdeane/Project/New_Start/frontend/src/components/",
    "/Users/thomasdeane/Project/New_Start/frontend/src/pages/",
    "/Users/thomasdeane/Project/New_Start/frontend/src/context/",
    "/Users/thomasdeane/Project/New_Start/frontend/src/app.js",
    "/Users/thomasdeane/Project/New_Start/frontend/src/styles.css",
    "/Users/thomasdeane/Project/New_Start/frontend/src/index.js"
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