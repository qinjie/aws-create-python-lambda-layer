#!/bin/bash

# Redirect stderr to stdout
exec 2>&1

##################
# Create zip file to deploy an AWS Lambda Layer

# Ensure required tools are installed
#   sudo apt install python3-virtualenv awscli

# Default values for environment variables
PYTHON_BASE_VERSION=${PYTHON_BASE_VERSION:-"python3.13"} # Default to python3.13 if not set
LAYER_NAME=${LAYER_NAME}
LAYER_DESCRIPTION=${LAYER_DESCRIPTION:-"A sample Lambda layer"}
LAYER_COMPATIBLE_RUNTIMES=${LAYER_COMPATIBLE_RUNTIMES:-$PYTHON_BASE_VERSION}

if [ $# -lt 1 ]; then
    echo "Usage: ./create_lambda_layer.sh <SOURCE_FOLDER_OR_REQUIREMENTS_FILE>"
    echo "Example: ./create_lambda_layer.sh pandas_layer"
    echo "Example: ./create_lambda_layer.sh pandas_layer/requirements.txt"
    exit 1
fi

if [ -d "$1" ]; then
    echo "$1 is a folder"
    FILEBASENAME=$(basename "$1")
    SOURCE_FOLDER="$1"
    ZIP_FILE="${FILEBASENAME}.zip"
    REQUIREMENTS_FILE="$1/requirements.txt"
elif [ -f "$1" ]; then
    echo "$1 is a file"
    SOURCE_FOLDER=""
    FILEBASENAME=$(basename "${1%.*}")
    ZIP_FILE="${FILEBASENAME}.zip"
    REQUIREMENTS_FILE="$1"
else
    echo "First argument must be either a folder or a requirements file"
    exit 1
fi

for cmd in virtualenv zip; do
    if ! command -v $cmd &>/dev/null; then
        echo "Error: $cmd is not installed."
        exit 1
    fi
done

echo "Create layer $LAYER_NAME ($PYTHON_BASE_VERSION) from $SOURCE_FOLDER/$REQUIREMENTS_FILE to $ZIP_FILE"

# Remove existing zip file and temporary directories
echo "Removing existing $ZIP_FILE, ./python, and ./v-env"
rm -rf "$ZIP_FILE" python v-env

# Create virtual environment and install libraries
echo "Creating virtual environment for $PYTHON_BASE_VERSION"
virtualenv --python="$PYTHON_BASE_VERSION" v-env || { echo "Failed to create virtual environment"; exit 1; }
source ./v-env/bin/activate

if [ -f "$REQUIREMENTS_FILE" ]; then
    echo "Installing library files from $REQUIREMENTS_FILE"
    pip install -r "$REQUIREMENTS_FILE" || { echo "Failed to install dependencies"; deactivate; exit 1; }
else
    echo "No requirements file provided."
    exit 1
fi
deactivate

# Extract and zip installed libraries
echo "Creating zip file $ZIP_FILE from libraries"
mkdir python
cd python || { echo "Failed to change directory to 'python'"; exit 1; }
cp -r ../v-env/lib/"$PYTHON_BASE_VERSION"/site-packages/* .

# Copy requirements file into the zip folder as a record, if it exists
if [ -f "../$REQUIREMENTS_FILE" ]; then
    cp "../$REQUIREMENTS_FILE" .
fi

# Copy the entire source folder into the 'python' directory, if specified
if [ -n "$SOURCE_FOLDER" ]; then
    cp -r "../${SOURCE_FOLDER%/}" .
fi

# Remove unnecessary files before zipping
echo "Removing unused folders (tests, __pycache__)"
find . -type d -name "tests" -exec rm -rf {} +
find . -type d -name "__pycache__" -exec rm -rf {} +

# Zip the contents of the 'python' directory into the ZIP file
cd ..
zip -r "$ZIP_FILE" python \
    --exclude 'python/*.zip*' \
    --exclude 'python/__pycache__'

# Clean up temporary directories and files
echo "Cleaning up..."
[ -d python ] && rm -rf python
[ -d v-env ] && rm -rf v-env

echo "Lambda layer package created: $ZIP_FILE"

# Optional: Publish it to AWS Lambda using environment variables
if [ -n "$LAYER_NAME" ]; then
    if ! command -v aws &>/dev/null; then
        echo "Error: aws is not installed."
        exit 1
    fi

    echo "Publishing Lambda layer..."
    if ! aws lambda publish-layer-version \
        --layer-name "$LAYER_NAME" \
        --description "$LAYER_DESCRIPTION" \
        --zip-file fileb://"$ZIP_FILE" \
        --compatible-runtimes "$LAYER_COMPATIBLE_RUNTIMES"; then
        echo "Failed to publish Lambda layer"
        exit 1
    fi
else
    echo "LAYER_NAME is not set. Skipping Lambda layer publishing."
fi
