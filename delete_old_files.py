import os
import sys

def delete_files_from_txt(file_with_paths):
    replaceCharacter = False # For Windows
    if sys.platform == 'linux' or sys.platform == "linux2" or sys.platform == "darwin": # For linux and Mac OS
        replaceCharacter = True
    # Open the txt file and read all lines (file paths)
    with open(file_with_paths, 'r') as file:
        # Iterate through each file path in the txt file
        for line in file:
            # Remove any extra whitespace or newline characters
            file_path = line.strip()

            if replaceCharacter:
                file_path = file_path.replace("\\", "/")
            
            # Check if the file exists before attempting to delete
            if os.path.exists(file_path):
                try:
                    os.remove(file_path)
                    print(f"File deleted: {file_path}")
                except Exception as e:
                    print(f"Error deleting {file_path}: {e}")
            else:
                print(f"File not found: {file_path}")

if __name__ == "__main__":
    # Path to the txt file containing the file names
    txt_file = "old_mod_asset_files.txt"
    
    # Call the function to delete the files
    delete_files_from_txt(txt_file)
    print("File deletion process completed.")
