#!/bin/bash

##################
# Create zip file to deploy an AWS Lambda Layer

# Need to install virtualenv and aws-cli
#   sudo apt install python3-virtualenv

# Check number of arguments == 3
if (( $# != 3 )); then
    echo "Usage: ./create_lambda_layer.sh <PYTHON_VERSION> <SOURCE_FOLDER> <OUTPUT_ZIP_FILE>"
    echo "Example: ./create_lambda_layer.sh python3.8"
    exit 1
fi

# Create virtual env and install libraries
echo "Create virtual environment for $1"
virtualenv --python=$1 v-env
source ./v-env/bin/activate

echo "Install library files from $2/requirements.txt"
pip install -r $2/requirements.txt 
deactivate

# Extract and zip installed libraries
# The folder name MUST be python and python.zip
echo "Create zip file $3 from libraries and $2"
mkdir python
cd python
cp -r ../v-env/lib/$1/site-packages/* .
# Copy whole SOURCE_FOLDER into python folder too
cp -r ../$2 .
cd ..
zip -r $3 python

# # Clean up
echo "Clean up..." 
rm -rf python
rm -rf v-env

# # Publish it to AWS
echo "Create lambda layer..."
aws lambda publish-layer-version --layer-name $2 --zip-file fileb://$3 --compatible-runtimes $1

