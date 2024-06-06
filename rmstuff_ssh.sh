# $TOKEN if private repo
# git clone "https://$TOKEN@github.com/$REPO_URL.git"
# https://github.com/jhustata/basic

read -p "Enter your GitHub username: " USERNAME
read -p "Enter your GitHub repo: " REPO
read -p "Enter your GitHub filename: " FILENAME
read -p "Enter your GitHub email: " EMAIL
read -p "Enter your GitHub ssh: " SSH

# Switch to the main branch
git clone "https://github.com/$USERNAME/$REPO"
cd "$(basename "https://github.com/$USERNAME/$REPO")"

# Remove the specified path (can be directory, file, or file type)
rm -rf $FILENAME

# Stage, commit, and push deletions
git add -A 
git commit -m "Removed $FILENAME in main directory"
git remote -v

# Permissions for access
chmod 600 "$(eval echo $SSH)"
git remote set-url origin "git@github.com:$USERNAME/$REPO_NAME"
ssh-add "$(eval echo $SSH)"
git config --local user.name "$USERNAME"
git config --local user.email "$EMAIL"

# Checkout the main branch
git checkout main
git push -u origin main