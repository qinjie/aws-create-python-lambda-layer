# Script to Create AWS Lambda Layer

This script creates a zip file with python libraries, which can be used to deploy as an AWS Lambda Layer. Optionally, you can use AWS CLI to deploy the layer to AWS.

Usage:

    `./create_lambda_layer.sh <PYTHON_VERSION> <SOURCE_FOLDER> <OUTPUT_ZIP_FILE>`

Example:

    `./create_lambda_layer.sh python3.8`

### Create Zip File

1. Install python virtualenv.

   ```bash
   sudo apt install python3-virtualenv
   ```

2. Update `requirements.txt` file in the <SOURCE_FOLDER> with required libraries.
3. Copy `create_lambda_layer.sh` to the parent folder of <SOURCE_FOLDER>, i.e. at the same level as <SOURCE_FOLDER>.
4. Run the script to create a zip file containing libraries specified in `requirements.txt`.

### Publish to AWS

#### Option 1

- Use AWS Management Console to create AWS Lambda layer manually using the zip file

#### Option 2

- Set the default profile of the AWS CLI using `export AWS_DEFAULT_PROFILE=<PROFILE>`.
- Uncomment last line in `create_lambda_layer.sh` file.
