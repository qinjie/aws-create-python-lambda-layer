# Script to Create AWS Lambda Layer


This script creates a zip file with python libraries, which can be used to deploy as an AWS Lambda Layer. Optionally, you can use AWS CLI to deploy the layer to AWS.

### Create Zip File

1. Install python virtualenv.

    ```bash
    sudo apt install python3-virtualenv
    ```

2. Update `requirements.txt` file with required libraries.
3. Update `create_lambda_layer.sh` file with correct python version.
4. Run the script to create a zip file containing libraries specified in `requirements.txt`.

### Publish to AWS

* Use AWS Management Console to create AWS Lambda layer manually using the zip file
* Copy the last command (commented off) from `create_lambda_layer.sh` file. Update the command and run it.
    * You  may supply AWS Profile with `--profile`.

  

