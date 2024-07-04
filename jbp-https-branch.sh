#!/bin/bash

read -p "Enter your GitHub username (default: abikesa): " GITHUB_USERNAME
GITHUB_USERNAME=${GITHUB_USERNAME:-abikesa}

read -p "Enter your GitHub repository name (default: worthy): " REPO_NAME
REPO_NAME=${REPO_NAME:-worthy}

read -p "Enter your email address (default: abikesa.sh@gmail.com): " EMAIL_ADDRESS
EMAIL_ADDRESS=${EMAIL_ADDRESS:-abikesa.sh@gmail.com}

read -p "Enter your root directory (e.g., ~/Dropbox/1f.ἡἔρις,κ/1.ontology, default: $(pwd)): " ROOT_DIR
ROOT_DIR=${ROOT_DIR:-$(pwd)}

read -p "Enter the name of the subdirectory to be built within the root directory (default: local): " SUBDIR_NAME
SUBDIR_NAME=${SUBDIR_NAME:-local}

read -p "Enter the name of the new branch (default: experiment-branch): " NEW_BRANCH
NEW_BRANCH=${NEW_BRANCH:-experiment-branch}

read -p "Enter your commit statement: " COMMIT_THIS

# Navigate to the root directory
cd "$ROOT_DIR" || { echo "Failed to navigate to root directory"; exit 1; }

# Ensure the 'local' directory exists
if [ ! -d "$SUBDIR_NAME" ]; then
  echo "The '$SUBDIR_NAME' directory does not exist in the root directory."
  exit 1
fi

# Set Git configuration
git config --global user.name "$GITHUB_USERNAME"
git config --global user.email "$EMAIL_ADDRESS"

# Remove previous build and repository directory if they exist
rm -rf "$SUBDIR_NAME/_build"
jb build "$SUBDIR_NAME"
rm -rf "$REPO_NAME"

# Clone the repository
git clone "https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
if [ ! -d "$REPO_NAME" ]; then
  echo "Failed to clone the repository. Check your GitHub username, repository name, and permissions."
  exit 1
fi

# Copy the contents of the 'local' directory to the cloned repository
cp -r "$SUBDIR_NAME"/* "$REPO_NAME"
cd "$REPO_NAME" || { echo "Failed to navigate to the repository directory"; exit 1; }

# Create and switch to the new branch
git checkout -b "$NEW_BRANCH"

# Add, commit, and push the changes
git add ./*
git commit -m "$COMMIT_THIS"
git push -u origin "$NEW_BRANCH"
if [ $? -ne 0 ]; then
  echo "Failed to push to the repository. Check your credentials and GitHub permissions."
  exit 1
fi

echo "Changes in the '$SUBDIR_NAME' directory have been pushed to the '$NEW_BRANCH' branch in the $GITHUB_USERNAME/$REPO_NAME repository!"
