#!/bin/bash

# Prompt the user for their GitHub information
read -p "Enter your GitHub username: " USERNAME
read -p "Enter your GitHub repository name: " REPO
read -p "Enter the filename to remove: " FILENAME
read -p "Enter your GitHub email: " EMAIL

# Clone the repository using HTTPS (will prompt for username and password)
git clone "https://github.com/$USERNAME/$REPO.git"
cd "$REPO" || { echo "Failed to enter repository directory"; exit 1; }

# Remove the specified file or directory
rm -rf "$FILENAME"

# Stage, commit, and push the deletions
git add -A
git commit -m "Removed $FILENAME from repository"
git config --local user.name "$USERNAME"
git config --local user.email "$EMAIL"

# Push the changes to the main branch (will prompt for username and password)
git push origin main

echo "Removed $FILENAME and pushed changes to $REPO"
