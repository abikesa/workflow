#!/bin/bash

# Ask for the directory to change to
echo "Enter the directory to change to (relative to ~/documents):"
read dir

# Change to the specified directory
cd ~/documents/"$dir" || { echo "Directory not found"; exit 1; }

# Loop through all items in the directory
for item in *; do
    # Check if the item is a directory and not "kitabo"
    if [ -d "$item" ]; then
        if [ "$item" != "kitabo" ] && ! [[ $item =~ ^[1-6]-.* ]]; then
            # Remove the directory and its contents
            rm -rf "$item"
            echo "Deleted directory $item"
        fi
    elif [ -f "$item" ]; then
        # Check if the file should be deleted
        if [[ $item == _file* ]]; then
            rm "$item"
            echo "Deleted file $item"
        elif [[ $item == *.* ]]; then
            if ! [[ $item =~ ^[1-6]-.* ]]; then
                rm "$item"
                echo "Deleted file $item"
            fi
        else
            rm "$item"
            echo "Deleted file $item"
        fi
    fi
done

echo "Finished deleting directory contents"
