#!/bin/bash
# adopted from ipython/docker-notebook
# https://github.com/ipython/docker-notebook/blob/master/notebook/notebook.sh

# Set configuration defaults
: ${PASSWORD:=""}
: ${PEM_FILE:="/home/mycert.pem"}

# Create a self signed certificate
cd /home
openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout mycert.pem -out mycert.pem -subj "/C=XX/ST=XX/L=XX/O=XX/CN=XX"
: ${CERTFILE_OPTION="--certfile=$PEM_FILE"}

# Create the hash to pass to the IPython notebook, but don't export it so it doesn't appear
# as an environment variable within IPython kernels themselves
HASH=$(python -c "from IPython.lib import passwd; print(passwd('${PASSWORD}'))")
unset PASSWORD

cd /home/kaggle
jupyter notebook --no-browser --port 8888 --ip=* $CERTFILE_OPTION --NotebookApp.password="$HASH" --IPKernelApp.pylab="inline"

unset HASH
