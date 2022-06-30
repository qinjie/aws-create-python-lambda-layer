# Create NLTK Lambda Layer

To use NTLK in AWS Lambda function, you can create a lambda layer to include NTLK library and necessary packages.  

But apart from NTLK library, it is common to download other NLTK supporting packages. 



Update following script if necessary:

* Python version
* File name of requirements.txt
* Add other NLTK packages to download

```
# Create virtual environment
virtualenv --python=python3.8 v-env

source ./v-env/bin/activate

# Install library and download package
pip install -r nltk_requirements.txt
python -c "import nltk; nltk.download('stopwords', download_dir='./nltk_data')"

# Copy library and package(s) into /python folder
mkdir python
cp -R nltk_data/* ./python
cp -R v-env/lib/python3.8/site-packages/* ./python

# Create zip file
zip -r nltk.zip python --exclude python/*.zip* --exclude python/__pycache__

# Clean up
rm -rf nltk_data
rm -rf v-env
```

