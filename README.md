# Script to Create AWS Lambda Layer in Python

This script creates a zip file with python libraries, which can be used to deploy as an AWS Lambda Layer. Optionally, you can use AWS CLI to deploy the layer to AWS.

It creates a `python` folder with libraries files indicated in requirements.txt in SOURCE_FOLDER. It also copies SOURCE_FOLDER into `python` folder too.

The `useful-layers` directory contains a few common Lambda layers for reference.

## Usages

### Option 1: Using a Source Folder

When providing a source folder, all files in the folder will be included in the zip file. The zip file will have the same name as the folder (e.g., `source_folder.zip`).

    ```
    ./create_lambda_layer.sh <SOURCE_FOLDER>
    ```

Examples:

    ```
    ./create_lambda_layer.sh iso3166
    ```

### Option 2: Using a Requirements File

If you provide a `requirements.txt` file, the script will install the dependencies listed in it and include `requirements.txt` file in the output file `requirements.zip`.

    ```
    ./create_lambda_layer.sh <REQUIREMENTS_FILE>
    ```

Examples:

    ```
    ./create_lambda_layer.sh iso3166/requirements.txt
    ```

or

    ```
    ./create_lambda_layer.sh requirements.txt
    ```

## Environment Variables

You can customize the behavior of the script using these optional environment variables:

    - `PYTHON_BASE_VERSION`: Specifies the Python version to use (default: `python3.13`).
    - `LAYER_NAME`: Name of the Lambda layer (optional; used when publishing to AWS).
    - `LAYER_DESCRIPTION`: Description of the Lambda layer (default: `"A sample Lambda layer"`).

## Publish to AWS

For option 1 & 2, make sure you have AWS CLI with proper profile setup in your machine.

### Option 1

Set the environment variable `LAYER_NAME` and optional environment variable `LAYER_DESCRIPTION`. The script will run aws cli to publish the layer.

### Option 2

Use AWS CLI. Set your default AWS CLI profile if you have multiple AWS profiles.

    ```
    export AWS_DEFAULT_PROFILE=<PROFILE>
    ```

### Option 3

Manually upload the generated zip file to create an AWS Lambda Layer using the AWS Management Console.
