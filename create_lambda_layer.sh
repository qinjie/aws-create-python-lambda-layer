##################
# Create zip file to deploy an AWS Lambda Layer

# Need to install virtualenv and aws-cli
#   sudo apt install python3-virtualenv

# Create virtual env and install libraries
virtualenv --python=python3.8 v-env
source ./v-env/bin/activate
pip install -r requirements.txt 
deactivate

# Extract and zip installed libraries
# The folder name MUST be python and python.zip
mkdir python
cd python
cp -r ../v-env/lib/python3.8/site-packages/* .
cd ..
zip -r python.zip python

# Publish it to AWS
# aws lambda publish-layer-version --layer-name pandas --zip-file fileb://python.zip --compatible-runtimes python3.8

