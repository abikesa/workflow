#!/bin/bash

# Set up variables
VENV_PATH="/Users/hades/Documents/hades/myenv"
STATA_PATH="/Applications/Stata/StataMP.app/Contents/MacOS/stata-mp"
ZSHRC_PATH="$HOME/.zshrc"

# Step 1: Remove existing virtual environment if it exists
echo "Removing existing virtual environment..."
rm -rf $VENV_PATH

# Step 2: Create a new virtual environment
echo "Creating a new virtual environment..."
python3 -m venv $VENV_PATH

# Step 3: Activate the virtual environment
echo "Activating the virtual environment..."
source $VENV_PATH/bin/activate

# Step 4: Install necessary packages for Python
echo "Installing necessary packages for Python..."
pip install stata_kernel ipykernel setuptools notebook

# Step 5: Configure environment variable for Stata path
echo "Configuring environment variable for Stata path..."
if [ ! -f $ZSHRC_PATH ]; then
    touch $ZSHRC_PATH
fi
grep -qxF "export STATA_KERNEL_STATA_PATH=$STATA_PATH" $ZSHRC_PATH || echo "export STATA_KERNEL_STATA_PATH=$STATA_PATH" >> $ZSHRC_PATH
source $ZSHRC_PATH

# Step 6: Install the Stata kernel
echo "Installing the Stata kernel..."
python -m stata_kernel.install

# Step 7: Install IRkernel for R
echo "Installing IRkernel for R..."
Rscript -e "install.packages('IRkernel')"
Rscript -e "IRkernel::installspec(user = FALSE)"

# Step 8: Verify the installation of kernels
echo "Verifying kernel installation..."
jupyter kernelspec list

# Step 9: Start Jupyter Notebook server in the background
echo "Starting Jupyter Notebook server in the background..."
nohup jupyter notebook --no-browser --NotebookApp.token='' --NotebookApp.password='' > jupyter.log 2>&1 &

# Wait for the Jupyter server to start
sleep 5

echo "Setup complete! You can now open .ipynb files directly in VSCode and use the Stata and R kernels."
