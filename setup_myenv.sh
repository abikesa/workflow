#!/bin/zsh

# Define the environment directory
ENV_DIR="myenv"

# Remove the existing environment if it exists
if [ -d "$ENV_DIR" ]; then
    rm -rf "$ENV_DIR"
fi

# Create a new virtual environment
python3 -m venv $ENV_DIR

# Check if virtual environment was created successfully
if [ ! -d "$ENV_DIR" ]; then
    echo "Failed to create virtual environment."
    exit 1
fi

# Activate the virtual environment
source $ENV_DIR/bin/activate

# Check if activation was successful
if [ "$VIRTUAL_ENV" != "" ]; then
    echo "Virtual environment activated."
else
    echo "Failed to activate virtual environment."
    exit 1
fi

# Ensure pip is installed
if ! command -v pip &> /dev/null; then
    echo "pip could not be found, installing pip..."
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python get-pip.py
    if [ $? -ne 0 ]; then
        echo "Failed to install pip."
        deactivate
        exit 1
    fi
fi

# Upgrade pip
pip install --upgrade pip

# Install necessary Python packages
pip install jupyter jupyterlab ipykernel jupyter-book ghp-import matplotlib numpy wordcloud pandas scipy seaborn scikit-learn tensorflow keras plotly dash flask django pytest pylint black isort mypy pydantic fastapi uvicorn requests beautifulsoup4 sqlalchemy ipython tqdm joblib sympy h5py pyqt5 nbconvert nbformat ipywidgets networkx

# Check if Jupyter Book is installed
if ! command -v jb &> /dev/null; then
    echo "Jupyter Book could not be found. Something went wrong with the installation."
    deactivate
    exit 1
fi

# Install IRkernel for R
Rscript -e "install.packages('IRkernel', repos='https://cloud.r-project.org/')"
if [ $? -ne 0 ]; then
    echo "Failed to install IRkernel."
    deactivate
    exit 1
fi
Rscript -e "IRkernel::installspec(name = 'ir', displayname = 'R')"
if [ $? -ne 0 ]; then
    echo "Failed to install IRkernel spec."
    deactivate
    exit 1
fi

# Install Stata kernel (assuming you have Stata installed)
pip install stata_kernel
python -m stata_kernel.install
if [ $? -ne 0 ]; then
    echo "Failed to install Stata kernel."
    deactivate
    exit 1
fi

echo "Environment setup complete."

# Deactivate the virtual environment
deactivate

# Print instructions for reactivating the virtual environment
echo "To reactivate the virtual environment, use the following command:"
echo "source $ENV_DIR/bin/activate"
