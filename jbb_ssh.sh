
#!/bin/bash

# User-defined inputs for abi/abikesa_jbb.sh; substantive edits on 08/14/2023:

read -p "Enter your GitHub username (default: abikesa): " GITHUB_USERNAME
GITHUB_USERNAME=${GITHUB_USERNAME:-abikesa}

read -p "Enter your GitHub repository name (default: worthy): " REPO_NAME
REPO_NAME=${REPO_NAME:-worthy}

read -p "Enter your email address (default: abikesa.sh@gmail.com): " EMAIL_ADDRESS
EMAIL_ADDRESS=${EMAIL_ADDRESS:-abikesa.sh@gmail.com}

read -p "Enter your root directory (e.g., ~/Dropbox/1f.ἡἔρις,κ/1.ontology, default: /documents/rhythm): " ROOT_DIR
ROOT_DIR=${ROOT_DIR:-/documents/rhythm}

read -p "Enter the name of the subdirectory to be built within the root directory (default: local): " SUBDIR_NAME
SUBDIR_NAME=${SUBDIR_NAME:-local}

read -p "Enter your commit statement: " COMMIT_THIS

read -p "Enter your SSH key path (e.g., ~/.ssh/id_nh_projectbetaprojectbeta, default: ~/.ssh/id_rsa): " SSH_KEY_PATH
SSH_KEY_PATH=${SSH_KEY_PATH:-~/.ssh/id_rsa}

# Ensure ssh-agent is running
eval "$(ssh-agent -s)"

# Remove all identities from the SSH agent
ssh-add -D

# Add your SSH key to the agent
chmod 600 "$(eval echo $SSH_KEY_PATH)"
ssh-add "$(eval echo $SSH_KEY_PATH)"

# Configure Git
git config --local user.name "$GITHUB_USERNAME"
git config --local user.email "$EMAIL_ADDRESS"

cd "$(eval echo $ROOT_DIR)"

# Clean and build the book with Jupyter Book
rm -rf $SUBDIR_NAME/_build
jb build $SUBDIR_NAME

# Remove old repository if it exists
rm -rf $REPO_NAME

if [ -d "$REPO_NAME" ]; then
  echo "Directory $REPO_NAME already exists. Choose another directory or delete the existing one."
  exit 1
fi

# Clone the repository
git clone "git@github.com:$GITHUB_USERNAME/$REPO_NAME.git"
if [ ! -d "$REPO_NAME" ]; then
  echo "Failed to clone the repository. Check your GitHub username, repository name, and permissions."
  exit 1
fi

# Copy files to the repository and commit
cp -r $SUBDIR_NAME/* $REPO_NAME
cd $REPO_NAME

git add ./*
git commit -m "$COMMIT_THIS"
git remote -v

# Set the remote URL and ensure correct user credentials
git remote set-url origin "git@github.com:$GITHUB_USERNAME/$REPO_NAME.git"
git config --local user.name "$GITHUB_USERNAME"
git config --local user.email "$EMAIL_ADDRESS"

# Checkout the main branch
git checkout main
if [ $? -ne 0 ]; then
  echo "Failed to checkout the main branch. Make sure it exists in the repository."
  exit 1
fi

# Push changes to the repository
git push -u origin main
if [ $? -ne 0 ]; then
  echo "Failed to push to the repository. Check your SSH key path and GitHub permissions."
  exit 1
fi

# Publish with ghp-import
ghp-import -n -p -f _build/html

cd ..
rm -rf $REPO_NAME
echo "Jupyter Book content updated and pushed to $GITHUB_USERNAME/$REPO_NAME repository!"
