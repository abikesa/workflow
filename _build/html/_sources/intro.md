# Retiring `id_workflow`

```bash
#!/bin/zsh

# Define the environment directory; setup_environement.sh
ENV_DIR="myenv"

# Remove the existing environment if it exists
if [ -d "$ENV_DIR" ]; then
    rm -rf "$ENV_DIR"
fi

# Create a new virtual environment
python3 -m venv $ENV_DIR

# Activate the virtual environment
source $ENV_DIR/bin/activate

# Upgrade pip
pip install --upgrade pip

# Install Python packages
pip install jupyter jupyterlab ipykernel jupyter-book

# Install IRkernel for R
Rscript -e "install.packages('IRkernel', repos='https://cloud.r-project.org/')"
Rscript -e "IRkernel::installspec(name = 'ir', displayname = 'R')"

# Install Stata kernel (assuming you have Stata installed)
pip install stata_kernel
python -m stata_kernel.install

# Deactivate the virtual environment
deactivate

echo "Environment setup complete."

```

```{tableofcontents}
```
