

```stata
qui {
	cls
	use ${repo}transplants, clear
    ds, not(type string)  
	global threshold 9  
	putexcel set levelsof, replace 
	local row=2
    foreach v of varlist age gender race { //`r(varlist)'
	    levelsof `v', local(numlevels)
	    if r(r) == 2 {  
			putexcel A`row' = ("`v'") B`row' = ("per")
			noi di  _col(1)    "`v'"  _col(30)  "per"
			local row = `row' + 1
	    }
	    else if inrange(`r(r)', 3, $threshold) {  
			putexcel A`row' = ("`v', %") B`row' = ("")
			noi di   _col(1)   "`v', %" _col(30)   ""
			foreach l of numlist `numlevels' {
				local row = `row' + 1
                putexcel A`row' = ("    catlab") B`row' = ("per")
				noi di  _col(1)    "    catlab" _col(30)   "per"
			}	
	    }
	    else {  
			putexcel A`row' = ("`v'") B`row' = ("m_iqr")
			noi di   _col(1)   "`v'"  _col(30)  "m_iqr"
			local row = `row' + 1
	    }
		
    }
	
}


```

Got it. To work 100% from .ipynb files in VSCode, we need to ensure that the Jupyter server runs in the background and that the Jupyter extension in VSCode automatically connects to it. Here’s the script tailored for this workflow:

### Complete Script for Setting Up Stata and R Kernels for VSCode

```sh
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

# Step 8: Start Jupyter Notebook server in the background
echo "Starting Jupyter Notebook server in the background..."
nohup jupyter notebook --no-browser --NotebookApp.token='' --NotebookApp.password='' > jupyter.log 2>&1 &

# Wait for the Jupyter server to start
sleep 5

echo "Setup complete! You can now open .ipynb files directly in VSCode and use the Stata and R kernels."
```

### Instructions to Use the Script

1. **Save the Script**:
   - Save the script to a file, for example, `setup_stata_r_kernel.sh`.

2. **Make the Script Executable**:
   - Make the script executable by running the following command:

   ```sh
   chmod +x setup_stata_r_kernel.sh
   ```

3. **Run the Script**:
   - Run the script by executing:

   ```sh
   ./setup_stata_r_kernel.sh
   ```

### Explanation and How to Use in VSCode

- **Step 1**: The script removes any existing virtual environment to ensure a fresh setup.
- **Step 2**: A new virtual environment is created.
- **Step 3**: The virtual environment is activated.
- **Step 4**: Necessary Python packages (`stata_kernel`, `ipykernel`, `setuptools`, `notebook`) are installed.
- **Step 5**: The environment variable for the Stata path is set up.
- **Step 6**: The Stata kernel is installed.
- **Step 7**: The IRkernel for R is installed.
- **Step 8**: The Jupyter Notebook server is started in the background with no authentication required (`--NotebookApp.token='' --NotebookApp.password=''`).

### Working with .ipynb Files in VSCode

After running the script, follow these steps:

1. **Open VSCode**:
   - Open VSCode and ensure the Jupyter extension is installed.

2. **Open or Create Jupyter Notebooks**:
   - Open an existing `.ipynb` file or create a new one.

3. **Select Kernel**:
   - When you open a notebook, click on the kernel name at the top right and select the appropriate kernel (Stata or R).

VSCode should automatically connect to the running Jupyter server in the background. This setup ensures that you can work entirely within VSCode, using the provided kernels without needing to interact with the browser-based Jupyter interface.