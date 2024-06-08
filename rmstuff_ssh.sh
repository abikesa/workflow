#!/bin/bash

# Prompt the user for their GitHub information
read -p "Enter your GitHub username: " USERNAME
read -p "Enter your GitHub repo: " REPO
read -p "Enter the filenames or directories to remove (space-separated, use quotes for names with spaces): " FILENAMES
read -p "Enter your GitHub email: " EMAIL
read -p "Enter the path to your GitHub SSH key: " SSH_KEY_PATH

# Use a temporary directory for the clone operation
TEMP_DIR=$(mktemp -d)
if [ ! -d "$TEMP_DIR" ]; then
  echo "Failed to create temporary directory"
  exit 1
fi

# Clone the repository using SSH
git clone "git@github.com:$USERNAME/$REPO.git" "$TEMP_DIR"
cd "$TEMP_DIR" || { echo "Failed to enter repository directory"; exit 1; }

# Remove the specified files or directories
IFS=' ' read -r -a FILEARRAY <<< "$FILENAMES"
for FILENAME in "${FILEARRAY[@]}"; do
  if [ -e "$FILENAME" ]; then
    rm -rf "$FILENAME"
    echo "Removed $FILENAME"
  else
    echo "File or directory $FILENAME does not exist"
  fi
done

# Stage, commit, and push the deletions
git add -A
git commit -m "Removed files or directories: ${FILENAMES[*]} from repository"
git config --local user.name "$USERNAME"
git config --local user.email "$EMAIL"

# Ensure the SSH key has the correct permissions
chmod 600 "$SSH_KEY_PATH"
eval "$(ssh-agent -s)"
ssh-add "$SSH_KEY_PATH"

# Push the changes to the main branch
git push origin main

echo "Removed ${FILENAMES[*]} and pushed changes to $REPO"

# Clean up the temporary directory
cd ..
rm -rf "$TEMP_DIR"
